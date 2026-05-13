/// Row selection mode for [ProTable].
enum ProSelectionMode {
  /// No selection UI is shown.
  none,

  /// At most one row can be selected at a time.
  single,

  /// Any number of rows can be selected. A header checkbox toggles all rows
  /// on the current page.
  multi,
}
