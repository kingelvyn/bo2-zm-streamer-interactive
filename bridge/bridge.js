const { StreamerbotClient } = require('@streamerbot/client');
const fs = require('fs');
const path = require('path');
const { spawn } = require('child_process');

const QUEUE_FILE = path.join(
  process.env.LOCALAPPDATA,
  'Plutonium', 'storage', 't6', 'wheel_queue.json'
);
const PENDING_FILE = path.join(__dirname, 'pending_spins.txt');

let queue = [];

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
  for (const item of queue) {
    total += item.count || 1;
  }
  fs.writeFileSync(PENDING_FILE, String(total));
}

function getUserFromData(data) {
  return data?.user_name || data?.user_login || 'unknown';
}

function addSpin(eventType, user, count = 1, amount = 0) {
  for (let i = 0; i < count; i++) {
    queue.push({
      cmd: 'spin',
      count: 1,
      event: eventType,
      user,
      amount,
      ts: Date.now()
    });
  }
  saveQueue();
  console.log(`[QUEUE] ${eventType} | ${user} | spins=${count} | amount=${amount}`);
}

loadQueue();
saveQueue();

const client = new StreamerbotClient({
  host: '127.0.0.1',
  port: 8080,
  endpoint: '/',
  password: 'twitchstreamer'
});

client.on('Twitch.Follow', ({ event, data }) => {
  console.log('[FOLLOW RAW]', JSON.stringify(data, null, 2));
  addSpin('follow', getUserFromData(data), 1);
});

client.on('Twitch.Sub', ({ event, data }) => {
  console.log('[SUB RAW]', JSON.stringify(data, null, 2));
  addSpin('sub', getUserFromData(data), 1);
});

client.on('Twitch.ReSub', ({ event, data }) => {
  console.log('[RESUB RAW]', JSON.stringify(data, null, 2));
  addSpin('resub', getUserFromData(data), 1);
});

client.on('Twitch.GiftSub', ({ event, data }) => {
  console.log('[GIFTSUB RAW]', JSON.stringify(data, null, 2));
  addSpin('giftsub', getUserFromData(data), 1);
});

client.on('Twitch.Cheer', ({ data }) => {
  console.log('[CHEER RAW]', JSON.stringify(data, null, 2));

  const user = getUserFromData(data);
  const bits = data?.bits || 0;

  let spins = 1;
  if (bits >= 1000)
    spins = 3;
  else if (bits >= 500)
    spins = 2;

  addSpin('cheer', user, spins, bits);
});

console.log('Listening on Streamer.bot...');
// Start consume_queue.js automatically alongside bridge.js
const consumer = spawn('node', [path.join(__dirname, 'consume_queue.js')], {
  stdio: 'inherit'
});
consumer.on('exit', (code) => console.log(`[CONSUMER] exited with code ${code}`));

console.log('Streamer.bot bridge started...');