<div align="center">

<img src="assets/logo.png" alt="checkcheck — logo" width="220" />

# checkcheck

### Manuscript checks that preserve authorial control.

[![Claude_Code](https://img.shields.io/badge/Claude_Code-supported-D97757?style=flat-square)](#install)
[![Codex](https://img.shields.io/badge/Codex-supported-111827?style=flat-square)](#install)
[![Qwen_Code](https://img.shields.io/badge/Qwen_Code-supported-615CED?style=flat-square)](#install)

</div>

---

| Skill | Invoke / say | Scope |
| --- | --- | --- |
| [`run-trivial-checks`](skills/run-trivial-checks/SKILL.md) | `/run-trivial-checks` / “trivial” | Language, terminology, abbreviations, nomenclature, tense, references, figure-panel and supplementary citations, number style, LaTeX syntax, statistics and prose-notation checks. |
| [`run-convention-checks`](skills/run-convention-checks/SKILL.md) | `/run-convention-checks` / “convention checks” | Academic-writing conventions, beginning with Methods rationale, citation, replication-detail and LaTeX-formatting checks. |
| [`run-de-ai`](skills/run-de-ai/SKILL.md) | `/run-de-ai` / “de-AI” | Identifies AI-like prose habits while retaining the manuscript’s scientific meaning and authorial voice. |
| [`run-nc-checks`](skills/run-nc-checks/SKILL.md) | `/run-nc-checks` / “nature communication(s)” | Nature Communications submission-format compliance: cover letter, main text, figures, references, nomenclature and ORCIDs. |

## The contract

```text
Run 1  →  write a review summary; edit nothing; wait for the author
Run 2  →  apply only approved findings; report the remaining author input
```

`run-trivial-checks` additionally validates the final diff to confirm revisions changed expression, not scientific content.

## Install

```bash
git clone https://github.com/EthanShenx/checkcheck.git ~/checkcheck
cd ~/checkcheck
./install.sh
```

Install one target only with `./install.sh --claude`, `--codex`, or `--qwen`. Claude Code uses linked skills and receives pulls immediately; rerun the installer after updating for Codex and Qwen.

## Use

```text
/run-trivial-checks ./manuscript
# or
/run-convention-checks ./manuscript
# or
/run-de-ai ./manuscript
# or
/run-nc-checks ./submission
```

Review the generated `*_SUMMARY.md`, then reply with the finding IDs to apply. The skills never invent data, statistics, ORCIDs, reviewer details, or other author-supplied information.
