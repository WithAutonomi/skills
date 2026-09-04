# PR #13 repair evidence — 2026-Sep-04

Implementation history: the binary-only repair landed at `dcca31ed347a12e620eaaaf784ec1e70ee26d6c8`; the 0.1.4 install/freshness repair landed at `e4f5a9776ab45af0cd5a7392000ba80dd16fa660`, based on pushed 0.1.3 revision `807e03cebe5b06886a42c6c013ed9797258122ac`.

This is local evidence, not CI. GitHub CI covers ADR governance only. No `.gsd/gate.sh` or skill-specific CI arbiter exists, so local evidence is weaker than CI and independent clean-context evidence.

## Static checks

- `python3 scripts/adr-governance.py` — passed, 14 ADR files checked.
- `npx skills add ./ --list` — passed, local path validated and one skill named `autonomi` discovered.
- Equivalent frontmatter check — passed: name `autonomi`; description 1,021 characters; compatibility 332 characters.
- Active version agreement — passed: `skills/autonomi/VERSION`, skill frontmatter, plugin manifest and marketplace manifest all report `0.1.4`.
- Plugin JSON parsing — passed.
- Relative Markdown links and anchors across the shipped skill — passed, five files checked.
- Vocabulary scan — only the accepted product phrase `permanence tier` matched.
- Lengths — passed: `SKILL.md` 261 lines; references 60, 112, 73 and 103 lines.
- Forbidden shipped claims/commands — no `ant update --check`, ANT-and-ETH wallet-balance claim, or `rm -rf` found.
- Changed-claim source-binding review — passed against ant-client 0.3.6 at `dbc01ce8fdbdfe9ac4d064d35f36b4684bf6a616`: CLI identity in `ant-cli/src/cli.rs`; update flags and behavior in `ant-cli/src/commands/update.rs` and `ant-core/src/update.rs`; ANT-only wallet output in `ant-cli/src/commands/data/wallet.rs`; reset safeguards and missing-path behavior in `ant-cli/src/commands/node/reset.rs` and `ant-core/src/node/mod.rs`; Unix config paths and bootstrap preservation in `ant-core/src/config.rs` lines 27–45 and 60–80 plus `install.sh` platform/config handling.
- `git diff --check` — passed.
- New release-check URL — HTTP 200.
- Skill `VERSION` URL — HTTP 404 while the repository is private, matching the documented best-effort failure path; an unauthenticated HTTP 200 remains a post-publication promotion check.
- `skills-ref` — unavailable; the documented equivalent frontmatter check was used.
- Snyk agent scan — not run because `SNYK_TOKEN` is unavailable.

The first ad-hoc Node frontmatter command failed because its regular expression did not parse the indented version field. The corrected parser produced the passing result above; no repository or test-harness change was used to turn a product failure green. The repository-root commands were `python3 scripts/adr-governance.py`, `npx skills add ./ --list`, `python3 -m json.tool .claude-plugin/plugin.json`, `python3 -m json.tool .claude-plugin/marketplace.json`, `wc -l skills/autonomi/SKILL.md skills/autonomi/references/*.md`, `rg -n 'ant update --check|ANT and ETH balances|shows the ANT and ETH|rm -rf' skills/autonomi`, and `git diff --check e616b9f5e9724007ed56911cb94b479319227e45`. Frontmatter/version, links/anchors and changed-claim provenance were direct read-only inspections of the files and exact upstream sources named above, not committed verifier scripts.

For 0.1.3, source inspection at ant-client commit `dbc01ce8fdbdfe9ac4d064d35f36b4684bf6a616` confirmed that wallet dispatch unconditionally calls `require_secret_key()` before either wallet action (`ant-cli/src/main.rs` lines 133–138 and 393–400), while free reads and `file cost` build a data client without requiring a wallet (lines 140–159 and 191–211). No wallet command or key was used. The full local static set above passed with all active versions at 0.1.3, description 1,021 characters, compatibility 332 characters, five shipped Markdown files resolving their links/anchors, and only the accepted `permanence tier` vocabulary match.

