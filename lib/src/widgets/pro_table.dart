import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../models/pro_cell.dart';
import '../models/pro_column.dart';
import '../models/pro_density.dart';
import '../models/pro_loading.dart';
import '../models/pro_pagination.dart';
import '../models/pro_selection.dart';
import '../models/pro_sort.dart';
import '../theme/pro_table_theme.dart';
import '../utils/column_layout.dart';
import 'pagination_bar.dart';
import 'toolbar.dart';

/// A fully-featured, responsive data table for Flutter.
///
/// `T` is the row type — any object you like. Pass it [columns] that describe
/// how to read values from a row, then [rows] is the dataset. Built-in
/// pagination, sorting, search, selection, expandable rows, frozen columns
/// and cell merging are all controlled through optional parameters.
class ProTable<T> extends StatefulWidget {
  const ProTable({
    super.key,
    required this.rows,
    required this.columns,
    this.title,
    this.subtitle,
    this.actions,
    this.theme,
    this.pagination = const ProPagination(),
    this.enablePagination = true,
    this.enableSearch = true,
    this.searchHint,
    this.searchPredicate,
    this.initialSort,
    this.onSortChanged,
    this.selectionMode = ProSelectionMode.none,
    this.initialSelection = const {},
    this.onSelectionChanged,
    this.rowKey,
    this.expandedRowBuilder,
    this.initiallyExpanded = const {},
    this.onRowExpansionChanged,
    this.onRowTap,
    this.onRowDoubleTap,
    this.onRowLongPress,
    this.cellSpans = const [],
    this.rowStyleResolver,
    this.loading = false,
    this.emptyStateBuilder,
    this.loadingBuilder,
    this.minWidth,
    this.maxHeight,
    this.shrinkWrap = false,
    this.semanticLabel,
    this.autoSizeRows = false,
    this.enableColumnReorder = false,
    this.onColumnReorder,
    this.oddRowColor,
    this.evenRowColor,
    this.density = ProTableDensity.standard,
    this.showRowNumbers = false,
    this.rowNumberHeader = '#',
    this.showFooter = false,
    this.footerBuilder,
    this.bulkActionsBuilder,
    this.bulkActionsLabel,
    this.enableColumnResize = false,
    this.enableColumnVisibilityToggle = false,
    this.mobileBreakpoint,
    this.mobileCardBuilder,
    this.loadingStyle = ProLoadingStyle.spinner,
    this.skeletonRowCount = 6,
  });

  /// The data set. Sorting/searching/pagination are applied on top of this
  /// list — the original order is preserved.
  final List<T> rows;

  /// Column definitions in display order.
  final List<ProColumn<T>> columns;

  /// Optional table title rendered in the toolbar.
  final String? title;

  /// Optional subtitle rendered under the title.
  final String? subtitle;

  /// Trailing toolbar actions (buttons, dropdowns, etc).
  final List<Widget>? actions;

  /// Visual theme. When null, derived from the surrounding [Theme].
  final ProTableTheme? theme;

  /// Pagination configuration. Set [enablePagination] to false to disable.
  final ProPagination pagination;

  /// Whether to render the pagination footer.
  final bool enablePagination;

  /// Whether to render the toolbar search input.
  final bool enableSearch;

  final String? searchHint;

  /// Custom search predicate. When null, the default checks each
  /// `ProColumn.searchable` column's stringified value with `contains`.
  final bool Function(T row, String query)? searchPredicate;

  /// Initial sort applied on first build.
  final ProSort? initialSort;

  /// Called when the user clicks a sortable column header.
  final ValueChanged<ProSort?>? onSortChanged;

  /// Whether rows can be selected. Single shows a radio-like behaviour, multi
  /// renders a checkbox column with select-all in the header.
  final ProSelectionMode selectionMode;

  /// Initially-selected row keys.
  final Set<Object> initialSelection;

  /// Called whenever the selection changes.
  final ValueChanged<Set<Object>>? onSelectionChanged;

  /// Returns a stable identity for a row. Defaults to [identityHashCode].
  /// Used for selection and expansion state across sort/filter changes.
  final Object Function(T row)? rowKey;

  /// Renders the expanded panel for a row. When provided, columns marked
  /// `expandable: true` will show an expand toggle.
  final Widget Function(BuildContext context, T row)? expandedRowBuilder;

  /// Initially-expanded row keys.
  final Set<Object> initiallyExpanded;

  /// Called whenever a row's expansion changes.
  final void Function(Object rowKey, bool expanded)? onRowExpansionChanged;

  /// Tap on a row.
  final void Function(T row, int index)? onRowTap;

  /// Double-tap on a row.
  final void Function(T row, int index)? onRowDoubleTap;

  /// Long-press on a row.
  final void Function(T row, int index)? onRowLongPress;

  /// Merged cells (rowspan / colspan). See [ProCellSpan].
  final List<ProCellSpan> cellSpans;

  /// Per-row style override (background color, text style, etc).
  final ProCellStyle Function(T row, int rowIndex)? rowStyleResolver;

  /// Show a centered loading indicator instead of rows.
  final bool loading;

  /// Custom empty-state widget.
  final Widget Function(BuildContext context)? emptyStateBuilder;

  /// Custom loading widget.
  final Widget Function(BuildContext context)? loadingBuilder;

  /// Forces a minimum total width. When the available width is smaller, the
  /// table scrolls horizontally.
  final double? minWidth;

  /// Cap on the table height. When null, the table sizes to its content if
  /// [shrinkWrap] is true, otherwise it fills its parent.
  final double? maxHeight;

  /// Whether the body sizes itself to its content.
  final bool shrinkWrap;

  final String? semanticLabel;

  /// When true, rows grow to fit their cell content (multi-line text, taller
  /// widgets) instead of being clipped to `theme.rowHeight`.
  final bool autoSizeRows;

  /// Allow drag-and-drop reordering of non-pinned columns. The user drags a
  /// header cell onto another header to swap their positions.
  final bool enableColumnReorder;

  /// Called whenever the user reorders columns. Provides the full ordered
  /// list of column ids — persist this to disk if you want the order to
  /// survive across sessions.
  final ValueChanged<List<String>>? onColumnReorder;

  /// Background color for odd-indexed rows (0-based — first row is even).
  /// When null, falls back to `theme.stripedRowColor` if `theme.striped` is
  /// true.
  final Color? oddRowColor;

  /// Background color for even-indexed rows (the first row, third, …).
  final Color? evenRowColor;

