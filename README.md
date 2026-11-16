# florenzen.github.io

Short redirects served at `https://florenzen.github.io/r/<name>`.

## Add a redirect

Create a file `r/<name>` (no extension) whose first non-comment line is the target URL:

```plain
# optional comment
https://example.com/some/long/path
```

Commit and push to `main`. The workflow builds `_site/r/<name>.html` with
`scripts/build.sh` and deploys only `_site/` to GitHub Pages.

Build locally: `sh scripts/build.sh`

## Linting and formatting

| Files                                                  | Linter / formatter                | Config                  |
| ------------------------------------------------------ | --------------------------------- | ----------------------- |
| Markdown                                               | markdownlint                      | `.markdownlint.json`    |
| JSON and YAML (also `.nsprc`)                          | Prettier (format)                 | Prettier defaults       |
| GitHub workflows (`.github/workflows/`)                | actionlint                        | none                    |
| Shell scripts (`scripts/`, `.devcontainer/`)           | ShellCheck (lint), shfmt (format) | `.editorconfig` (shfmt) |
| Dockerfile (`.devcontainer/Dockerfile`)                | hadolint                          | `.hadolint.yaml`        |
| Redirects (`r/`)                                       | `scripts/build.sh`                | none                    |
| npm dependencies (`package.json`, `package-lock.json`) | npm audit (via better-npm-audit)  | `.nsprc` (exceptions)   |

The tool versions are pinned in `package.json` and `requirements-dev.txt`. The devcontainer installs
them (Python tools in `.devcontainer/Dockerfile`, npm packages in `.devcontainer/post-create.sh`), and the VS Code extensions, the
pre-commit hook and CI all use these same versions. The checks run automatically on every
`git commit`.

Check everything, the same way CI does (pre-commit only sees files git knows about, so `git add`
new files first):

```sh
pre-commit run --all-files
```

Auto-fix:

```sh
npx markdownlint-cli2 "**/*.md" "#node_modules" --fix                   # Markdown
npx prettier --write "**/*.{json,yml,yaml}" "!**/*-lock.json" .nsprc    # JSON and YAML formatting
shfmt --write scripts .devcontainer                                     # shell script formatting
```

Findings of actionlint, ShellCheck, hadolint and npm audit have to be fixed by hand. For a vulnerable npm
package, update it or, if it can't be reached, add a documented exception with an expiry date to
`.nsprc`.

## CI

- **Push to `main`:** `.github/workflows/pages.yml` runs the lint workflow
  (`.github/workflows/lint.yml`, which runs `pre-commit run --all-files`). Only if it passes does it
  build `_site/` and deploy it to GitHub Pages.
- **Push to any other branch:** `.github/workflows/check.yml` runs the same lint workflow and,
  alongside it, the build.
