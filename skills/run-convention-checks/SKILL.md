---
name: run-convention-checks
description: >
  Check whether a manuscript follows academic-paper conventions. The scope audits Methods for
  forbidden \texttt{} formatting, software citation placement and functional introductions,
  missing motivation for consequential analytical choices, and nonessential implementation detail;
  it also audits manuscript-wide literature citations for evidence-backed replacement candidates.
  Use whenever the user says
  "convention checks", "academic paper conventions", "methods conventions", or invokes
  /run-convention-checks. First run writes CONVENTION_CHECKS_SUMMARY.md without editing; a later
  run applies only user-approved revisions and validates that methods remain reproducible.
allowed-tools:
  - Read
  - Write
  - Edit
  - Grep
  - Glob
  - Bash
  - WebSearch
  - WebFetch
  - Agent
  - AskUserQuestion
  - TodoWrite
---

# Run Academic Convention Checks

This is a conservative, two-phase academic-writing review. Its purpose is to make Methods clear,
motivated, properly attributed, and concise **without** weakening reproducibility or changing the
analysis. Do not treat routine implementation detail as a defect automatically; context determines
what a reader needs to reproduce the work.

## Mandatory workflow

1. **Inspect only:** read the complete relevant Methods section, manuscript claims, and cited
   literature context.
2. **Report only:** write `CONVENTION_CHECKS_SUMMARY.md`; do not edit manuscript files.
3. **Wait:** stop after the report and obtain the author’s explicit approval of finding IDs/areas.
4. **Revise only approved findings:** a report or a detected issue is never permission to edit.

## Detect the phase

- **Phase 1 — REPORT:** The user asks for convention checks, or there is no
  `CONVENTION_CHECKS_SUMMARY.md` in the manuscript directory. Analyse and write the report only;
  do not edit manuscript files.
- **Phase 2 — REVISE:** The user has reviewed the summary and identifies the finding IDs or areas
  to revise. Apply only those approved changes, then validate the final diff.

If phase is ambiguous, ask. If the Methods text, manuscript citations, or bibliography changed
after a report was made, write a fresh report rather than acting on stale finding IDs.

## Locate the Methods section and citation context

Use the manuscript path supplied by the user. Otherwise locate the root LaTeX document
(`\documentclass` / `\begin{document}`), its included `.tex` files, or the relevant `.docx` /
`.md` manuscript. Identify the Methods section and all Methods subsections, including material
loaded with `\input` or `\include`. Locate the bibliography (`.bib`, reference list, and citation
commands) and scan the complete main text for literature claims and software citations. The Methods
checks apply only to Methods; the literature-replacement and software-citation-placement checks
also require the relevant full-manuscript context. Do not audit supplementary source unless it is
part of Methods or necessary to resolve a cited claim.

Write `CONVENTION_CHECKS_SUMMARY.md` in the manuscript directory.

---

## PHASE 1 — report only

Read the complete Methods section, relevant manuscript claims, and citation sources. Do not modify
files. Write `CONVENTION_CHECKS_SUMMARY.md` with: files and Methods sections analysed; date; an
explicit statement that **“No manuscript files were edited.”**; a dashboard; and one section per
check. Each finding requires a stable ID (for example, `MC-CITATION-01`), precise location, short
excerpt or description, rationale, a proposed meaning-preserving revision, status (`PASS`,
`REVIEW`, or `NEEDS AUTHOR INPUT`), and confidence.

Report representative clusters when a repeated issue has one shared solution. Do not generate a
finding for every benign routine step or infer a scientific rationale that the manuscript does not
provide.

### Required Methods and literature-citation checks

1. **No `\texttt{}` formatting.** Find every `\texttt{...}` command in the Methods section,
   including commands split across included source files. Each is a finding. The approved revision
   is to remove the `\texttt{}` wrapper while preserving its contents, escaping, and meaning; for
   example, `\texttt{AnnData}` becomes `AnnData`. Do not remove or alter `\texttt{}` outside
   Methods, and do not change the underlying software name, code token, version, path, or value.

2. **Missing methodological citations.** Identify software, algorithms, protocols, datasets,
   tools, and practices that should be attributed but lack an appropriate citation. Scrutinise
   phrases such as “as previously described,” “following the published protocol,” or “as in our
   earlier work”: they require a specific supporting citation or clear pointer. Examples include a
   named analysis package/version, a neighbourhood-abundance method, a cell-prioritisation method,
   integration method, or a laboratory/clinical protocol whose origin is external. Flag the exact
   claim and the citation needed; mark it `NEEDS AUTHOR INPUT` if the correct source is unknown.
   Never invent a citation, DOI, author, or claim of prior validation.

