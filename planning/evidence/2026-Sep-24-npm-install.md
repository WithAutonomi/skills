# Checkpoint: npm-first client installation

Date: 2026-09-24
Role: implementation and scoped verification, OpenCode (openai/gpt-6-astra)
Branch: `autonomi-npm-install`; base `69ca49452e7555f607646bc9f023718bf43cd046`
Packet: [`PACKET-autonomi-npm-install.md`](../packets/PACKET-autonomi-npm-install.md)
Status: PR authorised for Hermes review; implementation committed at `81f023e7d74c232dd04bd47a88bf82f09887cc8a`. Hermes review and Jim's merge decision remain; not declared merge-ready.
Meaningful work-unit: Yes. Craft Review complete; adversarial report delivered; Claude clean-context not run and explicitly waived by Jim for this change. Historical dispatch/lock records below remain evidence, not current blockers to opening the PR.

## Owner review decision

On 24 September Jim directed: "Don't worry about the Claude review. Please can we just assemble a PR for this, and I can get it reviewed by Hermes?" The branch push and PR are authorised; Hermes review replaces the Claude gate. This is not a passed clean-context test, a waiver of truthful evidence, or merge approval. No attempt to clear or reuse the existing review lock will be made.

## Committed-review attempt

Jim authorised a local commit and the official Claude review. Commit `81f023e7d74c232dd04bd47a88bf82f09887cc8a` contains the 17 intended files; ADR governance and whitespace checks passed before commit, and the project worktree was clean afterwards. No hooks were bypassed.

The canonical namespace is owned by the caller and mode 700. The atomic acquisition command failed safely:

```text
mkdir -m 700 '/var/folders/f_/j942sskj6nx67b6gk3rqgsqm0000gn/T/opencode/gsd-cleancontext/lock'
mkdir: .../gsd-cleancontext/lock: File exists
```

Read-only inspection found a mode-700 lock directory, modified 22 September, with a brief for the separate **standalone Try Autonomi** review at candidate `5dc3288154e805cedfb2d8328eb377629f82cc5d`. Its presence does not establish whether that review is still running or stale. It was not overwritten, removed, or reused. No brief was written for this candidate, no valid dispatch was sent, no Claude process launched, and no result or model identity is claimed. The initially generated run ID `14832cee-c65b-4239-9af5-d2d0602453f0` was unused.

An earlier compound namespace precheck had returned success for an absent-lock test, but later inspection and the atomic `mkdir` both found the lock. The failed atomic acquisition is authoritative; no assumption about a race or stale read was used to override it. GSD launcher revision inspected: `3708e21221415895406e1f46539bea7a64feeb5c`; its three load-bearing launcher files matched HEAD.

At that point clean-context was blocked before dispatch. Jim's subsequent decision above removes that gate for this PR; the existing lock remains untouched.

## Changes

- npm-first setup; Linux/macOS and Windows direct scripts moved to the bundled reference, with manual checksum path retained.
- npm ownership checks before update/removal; retained-state policy unchanged; no node teardown.
- README, pinned source evidence, installation-related design/source-map notes, testing expectations, and current handoff aligned; version 0.1.5 synchronized across all four release surfaces.
- OpenClaw, archives, wallet/node operations, CI and governance mechanisms unchanged.

## Local evidence

`bash planning/evidence/npm-install-proof.sh` on macOS, Node v22.22.3, npm 10.9.8:

```text
added 2 packages
@withautonomi/ant@0.3.8
Identity, npm ownership and repeated detection: PASS (ant 0.3.8)
ant file --help: upload, download, cost
npm view @withautonomi/ant@latest version: 0.3.8
npm update -g @withautonomi/ant: changed 2 packages; ant 0.3.8
npm uninstall -g @withautonomi/ant: removed 2 packages
Removal and 9 retained-state hashes: PASS
```

Successful disposable root: `/var/folders/f_/j942sskj6nx67b6gk3rqgsqm0000gn/T/autonomi-npm-proof.5Ciu5n`. Its home, npm prefix and cache are isolated; retained files remain available for inspection. No wallet, key, paid operation, node, daemon or real-home change. Update exercised the package-manager command at the current latest version, not a cross-version upgrade. Repeated detection is a mechanical check, not proof of agent behaviour.

The first new-proof run stopped after installation on `/var` versus `/private/var` in the ownership assertion. The expected and actual launcher now both use `realpathSync`; equality remains strict. This is an explicitly in-scope new test correction, not an environmental dismissal or a relaxed assertion. No base implementation of this new proof exists. The unsuccessful root `autonomi-npm-proof.sZHpc9` is also retained; nothing was removed from the real installation.

