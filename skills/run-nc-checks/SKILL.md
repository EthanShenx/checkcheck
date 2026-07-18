---
name: run-nc-checks
description: >
  Check a manuscript submission package against Nature Communications journal format-compliance
  requirements — cover letter, main text (title/abstract/word & display-item limits, methods,
  statistics reporting, tables, figure legends, figure/table citation style, equations, references
  in Nature style), gene/protein nomenclature (symbols not italicized full names), and ORCID
  coverage. Use this skill whenever the user says "nature communication", "nature communications",
  "run nc checks", "NC checks", or asks to check a manuscript against Nature Communications
  formatting. Two-run pipeline: the FIRST run only produces a compliance summary markdown (never
  edits) and waits for the user to say what to revise; the SECOND run applies only the approved
  revisions (via subagents).
allowed-tools:
  - Read
  - Write
  - Edit
  - Grep
  - Glob
  - Bash
  - Agent
  - AskUserQuestion
  - TodoWrite
---

# Run Nature Communications Format Checks

A two-phase Nature Communications (NC) submission-compliance pipeline. As with the trivial checks,
**the first run only reports** — many apparent deviations are deliberate or dictated by the author's
data — so the user decides what actually gets changed.

## Mandatory workflow

1. **Inspect only:** read the complete submission package and measure every relevant requirement.
2. **Report only:** write `NC_CHECKS_SUMMARY.md`; do not edit any submission file.
3. **Wait:** stop after the report and obtain the author’s explicit approval of finding IDs/areas.
4. **Revise only approved findings:** a report or a detected non-compliance is never permission to
   edit.

## Subagent parity

When invoking a subagent for analysis, revision, or validation, configure it with the **same model,
intelligence level, and reasoning effort as the current agent**. For example, if the current agent
is Opus 4.8 with high reasoning, every subagent must be Opus 4.8 with high reasoning. Never
delegate a decision to a lower-capability or lower-reasoning agent. If exact parity cannot be set,
perform the work locally instead.

## Detecting which run this is

- **First run (REPORT):** No `NC_CHECKS_SUMMARY.md` in the manuscript directory yet, or the user is
  just asking to run the NC checks. → Produce the summary; **do not edit** the manuscript.
- **Second run (REVISE):** `NC_CHECKS_SUMMARY.md` exists AND the user is telling you what to revise.
  → Apply only the approved changes (via subagents where useful).

If ambiguous, ask which phase the user wants.

## Locating the submission package

If the user did not name the files, find them in the working directory:

- Main text: `Glob` `**/*.tex` (main file has `\documentclass`/`\begin{document}`) or `**/*.docx` /
  `**/*.md`.
- Cover letter: look for `**/*cover*letter*`, `**/*cover*`, or ask.
- References: `**/*.bib` and/or a bibliography section.
- Figures: image files / `\includegraphics` references (for the size check).

Write `NC_CHECKS_SUMMARY.md` into the manuscript's directory.

---

## PHASE 1 — Report only

Read the full package. Run every check below as analysis only. Produce `NC_CHECKS_SUMMARY.md` with,
per finding: an **ID** (e.g., `MT-ABSTRACT-01`), **location**, **requirement**, **current state**,
**proposed change / how to fix**, **status** (PASS / FAIL / NEEDS AUTHOR INPUT), and **confidence**.
Do not modify anything.

### A. Cover letter

Confirm it clearly:

1. Uses a professional formatting template with the university/institution **logo(s)**.
2. Follows cover-letter writing convention and professional format.
3. Addresses each of:
   1. Iterates the paper's main findings.
   2. Demonstrates impact for **both** the field **and** the broad science audience.
   3. Briefly discusses importance and why the work suits Nature Communications' diverse readership.
   4. Compares with competitors and explains why this work is unique.
   5. Suggests **5–6 referees** with names + contact info, and requests exclusion of referees if any.
   6. Provides affiliation and contact info for the corresponding author.
   7. States (at the end) whether there were prior discussions with an NC editor about the work.
   8. Avoids repeating information already in the abstract/introduction.

### B. Main text file (incorporating figures)