  /// Vertical density (compact / standard / comfortable). Applied to the
  /// theme via `theme.applyDensity(density)`.
  final ProTableDensity density;

  /// When true, prepend a leading "#" column showing 1-based row numbers
  /// across the current page.
  final bool showRowNumbers;

  /// Header label of the row-number column. Defaults to "#".
  final String rowNumberHeader;

  /// When true, render a footer row beneath the body. Each column can
  /// supply a `ProColumn.footerBuilder` to render its footer cell. When all
  /// columns return null and [footerBuilder] is also null, the footer is
  /// hidden even with `showFooter: true`.
  final bool showFooter;

  /// Custom builder for the entire footer row. When supplied, this overrides
  /// per-column footer builders.
  final Widget Function(BuildContext context, List<T> rows)? footerBuilder;

  /// When non-null and a row selection exists, a sticky action bar slides in
  /// at the bottom of the table (Zoho/Odoo style). The builder receives the
  /// selected row keys; return action buttons / widgets.
  final List<Widget> Function(BuildContext context, Set<Object> selectedKeys)?
      bulkActionsBuilder;

  /// Optional left-hand label for the bulk actions bar (e.g. "3 selected").
  /// When null, defaults to "{n} selected".
  final String Function(int count)? bulkActionsLabel;

  /// Whether the user can drag the right edge of a column header to resize.
  final bool enableColumnResize;

  /// Adds a "Columns" button to the toolbar that opens a popup letting the
  /// user toggle column visibility (per-column `hideable: false` opts out).
  final bool enableColumnVisibilityToggle;

  /// When the table renders below this width, switch to a card list view.
  /// Pair with [mobileCardBuilder]. When null, the table never switches
  /// modes.
  final double? mobileBreakpoint;

  /// How to render each row as a card on mobile. When null, a default
  /// implementation is used that lists each column's title + value in a
  /// vertical layout.
  final Widget Function(BuildContext context, T row, int index)?
      mobileCardBuilder;

  /// How the loading state is presented (spinner or skeleton rows).
  final ProLoadingStyle loadingStyle;

  /// Number of skeleton rows to render while loading.
  final int skeletonRowCount;

  @override
  State<ProTable<T>> createState() => _ProTableState<T>();
}

class _ProTableState<T> extends State<ProTable<T>> {
  late ProSort? _sort = widget.initialSort;
  late ProPagination _pagination = widget.pagination;
  late final Set<Object> _selected = {...widget.initialSelection};
  late final Set<Object> _expanded = {...widget.initiallyExpanded};
  String _search = '';
  List<String>? _columnOrder; // ids of non-pinned columns in user-chosen order
  final Set<String> _hiddenColumns = {};
  final Map<String, double> _resizedWidths = {};

  final ScrollController _vCtrl = ScrollController();
  final ScrollController _bodyHCtrl = ScrollController();
  final ScrollController _headerHCtrl = ScrollController();
  bool _syncing = false;

  @override
  void initState() {
    super.initState();
    _bodyHCtrl.addListener(_onBodyScroll);
    _headerHCtrl.addListener(_onHeaderScroll);
  }