Independent static verifier: ADR governance (14 records), equivalent frontmatter via existing PyYAML, synchronized version/plugin JSON, shipped relative links/anchors, vocabulary, lengths and skill discovery passed. `skills-ref` unavailable; its documented equivalent was used. Discovery used an isolated home/cache and `npx skills add ./ --list` (`skills@1.7.0`), found exactly `autonomi`, and installed no skill. An initial discovery invocation mistakenly supplied the same npm user/global config path; that command error reproduced on base `69ca494`, then the verifier used distinct disposable config paths. It was not attributed to the candidate.

Static verifier observations: missing evidence link and outdated handoff were work-in-progress items completed here. The README's pre-existing `-a claude` example differs from current skills CLI `claude-code`; reproduced with `git show 69ca494:README.md`, left outside this installation-method change.

## Evidence limits and reviews

- Local gate: no `.gsd/gate.sh`. ADR CI: `.github/workflows/adr-governance.yml`, filtered to governance paths; unchanged and not triggered by this local candidate. For installation behaviour, **no CI arbiter exists; evidence is weaker**.
- Security scan: not run; existing `SNYK_TOKEN` absent. No new credential or paid tooling requested.
- Windows and Linux runtime proof: not run here. Direct installers retained from prior instructions; no new execution proof claimed.
- Script-disabled and optional-dependency-failure behaviour: source-read, not yet executed in this checkpoint.
- Cryptographic npm attestation chain: not independently verified. Packaging-time verification is not claimed as local release-signature verification.
- Craft Review: **Pass**, fresh `craft` session `ses_f2d18d75bffekAMTUJKALjDs1n`. It read all candidate files plus the full captured tracked diff against `69ca494`, and all three then-untracked files as new content. No CONFORMANCE/SIMPLICITY/NIT findings. It initially lacked diff access; an in-workspace capture under `.git/` resolved that. Same model/provider as implementer, so independence is weaker. Subsequent edits are evidence/review records and the PR draft, not shipped instructions.
- Clean-context review: **Not run; Jim-waived in favour of Hermes review.** The first incomplete dispatch was rejected before Claude invocation. After Jim authorised the local commit, atomic lock acquisition failed as recorded above. No Claude process or substitute result was used. Neither failure is presented as review evidence.
- Adversarial review: **Report attached below**, session `ses_f2d18d6c5ffeTUM1l64JU4SXfA`, fresh OpenAI gpt-6-astra; same-model independence limit. One review at this gate; no automatic fix-loop.

## Adversarial report and disposition

- No CRITICAL/HIGH content defect or new data-loss path found. Source review supports npm identity, platform delivery, bootstrap behaviour, update refusal and verification wording.
- **MEDIUM, evidence:** mechanical proof does not prove an agent follows detection, approval or wrong-prefix refusal. Required fresh-agent installation/free-read and npm-removal scenarios remain open; do not call the work merge-ready.
- **MEDIUM, evidence, resolved:** the reviewer saw uncommitted files. The candidate and recorded commands now exist in commit `81f023e` and subsequent evidence-only commits, available for checkout once pushed. Hermes can review the exact PR head.
- **LOW, inherited:** the Windows direct fallback retains `-ExecutionPolicy Bypass`, while nearby new prose requires honouring organisational execution policy. Identical invocation was verified in `git show 69ca494:skills/autonomi/SKILL.md`; carried as a non-blocking observation, not silently broadened or corrected in this gate. Jim may choose a separate clarification.
- Scope observations: same-version npm update is not an upgrade proof; fixtures are representative retained state, not live nodes; no Windows/Linux runtime, script-disabled, missing-optional-dependency or cryptographic-attestation proof. Do not expand into a test framework or platform automation to close unapproved scope.

## Reproducible static commands

Run from the repo root. These check the declared existing requirements; they do not alter the gate or replace the independent agent scenarios.

```bash
python3 scripts/adr-governance.py
git diff --check 69ca494
bash -n planning/evidence/npm-install-proof.sh
```

Equivalent frontmatter, versions, lengths, vocabulary and relative-link checks (existing PyYAML required):