For 0.1.4, `python3 scripts/adr-governance.py` passed 14 ADRs; `npx skills add ./ --list` validated the local path and found only `autonomi`; the equivalent frontmatter check reported name `autonomi`, description 1,021 characters and compatibility 332; all four active version surfaces reported 0.1.4; both plugin files parsed as JSON; five shipped Markdown files resolved 27 relative links/anchors; lengths stayed within limits; vocabulary had only the accepted `permanence tier` match; forbidden claims/commands were absent; and `git diff --check 807e03cebe5b06886a42c6c013ed9797258122ac` passed. The first 0.1.4 frontmatter inspection command failed because its ad-hoc regular expression treated the apostrophe inside `network's` as a quote delimiter. A corrected read-only parser handled the double-quoted YAML field and produced the passing values above; no repository, harness, CI, gate or expectation changed.

## Disposable 0.1.4 config-path proof

No command used the real home directory or invoked `ant`. Four fresh fixtures under `${TMPDIR:-/tmp}` replaced `HOME`, `XDG_CONFIG_HOME` and `uname`; the install snippet itself was unchanged. On each platform, one run started without a destination file and compared the copied result with the source; another started with a sentinel destination, reran the snippet and compared its SHA-256 before and after. Wrong-platform and default paths were asserted absent.

Equivalent reproduction, using only the snippet committed in `skills/autonomi/references/install-and-verify.md` (the literal four original shell invocations were not retained):

```bash
set -euo pipefail
for OS in Darwin Linux; do
  FIXTURE=$(mktemp -d "${TMPDIR:-/tmp}/autonomi-config-${OS}.XXXXXX")
  mkdir -p "$FIXTURE/fake-bin" "$FIXTURE/source"
  printf '#!/bin/sh\nprintf "%s\\n"\n' "$OS" > "$FIXTURE/fake-bin/uname"
  chmod 755 "$FIXTURE/fake-bin/uname"
  printf 'new bootstrap\n' > "$FIXTURE/source/bootstrap_peers.toml"
  run_snippet() {
    HOME="$FIXTURE/home" XDG_CONFIG_HOME="$FIXTURE/xdg" SOURCE="$FIXTURE/source" PATH="$FIXTURE/fake-bin:/usr/bin:/bin" bash -c '
      set -euo pipefail
      if [ "$(uname -s)" = "Darwin" ]; then
        ANT_CONFIG_DIR="$HOME/Library/Application Support/ant"
      else
        ANT_CONFIG_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/ant"
      fi
      mkdir -p "$ANT_CONFIG_DIR"
      test -e "$ANT_CONFIG_DIR/bootstrap_peers.toml" || cp "$SOURCE/bootstrap_peers.toml" "$ANT_CONFIG_DIR/"
    '
  }
  if [ "$OS" = Darwin ]; then
    EXPECTED="$FIXTURE/home/Library/Application Support/ant/bootstrap_peers.toml"
    WRONG="$FIXTURE/home/.config/ant/bootstrap_peers.toml"
    WRONG_ALSO=""
  else
    EXPECTED="$FIXTURE/xdg/ant/bootstrap_peers.toml"
    WRONG="$FIXTURE/home/.config/ant/bootstrap_peers.toml"
    WRONG_ALSO="$FIXTURE/home/Library/Application Support/ant/bootstrap_peers.toml"
  fi
  run_snippet
  cmp "$FIXTURE/source/bootstrap_peers.toml" "$EXPECTED"
  test ! -e "$WRONG"
  test -z "$WRONG_ALSO" || test ! -e "$WRONG_ALSO"
  printf 'existing bootstrap\n' > "$EXPECTED"
  BEFORE=$(shasum -a 256 "$EXPECTED")
  run_snippet
  AFTER=$(shasum -a 256 "$EXPECTED")
  test "$BEFORE" = "$AFTER"
done
```

Results:

