/// Pagination state for [ProTable].
class ProPagination {
  const ProPagination({
    this.page = 1,
    this.pageSize = 10,
    this.pageSizeOptions = const [10, 25, 50, 100],
    this.showPageSizeSelector = true,
    this.showJumpToPage = true,
    this.maxVisiblePageButtons = 7,
  });

  /// 1-based current page.
  final int page;

  /// Rows per page.
  final int pageSize;

  /// Options to choose from in the page size dropdown.
  final List<int> pageSizeOptions;

  /// Show the page size dropdown.
  final bool showPageSizeSelector;

  /// Show the input that lets users jump to a specific page.
  final bool showJumpToPage;

  /// Maximum number of page-number buttons to show inline. The rest collapse
  /// into a `…` ellipsis (React-style).
  final int maxVisiblePageButtons;

  ProPagination copyWith({
    int? page,
    int? pageSize,
    List<int>? pageSizeOptions,
    bool? showPageSizeSelector,
    bool? showJumpToPage,
    int? maxVisiblePageButtons,
  }) {
    return ProPagination(
      page: page ?? this.page,
      pageSize: pageSize ?? this.pageSize,
      pageSizeOptions: pageSizeOptions ?? this.pageSizeOptions,
      showPageSizeSelector: showPageSizeSelector ?? this.showPageSizeSelector,
      showJumpToPage: showJumpToPage ?? this.showJumpToPage,
      maxVisiblePageButtons:
          maxVisiblePageButtons ?? this.maxVisiblePageButtons,
    );
  }

  int totalPages(int totalRows) =>
      pageSize <= 0 ? 1 : (totalRows / pageSize).ceil().clamp(1, 1 << 31);
}
