import YAML from "yaml";
import fs from "fs/promises";
import crypto from "crypto";
import os from "os";

const userInfo = os.userInfo();
const uid = userInfo.uid;

const colorMap = {
  red: "1",
  green: "2",
  yellow: "3",
  blue: "4",
  magenta: "5",
  cyan: "6",

  rose: "9",
  chartreuse: "10",
  orange: "11",
  azure: "12",
  violet: "13",
  springgreen: "14",
};

function getRandomColor() {
  const keys = Object.values(colorMap);

  return keys[Math.floor(Math.random() * keys.length)];
}

const md5 = (str) => crypto.createHash("md5").update(str).digest("hex");

const generateCacheFile = async () => {
  const yaml = await fs.readFile(
    `${process.env.HOME}/.tmux-keys.yaml`,
    "utf-8"
  );

  const config = YAML.parse(yaml);

  const viewsFunctions = Object.entries(config.views).map(([view, value]) => {
    let subfn = `
${md5(view)}_view() {
  unbind_keys
${Object.entries(value)
  .map(([key, command]) => {

    console.log(key, command);
    const key_string = `
  create_key ${key} "${
      command.text_exec ? `$(${command.text_exec})` : command.text
    }" ${
      command.view
        ? `'${md5(command.view)}_view' '-v'`
        : command.command
        ? `'${command.command}' '-s'`
        : command.tmux_command
        ? `'${command.tmux_command}' '-b'`
        : `'${command.template}' '-t'`
    }
  left_status+="#[bg=colour8,fg=colour15,bold] ${key} #[bg=colour${
      command.color ? colorMap[command.color] : getRandomColor()
    },fg=colour0,bold] ${
      command.text_exec ? `$(${command.text_exec})` : command.text
    } #[fg=default,bg=default]"
`;

    return key_string;
  })
  .join(`  left_status+=' '`)}
  set_status
}
    `;

    return subfn;
  });

  let script = `
left_status=''

function unbind_keys() {
  tmux unbind-key -n F1
  tmux unbind-key -n F2
  tmux unbind-key -n F3
  tmux unbind-key -n F4
  tmux unbind-key -n F5
  tmux unbind-key -n F6
  tmux unbind-key -n F7
  tmux unbind-key -n F8
  tmux unbind-key -n F9
  tmux unbind-key -n F10
  tmux unbind-key -n F11
  tmux unbind-key -n F12
}

function create_key() {
  if [ "$4" = "-s" ]; then
    tmux bind-key -n F\${1} send-keys $keys[$1] "$3
"
  elif [ "$4" = "-t" ]; then
    tmux bind-key -n F\${1} send-keys $keys[$1] "$3"
  elif [ "$4" = "-v" ]; then
    tmux bind-key -n "F\${1}" run-shell "zsh \${TMPDIR:-/tmp}/zsh-\${UID}/tmux-keys.zsh '$3'"
  elif [ "$4" = "-b" ]; then
    tmux bind-key -n F\${1} "$3"
  fi
}

function set_status() {
  tmux set -g status-right "$left_status"
}

  ${viewsFunctions.join("")}

case $1 in
${Object.entries(config.views)
  .map(([view, val]) => `\t\t${md5(view)}_view) ${md5(view)}_view ;;`)
  .join("\n")}
    *) ${md5(config.default_view)}_view
esac

  `;

  fs.writeFile(
    `${process.env.TMPDIR || "/tmp"}/zsh-${uid}/tmux-keys.zsh`,
    script
  );
};

generateCacheFile();
