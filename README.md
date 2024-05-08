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

You can define simple commands for FN keys in `~/.tmux-keys.yaml` file.

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

  "Git":
    - type: view
      action: Main
    - title: Git Status
      type: exec
      action: "git status"
    - title: Git Branch
      type: exec
      action: git branch

  "Python":
    - type: view
      action: Main
    - text: Python Install
      type: insert
      action: "pip install "
    - title: Python CLI
      type: insert
      action: "python"

  "NPM":
    - type: view
      action: Main
    - title: NPM list
      type: exec
      action: "npm ls"
    - title: NPM Install
      type: insert
      action: "npm i "
    - title: Dev
      type: insert
      action: "npm run dev"
      color: cyan

  ZPM:
    - type: view
      action: Main
    - title: Upgrade Plugins
      type: exec
      action: "zpm upgrade"
    - title: Clean Cache
      type: exec
      action: "zpm clean"
    - title: Readme
      type: insert
      action: "zpm readme"

  System:
    - type: view
      action: Main
    - title_exec: _tmux_uname
      type: popup
      action: "neofetch"
      color: yellow
    - title_exec: _tmux_myip
      type: popup
      action: ip addr
      color: red
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
