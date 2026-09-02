# Example Configurations

This directory contains comprehensive tmux-keys configurations for different development environments.

## Available Examples

| File | Views | Description |
|------|-------|-------------|
| `minimal.yaml` | 1 | Basic window/pane navigation — start here |
| `full-stack.yaml` | 18 | Web development: Git workflow, npm/yarn/pnpm, testing, linting, databases (Prisma, Drizzle) |
| `devops.yaml` | 22 | DevOps/SRE: Docker, Kubernetes, system monitoring, networking, logs, security, AWS/GCP, Terraform |
| `python-dev.yaml` | 17 | Python: venv/poetry/uv/pyenv, pytest, linting (ruff/black/mypy), Django/FastAPI/Flask, SQLAlchemy/Alembic |

## Usage

Copy the example you want to use:

```bash
cp examples/full-stack.yaml ~/.tmux-keys.yaml
```

Or combine sections from multiple examples into your own config.

## Structure

Each config follows a hierarchical structure:

```
Main (navigation hub)
├── Category 1
│   ├── Subcategory A
│   └── Subcategory B
├── Category 2
└── Git (basic operations)
```

**F1** always returns to the parent view.

## View Counts

| Config | Main | Subviews | Total Actions |
|--------|------|----------|---------------|
| minimal | 1 | 0 | 6 |
| full-stack | 1 | 17 | ~180 |
| devops | 1 | 21 | ~200 |
| python-dev | 1 | 16 | ~170 |

## Customization Tips

1. **Start with one**: Pick the closest match to your workflow
2. **Remove unused views**: Delete sections you don't need
3. **Merge configs**: Combine Git from full-stack with Docker from devops
4. **Use `title_exec`**: Display dynamic info like current git branch
5. **Color coding**: Use colors to indicate action severity (red = destructive, green = safe)

## Colors Available

```
Basic:    red, green, yellow, blue, magenta, cyan
Extended: rose, chartreuse, orange, azure, violet, springgreen
```