1. **Size** < 30 MB.
2. Requirements:
   1. **Title:** if possible < 15 words; no technical terms, abbreviations, punctuation, or active
      verbs.
   2. **Abstract:** ~130–170 words; general introduction to the topic + brief nontechnical summary
      of main results and their implications. (Report the exact word count.)
   3. **Main text:** ≤ 5,000 words (Introduction, Results, Methods, Discussion) and ≤ 10 display
      items (figures + tables), commensurate with length; papers < 2,000 words → ≤ 4 figures/tables.
      (Report exact word count and display-item count.)
   4. **Methods:** contains ALL elements needed to interpret and replicate results; as concise as
      possible; ≤ 3,000 words (longer only if truly necessary). (Report exact word count.)
   5. **Statistics throughout main text:** a Methods statistics section describing tests used and
      whether one- or two-tailed; error bars defined in every figure; EXACT `n` for every statistic
      (individual values, not a range, if n varied); exact P values for significant **and**
      non-significant results; ANOVA → F values + degrees of freedom; t-tests → t-values + degrees
      of freedom. Flag each missing element with its location.
   6. **Tables:** each has a short title sentence; further detail as footnotes; tables with
      statistical analysis describe standard-error analysis and ranges in the legend.
   7. **Figures:** legends < 350 words each; begin with a brief title sentence for the whole figure
      (and corresponding results writing); do **not** include the experimental results/data or the
      methods used in the legend; each panel + caption understandable, as far as possible, in
      isolation from the main text; keep methodological detail to a minimum. (Report each legend's
      word count.)
   8. **Figure/table citation style:** abbreviate "Figure" → "**Fig.**" except at the start of a
      sentence; "Table" spelled out; supplementary items as "Supplementary Fig. N" /
      "Supplementary Table N". Flag violations. Examples:
      - "Table 1 provides a selected subset of the most active compounds. The entire list of 96
        compounds can be found as Supplementary Table 1."
      - "The biosynthetic pathway of l-ascorbic acid in animals involves intermediates of the
        d-glucuronic acid pathway (see Supplementary Fig. 2). Figure 2 shows…"
   9. **Equations:** provided in the main text; referred-to equations get parenthetical numbers
      `(1)` and are referred to as "equation (1)".
   10. **References:** ≤ 70 references, in standard **Nature** referencing style:
       - All authors listed unless ≥ 6, then first author + `et al.`
       - Authors: last name first, comma, initials with full stops.
       - Article titles: Roman text, only the first word capitalized (plus proper nouns), exactly as
         in the cited work, ending with a full stop. Titles required for Articles/Letters/Reviews/
         Progress.
       - Book titles: *italic*, all words initial-capitalized; publisher + city required.
       - Journal names: *italic*, abbreviated with full stops per common usage.
       - Volume numbers **bold** (and the following comma); full page range given.
       - Preprints: `Author, A. Title — Preprint at http://arXiv.org/... (year).`
       - Examples: `Eigler, D. M. & Schweizer, E. K. Positioning single atoms with a scanning
         tunnelling microscope. Nature 344, 524-526 (1990).` /
         `Jones, R. A. L. Soft Machines: Nanotechnology and Life Ch. 3 (Oxford Univ. Press, Oxford,
         2004).`

3. **Nomenclature:** approved gene symbols, using **symbols rather than italicized full names**
   (e.g., `Ttn`, not *titin*).

4. **ORCID:** all corresponding authors provide ORCID; as many other authors as possible provide
   theirs.

### Summary file structure

Write `NC_CHECKS_SUMMARY.md` with:

- Header: files analyzed, date, note that **nothing has been edited**.
- A top **compliance dashboard** (PASS/FAIL/NEEDS INPUT per requirement) with exact measured numbers
  (word counts, display-item count, reference count, file size, legend word counts).
- One `##` section per area (Cover letter / Main text / Nomenclature / ORCID), each a findings table
  (ID | Requirement | Current state | Proposed fix | Status | Confidence).
- A final **"How to proceed"** section telling the user to reply with which IDs/areas to revise.
  Note that some items (e.g., adding referee suggestions, ORCID numbers, exact P/F/df statistics,
  institutional logos) **require author-supplied information** and cannot be fixed by editing alone —
  mark these NEEDS AUTHOR INPUT.

### End of Phase 1

Write the file, then **stop and wait**. Tell the user the summary is ready, nothing was edited, and
ask them to review it and say what to revise. Do not proceed to Phase 2 in the same turn.

---

## PHASE 2 — Revise (only what the user approved)

Trigger: the user has read `NC_CHECKS_SUMMARY.md` and told you what to change.

1. **Parse the approval** — Determine the exact IDs/areas approved. Ask if ambiguous. For NEEDS
   AUTHOR INPUT items, collect the missing information from the user (or leave a clearly marked
   `TODO` placeholder if they ask you to) rather than fabricating referees, ORCIDs, P values, F
   values, or degrees of freedom. **Never invent statistical values or reviewer contact details.**

2. **Apply changes, optionally via subagents** — For a large approved set, dispatch multiple
   `Agent` subagents over disjoint slices (e.g., one for reference-style reformatting, one for
   figure-legend/citation-style fixes, one for cover-letter structure, one for nomenclature). Give
   each: the file path(s), the exact approved findings it owns, and a strict instruction to change
   only those spans. Keep partitions disjoint.

3. **Report** — Summarize what was applied (by ID), what was skipped, and what still needs
   author-supplied information before the submission is compliant.

## Guardrails

- Phase 1 is strictly read-only on the manuscript. Do not edit while reporting.
- Report exact measured numbers (word counts, item counts, file size) — the NC limits are numeric,
  so precision matters.
- Never fabricate statistics, referee names/contacts, ORCID IDs, or citation details to make a check
  "pass". Flag missing data as NEEDS AUTHOR INPUT.
- Keep finding IDs stable between phases so approvals map cleanly onto edits.
