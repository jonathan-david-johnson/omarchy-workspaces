# Omarchy Workspace Monitor Indicators

A small Omarchy workspace-bar extension that makes monitor assignment visible
without changing the bar's overall look:

- A subtle underline marks each workspace's monitor, using the active theme's
  accent and muted colors.
- A `›` at the end of the workspace list opens a compact monitor-color key.
- Hovering a workspace shows its monitor name.
- Workspaces without a current monitor assignment have no underline.

This replaces Omarchy's built-in `omarchy.workspaces` widget and preserves its
workspace switching behavior.

## Requirements

- Omarchy with the Quickshell shell and `omarchy plugin` commands.
- Tested on Omarchy **4.0.4-1** with Quickshell **0.3.1-1**.

## Install

Review the source before installing: Omarchy plugins run unsandboxed inside the
shell process.

```bash
omarchy plugin add https://github.com/jonathan-david-johnson/omarchy-workspaces.git --enable
```

The stable plugin ID is `jdj.workspaces`. Omarchy installs it under
`~/.config/omarchy/plugins/jdj.workspaces/` and replaces the built-in workspace
bar widget. It does not edit files under `/usr/share/omarchy/`.

If you already have a local `jdj.workspaces` clone, back it up and remove it
before installing this Git-managed copy; the installer will not overwrite an
existing local clone. The local clone does not automatically become Git-managed.

## Use

The bar shows a thin theme-colored underline for assigned workspaces. The first
monitor by connector name uses the theme accent; additional monitors use the
muted theme color. Click `›` to open the key with monitor connector names. Hover
a workspace for its assigned monitor. Click a workspace number as usual to
switch to it.

If an update does not appear in a running session, restart the shell while it is
unlocked:

```bash
omarchy restart shell
```

## Update or remove

```bash
omarchy plugin update jdj.workspaces
omarchy plugin remove jdj.workspaces
```

Removing the plugin restores Omarchy's built-in workspace widget.

## Development

Validate the plugin manifest and entry points with:

```bash
omarchy plugin validate .
```

On an Omarchy session, check the bar after changing the QML. Theme colors are
resolved live from Omarchy's shared color palette; the marker colors are not
hard-coded.

## License and attribution

MIT. This is a third-party extension, not an official Omarchy release. It is
based on Omarchy's built-in workspace widget by David Heinemeier Hansson and
Omarchy contributors. See [UPSTREAM.md](UPSTREAM.md) and [LICENSE](LICENSE).
