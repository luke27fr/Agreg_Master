/**
 * Upload content to Firestore for OTA delivery.
 * Uses Firebase CLI's stored credentials automatically.
 *
 * Usage:
 *   node _upload_batch.js [file1 file2 ...]
 *   CHANGELOG="msg" node _upload_batch.js file1 file2
 *   node _upload_batch.js                          (uploads glossaire.json as test)
 */

const { configstore } = require('firebase-tools/lib/configstore');
const https = require('https');
const fs = require('fs');
const path = require('path');

const PROJECT_ID = 'agreg-master-prod';
const BASE = `/v1/projects/${PROJECT_ID}/databases/(default)/documents`;
const FIREBASE_CLIENT_ID = '563584335869-fgrhgmd47bqnekij5i8b5pr03ho849e6.apps.googleusercontent.com';
const FIREBASE_CLIENT_SECRET = 'j9iVZfS8kkCEFUPaAeJV0sAi';

async function getFreshAccessToken() {
  const tokens = configstore.get('tokens');
  if (!tokens?.refresh_token) {
    throw new Error('No refresh token found. Run: firebase login');
  }
  const postData = new URLSearchParams({
    grant_type: 'refresh_token',
    refresh_token: tokens.refresh_token,
    client_id: FIREBASE_CLIENT_ID,
    client_secret: FIREBASE_CLIENT_SECRET,
  }).toString();

  return new Promise((resolve, reject) => {
    const req = https.request({
      hostname: 'oauth2.googleapis.com',
      path: '/token',
      method: 'POST',
      headers: {
        'Content-Type': 'application/x-www-form-urlencoded',
        'Content-Length': Buffer.byteLength(postData),
      },
    }, (res) => {
      let data = '';
      res.on('data', c => data += c);
      res.on('end', () => {
        const json = JSON.parse(data);
        if (json.access_token) resolve(json.access_token);
        else reject(new Error('Token exchange failed: ' + data));
      });
    });
    req.on('error', reject);
    req.write(postData);
    req.end();
  });
}

function firestoreRequest(method, docPath, body, token) {
  return new Promise((resolve, reject) => {
    const reqPath = `${BASE}/${docPath}`;
    const options = {
      hostname: 'firestore.googleapis.com',
      path: reqPath,
      method,
      headers: {
        'Authorization': `Bearer ${token}`,
        'Content-Type': 'application/json',
      },
    };
    const req = https.request(options, (res) => {
      let data = '';
      res.on('data', c => data += c);
      res.on('end', () => {
        if (res.statusCode >= 400) {
          reject(new Error(`HTTP ${res.statusCode} [${docPath}]: ${data.substring(0, 300)}`));
        } else {
          resolve(data ? JSON.parse(data) : null);
        }
      });
    });
    req.on('error', reject);
    if (body) req.write(JSON.stringify(body));
    req.end();
  });
}

function toFS(val) {
  if (typeof val === 'string') return { stringValue: val };
  if (typeof val === 'number') return Number.isInteger(val)
    ? { integerValue: String(val) } : { doubleValue: val };
  return { stringValue: String(val) };
}

async function main() {
  const files = process.argv.slice(2);
  if (files.length === 0) files.push('assets/glossaire.json');

  console.log(`=== Agreg Master - Content Upload ===`);
  console.log(`Project: ${PROJECT_ID}`);
  console.log(`Files:   ${files.length}\n`);

  console.log('Authenticating...');
  const token = await getFreshAccessToken();
  console.log('OK\n');

  // Read current version
  let currentVersion = 0;
  try {
    const doc = await firestoreRequest('GET', 'content_meta/current', null, token);
    if (doc?.fields?.version?.integerValue) {
      currentVersion = parseInt(doc.fields.version.integerValue);
    }
  } catch (e) {
    if (!e.message.includes('NOT_FOUND')) console.warn('Meta read warning:', e.message);
  }

  const newVersion = currentVersion + 1;
  console.log(`Version: v${currentVersion} -> v${newVersion}\n`);

  // Upload files
  let uploaded = 0;
  for (const filePath of files) {
    const fullPath = path.resolve(__dirname, '..', filePath);
    if (!fs.existsSync(fullPath)) {
      console.error(`  SKIP: ${filePath} (not found)`);
      continue;
    }
    const content = fs.readFileSync(fullPath, 'utf8');
    const docId = filePath.replace(/\//g, '--');
    const sizeKb = (content.length / 1024).toFixed(1);

    process.stdout.write(`  ${filePath} (${sizeKb} KB)... `);

    await firestoreRequest('PATCH', `content_files/${docId}`, {
      fields: {
        path: toFS(filePath),
        content: toFS(content),
        version: toFS(newVersion),
        updated_at: { timestampValue: new Date().toISOString() },
      }
    }, token);

    console.log('OK');
    uploaded++;
  }

  // Update version meta
  const changelog = process.env.CHANGELOG || 'Content update';
  await firestoreRequest('PATCH', 'content_meta/current', {
    fields: {
      version: toFS(newVersion),
      updated_at: { timestampValue: new Date().toISOString() },
      changelog: toFS(changelog),
    }
  }, token);

  console.log(`\nDone! v${newVersion} - ${uploaded} file(s) uploaded.`);
}

main().catch(e => { console.error('ERROR:', e.message); process.exit(1); });
