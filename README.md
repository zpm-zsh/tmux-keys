# Tmux keys

Make shortcut toolbar for F1-F12 keys in Tmux.

![preview](./preview.gif)

## Requirements

- zsh
- nodejs (only if for automatic generation of config)
- tmux

## Installation

### If you use [oh-my-zsh](https://github.com/robbyrussell/oh-my-zsh)

- Clone this repository into `~/.oh-my-zsh/custom/plugins`

```sh
cd ~/.oh-my-zsh/custom/plugins
git clone https://github.com/zpm-zsh/tmux-keys
```

- After that, add `tmux-keys` to your oh-my-zsh plugins array.

### If you use [Zgen](https://github.com/tarjoilija/zgen)

1. Add `zgen load zpm-zsh/tmux-keys` to your `.zshrc` with your other plugin
2. run `zgen save`

### If you use [ZPM](https://github.com/zpm-zsh/zpm)

- Add `zpm load zpm-zsh/tmux-keys` into your `.zshrc`


### Automatic

You can define simple commands for FN keys in one of these files (first existing file wins):
`$XDG_CONFIG_HOME/tmux/keys.yaml` (or `~/.config/tmux/keys.yaml`), `~/.tmux/keys.yaml`, `~/.tmux-keys.yaml`.

#### Structure

File should have two base keys:

1. `default_view` - default view to show.
2. `views` - list of defined views.

`views` section contains views you want to show. **Key is a view name.**

Under view name key you should define next keys:

1. `text` - text that will show on touchbar key.
2. `action` or `view` - `action` means executing some action that under is this key and `view` means show view that is under this key

#### Example

```yml
default_view: "Main"
views:
  "Main":
    - title: "←"
      type: tmux
      action: previous-window
      color: green
      flash: false
    - title: "→"
      type: tmux
      action: next-window
      color: green
      flash: false
    - type: view
      action: System
      color: violet
    - type: view
      action: Git
      color: chartreuse
    - type: view
      action: Python
      color: rose
    - type: view
      action: NPM
      color: magenta
    - type: view
      action: ZPM
      color: yellow
    - type: view
      action: Docker
      color: springgreen
    - type: view
      action: Ops
      color: red

  "Git":
    - type: view
      action: Main
      color: azure
    - title: Git Status
      type: popup
      action: "git status"
      color: cyan
    - title: Git Branch
      type: popup
      action: git branch
      color: blue

  "Python":
    - type: view
      action: Main
      color: azure
    - text: Python Install
      type: popup
      action: "pip install"
      color: orange
    - title: Python CLI
      type: exec
      action: "python"
      color: cyan

  "NPM":
    - type: view
      action: Main
      color: azure
    - title: NPM list
      type: popup
      action: "npm ls | less"
      color: chartreuse
    - title: NPM Install
      type: popup
      action: "npm i"
      color: springgreen
    - title: Dev
      type: popup
      action: "npm run dev"
      color: cyan

  ZPM:
    - type: view
      action: Main
      color: azure
    - title: Upgrade Plugins
      type: popup
      action: "zpm upgrade"
      color: orange
    - title: Clean Cache
      type: popup
      action: "zpm clean"
      color: rose
    - title: Readme
      type: popup
      action: "zpm readme"
      color: violet

  System:
    - type: view
      action: Main
      color: azure
    - title_exec: _tmux_uname
      type: popup
      action: "neofetch"
      color: yellow
    - title_exec: _tmux_myip
      type: popup
      action: ip addr
      color: red

  Docker:
    - type: view
      action: Main
      color: azure
    - title: Docker PS
      type: popup
      action: "docker ps"
      color: cyan
    - title: Docker Images
      type: popup
      action: "docker images"
      color: orange
    - title: Compose Up
      type: popup
      action: "docker compose up"
      color: violet

  Ops:
    - type: view
      action: Main
      color: azure
    - title: Top
      type: popup
      action: "top"
      color: chartreuse
    - title: Disk Usage
      type: popup
      action: "df -h"
      color: springgreen
    - title: Journalctl
      type: popup
      action: "journalctl -xe"
      color: magenta
```

# TODO

- [ ] Change plugin name

## Contributing

If you have some proposals how to improve this boilerplate feel free to open issues and send pull requests!

1. Fork it
2. Create your feature branch (git checkout -b my-new-feature)
3. Commit your changes (git commit -am 'Add some feature')
4. Push to the branch (git push origin my-new-feature)
5. Create new Pull Request

## License

Available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
