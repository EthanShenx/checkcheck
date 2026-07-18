---
name: run-title-check
description: >
  Review manuscript titles for clarity, precision, and impact, with clarity and precision taking
  priority. For every article title, Results subsection title, main-text figure-legend title, and
  Methods subsection title, provide three alternatives tailored to that title type. Use whenever
  the user says "title check", "review titles", "improve titles", or invokes /run-title-check.
  First run writes TITLE_CHECK_SUMMARY.md without editing; a later run applies only
  user-approved title replacements and validates that references and manuscript meaning remain
  intact.
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

# Run Manuscript Title Checks

This skill assesses titles for clarity, precision, scope, and impact. Precision and clarity are
the primary criteria: do not use vague, promotional, or stronger-than-supported language merely to
make a title more striking. A title must remain faithful to the manuscript’s stated work and
findings.

## Mandatory workflow

1. **Inspect only:** read all in-scope titles and the context needed to assess them.
2. **Report only:** write `TITLE_CHECK_SUMMARY.md`; do not edit manuscript files.
3. **Wait:** stop after the report and obtain the author’s explicit selection of title IDs/options.
4. **Revise only approved titles:** a proposed alternative is never permission to replace a title.

## Subagent parity

When invoking a subagent for analysis, revision, or validation, configure it with the **same model,
intelligence level, and reasoning effort as the current agent**. For example, if the current agent
is Opus 4.8 with high reasoning, every subagent must be Opus 4.8 with high reasoning. Never
delegate a decision to a lower-capability or lower-reasoning agent. If exact parity cannot be set,
perform the work locally instead.

## Detect the phase

- **Phase 1 — REPORT:** The user asks for a title check, or no `TITLE_CHECK_SUMMARY.md` exists in
  the manuscript directory. Read and report; do not edit manuscript files.
- **Phase 2 — REVISE:** The user has reviewed the summary and specifies the exact titles or
  alternative IDs to adopt. Apply only those approved replacements, then validate the diff.

If phase is unclear, ask. If titles or relevant Results content changed after the report, regenerate
the report rather than applying stale options.

## Locate titles and their context

Use the supplied manuscript path. Otherwise locate the root LaTeX document (`\documentclass` /
`\begin{document}`), its included `.tex` files, or the relevant `.docx` / `.md` source. Identify:

- article title (`\title{...}` or document-equivalent metadata);
- Results subsection titles and the Results content they introduce;
- main-text figure-legend titles (normally the opening title sentence of each main-figure caption);
  and
- Methods subsection titles.

Read enough surrounding text, captions, and cross-references to ground every alternative. Do not
review supplementary-figure titles unless the user requests them. Write `TITLE_CHECK_SUMMARY.md`
in the manuscript directory.

---

## PHASE 1 — report only

Read the manuscript and write `TITLE_CHECK_SUMMARY.md`; do not edit. Begin with files analysed,
date, and **“No manuscript files were edited.”** For every title, include a stable ID (for example,
`TC-RESULTS-03`), title type, location, current title, a short assessment of clarity/precision/
impact, three alternatives, and confidence. Do not omit a title because the current wording is
already strong: still provide three clearly distinct alternatives.

Use the following title-type conventions.

### 1. Article title and 2. Results subsection titles

For each article title and each Results subsection title, generate exactly three alternatives,
each labelled with one of these distinct angles:

| Angle | Requirement |
| --- | --- |
| **(a) Noun-based** | A concise, descriptive phrase stating what the study or section is about; topic-oriented rather than a full claim. |
| **(b) Full-scope** | A title that captures the complete range of the work or finding so important scope is not omitted. |
| **(c) Headline-result** | A results-oriented, declarative title that foregrounds the one most important supported finding. |

For a subsection, use only the evidence in that subsection and its directly linked figures. For the
article title, use the entire manuscript. A headline-result option must not overgeneralise or claim
causality, mechanism, or clinical relevance that the manuscript does not establish.

### 3. Main-text figure-legend titles

For every main-text figure, identify and state the Results subsection it maps to. Determine the
mapping from figure placement, citation context, caption content, and Results structure. Report the
mapping with a confidence level. If no defensible mapping can be made, mark it `NEEDS AUTHOR INPUT`
and explain why.

Provide three alternatives for each figure-legend title. Base them on the mapped Results subsection
title: use either a close rephrasing or a deliberate pivot toward the particular aspect the figure
emphasises. Label the options **(a) subsection-aligned**, **(b) full-scope figure**, and
**(c) figure-emphasis**. Each must be an informative title sentence or concise title phrase,
according to the manuscript’s established figure-legend convention, and must not repeat detailed
methods or results prose from the caption.

### 4. Methods subsection titles

For every Methods subsection title, provide exactly three alternatives. Keep all three brief,
noun-based, and specific to the procedure or analysis described. Do not use headline-result claims,
full sentences, promotional language, or wording that implies an outcome.

### Handoff

End the report with **How to proceed**, asking the author to name the title IDs and selected
alternative labels to adopt. Stop after writing the report. Do not revise titles in the same turn.

---

## PHASE 2 — revise only approved titles

1. Map each approval to one exact title ID and alternative label. Ask when the approval is
   ambiguous, including where multiple titles share similar wording.
2. Replace only the approved title text. Preserve sectioning commands, labels, cross-references,
   caption structure, title case convention, punctuation required by the document class, and
   figure/table numbering.
3. Launch a validation agent with the approved IDs and final diff. It must verify that every title
   change matches an approved option and that no body text, scientific claim, cross-reference,
   citation, caption content, or LaTeX structure changed unintentionally. Correct or revert any
   unapproved change before reporting.
4. Report adopted titles, validation result, skipped options, and unresolved mappings.

## Guardrails

- Phase 1 is strictly report-only.
- Preserve scientific meaning and the strength of evidence. Never manufacture novelty, causality,
  generality, or impact.
- Treat figure-to-Results mappings as an inference; state the confidence and ask rather than guess
  when the evidence is insufficient.
- Do not edit titles in supplementary material unless explicitly asked.
