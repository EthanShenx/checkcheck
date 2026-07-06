<div align="center">

<img src="assets/logo.png" alt="checkcheck" width="320" />

# checkcheck

**Manuscript checking skills for AI coding agents.**
Portable [Agent Skills](https://code.claude.com/docs/en/skills) that turn Claude Code, OpenAI Codex, and Qwen Code into a rigorous, submission-grade manuscript reviewer.

[![Skills](https://img.shields.io/badge/skills-1-000?style=flat-square)](skills/)
[![Claude Code](https://img.shields.io/badge/Claude_Code-✓-d97757?style=flat-square)](#install)
[![Codex](https://img.shields.io/badge/Codex_CLI-✓-000?style=flat-square)](#install)
[![Qwen Code](https://img.shields.io/badge/Qwen_Code-✓-615ced?style=flat-square)](#install)

</div>

---

## What's inside

| Skill | Trigger | What it does |
|-------|---------|--------------|
| **`run-nc-checks`** | _"nature communication"_ | Audits a manuscript package against **Nature Communications** format-compliance rules — cover letter, title/abstract/word & display-item limits, methods, statistics reporting, tables, figure legends, `Fig.` citation style, equations, Nature reference style, gene-symbol nomenclature, and ORCID coverage. |

### How it works — a safe two-run pipeline

1. **Run 1 — Report only.** The skill reads your submission and writes a `NC_CHECKS_SUMMARY.md` compliance report **without editing anything**, then stops and waits. Nothing is changed, because many "deviations" are deliberate.
2. **Run 2 — Revise.** After you review the report and say what to fix, it applies **only** the approved items (parallelized across subagents), and never fabricates statistics, referees, or ORCIDs — missing data is flagged `NEEDS AUTHOR INPUT`.

---

## Install

Clone once, then install into every agent you use. Claude Code is linked (auto-updates on `git pull`); Codex and Qwen get generated command files from the same source.

```bash
git clone https://github.com/EthanShenx/checkcheck.git ~/checkcheck
cd ~/checkcheck
./install.sh            # installs into every detected agent
```

Install into just one agent:

```bash
./install.sh --claude   # Claude Code only
./install.sh --codex    # Codex CLI only
./install.sh --qwen     # Qwen Code only
```

<details>
<summary><b>What the installer writes (and how to do it manually)</b></summary>

| Agent | Location | Invoke as |
|-------|----------|-----------|
| **Claude Code** | `~/.claude/skills/run-nc-checks/` → **symlinked** to this repo | auto-triggers on _"nature communication"_ |
| **Codex CLI** | `~/.codex/prompts/run-nc-checks.md` | `/run-nc-checks` |
| **Qwen Code** | `~/.qwen/commands/run-nc-checks.toml` | `/run-nc-checks` |

**Manual install (Claude Code):** copy or symlink the skill folder:
```bash
ln -s ~/checkcheck/skills/run-nc-checks ~/.claude/skills/run-nc-checks
```
**Manual install (Codex):** copy the body of `skills/run-nc-checks/SKILL.md` (minus the YAML frontmatter) to `~/.codex/prompts/run-nc-checks.md`.
**Manual install (Qwen):** wrap the same body as the `prompt` field of `~/.qwen/commands/run-nc-checks.toml`.

</details>

---

## Usage

```
you ▸  run the nature communication checks on ./manuscript
       (Claude Code auto-triggers; on Codex/Qwen type /run-nc-checks)

  ⤷ Run 1 writes NC_CHECKS_SUMMARY.md and waits.
  ⤷ You review it and reply: "apply MT-REF-*, skip the cover-letter items"
  ⤷ Run 2 applies only those, and reports what still needs your input.
```

---

## Staying up to date

Pull the latest skills any time:

```bash
cd ~/checkcheck && git pull
```

- **Claude Code** picks up changes immediately — the skill folder is a symlink into this repo, so a `git pull` is all you need.
- **Codex & Qwen** use generated files, so re-run the installer after pulling:

```bash
cd ~/checkcheck && git pull && ./install.sh
```

Want it fully automatic? Add a shell alias that always syncs before you start work:

```bash
# ~/.zshrc or ~/.bashrc
alias checkcheck-update='git -C ~/checkcheck pull --quiet && ~/checkcheck/install.sh'
```

---

## Contributing skills

Each skill is a folder under [`skills/`](skills/) containing a single `SKILL.md` with YAML frontmatter (`name`, `description`) followed by the instructions. Drop in a new folder, and `install.sh` will pick it up for all three agents automatically.

---

<div align="center">
<sub>checkcheck · built for meticulous manuscripts</sub>
</div>
