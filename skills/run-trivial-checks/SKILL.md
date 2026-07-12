---
name: run-trivial-checks
description: >
  Review a biomedical manuscript for author-approved, expression-level “trivial” checks: typos,
  grammar, abbreviations, gene/protein nomenclature, American English, case consistency, LaTeX
  expressions, statistical-reporting consistency, prose-appropriate mathematical notation,
  duplicate references, and section-appropriate tense. Use whenever the user says "trivial",
  "run trivial checks", or invokes /run-trivial-checks. First run reports only in
  TRIVIAL_CHECKS_SUMMARY.md; a later run applies only user-approved fixes and validates that
  scientific content did not change.
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

# Run Trivial Manuscript Checks

This is a deliberately conservative, two-phase manuscript-editing pipeline. Treat the manuscript
as biomedical writing: terminology, gene symbols, names, and deliberate wording are not typos by
default. The author decides what is changed.

## Detect the phase

- **Phase 1 — REPORT:** The user asks for trivial checks, or no
  `TRIVIAL_CHECKS_SUMMARY.md` exists in the manuscript directory. Analyse and write the summary;
  do **not** edit manuscript, bibliography, figures, or source files.
- **Phase 2 — REVISE:** The summary exists and the user identifies findings or areas to change.
  Apply only those approved edits, then launch a validation agent.

If the request is ambiguous, ask which phase is wanted. If a previous summary is stale because the
manuscript changed, create a fresh report rather than treating old IDs as approval targets.

## Locate the manuscript

If paths were not supplied, locate the manuscript directory and inspect its source:

- Prefer the root LaTeX file (`\documentclass` / `\begin{document}`) and its included `.tex`
  files; otherwise use the provided `.docx` or `.md` main text.
- Find bibliography data (`.bib` and/or a bibliography section), figures, tables, and supplementary
  text needed to interpret references and abbreviations.

Write `TRIVIAL_CHECKS_SUMMARY.md` in the manuscript directory.

---

## PHASE 1 — report only

Read the full relevant manuscript and support files. Do not make edits. Write a comprehensive
`TRIVIAL_CHECKS_SUMMARY.md` with a dashboard and a findings table for every area. Each finding
must have a stable ID (for example `TR-GRAMMAR-01`), location, excerpt or precise description,
reason, proposed change, status (`PASS`, `REVIEW`, or `NEEDS AUTHOR INPUT`), and confidence.
Avoid noisy speculative findings; biomedical terms and intentional stylistic choices should be
reported as `REVIEW`, not silently “corrected.”

### Required checks

1. **Typos.** Identify genuine likely spelling or typographical errors in biomedical context. Do
   not treat specialised terminology, accepted variants, gene/protein symbols, or proper names as
   errors without evidence.

2. **Grammar.** Identify grammatical errors and unclear construction, but do not rewrite for taste
   or change the scientific claim. Report only.

3. **Abbreviations.** Audit the full document for:
   - a consistent definition form: `define an abbreviation (DAA)` or `DAA (define an abbreviation)`;
   - definition on first use, with full term and parenthesised abbreviation;
   - consistent use of the abbreviation after definition, without unsafe partial matches (for
     example, defining mammary gland as `MG` does not make “mammary duct” an `MG duct`);
   - no redundant redefinition, except where a conventional redefinition is justified (for example,
     a new abstract or another independently read manuscript section);
   - defined abbreviations that never recur: flag the definition as probably unnecessary;
   - correct plurals and possessives (`RBCs`, not plural `RBC's`) and no partial-match mistakes.

4. **Gene and protein nomenclature.** Check LaTeX usage against this baseline and report species
   ambiguity as author input. Do not alter a symbol merely because it resembles a term.

   | Species | Gene symbol | Gene name | Protein symbol | Protein name |
   | --- | --- | --- | --- | --- |
   | Human / primate | uppercase *italic* | lowercase Roman | uppercase Roman | lowercase Roman |
   | Mouse / rat | first letter uppercase, rest lowercase *italic* | lowercase Roman | uppercase Roman | lowercase Roman |
   | Human example | *TP53* | p53 tumor protein | TP53 | p53 |
   | Mouse example | *Trp53* | transformation-related protein 53 | Trp53 / TP53 | transformation-related protein 53 |

5. **American English.** Flag British spellings for alignment to American English, for example
   `characterised` → `characterized` and `remodelling` → `remodeling`. Preserve quoted material,
   proper names, and reference titles.

6. **Case consistency.** Review article, section/subsection, figure, and table titles for a
   consistent convention (sentence case versus title case). Do not choose a convention or edit on
   the first run: state the observed convention and mark the author preference as `NEEDS AUTHOR
   INPUT` if it is not already clear.

7. **LaTeX expressions.** Flag special symbols that should be represented in LaTeX, including but
   not limited to a superscript plus in `Adam12+` (for example, `Adam12$^+$` where appropriate).
   Preserve symbols inside verbatim contexts, URLs, code, and reference metadata.