```text
macOS copy fixture: /var/folders/f_/j942sskj6nx67b6gk3rqgsqm0000gn/T/autonomi-config-macos-copy.Q9Vwts
macOS destination: $HOME/Library/Application Support/ant/bootstrap_peers.toml
Copied when absent: yes
Wrong Linux path untouched: yes

XDG-Linux copy fixture: /var/folders/f_/j942sskj6nx67b6gk3rqgsqm0000gn/T/autonomi-config-linux-copy.gnSpXP
Linux destination: $XDG_CONFIG_HOME/ant/bootstrap_peers.toml
Copied when absent: yes
Wrong default/macOS paths untouched: yes

macOS preservation fixture: /var/folders/f_/j942sskj6nx67b6gk3rqgsqm0000gn/T/autonomi-config-macos.7X0u56
Existing bootstrap preserved: yes
SHA-256 before/after: 86ec6e75bf8665608d1a132e13a2ec4442bab3bc02a90591ea6f5f75a9a8f2d7

XDG-Linux preservation fixture: /var/folders/f_/j942sskj6nx67b6gk3rqgsqm0000gn/T/autonomi-config-linux.5GewYs
Existing bootstrap preserved: yes
SHA-256 before/after: 6f97aa921aca5df77a3224be3b66cd66412f0cfb73021574c83f5ea4c96c6ba0
```

## Disposable uninstall proof

No command used the real home directory or invoked an installed `ant`. The portable rerun selected a fresh fixture under the operating system's existing `${TMPDIR:-/tmp}` directory and required no machine-specific parent path.

The Autonomi-shaped fixture exposed a regular, non-symlink fake executable whose `--version` output was `ant 0.3.6` and whose `--help` output identified `Autonomi network client` with `wallet`, `file`, `node`, `chunk` and `update`. The check located that executable through a fixture-only `PATH`, verified both identity outputs, removed the exact file, asserted it was absent, asserted its parent directories remained, and compared SHA-256 hashes for every retained sentinel before and after.

Fixture setup and exercise commands:

```bash
set -euo pipefail
TMP_ROOT=${TMPDIR:-/tmp}
FIXTURE=$(mktemp -d "${TMP_ROOT%/}/autonomi-uninstall-failfast.XXXXXX")
mkdir -p "$FIXTURE/bin" "$FIXTURE/state/settings" "$FIXTURE/state/application-data/nodes" "$FIXTURE/state/logs" "$FIXTURE/state/payment-receipts" "$FIXTURE/installer-downloads" "$FIXTURE/source-files" "$FIXTURE/user-files"
printf '#!/bin/sh\nif [ "$1" = "--version" ]; then printf "ant 0.3.6\\n"; else printf "Autonomi network client\\nCommands: wallet file node chunk update\\n"; fi\n' > "$FIXTURE/bin/ant"
chmod 755 "$FIXTURE/bin/ant"
printf 'settings sentinel\n' > "$FIXTURE/state/settings/bootstrap_peers.toml"
printf 'cache sentinel\n' > "$FIXTURE/state/application-data/cache-state"
printf 'node sentinel\n' > "$FIXTURE/state/application-data/nodes/node-state"
printf 'log sentinel\n' > "$FIXTURE/state/logs/ant.log"
printf 'receipt sentinel\n' > "$FIXTURE/state/payment-receipts/upload-receipt"
printf 'installer sentinel\n' > "$FIXTURE/installer-downloads/ant-install.sh"
printf 'source sentinel\n' > "$FIXTURE/source-files/source.txt"
printf 'datamap sentinel\n' > "$FIXTURE/user-files/private.datamap"
BEFORE=$(shasum -a 256 "$FIXTURE/state/settings/bootstrap_peers.toml" "$FIXTURE/state/application-data/cache-state" "$FIXTURE/state/application-data/nodes/node-state" "$FIXTURE/state/logs/ant.log" "$FIXTURE/state/payment-receipts/upload-receipt" "$FIXTURE/installer-downloads/ant-install.sh" "$FIXTURE/source-files/source.txt" "$FIXTURE/user-files/private.datamap")
ANT_PATH=$(PATH="$FIXTURE/bin:/usr/bin:/bin" command -v ant)
test "$ANT_PATH" = "$FIXTURE/bin/ant"
test -f "$ANT_PATH"
test ! -L "$ANT_PATH"
VERSION_OUTPUT=$("$ANT_PATH" --version)
HELP_OUTPUT=$("$ANT_PATH" --help)
test "${VERSION_OUTPUT#ant }" != "$VERSION_OUTPUT"
printf '%s' "$HELP_OUTPUT" | rg -q 'Autonomi network client'
printf '%s' "$HELP_OUTPUT" | rg -q 'wallet.*file.*node.*chunk.*update'
rm "$ANT_PATH"
test ! -e "$FIXTURE/bin/ant"
test -d "$FIXTURE/bin"
test -d "$FIXTURE/state"
AFTER=$(shasum -a 256 "$FIXTURE/state/settings/bootstrap_peers.toml" "$FIXTURE/state/application-data/cache-state" "$FIXTURE/state/application-data/nodes/node-state" "$FIXTURE/state/logs/ant.log" "$FIXTURE/state/payment-receipts/upload-receipt" "$FIXTURE/installer-downloads/ant-install.sh" "$FIXTURE/source-files/source.txt" "$FIXTURE/user-files/private.datamap")
test "$BEFORE" = "$AFTER"
printf 'Fixture: %s\nIdentity: Autonomi client\nRegular non-symlink candidate: yes\nBinary removed: yes\nParent directories retained: yes\nBEFORE\n%s\nAFTER\n%s\n' "$FIXTURE" "$BEFORE" "$AFTER"
```

