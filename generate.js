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
    const prepareKey = (key) => (Array.isArray(value) ? +key + 1 : +key);

    let subfn = `
${md5(view)}_view() {
  unbind_keys
${Object.entries(value)
  .map(([key, action]) => {
    const color = action.color ? colorMap[action.color] : getRandomColor();
    const key_string = `
  create_key ${prepareKey(key)} "${
      action.title_exec
        ? `$(${action.title_exec})`
        : action.title
        ? action.title
        : action.action
    }" ${
      action.type === "view"
        ? `'${md5(action.action)}_view' 'view'`
        : action.type === "exec"
        ? `'${action.action}' 'exec'`
        : action.type === "insert"
        ? `'${action.action}' 'insert'`
        : action.type === "tmux"
        ? `'${action.action}' 'tmux'`
        : `'${action.action}' 'popup'`
    } ${color} ${
      action.sh === false || action.type === "view" ? "false" : "true"
    }
  left_status+="#[bg=colour8,fg=colour15,bold] ${prepareKey(
    key
  )} #[bg=colour${color},fg=colour0,bold] ${
      action.title_exec
        ? `$(${action.title_exec})`
        : action.title
        ? action.title
        : action.action
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
  display_message=''
  if [ "$6" = 'true' ]; then
    display_message="display -d 200 '#[fill=colour0 bg=colour\${5} align=centre] \${2} '"
  fi

  tmux_action=''

  if [ "$4" = "view" ]; then
    tmux_action="run-shell 'zsh \${TMPDIR:-/tmp}/zsh-\${UID}/tmux-keys.zsh $3'"
  elif [ "$4" = "insert" ]; then
    tmux_action="send-keys $keys[$1] '$3'"
  elif [ "$4" = "exec" ]; then
    tmux_action="send-keys $keys[$1] '$3\n'"
  elif [ "$4" = "popup" ]; then
    tmux_action="display-popup -w '80%' -h '80%' $3"
  elif [ "$4" = "tmux" ]; then
    tmux_action="$3"
  fi

  if [ "$display_message" = "" ]; then
    tmux bind-key -n F\${1} "$tmux_action"
  else
    tmux bind-key -n F\${1} "$display_message ; $tmux_action"
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
