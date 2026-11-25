# Agent Rules

This folder is a reconstruction kit for one Ghostty terminal configuration.

Before making changes, read `doc/spec/ghostty-setting.md`. Treat `config.ghostty`
at the repository root as the source of truth and `install.sh` as the
installation contract.

Do not introduce a different config path, theme, font, padding, or a
`command = ...` line unless the user explicitly asks for a change. If a change
is made, update the spec and re-run the verification commands in it.