Result: binary removed; all retained hashes unchanged.

```text
Fixture: /var/folders/f_/j942sskj6nx67b6gk3rqgsqm0000gn/T/autonomi-uninstall-failfast.mSgr1x
Identity: Autonomi client
Regular non-symlink candidate: yes
Binary removed: yes
Parent directories retained: yes
BEFORE
c2ac126d14720bf1dc67285f939569d18035c5d9967b39c1dfe5c8791c55ea48  /var/folders/f_/j942sskj6nx67b6gk3rqgsqm0000gn/T/autonomi-uninstall-failfast.mSgr1x/state/settings/bootstrap_peers.toml
6b6c43a00619ae67c407de895e4beca86c7b1a83a2dce9c57cdbce121f585a3e  /var/folders/f_/j942sskj6nx67b6gk3rqgsqm0000gn/T/autonomi-uninstall-failfast.mSgr1x/state/application-data/cache-state
0c42828cf9b5a176231ca6894df1d6a5f62239ef745c226a5b4f41fe45a79a76  /var/folders/f_/j942sskj6nx67b6gk3rqgsqm0000gn/T/autonomi-uninstall-failfast.mSgr1x/state/application-data/nodes/node-state
f2e25311ee176d8c12ee18989210d9a553ba5e7af43b557df71a5780dd6cac2d  /var/folders/f_/j942sskj6nx67b6gk3rqgsqm0000gn/T/autonomi-uninstall-failfast.mSgr1x/state/logs/ant.log
fa16da00a85217832ccec37a71b1e51b8303932b863a83ddcd805dfa0e5105fb  /var/folders/f_/j942sskj6nx67b6gk3rqgsqm0000gn/T/autonomi-uninstall-failfast.mSgr1x/state/payment-receipts/upload-receipt
3a6f409a5c2cecbabc1a9d47230845a027a80c199f8f6dfcf9ed25ab22bcd802  /var/folders/f_/j942sskj6nx67b6gk3rqgsqm0000gn/T/autonomi-uninstall-failfast.mSgr1x/installer-downloads/ant-install.sh
aa569e72c43489dfc9fb9ed63fc710464391ee8d9e6a57781c43c2ecaeebed29  /var/folders/f_/j942sskj6nx67b6gk3rqgsqm0000gn/T/autonomi-uninstall-failfast.mSgr1x/source-files/source.txt
f52336153111aecb145280f4c7357c94addf875781c7fa44459d1e2bdd320693  /var/folders/f_/j942sskj6nx67b6gk3rqgsqm0000gn/T/autonomi-uninstall-failfast.mSgr1x/user-files/private.datamap
AFTER
c2ac126d14720bf1dc67285f939569d18035c5d9967b39c1dfe5c8791c55ea48  /var/folders/f_/j942sskj6nx67b6gk3rqgsqm0000gn/T/autonomi-uninstall-failfast.mSgr1x/state/settings/bootstrap_peers.toml
6b6c43a00619ae67c407de895e4beca86c7b1a83a2dce9c57cdbce121f585a3e  /var/folders/f_/j942sskj6nx67b6gk3rqgsqm0000gn/T/autonomi-uninstall-failfast.mSgr1x/state/application-data/cache-state
0c42828cf9b5a176231ca6894df1d6a5f62239ef745c226a5b4f41fe45a79a76  /var/folders/f_/j942sskj6nx67b6gk3rqgsqm0000gn/T/autonomi-uninstall-failfast.mSgr1x/state/application-data/nodes/node-state
f2e25311ee176d8c12ee18989210d9a553ba5e7af43b557df71a5780dd6cac2d  /var/folders/f_/j942sskj6nx67b6gk3rqgsqm0000gn/T/autonomi-uninstall-failfast.mSgr1x/state/logs/ant.log
fa16da00a85217832ccec37a71b1e51b8303932b863a83ddcd805dfa0e5105fb  /var/folders/f_/j942sskj6nx67b6gk3rqgsqm0000gn/T/autonomi-uninstall-failfast.mSgr1x/state/payment-receipts/upload-receipt
3a6f409a5c2cecbabc1a9d47230845a027a80c199f8f6dfcf9ed25ab22bcd802  /var/folders/f_/j942sskj6nx67b6gk3rqgsqm0000gn/T/autonomi-uninstall-failfast.mSgr1x/installer-downloads/ant-install.sh
aa569e72c43489dfc9fb9ed63fc710464391ee8d9e6a57781c43c2ecaeebed29  /var/folders/f_/j942sskj6nx67b6gk3rqgsqm0000gn/T/autonomi-uninstall-failfast.mSgr1x/source-files/source.txt
f52336153111aecb145280f4c7357c94addf875781c7fa44459d1e2bdd320693  /var/folders/f_/j942sskj6nx67b6gk3rqgsqm0000gn/T/autonomi-uninstall-failfast.mSgr1x/user-files/private.datamap
```