8. **Statistical reporting consistency.** Compare the main text, tables, figure legends, and text
   embedded in figures. Report inconsistent formats for P values, fold changes, confidence
   intervals, effect sizes, `n`, and other repeated statistics. In particular, check that:
   - P-value spelling/capitalisation, spacing, decimal precision, and use of `=` versus `<` or `>`
     are consistent throughout;
   - asterisk notation (`*`, `**`, `***`, and so on) has one clear, consistently applied threshold
     definition wherever it is used;
   - borderline or non-significant P values use exact values to two or three decimal places (for
     example, `p = 0.041` or `p = 0.075`), while highly significant results use an established
     threshold (for example, `p < 0.001`) rather than an impossible rounded value such as
     `p = 0.0000`;
   - analyses involving thousands of genes, proteins, or comparable multiple comparisons report
     an adjusted P value / FDR where the study design makes false-discovery control necessary;
   - fold-change direction, base/log convention, sign, rounding, and labels are defined and used
     consistently.

   Do not infer an adjustment method, recalculate a statistic, or alter a value. If the analysis
   context does not establish whether multiple-testing correction is required, mark it `NEEDS
   AUTHOR INPUT`.

9. **Mathematical and shorthand notation in prose.** Flag notation used as a prose substitute in
   narrative text when a written word or phrase is expected. Suggest context-appropriate wording:
   `v.s.` → “versus”; `&` → “and”; `±` → “plus or minus”; `≈` → “approximately”; `×` → “times” or
   “by”; `→` → “leads to”, “results in”, or “to”; `#` → “number”; `@` → “at”; and `/` used as
   “or” or “per” → the written word (for example, “miles per hour”, not “miles/hour”). Flag
   vertical bars used to mean absolute value in prose and inequality symbols used in place of
   words such as “less than.”

   Do **not** flag conventional, meaning-preserving notation in equations, variable names,
   statistical expressions such as `p < 0.05`, percentages (for example, `55%`), units, chemical
   formulae, established names (for example, AT&T), URLs, code, figure axes, or bibliography
   metadata. Where the boundary is unclear, report it for author review instead of changing it.

10. **Duplicate references.** Identify candidate duplicate BibTeX entries and duplicate in-text
   citations. Verify bibliographic identity (DOI, title, authors, venue, year) before marking a
   candidate redundant. Report the merge target and affected citations; do not merge anything.

11. **Tense by section.** Flag only material deviations from the following guidance, distinguishing
   descriptive prose from quotations and established scientific names:
   - **Abstract/summary:** present simple for aims and continuing facts; present perfect for
     relevant prior research.
   - **Introduction:** present simple for paper structure, definitions, and enduring facts; past
     simple for historical context; present perfect for prior research relevant to this study.
   - **Theoretical framework:** present simple for theories and definitions.
   - **Methods/results:** past simple for completed experiments/events; present simple for stable
     methods and references to figures, tables, and other manuscript sections.
   - **Discussion/conclusion:** present simple for interpretation and enduring facts; past simple
     for this study’s results and other completed studies.
   - **Limitations:** past simple for study actions and shortcomings; present simple for enduring
     facts.
   - **Recommendations/implications:** prefer modal verbs and hedging for future claims (`can`,
     `should`, `may`, `could`, `likely`, `possibly`); present simple for recommendations/opinions;
     present perfect for past actions still relevant now.

### Summary format and handoff

Begin with files analysed, date, and an explicit statement: **“No manuscript files were edited.”**
Then include a concise dashboard, one section per check, and a final **How to proceed** section.
Ask the author to name the IDs to revise and, where necessary, state their title-case preference or
resolve ambiguous nomenclature/reference decisions.

After writing the summary, stop. Do not enter Phase 2 in the same turn.

---

## PHASE 2 — revise only approved findings

1. Parse the author’s approval into exact finding IDs and scope. Ask before editing if “fix all”
   could include `REVIEW` or `NEEDS AUTHOR INPUT` items with unresolved choices.
2. Make only the approved, expression-level changes. For a large disjoint set, use multiple agents
   with non-overlapping files/findings and strict boundaries. Do not alter scientific claims,
   measurements, biological interpretation, data, results, citations’ factual metadata, or author
   intent. Never fabricate nomenclature, bibliographic metadata, or author choices.
3. For an approved duplicate-reference merge, update both BibTeX and every affected in-text citation
   atomically, preserving citation meaning and order.
4. Launch a dedicated **validation agent** after all edits. Give it the before/after diff, approved
   IDs, and manuscript paths. It must verify that every modification is approved and expression-only;
   specifically flag changes to numbers, results, scientific claims, gene/protein identity, citation
   targets, author names, or other factual content. Correct or revert unapproved changes before
   reporting completion.
5. Report applied IDs, validation result, skipped findings, and outstanding author input.

## Guardrails

- Phase 1 is strictly report-only.
- Preserve LaTeX syntax, citation keys, labels, cross-references, and build structure unless their
  exact change was approved.
- Prefer an author question to an inferential “correction” whenever terminology, nomenclature,
  tense intent, title case, or duplicate-reference identity is uncertain.
