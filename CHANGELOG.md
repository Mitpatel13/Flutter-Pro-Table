## 0.2.1

* Added README screenshots showcasing the full demo, frozen columns, merged cells and skeleton loading state.
* Declared `screenshots:` in `pubspec.yaml` for the pub.dev package card.
* Cleaned up example app package namespace to `com.tablepro.mit` on Android and iOS.
* Updated repository and issue tracker URLs to the canonical GitHub location.

## 0.2.0

ERP-style customizations (Zoho / Odoo / AG-Grid inspired):

* **Density modes** — `density: ProTableDensity.compact / standard / comfortable` scales row height, header height and cell padding.
* **Row numbers** — `showRowNumbers: true` prepends a leading "#" column with 1-based row indices across the current page.
* **Column visibility toggle** — `enableColumnVisibilityToggle: true` adds a "Columns" button to the toolbar that opens a checkbox menu. Per-column `hideable: false` opts out.
* **Footer / summary row** — `showFooter: true` plus `ProColumn.footerBuilder` (or `ProTable.footerBuilder` for a custom one). Receives the filtered row list so you can compute totals, averages, counts.
* **Bulk actions bar** — `bulkActionsBuilder` slides in a sticky bar at the bottom when rows are selected, with a clear-selection button, label ("3 selected") and arbitrary action widgets.
* **Column resize** — `enableColumnResize: true` adds drag handles to the right edge of every non-pinned header cell. Bounded by `ProColumn.minResizeWidth` / `maxResizeWidth`.
* **Mobile card view** — `mobileBreakpoint: 600` + optional `mobileCardBuilder` switches the table to a card list on narrow screens.
* **Skeleton loading** — `loadingStyle: ProLoadingStyle.skeleton` renders animated shimmer rows. Customise count via `skeletonRowCount`.
* **Drag-and-drop column reorder** — `enableColumnReorder: true` (long-press a header to drag).
* **Auto row height** — `autoSizeRows: true` lets rows grow to fit multi-line content; `ProColumn.maxLines` caps line count.
* **Per-cell tap / long-press** — `ProColumn.onCellTap` and `onCellLongPress` for fine-grained navigation.
* **Alternating row colors** — `oddRowColor` / `evenRowColor` parameters; still works alongside `rowStyleResolver` for condition-based coloring.

Bug fixes:

* Fixed pagination footer where page-number buttons stretched to full width on certain layouts.

## 0.1.0

Initial release.

* Responsive `ProTable<T>` widget for iOS, Android, Web, macOS, Windows, Linux.
* React-style pagination with first/prev/numbered/next/last buttons, page-size dropdown, "jump to page" input.
* Built-in toolbar with title, subtitle, search input and trailing actions.
* Sortable columns with custom comparators and tri-state toggling.
* Single & multi row selection (radio / checkbox + select-all).
* Expandable rows with custom panel builder.
* Frozen / pinned columns (`ColumnPin.left` / `ColumnPin.right`) with synced horizontal scroll.
* Merged cells (rowspan / colspan) via `ProCellSpan`.
* Custom cell rendering through `cellBuilder`, `headerBuilder` and per-cell / per-row style resolvers.
* `ProTableTheme` controlling colours, radius, paddings, row height, dividers, striping, hover, and selected colour. Auto-derives from the surrounding `ThemeData`.
* `ProColumnWidth.fixed`, `ProColumnWidth.flex`, `ProColumnWidth.intrinsic`.
* Customisable empty / loading states.
* Hover effect on web/desktop, tap / double-tap / long-press on mobile.
