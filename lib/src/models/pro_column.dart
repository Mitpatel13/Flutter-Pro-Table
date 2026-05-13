import 'package:flutter/widgets.dart';

import 'pro_cell.dart';

/// How wide a [ProColumn] should be.
sealed class ProColumnWidth {
  const ProColumnWidth();

  /// A fixed pixel width.
  const factory ProColumnWidth.fixed(double width) = ProFixedColumnWidth;

  /// A flexible width that takes a share of the leftover horizontal space.
  /// [flex] behaves like the `flex` property of [Flexible].
  const factory ProColumnWidth.flex([int flex]) = ProFlexColumnWidth;

  /// A width that fits to its content, clamped between [min] and [max].
  const factory ProColumnWidth.intrinsic({double min, double max}) =
      ProIntrinsicColumnWidth;
}

class ProFixedColumnWidth extends ProColumnWidth {
  const ProFixedColumnWidth(this.width);
  final double width;
}

class ProFlexColumnWidth extends ProColumnWidth {
  const ProFlexColumnWidth([this.flex = 1]);
  final int flex;
}

class ProIntrinsicColumnWidth extends ProColumnWidth {
  const ProIntrinsicColumnWidth({this.min = 80, this.max = 320});
  final double min;
  final double max;
}

/// Where a column is pinned in horizontal scroll.
enum ColumnPin { none, left, right }

/// A single column definition for [ProTable].
///
/// [T] is the row type. The column reads its cell value from a row of type [T]
/// using [value], and optionally renders a custom widget through [cellBuilder].
class ProColumn<T> {
  const ProColumn({
    required this.id,
    required this.title,
    this.value,
    this.cellBuilder,
    this.headerBuilder,
    this.width = const ProColumnWidth.flex(),
    this.alignment = Alignment.centerLeft,
    this.headerAlignment,
    this.sortable = false,
    this.compare,
    this.filterable = false,
    this.searchable = true,
    this.pin = ColumnPin.none,
    this.expandable = false,
    this.tooltip,
    this.cellPadding,
    this.cellStyleResolver,
    this.headerStyle,
    this.visible = true,
    this.onCellTap,
    this.onCellLongPress,
    this.draggable = true,
    this.maxLines,
    this.footerBuilder,
    this.hideable = true,
    this.minResizeWidth = 64,
    this.maxResizeWidth = 800,
  });

  /// Stable identifier — used for sort state, column visibility etc.
  final String id;

  /// The header label.
  final String title;

  /// Function that returns the raw value for a row in this column.
  /// Used for default text rendering, sorting, searching and filtering.
  final Object? Function(T row)? value;

  /// Custom cell renderer. Overrides the default text rendering.
  final Widget Function(BuildContext context, T row, int rowIndex)? cellBuilder;

  /// Custom header renderer. Overrides the default header.
  final Widget Function(BuildContext context)? headerBuilder;

  /// Width of the column.
  final ProColumnWidth width;

  /// Alignment of cell content inside the cell.
  final Alignment alignment;

  /// Alignment of header content. Falls back to [alignment] when null.
  final Alignment? headerAlignment;

  /// Whether the column header allows sorting.
  final bool sortable;

  /// Custom comparator. When null, the [value] is compared with [Comparable].
  final int Function(T a, T b)? compare;

  /// Whether this column can be filtered through the toolbar's column filter.
  final bool filterable;

  /// Whether this column's value is matched by the global search box.
  final bool searchable;

  /// Pin position: none / left / right. Pinned columns stick during horizontal
  /// scroll.
  final ColumnPin pin;

  /// When true, this column will render an expand/collapse icon on each row.
  /// Pair with [ProTable.expandedRowBuilder] to render the expanded panel.
  final bool expandable;

  /// Optional tooltip shown when hovering the header.
  final String? tooltip;

  /// Padding inside cells of this column. Falls back to theme.
  final EdgeInsetsGeometry? cellPadding;

  /// Resolves custom styling per-cell (color, text style, border, etc).
  /// Useful for status badges, conditional formatting, etc.
  final ProCellStyle Function(T row, int rowIndex)? cellStyleResolver;

  /// Static header style override.
  final ProCellStyle? headerStyle;

  /// Whether the column is visible. Defaults to true.
  final bool visible;

  /// Per-cell tap handler — useful for navigation when only specific cells
  /// should be clickable (e.g. opening a detail page from the "name" column
  /// while the rest of the row is non-interactive).
  final void Function(T row, int rowIndex)? onCellTap;

  /// Per-cell long-press handler.
  final void Function(T row, int rowIndex)? onCellLongPress;

  /// Whether this column can be drag-reordered. Only effective when the
  /// table-level `enableColumnReorder` is true. Pinned columns are never
  /// reorderable.
  final bool draggable;

  /// Limits text wrapping in the default cell renderer. Pair with
  /// `ProTable.autoSizeRows: true` to allow rows to grow to fit multi-line
  /// content. When null, the default is 1 line with ellipsis.
  final int? maxLines;

  /// Renders the footer cell for this column when `ProTable.showFooter` is
  /// true. Receives the **filtered/sorted** row list (the same data the
  /// table is showing) so you can compute totals, averages, counts, etc.
  final Widget Function(BuildContext context, List<T> rows)? footerBuilder;

  /// Whether the user can hide this column from the column-visibility menu.
  /// Set to false for columns that should always be visible (e.g. an ID or
  /// "Name" column).
  final bool hideable;

  /// Minimum width when [ProTable.enableColumnResize] is true.
  final double minResizeWidth;

  /// Maximum width when [ProTable.enableColumnResize] is true.
  final double maxResizeWidth;

  Alignment get effectiveHeaderAlignment => headerAlignment ?? alignment;
}