  @override
  void didUpdateWidget(covariant ProTable<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.pagination.pageSize != widget.pagination.pageSize ||
        oldWidget.pagination.page != widget.pagination.page) {
      _pagination = widget.pagination;
    }
  }

  @override
  void dispose() {
    _bodyHCtrl.dispose();
    _headerHCtrl.dispose();
    _vCtrl.dispose();
    super.dispose();
  }

  void _onBodyScroll() {
    if (_syncing) return;
    if (!_headerHCtrl.hasClients) return;
    if (_headerHCtrl.offset == _bodyHCtrl.offset) return;
    _syncing = true;
    _headerHCtrl.jumpTo(_bodyHCtrl.offset);
    _syncing = false;
  }

  void _onHeaderScroll() {
    if (_syncing) return;
    if (!_bodyHCtrl.hasClients) return;
    if (_bodyHCtrl.offset == _headerHCtrl.offset) return;
    _syncing = true;
    _bodyHCtrl.jumpTo(_headerHCtrl.offset);
    _syncing = false;
  }

  Object _keyOf(T row) =>
      widget.rowKey?.call(row) ?? identityHashCode(row);

  /// Returns the visible columns with the user's drag-reorder applied to
  /// non-pinned columns. Pinned (left/right) columns keep their declared
  /// order — only the middle section is reorderable.
  List<ProColumn<T>> _orderedColumns() {
    final visible = widget.columns
        .where((c) => c.visible && !_hiddenColumns.contains(c.id))
        .toList();
    final order = _columnOrder;
    if (order == null) return visible;
    final left = visible.where((c) => c.pin == ColumnPin.left).toList();
    final right = visible.where((c) => c.pin == ColumnPin.right).toList();
    final middleIds = visible
        .where((c) => c.pin == ColumnPin.none)
        .map((c) => c.id)
        .toSet();
    final reordered = <ProColumn<T>>[];
    for (final id in order) {
      if (!middleIds.contains(id)) continue;
      reordered.add(visible.firstWhere((c) => c.id == id));
    }
    // Append any middle column not yet in the order (e.g. newly added).
    for (final c in visible) {
      if (c.pin != ColumnPin.none) continue;
      if (!order.contains(c.id)) reordered.add(c);
    }
    return [...left, ...reordered, ...right];
  }

  Widget _buildColumnVisibilityButton(ProTableTheme theme) {
    return PopupMenuButton<String>(
      tooltip: 'Show / hide columns',
      icon: Icon(Icons.view_column_outlined, color: theme.iconColor),
      itemBuilder: (ctx) {
        return [
          for (final col in widget.columns.where((c) => c.hideable))
            CheckedPopupMenuItem<String>(
              value: col.id,
              checked: !_hiddenColumns.contains(col.id),
              child: Text(col.title),
            ),
        ];
      },
      onSelected: (id) {
        setState(() {
          if (_hiddenColumns.contains(id)) {
            _hiddenColumns.remove(id);
          } else {
            _hiddenColumns.add(id);
          }
        });
      },
    );
  }

  void _reorderColumn(String fromId, String ontoId) {
    final visible = widget.columns.where((c) => c.visible).toList();
    final middleIds = visible
        .where((c) => c.pin == ColumnPin.none)
        .map((c) => c.id)
        .toList();
    final order = List<String>.of(_columnOrder ?? middleIds);
    final from = order.indexOf(fromId);
    final onto = order.indexOf(ontoId);
    if (from < 0 || onto < 0 || from == onto) return;
    final id = order.removeAt(from);
    order.insert(onto, id);
    setState(() => _columnOrder = order);
    widget.onColumnReorder?.call(order);
  }

  // ───── data pipeline ─────

  List<T> _processed(ProTableTheme theme) {
    Iterable<T> result = widget.rows;

    // Search
    if (_search.isNotEmpty) {
      final q = _search.toLowerCase();
      result = result.where((row) {
        if (widget.searchPredicate != null) {
          return widget.searchPredicate!(row, _search);
        }
        for (final col in widget.columns) {
          if (!col.searchable || col.value == null) continue;
          final v = col.value!(row);
          if (v == null) continue;
          if (v.toString().toLowerCase().contains(q)) return true;
        }
        return false;
      });
    }

    var list = result.toList();

    // Sort
    final sort = _sort;
    if (sort != null) {
      final col =
          widget.columns.firstWhere((c) => c.id == sort.columnId, orElse: () {
        return widget.columns.first;
      });
      list.sort((a, b) {
        int cmp;
        if (col.compare != null) {
          cmp = col.compare!(a, b);
        } else if (col.value != null) {
          final av = col.value!(a);
          final bv = col.value!(b);
          cmp = _defaultCompare(av, bv);
        } else {
          cmp = 0;
        }
        return sort.direction == ProSortDirection.ascending ? cmp : -cmp;
      });
    }

    return list;
  }

  int _defaultCompare(Object? a, Object? b) {
    if (a == null && b == null) return 0;
    if (a == null) return -1;
    if (b == null) return 1;
    if (a is Comparable && b is Comparable && a.runtimeType == b.runtimeType) {
      return a.compareTo(b);
    }
    return a.toString().compareTo(b.toString());
  }

  // ───── header sort interaction ─────

  void _onHeaderTap(ProColumn<T> column) {
    if (!column.sortable) return;
    setState(() {
      if (_sort?.columnId != column.id) {
        _sort = ProSort(
          columnId: column.id,
          direction: ProSortDirection.ascending,
        );
      } else if (_sort!.direction == ProSortDirection.ascending) {
        _sort = _sort!.flip();
      } else {
        _sort = null; // third click clears
      }
    });
    widget.onSortChanged?.call(_sort);
  }

  // ───── selection ─────

  void _toggleRow(T row) {
    final key = _keyOf(row);
    setState(() {
      if (widget.selectionMode == ProSelectionMode.single) {
        if (_selected.contains(key)) {
          _selected.clear();
        } else {
          _selected
            ..clear()
            ..add(key);
        }
      } else {
        if (_selected.contains(key)) {
          _selected.remove(key);
        } else {
          _selected.add(key);
        }
      }
    });
    widget.onSelectionChanged?.call({..._selected});
  }

  void _toggleSelectAllOnPage(List<T> pageRows) {
    final keys = pageRows.map(_keyOf).toSet();
    final allSelected = keys.every(_selected.contains);
    setState(() {
      if (allSelected) {
        _selected.removeAll(keys);
      } else {
        _selected.addAll(keys);
      }
    });
    widget.onSelectionChanged?.call({..._selected});
  }

  void _toggleExpand(T row) {
    final key = _keyOf(row);
    setState(() {
      if (_expanded.contains(key)) {
        _expanded.remove(key);
      } else {
        _expanded.add(key);
      }
    });
    widget.onRowExpansionChanged?.call(key, _expanded.contains(key));
  }

  // ───── build ─────

  @override
  Widget build(BuildContext context) {
    final baseTheme = widget.theme ?? ProTableTheme.fromContext(context);
    final theme = baseTheme.applyDensity(widget.density);
    final processed = _processed(theme);

    final pageRows = widget.enablePagination
        ? _paginate(processed, _pagination)
        : processed;

    final visibleColumns = _orderedColumns();

    final container = Material(
      color: theme.background,
      elevation: theme.elevation,
      borderRadius: theme.borderRadius,
      clipBehavior: Clip.antiAlias,
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: theme.borderRadius,
          border: Border.all(color: theme.borderColor),
        ),
        child: Column(
          mainAxisSize: widget.shrinkWrap ? MainAxisSize.min : MainAxisSize.max,
          children: [
            ProTableToolbar(
              theme: theme,
              title: widget.title,
              subtitle: widget.subtitle,
              actions: [
                if (widget.enableColumnVisibilityToggle)
                  _buildColumnVisibilityButton(theme),
                ...?widget.actions,
              ],
              searchEnabled: widget.enableSearch,
              searchHint: widget.searchHint,
              onSearchChanged: widget.enableSearch
                  ? (v) => setState(() {
                        _search = v;
                        _pagination = _pagination.copyWith(page: 1);
                      })
                  : null,
              initialSearchQuery: _search,
            ),
            if (widget.title != null ||
                widget.subtitle != null ||
                widget.enableSearch ||
                widget.enableColumnVisibilityToggle ||
                (widget.actions?.isNotEmpty ?? false))
              Divider(height: 1, color: theme.borderColor),
            if (widget.shrinkWrap)
              _TableBody<T>(
                state: this,
                theme: theme,
                visibleColumns: visibleColumns,
                pageRows: pageRows,
                processedRows: processed,
                shrinkWrap: true,
              )
            else
              Expanded(
                child: _TableBody<T>(
                  state: this,
                  theme: theme,
                  visibleColumns: visibleColumns,
                  pageRows: pageRows,
                  processedRows: processed,
                  shrinkWrap: false,
                ),
              ),
            if (widget.bulkActionsBuilder != null && _selected.isNotEmpty)
              _BulkActionsBar(
                theme: theme,
                label: widget.bulkActionsLabel?.call(_selected.length) ??
                    '${_selected.length} selected',
                actions: widget.bulkActionsBuilder!(context, {..._selected}),
                onClear: () {
                  setState(_selected.clear);
                  widget.onSelectionChanged?.call({});
                },
              ),
            if (widget.enablePagination) ...[
              Divider(height: 1, color: theme.borderColor),
              ProPaginationBar(
                pagination: _pagination,
                totalRows: processed.length,
                theme: theme,
                onChanged: (p) => setState(() => _pagination = p),
              ),
            ],
          ],
        ),
      ),
    );

    final sized = widget.maxHeight != null
        ? ConstrainedBox(
            constraints: BoxConstraints(maxHeight: widget.maxHeight!),
            child: container,
          )
        : container;

    return Semantics(
      label: widget.semanticLabel ?? widget.title,
      container: true,
      child: sized,
    );
  }

  List<T> _paginate(List<T> source, ProPagination p) {
    final start = (p.page - 1) * p.pageSize;
    if (start >= source.length) return const [];
    final end = (start + p.pageSize).clamp(0, source.length);
    return source.sublist(start, end);
  }
}

