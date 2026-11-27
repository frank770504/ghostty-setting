# ghosttly_setting

A reconstruction kit for one Ghostty terminal configuration. It installs a
checked-in config to the Linux/XDG Ghostty path and lets the result be verified
without access to the original machine.

## What's in this repo

| File | Purpose |
| --- | --- |
| `config.ghostty` | The config itself; source of truth. |
| `install.sh` | Idempotent installer with backup-on-replace behavior. |
| `doc/spec/ghostty-setting.md` | Settings, installation contract, and verification steps. |
| `AGENT.md` | Rules for agents making changes to this repo. |

## Configuration

The config uses the Catppuccin Mocha theme, Ubuntu Mono at size 11, and
85% background opacity so the desktop is subtly visible through Ghostty. It
also uses DPI-scaled padding so text does not touch the window edges:

```ghostty
theme = Catppuccin Mocha
background-opacity = 0.85
font-family = Ubuntu Mono
font-size = 11

window-padding-x = 8
window-padding-y = 6
window-padding-balance = true
window-padding-color = background
```

There is deliberately no `command = ...` line: Byobu is started manually, and
new windows open in the default shell. See the spec for the intent behind each
setting and the invariants to preserve.

## Requirements

- Ghostty 1.3 or later (the observed version was `1.3.0-dev` on Linux).
- The `Ubuntu Mono` font installed and available to Ghostty. This kit does not
  install fonts or packages.

## Install

Run the installer from any working directory:

```bash
/path/to/ghosttly_setting/install.sh
```

It reads `config.ghostty` from its own directory and installs to
`${XDG_CONFIG_HOME:-$HOME/.config}/ghostty/config.ghostty`.

- If the destination is already byte-identical, nothing is changed.
- If a different file or symlink exists there, it is first copied to
  `config.ghostty.bak.<UTC timestamp>.<pid>`; installation then uses a temporary
  file and an atomic `mv`.
- The installer does not edit shell profiles, launch Byobu, or write to the
  macOS config path.

## Verify

```bash
cd /path/to/ghosttly_setting

# Validate the checked-in config.
ghostty +validate-config --config-file=./config.ghostty

# Install (safe to re-run).
./install.sh

# Confirm the installed file matches the source.
DEST="${XDG_CONFIG_HOME:-$HOME/.config}/ghostty/config.ghostty"
diff -u ./config.ghostty "$DEST"

# Confirm the effective settings reported by Ghostty.
ghostty +show-config | grep -E '^(theme|background-opacity|font-family|font-size|window-padding-(x|y|balance)) ='

# `window-padding-color` can be hidden by +show-config defaults; check the file.
grep -F 'window-padding-color = background' "$DEST"
```

A clean validation, an empty `diff`, the expected values from `+show-config`, and
a fresh window showing subtle transparency with readable text mean the
reconstruction is complete.

## Making changes

`config.ghostty` is the source of truth. Do not change the config path, theme,
font, padding, or add an auto-start command unless explicitly intended; update
`doc/spec/ghostty-setting.md` alongside any config or installer change and
re-run the verification commands above.
