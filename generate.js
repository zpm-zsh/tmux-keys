import YAML from "yaml";
import fs from "fs/promises";
import crypto from "crypto";

const md5 = (str) => crypto.createHash("md5").update(str).digest("hex");

const generateCacheFile = async () => {
  const yaml = await fs.readFile(
    `${process.env.HOME}/.tmux-keys.yaml`,
    "utf-8"
  );

  const config = YAML.parse(yaml);

  let mainFunction = "";
  mainFunction += "\nprecmd_apple_touchbar() {\n";
  mainFunction += "\tcase $state in\n";
  mainFunction += Object.entries(config.views)
    .map(([view, val]) => `\t\t${md5(view)}) ${md5(view)}_view ;;`)
    .join("\n");
  mainFunction += "\n\tesac\n";
  mainFunction += "}\n";

  let viewsFunctions = "";
  viewsFunctions += Object.entries(config.views).map(([view, value]) => {
    let subfn = "";
    subfn += `\n${md5(view)}_view() {\n`;

    subfn += `\tset_state '${md5(view)}'\n`;
    subfn += `\tset_state_name '${view}'\n`;
    subfn += "\n";
    subfn += `\tunbind_keys\n`;
    subfn += `\tprefix_keys\n`;
    subfn += "\n";

    subfn += Object.entries(value)
      .map(([key, command]) => {
        let key_string = "";

        const commandStr = command.view
          ? `'${md5(command.view)}_view' '-v'`
          : command.command
          ? `'${command.command}' '-s'`
          : `'${command.template}' '-t'`;

        key_string += `\tcreate_key ${key} "${
          command.text_exec ? `$(${command.text_exec})` : command.text
        }" ${commandStr}`;

        return key_string;
      })
      .join("\n");

    subfn += "\n\n";
    subfn += `\tsuffix_keys\n`;
    subfn += `\twrite_to_file\n`;
    subfn += `\ttmux refresh-client -S\n`;
    subfn += "}\n";

    return subfn;
  });

  let defineViewsFunctions = "\n";
  defineViewsFunctions += Object.entries(config.views)
    .map(([view, val]) => `zle -N ${md5(view)}_view`)
    .join("\n");
  defineViewsFunctions += "\n";

  let script = "";
  script += `set_state '${md5(config.default_view)}'\n`;
  script += `set_state_name '${config.default_view}'\n`;
  script += viewsFunctions;
  script += defineViewsFunctions;
  script += mainFunction;
  script += "\nautoload -Uz add-zsh-hook\n";
  script += "add-zsh-hook precmd precmd_apple_touchbar\n";

  fs.writeFile(
    `${process.env.TMPDIR || "/tmp"}/zsh-${process.env.UID}/tmux-keys.zsh`,
    script
  );
};

generateCacheFile();