/// Internal body widget — kept private and built by [_ProTableState].
class _TableBody<T> extends StatelessWidget {
  const _TableBody({
    required this.state,
    required this.theme,
    required this.visibleColumns,
    required this.pageRows,
    required this.processedRows,
    required this.shrinkWrap,
  });

  final _ProTableState<T> state;
  final ProTableTheme theme;
  final List<ProColumn<T>> visibleColumns;
  final List<T> pageRows;
  final List<T> processedRows;
  final bool shrinkWrap;

  @override
  Widget build(BuildContext context) {
    if (state.widget.loading) {
      if (state.widget.loadingBuilder != null) {
        return state.widget.loadingBuilder!(context);
      }
      if (state.widget.loadingStyle == ProLoadingStyle.skeleton) {
        return LayoutBuilder(builder: (context, constraints) {
          return _buildSkeleton(context, constraints.maxWidth);
        });
      }
      return const Center(
          child: Padding(
        padding: EdgeInsets.all(48),
        child: CircularProgressIndicator(),
      ));
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        // Mobile card view fallback.
        final mb = state.widget.mobileBreakpoint;
        if (mb != null && constraints.maxWidth < mb) {
          return _buildCardList(context);
        }

        // Inject a synthetic "#" row-number column at the start (pinned left)
        // when showRowNumbers is true.
        final cols = state.widget.showRowNumbers
            ? <ProColumn<T>>[_rowNumberColumn(theme), ...visibleColumns]
            : visibleColumns;

        // Reserved width for selection checkbox column.
        final hasSelection =
            state.widget.selectionMode != ProSelectionMode.none;
        final hasExpand =
            state.widget.expandedRowBuilder != null &&
                cols.any((c) => c.expandable);
        final extraLeading = (hasSelection ? 48.0 : 0.0);

        // Split columns by pin
        final left = cols.where((c) => c.pin == ColumnPin.left).toList();
        final middle = cols.where((c) => c.pin == ColumnPin.none).toList();
        final right = cols.where((c) => c.pin == ColumnPin.right).toList();

        // Compute width
        final available = constraints.maxWidth - extraLeading;
        final layout = resolveColumnWidths<T>(
          columns: cols,
          availableWidth: state.widget.minWidth != null
              ? state.widget.minWidth!.clamp(available, double.infinity)
              : available,
          headerTextStyle: theme.headerTextStyle,
          rowTextStyle: theme.rowTextStyle,
          cellPadding: theme.cellPadding,
        );

        // Map column → resolved width (apply user resize overrides).
        final widthMap = <String, double>{};
        for (var i = 0; i < cols.length; i++) {
          final col = cols[i];
          final resized = state._resizedWidths[col.id];
          widthMap[col.id] = resized ?? layout.widths[i];
        }

        double sumOf(List<ProColumn<T>> cs) =>
            cs.fold<double>(0, (a, c) => a + (widthMap[c.id] ?? 0));
        final leftWidth = sumOf(left);
        final middleWidth = sumOf(middle);
        final rightWidth = sumOf(right);

        // Header row
        final header = SizedBox(
          height: theme.headerHeight,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (hasSelection) _selectAllHeader(context, hasExpand),
              if (left.isNotEmpty)
                _staticHeaderSection(left, widthMap, leftWidth, hasExpand),
              if (middle.isNotEmpty)
                Expanded(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    controller: state._headerHCtrl,
                    physics: const ClampingScrollPhysics(),
                    child: _staticHeaderSection(
                        middle, widthMap, middleWidth, hasExpand),
                  ),
                ),
              if (right.isNotEmpty)
                _staticHeaderSection(right, widthMap, rightWidth, hasExpand),
            ],
          ),
        );

        // Body
        final bodyContent = pageRows.isEmpty
            ? _emptyState(context)
            : Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (hasSelection)
                    _selectionColumnBody(context, pageRows, hasExpand),
                  if (left.isNotEmpty)
                    _bodySection(context, left, widthMap, leftWidth, pageRows,
                        hasExpand: hasExpand,
                        renderExpandToggle:
                            !hasSelection && left.contains(cols.firstOrNull)),
                  if (middle.isNotEmpty)
                    Expanded(
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        controller: state._bodyHCtrl,
                        physics: const ClampingScrollPhysics(),
                        child: _bodySection(
                            context, middle, widthMap, middleWidth, pageRows,
                            hasExpand: hasExpand,
                            renderExpandToggle:
                                !hasSelection && left.isEmpty),
                      ),
                    ),
                  if (right.isNotEmpty)
                    _bodySection(
                        context, right, widthMap, rightWidth, pageRows,
                        hasExpand: hasExpand, renderExpandToggle: false),
                ],
              );

        Widget body;
        if (pageRows.isEmpty) {
          body = bodyContent;
        } else if (shrinkWrap) {
          body = bodyContent;
        } else {
          body = SingleChildScrollView(
            controller: state._vCtrl,
            child: bodyContent,
          );
        }

        // Optional footer row (totals / summaries).
        Widget? footer;
        if (state.widget.showFooter) {
          if (state.widget.footerBuilder != null) {
            footer = Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: theme.headerBackground,
                border: Border(top: BorderSide(color: theme.borderColor)),
              ),
              padding: theme.cellPadding,
              child: state.widget.footerBuilder!(context, processedRows),
            );
          } else if (cols.any((c) => c.footerBuilder != null)) {
            footer = _buildFooterRow(
              context,
              cols,
              widthMap,
              processedRows,
              hasSelection: hasSelection,
              left: left,
              middle: middle,
              right: right,
              middleWidth: middleWidth,
              leftWidth: leftWidth,
              rightWidth: rightWidth,
            );
          }
        }

        return Column(
          mainAxisSize: shrinkWrap ? MainAxisSize.min : MainAxisSize.max,
          children: [
            Container(
              decoration: BoxDecoration(
                color: theme.headerBackground,
                border: Border(
                  bottom: BorderSide(color: theme.borderColor),
                ),
              ),
              child: header,
            ),
            if (shrinkWrap) body else Expanded(child: body),
            if (footer != null) footer,
          ],
        );
      },
    );
  }

  // ───── synthetic row-number column ─────

  ProColumn<T> _rowNumberColumn(ProTableTheme theme) {
    return ProColumn<T>(
      id: '__rownum__',
      title: state.widget.rowNumberHeader,
      pin: ColumnPin.left,
      width: const ProColumnWidth.fixed(56),
      alignment: Alignment.center,
      headerAlignment: Alignment.center,
      sortable: false,
      hideable: false,
      draggable: false,
      cellBuilder: (ctx, row, index) {
        final p = state._pagination;
        final rowNum =
            (p.page - 1) * p.pageSize + index + 1;
        return Text(
          '$rowNum',
          style: theme.subtitleTextStyle,
        );
      },
    );
  }

  // ───── footer row ─────

  Widget _buildFooterRow(
    BuildContext context,
    List<ProColumn<T>> cols,
    Map<String, double> widthMap,
    List<T> rows, {
    required bool hasSelection,
    required List<ProColumn<T>> left,
    required List<ProColumn<T>> middle,
    required List<ProColumn<T>> right,
    required double leftWidth,
    required double middleWidth,
    required double rightWidth,
  }) {
    Widget footerCell(ProColumn<T> col) {
      final w = widthMap[col.id] ?? 120;
      final child = col.footerBuilder?.call(context, rows) ?? const SizedBox();
      return SizedBox(
        width: w,
        child: Padding(
          padding: theme.cellPadding,
          child: Align(alignment: col.alignment, child: child),
        ),
      );
    }

    return Container(
      decoration: BoxDecoration(
        color: theme.headerBackground,
        border: Border(top: BorderSide(color: theme.borderColor)),
      ),
      child: SizedBox(
        height: theme.headerHeight,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (hasSelection) const SizedBox(width: 48),
            if (left.isNotEmpty)
              SizedBox(
                width: leftWidth,
                child: Row(children: [for (final c in left) footerCell(c)]),
              ),
            if (middle.isNotEmpty)
              Expanded(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  // Same controller as body so footer stays aligned.
                  controller: state._headerHCtrl,
                  physics: const NeverScrollableScrollPhysics(),
                  child: SizedBox(
                    width: middleWidth,
                    child: Row(
                      children: [for (final c in middle) footerCell(c)],
                    ),
                  ),
                ),
              ),
            if (right.isNotEmpty)
              SizedBox(
                width: rightWidth,
                child: Row(children: [for (final c in right) footerCell(c)]),
              ),
          ],
        ),
      ),
    );
  }

  // ───── skeleton loading ─────

  Widget _buildSkeleton(BuildContext context, double width) {
    final n = state.widget.skeletonRowCount.clamp(1, 50);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (var i = 0; i < n; i++)
          Container(
            height: theme.rowHeight,
            padding: theme.cellPadding,
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(color: theme.dividerColor),
              ),
            ),
            child: Row(
              children: [
                _SkeletonShimmer(
                  color: theme.dividerColor,
                  width: 28,
                  height: 14,
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _SkeletonShimmer(
                    color: theme.dividerColor,
                    height: 14,
                  ),
                ),
                const SizedBox(width: 16),
                _SkeletonShimmer(
                  color: theme.dividerColor,
                  width: 80,
                  height: 14,
                ),
                const SizedBox(width: 16),
                _SkeletonShimmer(
                  color: theme.dividerColor,
                  width: 60,
                  height: 14,
                ),
              ],
            ),
          ),
      ],
    );
  }

  // ───── mobile card list ─────

  Widget _buildCardList(BuildContext context) {
    final builder = state.widget.mobileCardBuilder ?? _defaultMobileCard;
    if (pageRows.isEmpty) return _emptyState(context);
    final scroll = ListView.separated(
      shrinkWrap: shrinkWrap,
      controller: shrinkWrap ? null : state._vCtrl,
      physics: shrinkWrap ? const NeverScrollableScrollPhysics() : null,
      padding: const EdgeInsets.all(8),
      itemCount: pageRows.length,
      separatorBuilder: (_, __) => const SizedBox(height: 8),
      itemBuilder: (ctx, i) => builder(ctx, pageRows[i], i),
    );
    return scroll;
  }

  Widget _defaultMobileCard(BuildContext context, T row, int index) {
    final key = state._keyOf(row);
    final isSelected = state._selected.contains(key);
    return Card(
      elevation: 0,
      color: isSelected ? theme.selectedRowColor : theme.background,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: theme.borderColor),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: state.widget.onRowTap == null
            ? null
            : () => state.widget.onRowTap!(row, index),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              for (final col in visibleColumns)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: 110,
                        child: Text(
                          col.title,
                          style: theme.subtitleTextStyle,
                        ),
                      ),
                      Expanded(
                        child: col.cellBuilder != null
                            ? col.cellBuilder!(context, row, index)
                            : Text(
                                col.value?.call(row)?.toString() ?? '',
                                style: theme.rowTextStyle,
                              ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  // ───── header rendering ─────

  Widget _selectAllHeader(BuildContext context, bool hasExpand) {
    final isMulti = state.widget.selectionMode == ProSelectionMode.multi;
    final keys = pageRows.map(state._keyOf).toSet();
    final allSelected = keys.isNotEmpty &&
        keys.every((k) => state._selected.contains(k));
    final someSelected = keys.any((k) => state._selected.contains(k));

    return Container(
      width: 48,
      alignment: Alignment.center,
      child: isMulti
          ? Checkbox(
              value: allSelected
                  ? true
                  : (someSelected ? null : false),
              tristate: true,
              onChanged: (_) => state._toggleSelectAllOnPage(pageRows),
            )
          : const SizedBox.shrink(),
    );
  }

  Widget _staticHeaderSection(
    List<ProColumn<T>> cols,
    Map<String, double> widthMap,
    double sectionWidth,
    bool hasExpand,
  ) {
    return SizedBox(
      width: sectionWidth,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          for (final col in cols)
            _headerCell(col, widthMap[col.id] ?? 120),
        ],
      ),
    );
  }

  Widget _headerCell(ProColumn<T> col, double width) {
    final isSorted = state._sort?.columnId == col.id;
    final asc =
        isSorted && state._sort!.direction == ProSortDirection.ascending;

    final text = Builder(builder: (context) {
      if (col.headerBuilder != null) {
        return col.headerBuilder!(context);
      }
      return Align(
        alignment: col.effectiveHeaderAlignment,
        child: Text(
          col.title,
          style: theme.headerTextStyle.merge(col.headerStyle?.textStyle),
          overflow: TextOverflow.ellipsis,
        ),
      );
    });

    final inner = Container(
      padding: theme.headerPadding,
      decoration: theme.showVerticalDividers
          ? BoxDecoration(
              border: Border(
                right: BorderSide(color: theme.dividerColor),
              ),
            )
          : null,
      child: Row(
        mainAxisAlignment: _alignmentToMain(col.effectiveHeaderAlignment),
        children: [
          Flexible(child: text),
          if (col.sortable) ...[
            const SizedBox(width: 4),
            Icon(
              isSorted
                  ? (asc ? Icons.arrow_upward : Icons.arrow_downward)
                  : Icons.unfold_more,
              size: 16,
              color: isSorted ? theme.primaryColor : theme.iconColor,
            ),
          ],
        ],
      ),
    );

    final canResize = state.widget.enableColumnResize &&
        col.id != '__rownum__' &&
        col.pin == ColumnPin.none;

    final cell = SizedBox(
      width: width,
      child: canResize
          ? Stack(
              clipBehavior: Clip.none,
              children: [
                Positioned.fill(child: inner),
                Positioned(
                  top: 0,
                  bottom: 0,
                  right: 0,
                  width: 8,
                  child: MouseRegion(
                    cursor: SystemMouseCursors.resizeColumn,
                    child: GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onHorizontalDragUpdate: (d) {
                        final current =
                            state._resizedWidths[col.id] ?? width;
                        final next = (current + d.delta.dx).clamp(
                          col.minResizeWidth,
                          col.maxResizeWidth,
                        );
                        // ignore: invalid_use_of_protected_member
                        state.setState(() {
                          state._resizedWidths[col.id] = next;
                        });
                      },
                      child: Center(
                        child: Container(
                          width: 2,
                          color: theme.dividerColor,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            )
          : inner,
    );

    Widget result = cell;
    if (col.tooltip != null) {
      result = Tooltip(message: col.tooltip!, child: result);
    }
    if (col.sortable) {
      result = MouseRegion(
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () => state._onHeaderTap(col),
          child: result,
        ),
      );
    }

    final canDrag = state.widget.enableColumnReorder &&
        col.draggable &&
        col.pin == ColumnPin.none;

    if (canDrag) {
      final feedback = Material(
        elevation: 6,
        color: theme.headerBackground,
        borderRadius: BorderRadius.circular(8),
        child: SizedBox(
          width: width,
          height: theme.headerHeight,
          child: Padding(
            padding: theme.headerPadding,
            child: Align(
              alignment: col.effectiveHeaderAlignment,
              child: Text(col.title, style: theme.headerTextStyle),
            ),
          ),
        ),
      );

      result = DragTarget<String>(
        onWillAcceptWithDetails: (d) => d.data != col.id,
        onAcceptWithDetails: (d) => state._reorderColumn(d.data, col.id),
        builder: (ctx, candidate, rejected) {
          final highlighted = candidate.isNotEmpty;
          return LongPressDraggable<String>(
            data: col.id,
            delay: const Duration(milliseconds: 200),
            feedback: feedback,
            childWhenDragging: Opacity(opacity: 0.3, child: result),
            child: Container(
              decoration: highlighted
                  ? BoxDecoration(
                      color: theme.primaryColor.withValues(alpha: 0.1),
                      border: Border(
                        left: BorderSide(
                          color: theme.primaryColor,
                          width: 2,
                        ),
                      ),
                    )
                  : null,
              child: result,
            ),
          );
        },
      );
    }

    return result;
  }

  MainAxisAlignment _alignmentToMain(Alignment a) {
    if (a == Alignment.center ||
        a == Alignment.topCenter ||
        a == Alignment.bottomCenter) {
      return MainAxisAlignment.center;
    }
    if (a == Alignment.centerRight ||
        a == Alignment.topRight ||
        a == Alignment.bottomRight) {
      return MainAxisAlignment.end;
    }
    return MainAxisAlignment.start;
  }

  // ───── selection column body ─────

  Widget _selectionColumnBody(
      BuildContext context, List<T> rows, bool hasExpand) {
    return SizedBox(
      width: 48,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (var i = 0; i < rows.length; i++)
            SizedBox(
              height: theme.rowHeight,
              child: Center(
                child: state.widget.selectionMode == ProSelectionMode.multi
                    ? Checkbox(
                        value: state._selected.contains(state._keyOf(rows[i])),
                        onChanged: (_) => state._toggleRow(rows[i]),
                      )
                    : _SingleSelectRadio(
                        selected: state._selected
                            .contains(state._keyOf(rows[i])),
                        color: theme.primaryColor,
                        onTap: () => state._toggleRow(rows[i]),
                      ),
              ),
            ),
          // padding for expanded panels
          if (hasExpand)
            for (var i = 0; i < rows.length; i++)
              if (state._expanded.contains(state._keyOf(rows[i])))
                SizedBox(
                  height: 0,
                  child: const SizedBox.shrink(),
                ),
        ],
      ),
    );
  }

  // ───── body section ─────

  Widget _bodySection(
    BuildContext context,
    List<ProColumn<T>> cols,
    Map<String, double> widthMap,
    double sectionWidth,
    List<T> rows, {
    required bool hasExpand,
    required bool renderExpandToggle,
  }) {
    // For pinned sections (sectionWidth small), we still use the same rendering
    // pipeline. Cell merging is only applied within the middle section.
    final isMiddle = sectionWidth > 0 &&
        cols.isNotEmpty &&
        cols.first.pin == ColumnPin.none;

    final rowsWidget = Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (var i = 0; i < rows.length; i++) ..._buildRow(
          context,
          rows[i],
          i,
          cols,
          widthMap,
          sectionWidth,
          renderExpandToggle: renderExpandToggle,
          allowMerging: isMiddle,
        ),
      ],
    );

    if (!isMiddle) return SizedBox(width: sectionWidth, child: rowsWidget);

    // Apply cell-span overlays in the middle section only.
    final spans = state.widget.cellSpans;
    if (spans.isEmpty) return SizedBox(width: sectionWidth, child: rowsWidget);

    return SizedBox(
      width: sectionWidth,
      child: Stack(
        children: [
          rowsWidget,
          for (final span in spans) _spanOverlay(context, span, cols, widthMap),
        ],
      ),
    );
  }

  // Build the row + (optional) expanded panel as a list of slivers.
  List<Widget> _buildRow(
    BuildContext context,
    T row,
    int pageRowIndex,
    List<ProColumn<T>> cols,
    Map<String, double> widthMap,
    double sectionWidth, {
    required bool renderExpandToggle,
    required bool allowMerging,
  }) {
    final key = state._keyOf(row);
    final isSelected = state._selected.contains(key);
    final isExpanded = state._expanded.contains(key);
    final rowStyle = state.widget.rowStyleResolver?.call(row, pageRowIndex);

    final spanCovered = <int>{};
    if (allowMerging) {
      // Build set of column-indices in this row that are covered by spans.
      for (final span in state.widget.cellSpans) {
        if (span.rowIndex > pageRowIndex) continue;
        if (span.rowIndex + span.rowSpan <= pageRowIndex) continue;
        final startIdx = cols.indexWhere((c) => c.id == span.columnId);
        if (startIdx < 0) continue;
        final isOriginRow = span.rowIndex == pageRowIndex;
        for (var j = 0; j < span.columnSpan; j++) {
          if (!isOriginRow || j > 0) {
            spanCovered.add(startIdx + j);
          }
        }
      }
    }

    // Resolve the row background. Priority:
    //   1. Selected → theme.selectedRowColor
    //   2. rowStyleResolver background
    //   3. oddRowColor / evenRowColor (explicit per-table)
    //   4. theme.stripedRowColor when theme.striped is true (legacy)
    Color? altColor;
    if (pageRowIndex.isOdd) {
      altColor = state.widget.oddRowColor ??
          (theme.striped ? theme.stripedRowColor : null);
    } else {
      altColor = state.widget.evenRowColor;
    }
    final rowBg = isSelected
        ? theme.selectedRowColor
        : (rowStyle?.backgroundColor ?? altColor);

    final rowChildren = <Widget>[];
    for (var i = 0; i < cols.length; i++) {
      final col = cols[i];
      final w = widthMap[col.id] ?? 120;
      if (spanCovered.contains(i)) {
        rowChildren.add(SizedBox(width: w));
        continue;
      }
      rowChildren.add(_dataCell(
        context,
        col,
        row,
        pageRowIndex,
        w,
        renderExpandToggle: renderExpandToggle && i == 0 && col.expandable,
        isExpanded: isExpanded,
      ));
    }

    final rowWidget = MouseRegion(
      cursor: state.widget.onRowTap != null
          ? SystemMouseCursors.click
          : SystemMouseCursors.basic,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () =>
            state.widget.onRowTap?.call(row, pageRowIndex),
        onDoubleTap: state.widget.onRowDoubleTap == null
            ? null
            : () => state.widget.onRowDoubleTap!(row, pageRowIndex),
        onLongPress: state.widget.onRowLongPress == null
            ? null
            : () => state.widget.onRowLongPress!(row, pageRowIndex),
        child: _HoverRow(
          hoverColor: theme.hoverColor,
          baseColor: rowBg,
          child: Container(
            constraints: state.widget.autoSizeRows
                ? const BoxConstraints()
                : BoxConstraints(minHeight: theme.rowHeight),
            decoration: BoxDecoration(
              border: theme.showHorizontalDividers
                  ? Border(
                      bottom: BorderSide(color: theme.dividerColor),
                    )
                  : null,
            ),
            child: IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: rowChildren,
              ),
            ),
          ),
        ),
      ),
    );

    final widgets = <Widget>[rowWidget];

    if (isExpanded && state.widget.expandedRowBuilder != null) {
      widgets.add(Container(
        width: sectionWidth,
        decoration: BoxDecoration(
          color: theme.expandedRowBackground,
          border: Border(bottom: BorderSide(color: theme.dividerColor)),
        ),
        padding: const EdgeInsets.all(16),
        child: state.widget.expandedRowBuilder!(context, row),
      ));
    }
    return widgets;
  }

  Widget _dataCell(
    BuildContext context,
    ProColumn<T> col,
    T row,
    int pageRowIndex,
    double width, {
    required bool renderExpandToggle,
    required bool isExpanded,
  }) {
    final cellStyle = col.cellStyleResolver?.call(row, pageRowIndex);

    Widget content;
    if (col.cellBuilder != null) {
      content = col.cellBuilder!(context, row, pageRowIndex);
    } else {
      final raw = col.value?.call(row);
      final autoSize = state.widget.autoSizeRows;
      content = Text(
        raw?.toString() ?? '',
        style: theme.rowTextStyle.merge(cellStyle?.textStyle),
        maxLines: col.maxLines ?? (autoSize ? null : 1),
        overflow: autoSize && col.maxLines == null
            ? TextOverflow.visible
            : TextOverflow.ellipsis,
        softWrap: autoSize || (col.maxLines != null && col.maxLines! > 1),
      );
    }

    final padded = Padding(
      padding: cellStyle?.padding ?? col.cellPadding ?? theme.cellPadding,
      child: Row(
        children: [
          if (renderExpandToggle)
            Padding(
              padding: const EdgeInsets.only(right: 4),
              child: InkWell(
                borderRadius: BorderRadius.circular(20),
                onTap: () => state._toggleExpand(row),
                child: Padding(
                  padding: const EdgeInsets.all(2),
                  child: AnimatedRotation(
                    duration: const Duration(milliseconds: 150),
                    turns: isExpanded ? 0.25 : 0.0,
                    child: Icon(Icons.chevron_right,
                        size: 18, color: theme.iconColor),
                  ),
                ),
              ),
            ),
          Expanded(
            child: Align(
              alignment: cellStyle?.alignment ?? col.alignment,
              child: content,
            ),
          ),
        ],
      ),
    );

    Widget cellChild = cellStyle == null
        ? padded
        : Container(
            decoration: BoxDecoration(
              color: cellStyle.backgroundColor,
              borderRadius: cellStyle.borderRadius,
              border: cellStyle.border,
            ),
            child: padded,
          );

    // Per-cell tap / long-press handler — overrides the row tap for this cell.
    if (col.onCellTap != null || col.onCellLongPress != null) {
      cellChild = MouseRegion(
        cursor: col.onCellTap != null
            ? SystemMouseCursors.click
            : SystemMouseCursors.basic,
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: col.onCellTap == null
              ? null
              : () => col.onCellTap!(row, pageRowIndex),
          onLongPress: col.onCellLongPress == null
              ? null
              : () => col.onCellLongPress!(row, pageRowIndex),
          child: cellChild,
        ),
      );
    }

    final box = SizedBox(width: width, child: cellChild);

    if (theme.showVerticalDividers) {
      return Container(
        decoration: BoxDecoration(
          border: Border(right: BorderSide(color: theme.dividerColor)),
        ),
        child: box,
      );
    }
    return box;
  }

  // ───── span overlay ─────

  Widget _spanOverlay(
    BuildContext context,
    ProCellSpan span,
    List<ProColumn<T>> cols,
    Map<String, double> widthMap,
  ) {
    final colIdx = cols.indexWhere((c) => c.id == span.columnId);
    if (colIdx < 0) return const SizedBox.shrink();
    final left = cols
        .take(colIdx)
        .fold<double>(0, (a, c) => a + (widthMap[c.id] ?? 0));
    final width = cols
        .skip(colIdx)
        .take(span.columnSpan)
        .fold<double>(0, (a, c) => a + (widthMap[c.id] ?? 0));

    // Compute Y by counting row heights, including expanded panels.
    var top = 0.0;
    var spanHeight = 0.0;
    for (var i = 0; i < pageRows.length; i++) {
      final rowH = theme.rowHeight;
      final isExpanded =
          state._expanded.contains(state._keyOf(pageRows[i])) &&
              state.widget.expandedRowBuilder != null;
      if (i < span.rowIndex) {
        top += rowH;
        if (isExpanded) {
          // expanded panel height is unknown, fall back to 0 — overlay will
          // misalign for spans that cross expanded rows.
        }
      } else if (i < span.rowIndex + span.rowSpan) {
        spanHeight += rowH;
      } else {
        break;
      }
    }

    final style = span.style;
    final effectiveBg = style?.backgroundColor ?? theme.background;

    return Positioned(
      left: left,
      top: top,
      width: width,
      height: spanHeight,
      child: IgnorePointer(
        ignoring: false,
        child: Container(
          decoration: BoxDecoration(
            color: effectiveBg,
            borderRadius: style?.borderRadius,
            border: style?.border ??
                Border(
                  bottom: BorderSide(color: theme.dividerColor),
                ),
          ),
          padding: style?.padding ?? theme.cellPadding,
          alignment: style?.alignment ?? Alignment.centerLeft,
          child: DefaultTextStyle.merge(
            style: theme.rowTextStyle.merge(style?.textStyle),
            child: Builder(builder: span.builder),
          ),
        ),
      ),
    );
  }

  // ───── empty state ─────

  Widget _emptyState(BuildContext context) {
    if (state.widget.emptyStateBuilder != null) {
      return state.widget.emptyStateBuilder!(context);
    }
    return Padding(
      padding: const EdgeInsets.all(48),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.inbox_outlined,
                size: 48, color: theme.iconColor),
            const SizedBox(height: 12),
            Text('No results',
                style: theme.emptyStateTextStyle),
          ],
        ),
      ),
    );
  }
}

