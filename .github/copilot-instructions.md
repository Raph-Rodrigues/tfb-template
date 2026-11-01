# Copilot instructions for this repository

## Build, test, and lint

This repository contains an ABNT-style Physics bachelor's thesis and a reusable Beamer presentation. There is no dedicated test suite or lint configuration in the project root.

Use the build target for the document being changed:

- Build the ABNT thesis from the repo root:
  - `make`
  - `latexmk -lualatex main.tex`
- Build the preserved Beamer slides:
  - `make slides`
  - `latexmk -lualatex main-slides.tex`
- Regenerate chart/data input when the physics dataset changes:
  - `lua scripts/gerar_dados.lua`
- Clean generated build artifacts:
  - `make clean`

If you need to validate a single generated artifact or a changed slide source, re-run the `latexmk -lualatex main.tex` build for the affected document; there is no project-specific unit test runner to target.

## High-level architecture

The repository contains two independent LaTeX documents:

- `main.tex` is the ABNTeX2 academic-document entry point; it includes chapters from `capitulos/`, reusable physics fragments from `content/`, and references from `referencias.bib`.
- `main-slides.tex` is the Beamer presentation entry point. It defines the slide metadata and includes the presentation fragments from `content/`.
- `beamerthemefisica.sty` owns the presentation theme: dark styling, colors, typography, header/footer, and slide decorations.
- `fisica.sty` defines the project-specific LaTeX macros, physics notation, and reusable layout helpers used across slides.
- `fisica-video.sty` adds local-video and media helpers used in the demo slides.
- `content/*.tex` are the reusable physics fragments; compatible excerpts are adapted into the thesis, while the slide document includes the fragments as Beamer frames.
- `lua/*.lua` contains Lua helpers that emit LaTeX content and generate tables/plots used in the slides.
- `scripts/gerar_dados.lua` generates `dados/oscilador.csv`, which is the source data consumed by the oscillator plots and related visualizations.
- `tools/` contains helper scripts for generating or extracting video assets for demos, not core presentation logic.

The thesis pattern is: ABNTeX2 chapters + Lua-generated data and plots + BibTeX references -> LuaLaTeX -> `main.pdf`. The presentation pattern is: Beamer slides + the same Lua modules -> LuaLaTeX -> `main-slides.pdf`.

## Key conventions

- Run all commands from the repository root. The build expects relative paths such as `./lua` and `./dados`.
- Use LuaLaTeX for both documents; the thesis loads the repository's Lua-backed `fisica.sty` package.
- Prefer the repo-native build path (`make` or `latexmk -lualatex`) over ad hoc LaTeX commands.
- Treat `main.pdf`, `main-slides.pdf`, and the auxiliary files (`.aux`, `.fdb_latexmk`, `.log`, `.nav`, etc.) as generated artifacts; do not edit them manually.
- If you change the model or generated physics data, regenerate `dados/oscilador.csv` before rebuilding the presentation so the plots reflect the current data.
- Keep slide content modular: prefer editing or adding the appropriate file in `content/` and including it from `main-slides.tex`, instead of restructuring the document at the top level.
- Keep thesis chapters modular under `capitulos/`; preserve the ABNTeX2 document structure and update institutional requirements in `main.tex`.

## Repository-specific notes

- The project includes a custom TeX theme and presentation identity; visual changes are usually made in `beamerthemefisica.sty` rather than inline on individual slides.
- The template is designed for a specific physics seminar / academic presentation style, so maintain the existing narrative structure and naming conventions unless a real document change requires otherwise.
- The README is the main user-facing reference for build steps, supported packages, and project customization.
