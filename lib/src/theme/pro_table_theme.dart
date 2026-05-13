import 'package:flutter/material.dart';

import '../models/pro_density.dart';

/// Visual theme for [ProTable]. Pass an instance to [ProTable.theme] or rely
/// on [ProTableTheme.fromContext] which derives sensible defaults from the
/// surrounding [ThemeData].
class ProTableTheme {
  const ProTableTheme({
    required this.background,
    required this.headerBackground,
    required this.headerTextStyle,
    required this.rowTextStyle,
    required this.borderColor,
    required this.dividerColor,
    required this.stripedRowColor,
    required this.hoverColor,
    required this.selectedRowColor,
    required this.expandedRowBackground,
    required this.cellPadding,
    required this.headerPadding,
    required this.rowHeight,
    required this.headerHeight,
    required this.borderRadius,
    required this.elevation,
    required this.titleTextStyle,
    required this.subtitleTextStyle,
    required this.iconColor,
    required this.primaryColor,
    required this.onPrimaryColor,
    required this.emptyStateTextStyle,
    required this.showVerticalDividers,
    required this.showHorizontalDividers,
    required this.striped,
  });

  final Color background;
  final Color headerBackground;
  final TextStyle headerTextStyle;
  final TextStyle rowTextStyle;
  final Color borderColor;
  final Color dividerColor;
  final Color stripedRowColor;
  final Color hoverColor;
  final Color selectedRowColor;
  final Color expandedRowBackground;
  final EdgeInsetsGeometry cellPadding;
  final EdgeInsetsGeometry headerPadding;
  final double rowHeight;
  final double headerHeight;
  final BorderRadius borderRadius;
  final double elevation;
  final TextStyle titleTextStyle;
  final TextStyle subtitleTextStyle;
  final Color iconColor;
  final Color primaryColor;
  final Color onPrimaryColor;
  final TextStyle emptyStateTextStyle;
  final bool showVerticalDividers;
  final bool showHorizontalDividers;
  final bool striped;

  factory ProTableTheme.fromContext(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    return ProTableTheme(
      background: cs.surface,
      headerBackground:
          isDark ? cs.surfaceContainerHigh : cs.surfaceContainerLow,
      headerTextStyle: theme.textTheme.labelLarge!.copyWith(
        fontWeight: FontWeight.w600,
        color: cs.onSurface,
      ),
      rowTextStyle: theme.textTheme.bodyMedium!.copyWith(color: cs.onSurface),
      borderColor: cs.outlineVariant,
      dividerColor: cs.outlineVariant.withValues(alpha: 0.6),
      stripedRowColor: cs.surfaceContainerLowest,
      hoverColor: cs.primary.withValues(alpha: 0.06),
      selectedRowColor: cs.primary.withValues(alpha: 0.12),
      expandedRowBackground: cs.surfaceContainerLowest,
      cellPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      headerPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      rowHeight: 52,
      headerHeight: 52,
      borderRadius: BorderRadius.circular(12),
      elevation: 0,
      titleTextStyle: theme.textTheme.titleLarge!.copyWith(
        fontWeight: FontWeight.w600,
      ),
      subtitleTextStyle: theme.textTheme.bodySmall!.copyWith(
        color: cs.onSurfaceVariant,
      ),
      iconColor: cs.onSurfaceVariant,
      primaryColor: cs.primary,
      onPrimaryColor: cs.onPrimary,
      emptyStateTextStyle:
          theme.textTheme.bodyLarge!.copyWith(color: cs.onSurfaceVariant),
      showVerticalDividers: false,
      showHorizontalDividers: true,
      striped: true,
    );
  }

  /// Returns a copy of this theme scaled to a particular [density]. Affects
  /// `rowHeight`, `headerHeight`, `cellPadding` and `headerPadding`.
  ProTableTheme applyDensity(ProTableDensity density) {
    switch (density) {
      case ProTableDensity.compact:
        return copyWith(
          rowHeight: 36,
          headerHeight: 40,
          cellPadding:
              const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          headerPadding:
              const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        );
      case ProTableDensity.standard:
        return copyWith(
          rowHeight: 52,
          headerHeight: 52,
          cellPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          headerPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        );
      case ProTableDensity.comfortable:
        return copyWith(
          rowHeight: 64,
          headerHeight: 60,
          cellPadding:
              const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          headerPadding:
              const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        );
    }
  }

  ProTableTheme copyWith({
    Color? background,
    Color? headerBackground,
    TextStyle? headerTextStyle,
    TextStyle? rowTextStyle,
    Color? borderColor,
    Color? dividerColor,
    Color? stripedRowColor,
    Color? hoverColor,
    Color? selectedRowColor,
    Color? expandedRowBackground,
    EdgeInsetsGeometry? cellPadding,
    EdgeInsetsGeometry? headerPadding,
    double? rowHeight,
    double? headerHeight,
    BorderRadius? borderRadius,
    double? elevation,
    TextStyle? titleTextStyle,
    TextStyle? subtitleTextStyle,
    Color? iconColor,
    Color? primaryColor,
    Color? onPrimaryColor,
    TextStyle? emptyStateTextStyle,
    bool? showVerticalDividers,
    bool? showHorizontalDividers,
    bool? striped,
  }) {
    return ProTableTheme(
      background: background ?? this.background,
      headerBackground: headerBackground ?? this.headerBackground,
      headerTextStyle: headerTextStyle ?? this.headerTextStyle,
      rowTextStyle: rowTextStyle ?? this.rowTextStyle,
      borderColor: borderColor ?? this.borderColor,
      dividerColor: dividerColor ?? this.dividerColor,
      stripedRowColor: stripedRowColor ?? this.stripedRowColor,
      hoverColor: hoverColor ?? this.hoverColor,
      selectedRowColor: selectedRowColor ?? this.selectedRowColor,
      expandedRowBackground:
          expandedRowBackground ?? this.expandedRowBackground,
      cellPadding: cellPadding ?? this.cellPadding,
      headerPadding: headerPadding ?? this.headerPadding,
      rowHeight: rowHeight ?? this.rowHeight,
      headerHeight: headerHeight ?? this.headerHeight,
      borderRadius: borderRadius ?? this.borderRadius,
      elevation: elevation ?? this.elevation,
      titleTextStyle: titleTextStyle ?? this.titleTextStyle,
      subtitleTextStyle: subtitleTextStyle ?? this.subtitleTextStyle,
      iconColor: iconColor ?? this.iconColor,
      primaryColor: primaryColor ?? this.primaryColor,
      onPrimaryColor: onPrimaryColor ?? this.onPrimaryColor,
      emptyStateTextStyle: emptyStateTextStyle ?? this.emptyStateTextStyle,
      showVerticalDividers:
          showVerticalDividers ?? this.showVerticalDividers,
      showHorizontalDividers:
          showHorizontalDividers ?? this.showHorizontalDividers,
      striped: striped ?? this.striped,
    );
  }
}