3. **Replaceable literature references.** Identify a cited reference as a *replacement candidate*
   only when both conditions hold:
   - the cited article was published before 2019 **or** its journal's verified impact factor is
     below 8; **and**
   - another journal with a higher verified impact factor contains a source that directly supports
     the same statement in the manuscript.

   Inspect the manuscript claim and the cited source itself; do not use journal metrics as a proxy
   for whether a reference supports a claim. For every candidate, report:
   - the exact manuscript sentence/claim and its location;
   - the current reference, its article year, journal, impact factor, impact-factor year, and the
     authoritative metric source;
   - the specific supporting sentence or passage in the current reference, with a precise location
     (for example, abstract, Results subsection, page, or figure), that is being used to support
     the manuscript claim;
   - a proposed alternative reference, its journal's higher verified impact factor and metric
     source, and the specific sentence/passage that supports the same claim; and
   - the proposed in-text and bibliography change.

   Do not label a reference replaceable if its impact factor cannot be verified, the alternative
   does not directly support the same claim, or the original is needed for priority, a foundational
   method, software/protocol attribution, data provenance, a guideline, or a historical claim.
   Never invent an impact factor, citation, supporting passage, or comparison. Mark unresolved
   cases `NEEDS AUTHOR INPUT`. Impact factor is a screening criterion specified for this workflow,
   not a general measure of an individual paper's quality.

4. **Software citation placement (“software dresser”).** Inventory every in-text citation that
   supports or accompanies software anywhere in the main manuscript, including Results, Methods,
   captions, and other main-text sections. In the report, group each software package/tool with its
   current citation locations, whether its original paper is known, and its official GitHub link if
   one exists. Propose this two-part, approved-only revision:
   - remove all *in-text* software citation commands from their current locations, including
     Results and Methods, while leaving bibliography/BibTeX records unchanged; then
   - add or consolidate the software's paper citation at the relevant Methods description only,
     never in Results, and include its official GitHub link when one exists and the journal's style
     permits a URL.

   For example, a Results sentence such as “We next inferred candidate ... interactions using
   CellPhoneDB v5~\cite{...}” should lose the software citation there; the corresponding Methods
   description should carry the paper citation and official GitHub link, if available. Do not
   delete a citation that supports a non-software scientific claim merely because it appears near a
   tool name. Never fabricate a software paper, citation key, version, repository URL, or GitHub
   affiliation; mark missing or ambiguous provenance `NEEDS AUTHOR INPUT`.

5. **Functional introduction of niche computational-biology software.** At first substantive use,
   ensure a specialised or niche computational-biology tool is introduced with a brief,
   scientifically accurate statement of what it does and why it is being used in this analysis.
   This applies in addition to its citation and version where appropriate. It does **not** require a
   tutorial for foundational, widely understood analysis environments such as Scanpy or Seurat,
   unless their particular use would otherwise be unclear.

   Flag a bare tool introduction and propose a concise, purpose-led replacement grounded only in
   the manuscript’s stated analysis. Suitable patterns include:
   - “The tissue architecture was analysed using RESEPT v1.15, a computational tool that generates
     an atlas of regional gene-expression patterns in spatial transcriptomics data.”
   - “Regulatory analysis was conducted using DeepMAPS v1.033. We used DeepMAPS to build cell and
     gene embeddings and obtain active gene modules through its graph-transformer model.”
   - “Deconvolution of mixed cell populations was performed using the CARD v1.1 R package, which
     uses a reference-based approach and cell-type-specific expression signatures to estimate
     cell-type proportions in bulk RNA-seq or spatial transcriptomics data.”

   Do not overstate a tool’s capabilities, add unsupported method details, or turn this brief
   contextualisation into replication-irrelevant prose. If the function or reason for use cannot
   be determined from the manuscript and its cited source, mark it `NEEDS AUTHOR INPUT`.