The collision fixture exposed a fake executable whose `--version` output began `Apache Ant(TM) version 1.10.14`. The Autonomi identity predicate rejected it. The executable and sentinel remained present with these hashes:

```bash
set -euo pipefail
TMP_ROOT=${TMPDIR:-/tmp}
FIXTURE=$(mktemp -d "${TMP_ROOT%/}/apache-ant-failfast.XXXXXX")
mkdir -p "$FIXTURE/bin" "$FIXTURE/state"
printf '#!/bin/sh\nif [ "$1" = "--version" ]; then printf "Apache Ant(TM) version 1.10.14 compiled on August 16 2023\\n"; else printf "ant [options] [target]\\n"; fi\n' > "$FIXTURE/bin/ant"
chmod 755 "$FIXTURE/bin/ant"
printf 'must survive\n' > "$FIXTURE/state/sentinel"
BEFORE=$(shasum -a 256 "$FIXTURE/bin/ant" "$FIXTURE/state/sentinel")
ANT_PATH=$(PATH="$FIXTURE/bin:/usr/bin:/bin" command -v ant)
test "$ANT_PATH" = "$FIXTURE/bin/ant"
test -f "$ANT_PATH"
test ! -L "$ANT_PATH"
VERSION_OUTPUT=$("$ANT_PATH" --version)
! test "${VERSION_OUTPUT#ant }" != "$VERSION_OUTPUT"
test -e "$FIXTURE/bin/ant"
test -d "$FIXTURE/bin"
test -d "$FIXTURE/state"
AFTER=$(shasum -a 256 "$FIXTURE/bin/ant" "$FIXTURE/state/sentinel")
test "$BEFORE" = "$AFTER"
printf 'Fixture: %s\nIdentity: rejected as non-Autonomi\nRegular non-symlink candidate: yes\nBinary retained: yes\nParent directories retained: yes\nBEFORE\n%s\nAFTER\n%s\n' "$FIXTURE" "$BEFORE" "$AFTER"
```

