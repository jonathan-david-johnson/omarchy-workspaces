# Upstream attribution

This extension is based on Omarchy's built-in `omarchy.workspaces` bar widget.

- Project: [Omarchy](https://github.com/omacom/omarchy)
- Source: `shell/plugins/bar/widgets/Workspaces.qml`
- Baseline: Omarchy `4.0.4-1`, Quickshell `0.3.1-1`
- Original license: MIT, copyright David Heinemeier Hansson

The plugin retains `omarchy.clonedFrom: "omarchy.workspaces"` so Omarchy can
replace the built-in widget while preserving its bar placement. It imports
Omarchy's shared Quickshell UI and theme colors instead of copying them into
this repository.

Changes maintained here:

- Add subtle monitor-assignment underlines using Omarchy's active theme palette.
- Add a chevron-triggered monitor legend and workspace monitor tooltips.
- Preserve the built-in workspace labels and switching behavior.

Omarchy updates do not automatically merge changes from the built-in widget into
this extension. Compatibility changes must be reviewed and incorporated here.
