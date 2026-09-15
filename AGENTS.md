# RSMP Core Agent Guide

This repository contains the RSMP core specification. The specification is written in reStructuredText and built with Sphinx.

## Where Things Live

- `source/` contains the canonical specification source. Edit these files for documentation changes.
- `source/applicability/` contains the main protocol specification sections.
- `source/img/` contains diagrams and images used by the specification.
- `docs/` contains generated documentation output. Avoid editing it directly unless the task is specifically about generated artifacts.
- `BUILDING.md` documents local build dependencies and build commands.

## Build Commands

- `make html` builds the multi-page HTML documentation.
- `make singlehtml` builds a single-page HTML version.
- `make latexpdf` builds the PDF version.

## Editing Guidance

- Follow the existing writing style, section structure, terminology, and reStructuredText patterns.
- Keep specification text focused on the current version. When changing behavior or wording, do not add historical explanations unless the surrounding section already does that.
- Prefer succinct normative text over long explanatory passages.
- Keep related files coherent: update cross-references, indexes, glossary entries, diagrams, and tables when a change affects them.
- Use Sphinx roles consistently, including `:term:`, `:ref:`, `:numref:`, `:issue:`, and `:compare:` where the surrounding source uses them.

## Validation

- Run the narrowest relevant Sphinx build after edits, usually `make html`.
- If a build cannot be run because local dependencies are missing, mention that in the final response.