```text
Fixture: /var/folders/f_/j942sskj6nx67b6gk3rqgsqm0000gn/T/apache-ant-failfast.HQ28ON
Identity: rejected as non-Autonomi
Regular non-symlink candidate: yes
Binary retained: yes
Parent directories retained: yes
BEFORE
4972c5ece6c27c5d51e876abe534ef6ff1b625802500af5e997e6875a65b5c1d  /var/folders/f_/j942sskj6nx67b6gk3rqgsqm0000gn/T/apache-ant-failfast.HQ28ON/bin/ant
4885ac8169b7ccc51fd3b6af4dfbf8c097330aa64d8b8789ad4903da6779d4fc  /var/folders/f_/j942sskj6nx67b6gk3rqgsqm0000gn/T/apache-ant-failfast.HQ28ON/state/sentinel
AFTER
4972c5ece6c27c5d51e876abe534ef6ff1b625802500af5e997e6875a65b5c1d  /var/folders/f_/j942sskj6nx67b6gk3rqgsqm0000gn/T/apache-ant-failfast.HQ28ON/bin/ant
4885ac8169b7ccc51fd3b6af4dfbf8c097330aa64d8b8789ad4903da6779d4fc  /var/folders/f_/j942sskj6nx67b6gk3rqgsqm0000gn/T/apache-ant-failfast.HQ28ON/state/sentinel
```

These were direct deterministic shell proofs, not clean-context agent evidence.

## Independent review

Initial adversarial review: blocked with no CRITICAL findings and four HIGH findings. It found the Apache Ant collision, unsafe/false node-reset wording, stale live PR metadata and incomplete evidence/checkpoint state. The collision and node wording were repaired; metadata needs a committed and pushed 0.1.2 revision; current-state records are being reconciled here.

Initial Craft Review: no CONFORMANCE findings; one SIMPLICITY concern that the uninstall rule was duplicated between the main skill and install reference. The reference now points to the main rule and adds only its path-table clarification.

Fresh adversarial re-reviews resolved the wrong-product and node-reset findings, then found no remaining CRITICAL/HIGH content defect. The final evidence recheck found no CRITICAL, HIGH or MEDIUM issue after the fail-fast rerun; its one LOW request was to identify the changed-claim source review and narrow an overbroad reproducibility sentence, both corrected above.

The direct Craft passes found and then cleared the duplicated uninstall rule and a source-binding concern caused by naming Apache Ant in shipped prose; the shipped warning is now product-neutral. A final prompt-bounded Craft pass found no CONFORMANCE or SIMPLICITY issue in the supplied final text. Its only NIT was a misspelling in the review prompt itself; `Autreti` does not occur in the repository. Exact-commit Craft later inspected `dcca31ed347a12e620eaaaf784ec1e70ee26d6c8` through Git and found stale pre-commit wording in `docs/CURRENT.md` and `planning/HANDOFF.md`; this follow-up corrects it.

