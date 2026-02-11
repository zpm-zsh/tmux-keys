# AGENTS Instructions for `zpm-zsh---tmux-keys`

## Purpose
Этот файл фиксирует рабочие договоренности по плагину `tmux-keys`: поведение конфигов, генерации, popup/exec и правила цветовых схем.

## Config Resolution
Конфиг клавиш должен искаться строго в таком порядке (первый существующий файл):

1. `$XDG_CONFIG_HOME/tmux/keys.yaml` (или `~/.config/tmux/keys.yaml`, если `XDG_CONFIG_HOME` не задан)
2. `~/.tmux/keys.yaml`
3. `~/.tmux-keys.yaml`

Дополнительно:
- `tmux-keys.plugin.zsh` и `generate.py` должны использовать один и тот же порядок.
- Плагин передает выбранный путь в `generate.py` через `TMUX_KEYS_CONFIG`.
- Если конфиг не найден ни в одном месте, создается пример в первом пути (`$XDG_CONFIG_HOME/tmux/keys.yaml`).

## Cache/Regeneration Rules
- Кэш: `${TMPDIR:-/tmp}/zsh-${UID}/tmux-keys.zsh`.
- Кэш считается актуальным только если он новее:
  - выбранного YAML-конфига
  - `generate.py`
- Иначе скрипт должен быть пересобран.

## Action Types Behavior
- `type: exec`: команда отправляется в текущий pane и запускается с Enter через `send-keys ... C-m`.
  - Не использовать литерал `\n` для Enter.
- `type: popup`: запускать через `tmux display-popup` с рабочей директорией активного pane:
  - `-d "#{pane_current_path}"`
- Для долгих/шумных CLI-команд предпочтителен `type: popup`, чтобы не засорять командную строку текущего pane.

## Example Presets (Current Intent)
В примерах (`tmux-keys.example.yaml`, README snippet, fallback `tmux-keys.example.zsh`) применяем:
- `Git Status/Branch` -> `popup`
- `Python Install` -> `popup`
- `Python CLI` -> `exec` (в обычном pane)
- `NPM list/install/dev` -> `popup`
- `ZPM upgrade/clean/readme` -> `popup`

## Color Scheme Rules
Цвета должны быть консистентными и предсказуемыми:

1. Кнопки одного типа действия могут иметь один цвет (пример: `previous-window` и `next-window`).
2. Кнопки-секции в главном меню (`System`, `Git`, `Python`, `NPM`, `ZPM`) должны быть разными между собой.
3. Кнопка `Main` во всех секциях должна иметь один и тот же цвет.
4. Цвет `Main` не должен совпадать с цветом `previous/next`.
5. Внутри каждой секции цвета кнопок должны быть разными.
6. Внутри секции не использовать цвет самой секции из главного меню.

## Sync Rules
При изменении логики обязательно синхронизировать:
- `generate.py`
- `tmux-keys.plugin.zsh` (если затрагивается резолв/кэш)
- `tmux-keys.example.yaml`
- `README.md` (пример конфигурации)
- `tmux-keys.example.zsh` (fallback-пример)
