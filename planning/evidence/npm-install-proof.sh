#!/usr/bin/env bash
# Disposable macOS/Linux proof; never installs into the caller's npm prefix.
set -euo pipefail

TEST_ROOT=$(mktemp -d "${TMPDIR:-/tmp}/autonomi-npm-proof.XXXXXX")
export HOME="$TEST_ROOT/home"
export XDG_CONFIG_HOME="$HOME/.config" XDG_DATA_HOME="$HOME/.local/share"
export XDG_CACHE_HOME="$HOME/.cache"
export npm_config_prefix="$TEST_ROOT/prefix" npm_config_cache="$TEST_ROOT/npm-cache"
export npm_config_userconfig="$TEST_ROOT/npmrc"
mkdir -p "$HOME" "$npm_config_prefix"
export PATH="$npm_config_prefix/bin:$PATH"
export TEST_ROOT
printf 'Disposable evidence retained at: %s\n' "$TEST_ROOT"
node --version
npm --version

# Sentinels stand for retained state, not a real wallet or node.
node <<'NODE'
const fs = require('node:fs');
const path = require('node:path');
const crypto = require('node:crypto');
const root = process.env.TEST_ROOT;
const home = process.env.HOME;
const config = process.platform === 'darwin'
  ? path.join(home, 'Library/Application Support/ant')
  : path.join(process.env.XDG_CONFIG_HOME, 'ant');
const files = [path.join(config, 'bootstrap_peers.toml'), ...[
  'settings', 'application-data', 'logs', 'nodes', 'payment-receipts',
  'installer-download', 'source-file', 'private.datamap'
].map(name => path.join(home, 'retained', name))];
const sums = {};
for (const file of files) {
  fs.mkdirSync(path.dirname(file), {recursive: true});
  fs.writeFileSync(file, '# disposable retained-state sentinel\n');
  sums[file] = crypto.createHash('sha256').update(fs.readFileSync(file)).digest('hex');
}
fs.writeFileSync(path.join(root, 'retained-hashes.json'), JSON.stringify(sums));
NODE

npm install -g @withautonomi/ant
ANT="$npm_config_prefix/bin/ant"
test "$(command -v ant)" = "$ANT"
npm prefix -g
npm root -g
npm list -g --depth=0 @withautonomi/ant
node - "$ANT" <<'NODE'
const fs = require('node:fs');
const path = require('node:path');
const assert = require('node:assert/strict');
const pkg = path.join(process.env.npm_config_prefix, 'lib/node_modules/@withautonomi/ant');
assert.equal(fs.realpathSync(process.argv[2]), fs.realpathSync(path.join(pkg, 'bin/ant.js')));
const meta = JSON.parse(fs.readFileSync(path.join(pkg, 'package.json'), 'utf8'));
assert.equal(meta.name, '@withautonomi/ant');
assert.equal(meta.bin.ant, 'bin/ant.js');
const cp = require('node:child_process');
const version = cp.execFileSync(process.argv[2], ['--version'], {encoding: 'utf8'}).trim();
assert.equal(version, `ant ${meta.version}`);
const help = cp.execFileSync(process.argv[2], ['--help'], {encoding: 'utf8'});
assert.match(help, /Autonomi network client/);
for (const command of ['wallet', 'file', 'node', 'chunk', 'update']) {
  assert.match(help, new RegExp(`\\b${command}\\b`));
}
// Detect a working installation again, without reinstalling or updating it.
const before = fs.readFileSync(path.join(pkg, 'package.json'));
cp.execFileSync(process.argv[2], ['--version']);
cp.execFileSync(process.argv[2], ['--help']);
assert.deepEqual(fs.readFileSync(path.join(pkg, 'package.json')), before);
console.log(`Identity, npm ownership and repeated detection: PASS (${version})`);
NODE
"$ANT" file --help
npm view @withautonomi/ant@latest version
npm update -g @withautonomi/ant
"$ANT" --version

# Explicitly authorised removal of this proof's package only; retain everything else.
npm uninstall -g @withautonomi/ant
test ! -e "$ANT"
test ! -L "$ANT"
test ! -e "$npm_config_prefix/lib/node_modules/@withautonomi/ant"
node <<'NODE'
const fs = require('node:fs');
const crypto = require('node:crypto');
const assert = require('node:assert/strict');
const sums = JSON.parse(fs.readFileSync(`${process.env.TEST_ROOT}/retained-hashes.json`, 'utf8'));
for (const [file, expected] of Object.entries(sums)) {
  assert.equal(crypto.createHash('sha256').update(fs.readFileSync(file)).digest('hex'), expected, file);
}
console.log(`Removal and ${Object.keys(sums).length} retained-state hashes: PASS`);
NODE
