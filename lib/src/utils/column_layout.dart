import 'package:flutter/widgets.dart';

import '../models/pro_column.dart';

/// Resolves the final pixel width for each column given a total available
/// width. The algorithm:
///   1. Subtract widths of fixed columns.
///   2. Subtract widths of intrinsic columns (estimated as `min`).
///   3. Distribute the remainder across flex columns.
///   4. If the total is wider than what's available, columns keep their
///      preferred width and the table scrolls horizontally.
class ColumnLayout {
  const ColumnLayout(this.widths, this.totalWidth);

  /// Per-column resolved width, indexed by the original column list.
  final List<double> widths;
  final double totalWidth;
}

ColumnLayout resolveColumnWidths<T>({
  required List<ProColumn<T>> columns,
  required double availableWidth,
  required TextStyle headerTextStyle,
  required TextStyle rowTextStyle,
  required EdgeInsetsGeometry cellPadding,
}) {
  final widths = List<double>.filled(columns.length, 0);

  double fixedTotal = 0;
  int totalFlex = 0;
  double intrinsicTotal = 0;

  for (var i = 0; i < columns.length; i++) {
    final w = columns[i].width;
    switch (w) {
      case ProFixedColumnWidth():
        widths[i] = w.width;
        fixedTotal += w.width;
      case ProIntrinsicColumnWidth():
        // Estimate using the minimum width — we'll grow flex columns to fill.
        widths[i] = w.min;
        intrinsicTotal += w.min;
      case ProFlexColumnWidth():
        totalFlex += w.flex;
    }
  }

  final reserved = fixedTotal + intrinsicTotal;
  final remaining = (availableWidth - reserved).clamp(0.0, double.infinity);

  if (totalFlex > 0) {
    final perFlex = remaining / totalFlex;
    for (var i = 0; i < columns.length; i++) {
      final w = columns[i].width;
      if (w is ProFlexColumnWidth) {
        widths[i] = (w.flex * perFlex).clamp(64.0, double.infinity);
      }
    }
  } else if (remaining > 0) {
    // No flex columns: distribute leftover across intrinsic columns up to
    // their max, then leftover stays unused so the table is left-aligned.
    final intrinsicCols = <int>[
      for (var i = 0; i < columns.length; i++)
        if (columns[i].width is ProIntrinsicColumnWidth) i,
    ];
    if (intrinsicCols.isNotEmpty) {
      final share = remaining / intrinsicCols.length;
      for (final i in intrinsicCols) {
        final w = columns[i].width as ProIntrinsicColumnWidth;
        widths[i] = (widths[i] + share).clamp(w.min, w.max);
      }
    }
  }

  final total = widths.fold<double>(0, (a, b) => a + b);
  return ColumnLayout(widths, total);
}
