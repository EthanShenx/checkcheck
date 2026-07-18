---
name: run-de-ai
description: >
  Reduce AI-like writing conventions in a manuscript without changing its scientific meaning or
  authorial voice. Review em-dash and colon overuse, vague filler vocabulary, unnatural paragraph
  and sentence uniformity, reflexive rule-of-three lists, and “not X, but Y” constructions. Use
  whenever the user says "de-AI", "de ai", "AI writing conventions", "reduce AI writing", or
  invokes /run-de-ai. First run writes DE_AI_SUMMARY.md without editing; a later run applies only
  user-approved revisions and validates the final diff.
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

# Reduce AI-like Manuscript Writing Conventions

This skill reduces repetitive, template-like prose patterns, not legitimate scholarly style.
Scientific precision, authorial voice, and intended emphasis take priority over a mechanical style
rule. A pattern must be repeated, distracting, or clearly unnatural before it becomes a finding.

## Mandatory workflow

1. **Inspect only:** read the relevant manuscript prose and identify patterns.
2. **Report only:** write `DE_AI_SUMMARY.md`; do not edit manuscript files.
3. **Wait:** stop after the report and obtain the author’s explicit approval of finding IDs/areas.
4. **Revise only approved findings:** a report or a detected pattern is never permission to edit.

## Detect the phase

- **Phase 1 — REPORT:** The user asks to de-AI the manuscript, or there is no
  `DE_AI_SUMMARY.md` in the manuscript directory. Analyse and create the report only; edit no
  manuscript files.
- **Phase 2 — REVISE:** The user has reviewed `DE_AI_SUMMARY.md` and specifies the IDs or areas to
  revise. Change only the approved spans, then validate the diff.

If the phase is unclear, ask. If the manuscript changed after the report, create a fresh report
rather than treating old findings as current approval targets.

## Locate the manuscript

Use the manuscript path supplied by the user. Otherwise find the root LaTeX file
(`\documentclass` / `\begin{document}`) and included `.tex` files, or the relevant `.docx` or
`.md` manuscript. Analyse prose content only. Do not treat bibliography entries, quoted material,
URLs, code, LaTeX commands, equations, tables, figure labels, or reference metadata as prose
unless the user asks for them specifically.

Write `DE_AI_SUMMARY.md` in the manuscript directory.

---

## PHASE 1 — report only

Read the manuscript and write `DE_AI_SUMMARY.md`; do not edit. Start with files analysed, date,
and the statement **“No manuscript files were edited.”** Include a dashboard and a section for
each check. Every finding needs a stable ID (for example, `DAI-DASH-01`), location, short excerpt,
why it is a pattern rather than an isolated valid choice, a meaning-preserving proposed revision,
status (`PASS`, `REVIEW`, or `NEEDS AUTHOR INPUT`), and confidence.

Report clusters or representative examples when a pattern is widespread; do not create a noisy
finding for every instance. Explain the intended effect so the author can approve a category or
selected examples without losing control of the wording.

### Required checks

1. **Em dashes joining independent clauses.** Flag em dashes (`—`) that link two independent
   clauses. Propose a period, comma plus an appropriate conjunction, or a recast sentence that
   states the relation directly. Do not flag em dashes used legitimately for parenthetical
   interruption, ranges, established terminology, or LaTeX syntax unless the overall construction
   is genuinely awkward.

2. **Colon overuse.** Review colon frequency and rhetorical role. Flag repeated uses that merely
   set up an ordinary phrase or list and can be written as a complete sentence or integrated
   naturally into the syntax. Retain colons where they are genuinely necessary, including labels,
   conventional technical notation, ratios, times, titles/subtitles, and clear explanatory
   introductions.

3. **Vague or filler vocabulary.** Identify imprecise uses of terms such as “program,” “caveat,”
   “arm,” “audit,” “framing,” and “flag.” Propose a concrete term that follows from the local
   scientific meaning, or mark it `NEEDS AUTHOR INPUT` if the specific meaning is uncertain. Do
   not flag a word simply because it appears in the list: for example, “study arm,” a biological
   “program,” or “flag” as a technical verb may be exactly right in context.

4. **Paragraph rhythm.** Assess paragraph lengths within each prose section. Flag a sustained,
   conspicuously uniform sequence only when it makes the argument feel templated. Recommend breaks,
   combinations, or leaving paragraphs alone based on the underlying logic. Do not impose a target
   paragraph length, make paragraphs uniform, or split coherent scientific reasoning merely to
   vary appearance.

5. **Sentence rhythm and structure.** Review sequences of sentences for repeated length or
   construction, especially a run of similarly complex subordinate-clause sentences or a forced
   alternation of short sentences. Propose selective restructuring where it improves readability;
   preserve complex syntax when it is the clearest way to express the scientific logic. Do not
   revise solely to manufacture variation.

6. **Reflexive rule-of-three lists.** Flag repeated or conspicuous “A, B, and C” triads used as a
   generic rhetorical template. Recommend the number and form of examples that actually fit the
   argument: one illustration, a pair, four items, a sentence, or a list. Do not alter an
   exhaustive three-item scientific list, a required list, or an otherwise natural triad.

7. **“Not X, but Y” construction.** Flag the rhetorical construction that negates an alternative
   before asserting its replacement (for example, “A is not a …, but a …”). Propose a direct,
   meaning-preserving assertion. Retain genuine contrasts where negating X is scientifically
   necessary or avoids a material ambiguity.

### Handoff

End the report with **How to proceed**: ask the author to name the IDs or pattern groups to revise,
and to resolve any `NEEDS AUTHOR INPUT` items. Stop after writing the report. Do not enter Phase 2
in the same turn.

---

## PHASE 2 — revise only approved findings

1. Convert the author’s response into exact approved IDs. Ask if a broad instruction could include
   unresolved `REVIEW` or `NEEDS AUTHOR INPUT` items.
2. Apply only those changes. Use multiple agents only for disjoint files or finding groups; each
   agent must receive its exact approved spans and preserve scientific meaning, data, citations,
   LaTeX structure, and authorial claims.
3. Launch a validation agent with the approved IDs and final diff. It must check that every edit is
   approved, local, and stylistic; flag any change to scientific meaning, factual claims, numbers,
   statistical notation, citations, terminology, or LaTeX semantics. Correct or revert unapproved
   changes before reporting completion.
4. Report the applied IDs, validation result, skipped findings, and outstanding author decisions.

## Guardrails

- Phase 1 is strictly report-only.
- Never rewrite quotations, reference titles, code, formulas, citations, or other non-prose
  material unless the author explicitly includes it.
- Do not replace one stock phrase with another. Prefer clear, specific prose that fits the local
  argument.
- When stylistic preference and scientific emphasis conflict, preserve the scientific emphasis and
  ask the author.
