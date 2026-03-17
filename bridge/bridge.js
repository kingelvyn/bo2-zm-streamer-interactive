// Bridges .gsc files and Twitch events, run with consume_queue.js (node bridge.js)

require('dotenv').config();

const fs = require('fs');
const path = require('path');
const { spawn } = require('child_process');
const { RefreshingAuthProvider } = require('@twurple/auth');
const { ApiClient } = require('@twurple/api');
const { EventSubWsListener } = require('@twurple/eventsub-ws');

// =============================================
// CONFIG — fill these in
// =============================================
const CLIENT_ID = process.env.CLIENT_ID;
const CLIENT_SECRET = process.env.CLIENT_SECRET;
const ACCESS_TOKEN = process.env.ACCESS_TOKEN;
const REFRESH_TOKEN = process.env.REFRESH_TOKEN;
const BROADCASTER_USERNAME = process.env.BROADCASTER_USERNAME;
// =============================================

const QUEUE_FILE = path.join(
  process.env.LOCALAPPDATA,
  'Plutonium', 'storage', 't6', 'wheel_queue.json'
);
const PENDING_FILE = path.join(__dirname, 'pending_spins.txt');
const TOKEN_FILE = path.join(__dirname, 'tokens.json');

let queue = [];

// Persist refreshed tokens so they survive restarts
function loadTokens() {
  if (fs.existsSync(TOKEN_FILE)) {
    try {
      return JSON.parse(fs.readFileSync(TOKEN_FILE, 'utf8'));
    } catch {
      return null;
    }
  }
  return null;
}

function saveTokens(data) {
  fs.writeFileSync(TOKEN_FILE, JSON.stringify(data, null, 2));
}

function loadQueue() {
  if (fs.existsSync(QUEUE_FILE)) {
    try {
      queue = JSON.parse(fs.readFileSync(QUEUE_FILE, 'utf8'));
      if (!Array.isArray(queue)) queue = [];
    } catch {
      queue = [];
    }
  }
}

function saveQueue() {
  const tmp = QUEUE_FILE + '.tmp';
  fs.writeFileSync(tmp, JSON.stringify(queue, null, 2));
  fs.renameSync(tmp, QUEUE_FILE);
  updatePendingFile();
}

function updatePendingFile() {
  let total = 0;
  for (const item of queue) total += item.count || 1;
  fs.writeFileSync(PENDING_FILE, String(total));
}

function addSpin(eventType, user, count = 1, amount = 0) {
  for (let i = 0; i < count; i++) {
    queue.push({ cmd: 'spin', count: 1, event: eventType, user, amount, ts: Date.now() });
  }
  saveQueue();
  console.log(`[QUEUE] ${eventType} | ${user} | spins=${count} | amount=${amount}`);
}

async function main() {
  loadQueue();
  saveQueue();

  // Load saved tokens if available, otherwise use the ones from config
  const savedTokens = loadTokens();
  const tokenData = savedTokens || {
    accessToken: ACCESS_TOKEN,
    refreshToken: REFRESH_TOKEN,
    expiresIn: 0,
    obtainmentTimestamp: 0
  };

  const authProvider = new RefreshingAuthProvider({ clientId: CLIENT_ID, clientSecret: CLIENT_SECRET });

  authProvider.onRefresh((userId, newTokenData) => {
    saveTokens(newTokenData);
    console.log('[AUTH] Tokens refreshed and saved');
  });

  await authProvider.addUserForToken(tokenData, ['chat']);

  const apiClient = new ApiClient({ authProvider });

  // Get broadcaster user ID
  const user = await apiClient.users.getUserByName(BROADCASTER_USERNAME);
  if (!user) {
    console.error(`[ERROR] Could not find Twitch user: ${BROADCASTER_USERNAME}`);
    process.exit(1);
  }

  console.log(`[AUTH] Connected as ${user.displayName} (id: ${user.id})`);

  const listener = new EventSubWsListener({ apiClient });

  // Follows
  listener.onChannelFollow(user.id, user.id, (e) => {
    console.log(`[FOLLOW] ${e.userDisplayName}`);
    addSpin('follow', e.userDisplayName, 1);
  });

  // Subscriptions
  listener.onChannelSubscription(user.id, (e) => {
    if (e.isGift) return;
    console.log(`[SUB] ${e.userDisplayName}`);
    addSpin('sub', e.userDisplayName, 1);
  });

  // Resubs
  listener.onChannelSubscriptionMessage(user.id, (e) => {
    console.log(`[RESUB] ${e.userDisplayName}`);
    addSpin('resub', e.userDisplayName, 1);
  });

  // Gift subs
  listener.onChannelSubscriptionGift(user.id, (e) => {
    console.log(`[GIFTSUB] ${e.gifterDisplayName} gifted ${e.amount}`);
    addSpin('giftsub', e.gifterDisplayName, e.amount);
  });

  // Cheers
  listener.onChannelCheer(user.id, (e) => {
    const bits = e.bits;
    let spins = 1;
    if (bits >= 1000) spins = 3;
    else if (bits >= 500) spins = 2;
    console.log(`[CHEER] ${e.userDisplayName} cheered ${bits} bits = ${spins} spins`);
    addSpin('cheer', e.userDisplayName || 'anonymous', spins, bits);
  });

  listener.start();
  console.log('[EVENTSUB] Listening for Twitch events...');

  // Start consume_queue.js
  const consumer = spawn('node', [path.join(__dirname, 'consume_queue.js')], {
    stdio: 'inherit'
  });
  consumer.on('exit', (code) => console.log(`[CONSUMER] exited with code ${code}`));
}

main().catch(console.error);