const gitCommandPattern = /(?:^|[;&|()'"\n]\s*)(?:sudo\s+|command\s+|env\s+)*(?:[^\s;&|()'"]+\/)?git(?=$|[\s;&|()'"])/;

export default async () => ({
  "tool.execute.before": async (input, output) => {
    if (input.tool !== "bash") return;

    const command = output.args?.command;
    if (typeof command !== "string") return;

    if (gitCommandPattern.test(command)) {
      throw new Error("git is disabled in this opencode config. Use jj instead.");
    }
  },
});
