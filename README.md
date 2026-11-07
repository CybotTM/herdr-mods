# Herdr mods

Mods for [Herdr Desktop](https://herdr.dev). Each folder is one mod (or a pair that work together),
laid out like Herdr's home folder (`mods/<name>/`) with a `RECIPE.md` describing it.

| Folder | What it is |
| --- | --- |
| [issues](issues/) | GitHub issues and PRs in Herdr: a table, an in-app viewer (PR checks, diffs, merge), and a Create worktree dialog that starts work from a branch (including remote-only), an issue, a PR or a new name, with Claude's prompt prefilled. Two mods: `issues` and `new-worktree`. |
| [live-ports](live-ports/) | Listening ports grouped by the space that started them, as a status-bar button and popup with Open and Stop. |
| [usage-limits](usage-limits/) | Claude Code and Codex usage windows in a status bar, with a hover panel and session context. Reads the CLIs, never tokens. |
| [t3-actions](t3-actions/) | A one-click run button for the tab bar, after T3 Code's, with saved actions. |

They're also part of the [Orca layout](https://github.com/VladTemp27/herdr-orca).

## Install one

Ask your Herdr agent, with the folder's link:

> Read ~/.config/herdr-app/AGENTS.md, then add this mod: https://github.com/VladTemp27/herdr-mods/tree/main/issues

By hand: copy the folder's `mods/<name>/` into `~/.config/herdr-app/mods/`, run
`herdr-app check ~/.config/herdr-app/mods/<name>`, and place it as its `RECIPE.md` says
(`mod.open <name>`, a key, or a block in a layout you own).

## Updating this repo

`./sync.sh` copies these mods from your Herdr home into their folders.

## License

Apache-2.0, see [LICENSE](LICENSE) and [NOTICE](NOTICE).
