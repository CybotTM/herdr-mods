# Actions

A run button for Herdr's tab bar, after T3 Code's: **▶ Dev | ▾** runs your most recent command in
a new terminal with one click, and the ▾ menu lists every saved action plus **Add action**. Actions
are kept in shared state, so every layout and window sees the same list.

## What you see

- **In a bar** (sized to its block, 24px tall, outlined with a 1px `border`, radius 6, 12px text
  in `dim` that brightens on hover): the last-run action's icon and name (up to 140px) as the run
  part, a divider, and a ▾. Before any action exists: **▶ Add action**. In a narrow bar (shared
  `bar.compact`) the name hides and shows on hover.
- **Menu** (280px popup hanging under the bar at the click, not over it): one 32px row per action
  with its icon and name and an edit pencil on the right, then **+ Add action**.
- **Editor** (440 × 410 dialog, "Add action" / "Edit action", Esc): **Name** (placeholder "Dev"),
  **Command** ("bun run dev"), **Folder (optional)** ("Focused terminal's folder"), an **Icon** row
  (play, test, lint, configure, build, debug) and **Run in** (Tab, Right, Down); **Delete** (with
  Herdr's confirm dialog) and **Save**.

## How it behaves

- Run opens a terminal named after the action running `sh -c "<command>"` in a new tab, or split
  right or down. Its folder is the action's (a leading `~` is your home), else the focused
  terminal's, else a terminal in the same tab (for a mod pane), else the space's folder.
- Running an action makes it the bar's action. Enter in the editor saves.
- Agent status isn't shown; actions are plain commands.

## Built from

- `mods/t3-actions/`: `main.js` (bar control; `props.actions: "menu"` / `"edit"` as overlays make
  the menu and editor), `tip.js` (hover labels), `action-*.svg` icons, `check.cjs` (a Node check
  that renders every view on inert elements: `node mods/t3-actions/check.cjs`).
  `mod.json`: `{ "place": "none", "title": "Actions" }`.
- Put it in the tab bar's row, e.g.
  `{ "id": "actions", "type": "block", "size": { "px": 108 }, "content": { "mod": "t3-actions", "props": { "block": "actions" } } }`.
- Shared state `t3-actions`: `{ list: [{ id, name, command, icon, place, cwd? }], last: id }`.
- Herdr API: `run("terminal.open")`, `openOverlay`/`closeOverlay`, `shared`/`setShared`, `focused`,
  `panes`, `spaces`, `home`, `settings().zoom`, `nextCommand` (`t3-actions.delete-action:<id>`
  answers the confirm dialog); shipped mods `confirm` and `workspace-chrome` (the plus icon).

## Watch out

- The menu is placed from the press position under the bar (`y = 40 × zoom`); with no press (an
  assistive click) it falls back to the pointer.
- `sh -c` skips your shell's aliases and functions; wrap a command in `zsh -ic '…'` if it needs them.
- An svg doesn't take a hover text colour, so the icon and text brighten together through state.

## Done when

- `herdr-app check mods/t3-actions` and `node mods/t3-actions/check.cjs` pass.
- Add action → Save shows it on the bar; clicking ▶ opens a terminal running it in the chosen place
  and folder; the menu lists, edits and deletes actions (delete asks first).
