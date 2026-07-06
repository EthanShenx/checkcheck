#!/usr/bin/env bash
#
# checkcheck skill installer
# Installs every skill under ./skills/ into whichever of the supported agents
# are present on this machine: Claude Code, OpenAI Codex CLI, and Qwen Code.
#
# Usage:
#   ./install.sh            # install/update all skills for all detected agents
#   ./install.sh --claude   # only Claude Code
#   ./install.sh --codex    # only Codex CLI
#   ./install.sh --qwen     # only Qwen Code
#
# Claude Code is installed as a symlink, so a later `git pull` updates it with
# no re-run. Codex and Qwen use derived prompt/command files, so re-run this
# script (or `make update`) after pulling to refresh them.

set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SKILLS_DIR="$REPO_DIR/skills"

DO_CLAUDE=false DO_CODEX=false DO_QWEN=false
if [[ $# -eq 0 ]]; then
  DO_CLAUDE=true DO_CODEX=true DO_QWEN=true
else
  for arg in "$@"; do
    case "$arg" in
      --claude) DO_CLAUDE=true ;;
      --codex)  DO_CODEX=true ;;
      --qwen)   DO_QWEN=true ;;
      *) echo "unknown flag: $arg" >&2; exit 1 ;;
    esac
  done
fi

# Strip the YAML frontmatter (--- ... ---) from a SKILL.md, print the body.
skill_body() { awk 'NR==1&&/^---$/{f=1;next} f&&/^---$/{f=0;next} !f{print}' "$1"; }

info() { printf '  \033[32m✓\033[0m %s\n' "$1"; }

for skill_path in "$SKILLS_DIR"/*/; do
  name="$(basename "$skill_path")"
  src="$skill_path/SKILL.md"
  [[ -f "$src" ]] || continue
  echo "→ $name"

  # ---- Claude Code: ~/.claude/skills/<name> (symlink, auto-updates on pull)
  if $DO_CLAUDE; then
    dest="$HOME/.claude/skills/$name"
    mkdir -p "$HOME/.claude/skills"
    rm -rf "$dest"
    ln -s "${skill_path%/}" "$dest"
    info "Claude Code   → $dest"
  fi

  # ---- Codex CLI: ~/.codex/prompts/<name>.md (invoke as /<name>)
  if $DO_CODEX; then
    mkdir -p "$HOME/.codex/prompts"
    skill_body "$src" > "$HOME/.codex/prompts/$name.md"
    info "Codex CLI     → ~/.codex/prompts/$name.md  (use: /$name)"
  fi

  # ---- Qwen Code: ~/.qwen/commands/<name>.toml (invoke as /<name>)
  if $DO_QWEN; then
    mkdir -p "$HOME/.qwen/commands"
    {
      printf 'description = "%s skill (checkcheck)"\n' "$name"
      printf 'prompt = """\n'
      skill_body "$src"
      printf '"""\n'
    } > "$HOME/.qwen/commands/$name.toml"
    info "Qwen Code     → ~/.qwen/commands/$name.toml  (use: /$name)"
  fi
done

echo "Done."
