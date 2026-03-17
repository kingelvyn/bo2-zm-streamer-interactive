const http = require('http');

const CLIENT_ID = '9eu469xco5f1b02rss4fyycj5a2q0s';
const CLIENT_SECRET = 'z4mho1b461vsq0686a6pt1p0kym6xf';
const REDIRECT_URI = 'http://localhost:3000';
const SCOPES = [
  'moderator:read:followers',
  'bits:read',
  'channel:read:subscriptions'
].join(' ');

const authUrl = `https://id.twitch.tv/oauth2/authorize?client_id=${CLIENT_ID}&redirect_uri=${encodeURIComponent(REDIRECT_URI)}&response_type=code&scope=${encodeURIComponent(SCOPES)}`;

console.log('Open this URL in your browser:');
console.log(authUrl);
console.log('\nWaiting for redirect on http://localhost:3000 ...');

const server = http.createServer(async (req, res) => {
  const url = new URL(req.url, 'http://localhost:3000');
  const code = url.searchParams.get('code');

  if (!code) {
    res.end('No code found.');
    return;
  }

  res.end('Got it! Check your terminal for the tokens.');

  const tokenRes = await fetch('https://id.twitch.tv/oauth2/token', {
    method: 'POST',
    headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
    body: new URLSearchParams({
      client_id: CLIENT_ID,
      client_secret: CLIENT_SECRET,
      code,
      grant_type: 'authorization_code',
      redirect_uri: REDIRECT_URI
    })
  });

  const token = await tokenRes.json();

  if (token.access_token) {
    console.log('\n=== SAVE THESE VALUES ===');
    console.log('ACCESS_TOKEN:', token.access_token);
    console.log('REFRESH_TOKEN:', token.refresh_token);
    console.log('=========================\n');
  } else {
    console.log('Error getting token:', JSON.stringify(token, null, 2));
  }

  server.close();
});

server.listen(3000, () => console.log('Server ready on port 3000'));