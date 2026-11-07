# Usage limits

Every Claude Code and Codex usage window (the 5-hour session, weekly, and per-model weekly limits)
in a status bar, with a hover panel of details and the current session's context. The numbers come
from the CLIs themselves; the mod never reads a token or credential file.

## What you see

- **Bar** (a status-bar block on `chrome` with a 1px top `border`, 11.8px `muted` text, aligned
  left or right by `props.align`): "Used" (or "Remaining"), then per installed CLI its icon, a 44px
  bar for its first window, and every window as compact text joined by `·` (e.g. `5h 42% · wk 61%`),
  plus a refresh button. Below 70% text is `foreground`, from 70% amber (`ansi3`), from 90% red
  (`ansi1`). Without room, the bars drop first. Opt-in session numbers (context, calls,
  compactions) can sit before the limits. With no CLI found: a gauge icon.
- **Hover panel** (340px, opens after 350ms over the limits, anchored to the bar): per provider its
  icon, name, plan badge and status; one row per window with its long name, a 110px bar with a pace
  tick, the percentage and time to reset; "This session" for the focused agent (context bar,
  calls, compactions, last compaction). A ⚙ button turns it into **Settings**: checkboxes for which
  providers and windows the bar shows, "Always show time to reset", "Show bars", "Show remaining
  instead of used", and which session numbers go on the bar.

## How it behaves

- Fetches installed providers every 5 minutes (a missing CLI is rechecked hourly); Refresh forces
  one, with a 30-second cooldown. Readings are kept in shared `usage-limits.state`, choices in
  `usage-limits.prefs` (the layout's `props` preset them until the person changes something).
- A window past its reset shows `—` until a new reading. Amber and red windows always show time to
  reset; the others only with that setting on.
- Session numbers come from the focused agent's own session log (Claude Code or Codex), read for
  numbers only, at most every 10 seconds while hovering.
- Agent status isn't shown; this is account usage.

## Built from

- `mods/usage-limits/`: `main.js` (bar, panel, settings), `providers/` (`claude.js`, `codex.js`,
  `index.js`), `lib/` (pure: `format`, `prefs`, `report`, `session`, `state`, `view`), `helpers/`
  (`claude-usage.sh`, `codex-limits.sh`, `session.sh`), `icons/` (gauge, gear, back, refresh).
  `mod.json`: `{ "place": "none" }`.
- Put it in a layout block, e.g.
  `{ "id": "usage-limits", "type": "block", "size": { "weight": 2 }, "min": 130, "content": { "mod": "usage-limits", "props": { "align": "left", "showRemaining": true } } }`.
- Herdr API: `exec`, `focused`, `shared`/`setShared`, `props`, `appHome`, gpui-base `HoverCard`.
- Programs: `claude` (run briefly with `-p --safe-mode --no-session-persistence` and the
  `get_usage` control request; no prompt, no turn), `codex app-server` (`account/rateLimits/read`,
  falling back to the newest rate-limit snapshot in Codex's session logs), `sh`, `awk`.
  Override the binaries with `HERDR_USAGE_CLAUDE_BIN` / `HERDR_USAGE_CODEX_BIN`.

## Watch out

- Never read tokens or credentials: let each CLI authenticate itself. Only numbers leave
  `session.sh`; the session files hold whole conversations.
- `claude` must not start a turn or load hooks/MCP servers (`--safe-mode`).
- Codex's app-server can be absent or slow: fall back to its logged snapshots, and say "not
  installed" rather than show old logs when the CLI is gone.
- Approach for the Claude request: credit to jmalicki/herdr-mod-ai-usage (MIT).

## Done when

- `herdr-app check mods/usage-limits` passes.
- With `claude` and/or `codex` installed and logged in, the bar shows their windows within a few
  seconds and colours them amber at 70% and red at 90%.
- Hovering opens the panel with every window and the session block; ⚙ settings change the bar and
  survive a restart.