```bash
python3 - <<'PY'
import json, re
from pathlib import Path
from urllib.parse import unquote
import yaml
root = Path('skills/autonomi')
files = [root / 'SKILL.md', *sorted((root / 'references').glob('*.md'))]
meta = yaml.safe_load(files[0].read_text().split('---', 2)[1])
assert meta['name'] == root.name
assert re.fullmatch(r'[a-z0-9]+(?:-[a-z0-9]+)*', meta['name'])
assert len(meta['name']) <= 64
assert set(meta) <= {'name', 'description', 'license', 'compatibility', 'metadata', 'allowed-tools'}
for key, limit in [('description', 1024), ('compatibility', 500)]:
    assert isinstance(meta[key], str) and 0 < len(meta[key]) <= limit
    print(key, len(meta[key]))
assert all(isinstance(k, str) and isinstance(v, str) for k, v in meta['metadata'].items())
plugin = json.loads(Path('.claude-plugin/plugin.json').read_text())
market = json.loads(Path('.claude-plugin/marketplace.json').read_text())
entry, = [p for p in market['plugins'] if p['name'] == meta['name']]
versions = [(root / 'VERSION').read_text().strip(), meta['metadata']['version'], plugin['version'], entry['version']]
assert plugin['name'] == meta['name'] and set(versions) == {'0.1.5'}
vocab = re.compile(r'\b(tiers?|personas?|operators?|engines?|gauntlets?|packets?|source-bindings?|ADRs?|specs?|PRs?|TODOs?)\b', re.I)
def anchors(path):
    result, seen, fence = set(), {}, False
    for line in path.read_text().splitlines():
        if re.match(r'^\s*(```|~~~)', line):
            fence = not fence
            continue
        if fence:
            continue
        match = re.match(r'^#{1,6}\s+(.+?)\s*#*$', line)
        if match:
            heading = re.sub(r'\[([^]]+)\]\([^)]*\)', r'\1', match[1]).lower()
            slug = re.sub(r'[^\w\- ]', '', heading).replace(' ', '-')
            number = seen.get(slug, 0)
            seen[slug] = number + 1
            result.add(slug if not number else f'{slug}-{number}')
    return result
links = 0
for path in files:
    text = path.read_text()
    assert len(text.splitlines()) < (500 if path == files[0] else 200), path
    assert not vocab.search(re.sub(r'\b(permanence tier|retrieval tiers)\b', '', text, flags=re.I)), path
    for target in re.findall(r'\[[^\]]*\]\(([^)]+)\)', text):
        if re.match(r'[a-zA-Z][\w+.-]*:', target):
            continue
        local, _, anchor = unquote(target).partition('#')
        destination = path.parent / local if local else path
        assert destination.exists(), (path, target)
        assert not anchor or anchor in anchors(destination), (path, target)
        links += 1
print('PASS: metadata, four versions, length, vocabulary,', links, 'links/anchors')
PY
```

Isolated discovery (no skill installation, no caller configuration):

```bash
ROOT=$(mktemp -d "${TMPDIR:-/tmp}/autonomi-discovery.XXXXXX")
mkdir -p "$ROOT/home" "$ROOT/tmp" "$ROOT/prefix"
env -i PATH="$PATH" HOME="$ROOT/home" TMPDIR="$ROOT/tmp" \
  XDG_CONFIG_HOME="$ROOT/home/.config" XDG_DATA_HOME="$ROOT/home/.local/share" \
  XDG_CACHE_HOME="$ROOT/home/.cache" npm_config_cache="$ROOT/npm-cache" \
  npm_config_prefix="$ROOT/prefix" npm_config_userconfig="$ROOT/user.npmrc" \
  npm_config_globalconfig="$ROOT/global.npmrc" npm_config_yes=true \
  npm_config_ignore_scripts=true DISABLE_TELEMETRY=1 DO_NOT_TRACK=1 CI=1 \
  npx skills add ./ --list
```

Final rerun: all three command blocks above passed after the PR draft and review records were added. ADR governance checked 14 records; description 1,021 characters, compatibility 326; all four versions 0.1.5; 30 shipped relative links/anchors; discovery found exactly `autonomi`. `git diff --check` also passed. This is local working-tree evidence, not CI or a committed-revision review.

## Honesty and handoff

Test changes are explicitly approved in this packet: npm lifecycle proof and npm variants added without removing prior standalone/collision/state checks. No CI/gate/harness-adapter changes, no failures hidden, no real-state destruction. The proof script and static commands are committed in the candidate; checks remain dependent on their documented local prerequisites.

Next: publish the authorised PR using [the prepared description](../PR-autonomi-npm-install.md), then hand it to Jim for Hermes review. Do not recover the shared lock, rerun Claude, or merge. This checkpoint makes no release/merge-readiness claim.