6. **Motivation for consequential choices.** Check that substantive processing and analysis steps
   explain both what was done and why it was appropriate for the question. Flag a bare procedural
   transition such as “Milo’s (v1.3.1) was used next” when the reader is not told its analytical
   purpose. A suitable revision makes the purpose explicit, for example: “To test for changes in
   cellular abundance at high resolution across groups or conditions, we used Milo’s (v1.3.1)
   neighbourhood abundance approach.” Likewise, prefer a purpose-led statement such as “To model
   the cellular compartments most strongly perturbed by psoriasis, we used Augur” over an
   unexplained procedural assertion.

   Do not require a separate rationale for every elementary action. Focus on consequential choices:
   method selection, model/algorithm choice, integration, filtering and quality-control thresholds,
   transformation, cluster removal, data inclusion/exclusion, parameter selection, and prioritising
   one result or cell population over another.

7. **Reasons for exclusions and non-obvious parameters.** Flag removals, exclusions, thresholds,
   resolution choices, and other consequential settings that state *what* happened but not *why*.
   For example, a statement that cluster 4 was removed from human data and cluster 10 from mouse
   data must explain the biological or technical reason for each removal, even briefly. Do not
   fabricate reasons or infer that a cluster is low quality, doublet-like, or irrelevant. Mark the
   item `NEEDS AUTHOR INPUT` unless the rationale is established elsewhere in the manuscript.

8. **Replication-relevant concision.** Identify implementation details that do not help a reader
   interpret or reproduce the analysis and therefore consume limited Methods word count. Propose a
   concise revision only when the information is genuinely nonessential in context. Typical
   candidates include:
   - internal container/object type when the analytical action is clear: “Each sample was imported
     into Scanpy as an AnnData object” → “Each sample was imported into Scanpy”;
   - deployment internals such as a service port: “The scSAID web platform comprises a Java/Tomcat
     frontend backed by a Python Flask API on port 8054” → “The scSAID web platform comprises a
     Java/Tomcat frontend backed by a Python Flask API”; and
   - internal storage implementation that does not affect the stated analysis: “The filtered count
     matrix was preserved in `adata.layers[\"counts\"]`, followed by library-size normalisation
     using the default `sc.pp.normalize_total` setting, followed by log1p transformation” → “The
     filtered count matrix underwent library-size normalisation using the default
     `sc.pp.normalize_total` setting, followed by log1p transformation.”

   Preserve details necessary for replication, including inputs, software and versions, references,
   quality-control criteria, parameter values, transformations, statistical tests, model settings,
   and any implementation choice that can change results. If unsure whether a detail is necessary,
   mark it `REVIEW` rather than proposing deletion.

### Handoff

End the report with **How to proceed**. Ask the author to identify the IDs to revise and provide
the missing citations or rationales for `NEEDS AUTHOR INPUT` items. Stop after writing the report;
do not proceed to Phase 2 in the same turn.

---

## PHASE 2 — revise only approved findings

1. Parse the approval into exact finding IDs. If an instruction could remove a replication-relevant
   detail, replace a literature reference, or needs an unprovided citation/rationale, ask before
   editing.
2. Remove every approved `\texttt{}` wrapper in Methods, retaining the exact contents and valid
   LaTeX escaping. Apply other approved changes locally and preserve all scientific claims, values,
   software versions, parameters, citations, cross-references, and LaTeX semantics.
3. For approved software-dresser findings, first remove only the identified in-text software
   citations, retaining bibliography/BibTeX entries. Then add the approved original-paper citation
   and official GitHub link, if any, at the relevant Methods description; do not insert software
   citations in Results. For approved reference replacements, update only the specified in-text
   citation and bibliography entry after confirming the alternative's claim support and metric
   evidence remain as reported.
4. Do not add a citation, GitHub URL, impact factor, supporting passage, or rationale unless the
   author supplied it, it is verified from an authoritative source, or the author explicitly
   approves the precise language. Never invent provenance, methodological justification, or
   reproducibility details.
5. Launch a validation agent with the approved IDs and final diff. It must verify that all edits are
   approved, that `\texttt{}` was removed only within approved Methods spans, that software
   citations appear only in Methods, and that no replication-critical information, scientific
   claim, numerical value, citation target, bibliography record, or LaTeX syntax was
   unintentionally changed. Correct or revert unapproved changes before reporting.
6. Report applied IDs, validation result, skipped items, and outstanding author input.

## Guardrails

- Phase 1 is strictly report-only.
- Clarity and concision never justify removal of information that affects interpretation or
  replication.
- Preserve the Methods’ actual tense and authorial voice unless a separately approved revision
  changes it.
- Prefer an author question to an unsupported rationale, citation, GitHub URL, impact factor, or
  claim-to-source mapping.
