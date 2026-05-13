import 'package:flutter/material.dart';

import '../models/pro_pagination.dart';
import '../theme/pro_table_theme.dart';

/// Footer pagination control with first/prev/numbered/next/last + page size
/// selector + jump-to-page input.
class ProPaginationBar extends StatefulWidget {
  const ProPaginationBar({
    super.key,
    required this.pagination,
    required this.totalRows,
    required this.theme,
    required this.onChanged,
  });

  final ProPagination pagination;
  final int totalRows;
  final ProTableTheme theme;
  final ValueChanged<ProPagination> onChanged;

  @override
  State<ProPaginationBar> createState() => _ProPaginationBarState();
}

class _ProPaginationBarState extends State<ProPaginationBar> {
  late TextEditingController _jumpController;

  @override
  void initState() {
    super.initState();
    _jumpController = TextEditingController();
  }

  @override
  void dispose() {
    _jumpController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final p = widget.pagination;
    final totalPages = p.totalPages(widget.totalRows);
    final start = widget.totalRows == 0
        ? 0
        : ((p.page - 1) * p.pageSize + 1).clamp(0, widget.totalRows);
    final end = (p.page * p.pageSize).clamp(0, widget.totalRows);

    final summary = Text(
      widget.totalRows == 0
          ? 'No results'
          : 'Showing $start–$end of ${widget.totalRows}',
      style: widget.theme.subtitleTextStyle,
    );

    final pageList = _buildPageList(p.page, totalPages, p.maxVisiblePageButtons);

    final controls = <Widget>[
      if (p.showPageSizeSelector) ...[
        Text('Rows per page:', style: widget.theme.subtitleTextStyle),
        const SizedBox(width: 8),
        DropdownButton<int>(
          value: p.pageSize,
          isDense: true,
          underline: const SizedBox.shrink(),
          items: [
            for (final n in p.pageSizeOptions)
              DropdownMenuItem(value: n, child: Text('$n')),
          ],
          onChanged: (v) {
            if (v == null) return;
            widget.onChanged(p.copyWith(pageSize: v, page: 1));
          },
        ),
        const SizedBox(width: 12),
      ],
      _navIcon(Icons.first_page, p.page > 1,
          () => widget.onChanged(p.copyWith(page: 1))),
      _navIcon(Icons.chevron_left, p.page > 1,
          () => widget.onChanged(p.copyWith(page: p.page - 1))),
      const SizedBox(width: 4),
      for (final entry in pageList) _pageButton(entry, p.page),
      const SizedBox(width: 4),
      _navIcon(Icons.chevron_right, p.page < totalPages,
          () => widget.onChanged(p.copyWith(page: p.page + 1))),
      _navIcon(Icons.last_page, p.page < totalPages,
          () => widget.onChanged(p.copyWith(page: totalPages))),
      if (p.showJumpToPage && totalPages > 1) ...[
        const SizedBox(width: 12),
        SizedBox(
          width: 78,
          height: 36,
          child: TextField(
            controller: _jumpController,
            decoration: InputDecoration(
              isDense: true,
              hintText: 'Go to',
              hintStyle: widget.theme.subtitleTextStyle,
              border: const OutlineInputBorder(),
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            ),
            keyboardType: TextInputType.number,
            textAlign: TextAlign.center,
            onSubmitted: (text) {
              final n = int.tryParse(text);
              if (n == null) return;
              final clamped = n.clamp(1, totalPages);
              widget.onChanged(p.copyWith(page: clamped));
              _jumpController.clear();
            },
          ),
        ),
      ],
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: LayoutBuilder(
        builder: (context, constraints) {
          // On narrow screens, stack: summary on top, then a horizontally
          // scrollable single-line bar of controls so they never stretch.
          final narrow = constraints.maxWidth < 640;
          final controlsRow = SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: controls,
            ),
          );

          if (narrow) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                summary,
                const SizedBox(height: 8),
                controlsRow,
              ],
            );
          }

          return Row(
            children: [
              summary,
              const SizedBox(width: 12),
              Expanded(
                child: Align(
                  alignment: Alignment.centerRight,
                  child: controlsRow,
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _navIcon(IconData icon, bool enabled, VoidCallback onTap) {
    return SizedBox(
      width: 36,
      height: 36,
      child: IconButton(
        icon: Icon(icon, size: 20),
        visualDensity: VisualDensity.compact,
        padding: EdgeInsets.zero,
        onPressed: enabled ? onTap : null,
        color: widget.theme.iconColor,
      ),
    );
  }

  Widget _pageButton(_PageEntry entry, int currentPage) {
    if (entry is _Ellipsis) {
      return SizedBox(
        width: 24,
        height: 32,
        child: Center(
          child: Text('…', style: widget.theme.subtitleTextStyle),
        ),
      );
    }
    final n = (entry as _PageNumber).page;
    final selected = n == currentPage;
    final bg = selected ? widget.theme.primaryColor : Colors.transparent;
    final fg = selected
        ? widget.theme.onPrimaryColor
        : widget.theme.rowTextStyle.color;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2),
      child: SizedBox(
        height: 32,
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: bg,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: selected
                  ? widget.theme.primaryColor
                  : widget.theme.borderColor,
            ),
          ),
          child: InkWell(
            borderRadius: BorderRadius.circular(8),
            onTap: selected
                ? null
                : () => widget.onChanged(widget.pagination.copyWith(page: n)),
            child: Container(
              constraints: const BoxConstraints(minWidth: 32),
              padding: const EdgeInsets.symmetric(horizontal: 10),
              alignment: Alignment.center,
              child: Text(
                '$n',
                style: widget.theme.rowTextStyle.copyWith(
                  color: fg,
                  fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  List<_PageEntry> _buildPageList(int current, int total, int maxButtons) {
    if (total <= maxButtons) {
      return [for (var i = 1; i <= total; i++) _PageNumber(i)];
    }
    final result = <_PageEntry>[];
    final side = (maxButtons - 3) ~/ 2;
    result.add(_PageNumber(1));

    final start = (current - side).clamp(2, total - 1);
    final end = (current + side).clamp(2, total - 1);

    if (start > 2) result.add(const _Ellipsis());
    for (var i = start; i <= end; i++) {
      result.add(_PageNumber(i));
    }
    if (end < total - 1) result.add(const _Ellipsis());
    result.add(_PageNumber(total));
    return result;
  }
}

sealed class _PageEntry {
  const _PageEntry();
}

class _PageNumber extends _PageEntry {
  const _PageNumber(this.page);
  final int page;
}

class _Ellipsis extends _PageEntry {
  const _Ellipsis();
}