/// Custom single-select radio that mirrors Flutter's Radio look without the
/// deprecated groupValue API.
class _SingleSelectRadio extends StatelessWidget {
  const _SingleSelectRadio({
    required this.selected,
    required this.color,
    required this.onTap,
  });

  final bool selected;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkResponse(
      onTap: onTap,
      radius: 18,
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Icon(
          selected ? Icons.radio_button_checked : Icons.radio_button_unchecked,
          size: 20,
          color: selected ? color : Theme.of(context).colorScheme.outline,
        ),
      ),
    );
  }
}

/// Tiny stateful wrapper that paints a hover overlay on web/desktop.
class _HoverRow extends StatefulWidget {
  const _HoverRow({
    required this.child,
    required this.hoverColor,
    this.baseColor,
  });

  final Widget child;
  final Color hoverColor;
  final Color? baseColor;

  @override
  State<_HoverRow> createState() => _HoverRowState();
}

class _HoverRowState extends State<_HoverRow> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    final supportsHover = kIsWeb ||
        defaultTargetPlatform == TargetPlatform.macOS ||
        defaultTargetPlatform == TargetPlatform.windows ||
        defaultTargetPlatform == TargetPlatform.linux;

    final color = _hover && supportsHover
        ? Color.alphaBlend(widget.hoverColor, widget.baseColor ?? const Color(0x00000000))
        : widget.baseColor;

    return MouseRegion(
      onEnter: supportsHover ? (_) => setState(() => _hover = true) : null,
      onExit: supportsHover ? (_) => setState(() => _hover = false) : null,
      child: ColoredBox(
        color: color ?? const Color(0x00000000),
        child: widget.child,
      ),
    );
  }
}