Exact-revision Craft and adversarial review then inspected `1214aa87e5e68599ff4a02d2cb8a8c7e90f2fa5d`. They found no unsafe broad-delete route or mismatch in the corrected update, wallet, reset, version and licence claims, and confirmed the stale-state concern was fixed. They still marked the work not ready because official Fable clean-context did not run, Proposed ADR-0008 and DESIGN §6 still describe state removal, [PR #12](https://github.com/WithAutonomi/skills/pull/12) remains open and human approval is absent. The adversarial review also identified the machine-specific fixture parent, corrected by the portable rerun above, and a non-blocking race if the checked executable is replaced before deletion. Changing the shipped same-file rule would require a new version and a separately approved safety decision.

Exact-revision review at `f05c241be42ae4ed14424517a904bcc58a64bc9d` found a separate pre-existing factual defect: the wallet reference said `SECRET_KEY` was read only for commands that pay, but ant-client 0.3.6 unconditionally calls `require_secret_key()` for every wallet subcommand. Jim approved a bounded 0.1.3 correction: `wallet address`, `wallet balance` and paying operations require the key; free reads and `file cost` do not. He chose not to change the documented same-file replacement race, and approved binary-only uninstall as a temporary prototype divergence from Proposed ADR-0008 and DESIGN §6 while leaving formal pre-merge reconciliation open. The approved scope is in `planning/packets/PACKET-pr13-0.1.3-key-correction.md`.

Exact-revision adversarial and Craft reviews inspected 0.1.4 implementation commit `e4f5a9776ab45af0cd5a7392000ba80dd16fa660`. Both confirmed the Unix config-path correction itself is sound and bounded. Adversarial review found one MEDIUM mismatch: Proposed ADR-0013 called the raw HTTP response a guaranteed bounded scalar even though the shipped `curl` displays any successful response body to the agent. The no-new-machinery resolution keeps the command and explicitly treats its complete response as untrusted, interpreting only one valid semantic version and ignoring all other text. Its LOW findings are resolved by identifying `VERSION` as part of the bundle, labelling the fixture block as an equivalent reproduction rather than literal commands/output, and correcting the DESIGN inventory. Craft's one CONFORMANCE finding was stale pre-commit wording in the current-state records; this follow-up names the immutable implementation revision and removes the completed commit/push step. Exact re-review of the follow-up remains required.

The first clean-context dispatch was blocked before inference because it lacked the required `gsd.cleancontext.dispatch.v1` envelope; no commands ran and no files changed. A later validated dispatch is recorded below.

Implementation and the OpenAI adversarial/Craft agents used `gpt-5.6-sol`; those reviews are not cross-model evidence. The official Fable clean-context lane remains required for the independent provider/model boundary.

## Honesty rules

- No harness, CI, gate, build invocation or environment setup was changed.
- No failure was dismissed as environmental, flaky or pre-existing.
- Static-check outcomes, an equivalent reproducible fixture procedure and the recorded original outputs are documented above; the changed-claim source review names its exact upstream revision and files.
- No paid, node, upload, update, installed-client or real-home action ran.

## Failed clean-context dispatch — 2026-Sep-04

**Result: Not run / deferred.** A validated `gsd.cleancontext.dispatch.v1` brief targeted the clean committed revision `dcca31ed347a12e620eaaaf784ec1e70ee26d6c8`. OpenCode rejected `cleancontext` as a primary agent and fell back to its default `gpt-5.6-terra-fast` build agent. No Claude/Fable authentication or model call occurred, so the fallback output is not clean-context evidence.

- The fallback read the formal sources and ran only the brief's non-destructive static commands.
- It did not run a fixture deletion, use shell redirection, access the real home, invoke `ant`, or access credentials.
- Contrary to the read-only clean-context contract, it appended a report to this tracked file. That invalid report was replaced by this incident record before the branch advanced.
- The preserved private launcher lock is `/var/folders/f_/j942sskj6nx67b6gk3rqgsqm0000gn/T/opencode/gsd-cleancontext/lock`; its brief is 4,361 bytes with SHA-256 `3b129e71e0d28f0f2f25a0514750787fda4197eb0b55e2b4d99ceade60d5a2a9`.
- No retry is permitted in this session. The official Fable gate remains required before the work can be called PR/merge-ready.
