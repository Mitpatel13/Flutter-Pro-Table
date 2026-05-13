import 'package:flutter/widgets.dart';

/// Per-cell visual override. Use with [ProColumn.cellStyleResolver] or
/// [ProTable.rowStyleResolver] to apply conditional styling.
class ProCellStyle {
  const ProCellStyle({
    this.backgroundColor,
    this.textStyle,
    this.borderRadius,
    this.padding,
    this.border,
    this.alignment,
  });

  final Color? backgroundColor;
  final TextStyle? textStyle;
  final BorderRadius? borderRadius;
  final EdgeInsetsGeometry? padding;
  final BoxBorder? border;
  final Alignment? alignment;

  ProCellStyle merge(ProCellStyle? other) {
    if (other == null) return this;
    return ProCellStyle(
      backgroundColor: other.backgroundColor ?? backgroundColor,
      textStyle: textStyle?.merge(other.textStyle) ?? other.textStyle,
      borderRadius: other.borderRadius ?? borderRadius,
      padding: other.padding ?? padding,
      border: other.border ?? border,
      alignment: other.alignment ?? alignment,
    );
  }
}

/// Describes a cell that spans multiple columns and/or rows. Use this to
/// implement merged-cell layouts (rowspan / colspan) similar to HTML tables.
///
/// Provide a list of [ProCellSpan] through [ProTable.cellSpans]. Spans take
/// precedence over normal column rendering for the cells they cover.
class ProCellSpan {
  const ProCellSpan({
    required this.rowIndex,
    required this.columnId,
    this.rowSpan = 1,
    this.columnSpan = 1,
    required this.builder,
    this.style,
  })  : assert(rowSpan >= 1),
        assert(columnSpan >= 1);

  /// The row index (in the current visible/paginated dataset) where the span
  /// begins.
  final int rowIndex;

  /// The column id where the span begins.
  final String columnId;

  /// How many rows this cell spans.
  final int rowSpan;

  /// How many columns this cell spans.
  final int columnSpan;

  /// Renders the merged cell content.
  final Widget Function(BuildContext context) builder;

  /// Optional style for the merged cell.
  final ProCellStyle? style;
}
