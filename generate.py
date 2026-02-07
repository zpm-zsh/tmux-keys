#!/usr/bin/env python3
"""Generate tmux key bindings script from ~/.tmux-keys.yaml."""

from __future__ import annotations

import hashlib
import os
import random
import sys
from pathlib import Path
from typing import Any, Iterable, Mapping, Sequence

try:
    import yaml
except ImportError as exc:  # pragma: no cover - dependency guard
    sys.stderr.write(
        "PyYAML is required to run this script. Install it with `pip install PyYAML`.\n"
    )
    raise SystemExit(1) from exc


COLOR_MAP: Mapping[str, str] = {
    "red": "1",
    "green": "2",
    "yellow": "3",
    "blue": "4",
    "magenta": "5",
    "cyan": "6",
    "rose": "9",
    "chartreuse": "10",
    "orange": "11",
    "azure": "12",
    "violet": "13",
    "springgreen": "14",
}

COLOR_VALUES: Sequence[str] = tuple(COLOR_MAP.values())


def get_random_color() -> str:
    """Pick a random colour id from the mapping."""
    return random.choice(COLOR_VALUES)


def md5(value: str) -> str:
    """Return the hex digest for a string."""
    return hashlib.md5(value.encode("utf-8")).hexdigest()


def resolve_uid() -> str:
    """Return the numeric uid or a fallback string for the cache directory."""
    getuid = getattr(os, "getuid", None)
    if callable(getuid):
        return str(getuid())
    return "-1"


def escape_double_quotes(value: str) -> str:
    """Escape double-quote characters for inclusion inside double-quoted strings."""
    return value.replace('"', r"\"")


def load_config(config_path: Path) -> Mapping[str, Any]:
    """Load and parse the YAML configuration file."""
    try:
        yaml_text = config_path.read_text(encoding="utf-8")
    except FileNotFoundError as exc:
        raise SystemExit(f"Config file not found: {config_path}") from exc

    config = yaml.safe_load(yaml_text) or {}
    if not isinstance(config, Mapping):
        raise SystemExit("Invalid configuration: top-level YAML structure must be a mapping.")

    if "views" not in config or not isinstance(config["views"], Mapping):
        raise SystemExit("Invalid configuration: `views` section is required and must be a mapping.")

    return config


def iter_view_entries(entries: Any) -> Iterable[tuple[int, Mapping[str, Any]]]:
    """
    Yield (key_index, action_map) tuples for a view definition.

    The `key_index` matches the original JS behaviour:
    - For sequences the index starts at 1.
    - For mappings the numeric key is used as-is.
    """
    if isinstance(entries, Sequence) and not isinstance(entries, (str, bytes)):
        for idx, action in enumerate(entries, 1):
            if not isinstance(action, Mapping):
                raise SystemExit("Each action inside a view must be a mapping.")
            yield idx, action
        return

    if isinstance(entries, Mapping):
        for raw_key, action in entries.items():
            if not isinstance(action, Mapping):
                raise SystemExit("Each action inside a view must be a mapping.")
            try:
                index = int(raw_key)
            except (TypeError, ValueError) as exc:
                raise SystemExit("Non-numeric key detected in view mapping.") from exc
            yield index, action
        return

    raise SystemExit("Each view must be defined as a sequence or a mapping.")


def render_action(index: int, action: Mapping[str, Any]) -> str:
    """Render a single `create_key`/status block."""
    tmux_index = index
    title_expr = action.get("action", "")
    if action.get("title_exec"):
        title_expr = f"$({action['title_exec']})"
    elif action.get("title"):
        title_expr = action["title"]

    color_name = action.get("color")
    color_value = COLOR_MAP.get(color_name) if color_name else None
    if color_value is None:
        color_value = get_random_color()

    action_type = action.get("type")
    action_value = action.get("action", "")

    if action_type == "view":
        action_target = f"'{md5(action_value)}_view' 'view'"
    elif action_type == "exec":
        action_target = f"'{action_value}' 'exec'"
    elif action_type == "insert":
        action_target = f"'{action_value}' 'insert'"
    elif action_type == "tmux":
        action_target = f"'{action_value}' 'tmux'"
    else:
        action_target = f"'{action_value}' 'popup'"

    should_flash = "false" if action_type == "view" or action.get("sh") is False else "true"
    escaped_title = escape_double_quotes(title_expr)

    return (
        f"\n  create_key {tmux_index} \"{escaped_title}\" {action_target} {color_value} {should_flash}\n"
        f"  right_status+=\"#[bg=colour8,fg=colour15,bold] {tmux_index} #[bg=colour{color_value},fg=colour0,bold] "
        f"{escaped_title} #[fg=default,bg=default]\"\n"
    )