/// Animated shimmer placeholder used by skeleton loading rows.
class _SkeletonShimmer extends StatefulWidget {
  const _SkeletonShimmer({
    required this.color,
    this.width,
    this.height = 12,
  });

  final Color color;
  final double? width;
  final double height;

  @override
  State<_SkeletonShimmer> createState() => _SkeletonShimmerState();
}

class _SkeletonShimmerState extends State<_SkeletonShimmer>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1100),
  )..repeat(reverse: true);

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _ctrl,
      builder: (ctx, _) {
        final t = Curves.easeInOut.transform(_ctrl.value);
        final opacity = 0.35 + 0.5 * t;
        return Container(
          width: widget.width,
          height: widget.height,
          decoration: BoxDecoration(
            color: widget.color.withValues(alpha: opacity),
            borderRadius: BorderRadius.circular(4),
          ),
        );
      },
    );
  }
}

/// Sticky bulk-actions bar that slides in from the bottom when rows are
/// selected. Mirrors the Zoho/Odoo "X selected · ⋯ actions" affordance.
class _BulkActionsBar extends StatelessWidget {
  const _BulkActionsBar({
    required this.theme,
    required this.label,
    required this.actions,
    required this.onClear,
  });

  final ProTableTheme theme;
  final String label;
  final List<Widget> actions;
  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) {
    return AnimatedSize(
      duration: const Duration(milliseconds: 180),
      curve: Curves.easeOut,
      alignment: Alignment.topCenter,
      child: Container(
        decoration: BoxDecoration(
          color: theme.primaryColor,
          border: Border(top: BorderSide(color: theme.borderColor)),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          children: [
            IconButton(
              icon: Icon(Icons.close, color: theme.onPrimaryColor),
              tooltip: 'Clear selection',
              onPressed: onClear,
            ),
            const SizedBox(width: 4),
            Text(
              label,
              style: theme.rowTextStyle.copyWith(
                color: theme.onPrimaryColor,
                fontWeight: FontWeight.w600,
              ),
            ),
            const Spacer(),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: actions,
            ),
          ],
        ),
      ),
    );
  }
}