def render_view(view_name: str, entries: Any) -> str:
    """Render the shell function for a single view."""
    blocks = []
    for index, action in iter_view_entries(entries):
        blocks.append(render_action(index, action))

    actions_code = "  right_status+=' '".join(blocks)
    return (
        f"\n{md5(view_name)}_view() {{\n"
        "  unbind_keys\n"
        f"{actions_code}"
        "  set_status\n"
        "}\n"
    )


def render_script(config: Mapping[str, Any]) -> str:
    """Render the full tmux script payload."""
    views = config["views"]
    view_functions = "".join(render_view(view_name, entries) for view_name, entries in views.items())

    default_view_name = config.get("default_view")
    if not default_view_name:
        try:
            default_view_name = next(iter(views))
        except StopIteration:
            raise SystemExit("Invalid configuration: at least one view must be defined.")

    case_lines = "\n".join(
        f"        {md5(view_name)}_view) {md5(view_name)}_view ;;"
        for view_name in views
    )

    return (
        "\nright_status=' '\n\n"
        "function unbind_keys() {\n"
        "  tmux unbind-key -n F1\n"
        "  tmux unbind-key -n F2\n"
        "  tmux unbind-key -n F3\n"
        "  tmux unbind-key -n F4\n"
        "  tmux unbind-key -n F5\n"
        "  tmux unbind-key -n F6\n"
        "  tmux unbind-key -n F7\n"
        "  tmux unbind-key -n F8\n"
        "  tmux unbind-key -n F9\n"
        "  tmux unbind-key -n F10\n"
        "  tmux unbind-key -n F11\n"
        "  tmux unbind-key -n F12\n"
        "}\n\n"
        "function create_key() {\n"
        "  display_message=''\n"
        "  if [ \"$6\" = 'true' ]; then\n"
        "    display_message=\"display -d 600 '#[fill=colour0 bg=colour${5} align=centre] ${2} '\"\n"
        "  fi\n\n"
        "  tmux_action=''\n\n"
        "  if [ \"$4\" = \"view\" ]; then\n"
        "    tmux_action=\"run-shell 'zsh ${TMPDIR:-/tmp}/zsh-${UID}/tmux-keys.zsh $3'\"\n"
        "  elif [ \"$4\" = \"insert\" ]; then\n"
        "    tmux_action=\"send-keys $keys[$1] '$3'\"\n"
        "  elif [ \"$4\" = \"exec\" ]; then\n"
        "    tmux_action=\"send-keys $keys[$1] '$3\\n'\"\n"
        "  elif [ \"$4\" = \"popup\" ]; then\n"
        "    tmux_action=\"display-popup -w '80%' -h '80%' $3\"\n"
        "  elif [ \"$4\" = \"tmux\" ]; then\n"
        "    tmux_action=\"$3\"\n"
        "  fi\n\n"
        "  if [ \"$display_message\" = \"\" ]; then\n"
        "    tmux bind-key -n F${1} \"$tmux_action\"\n"
        "  else\n"
        "    tmux bind-key -n F${1} \"$display_message ; $tmux_action\"\n"
        "  fi\n"
        "}\n\n"
        "function set_status() {\n"
        "  tmux set -g status-right \"$right_status\"\n"
        "}\n\n"
        f"{view_functions}\n"
        "case $1 in\n"
        f"{case_lines}\n"
        f"    *) {md5(default_view_name)}_view\n"
        "esac\n\n"
    )


def main() -> None:
    config_path = Path.home() / ".tmux-keys.yaml"
    config = load_config(config_path)
    script_body = render_script(config)

    tmp_dir = Path(os.environ.get("TMPDIR", "/tmp"))
    cache_dir = tmp_dir / f"zsh-{resolve_uid()}"
    cache_dir.mkdir(parents=True, exist_ok=True)
    target_path = cache_dir / "tmux-keys.zsh"
    target_path.write_text(script_body, encoding="utf-8")


if __name__ == "__main__":
    main()
