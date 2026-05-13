import 'package:flutter/material.dart';

import '../theme/pro_table_theme.dart';

/// Top toolbar that holds the table title/subtitle, optional search input
/// and trailing action widgets.
class ProTableToolbar extends StatefulWidget {
  const ProTableToolbar({
    super.key,
    required this.theme,
    this.title,
    this.subtitle,
    this.actions,
    this.searchHint,
    this.onSearchChanged,
    this.searchEnabled = true,
    this.initialSearchQuery = '',
  });

  final ProTableTheme theme;
  final String? title;
  final String? subtitle;
  final List<Widget>? actions;
  final String? searchHint;
  final ValueChanged<String>? onSearchChanged;
  final bool searchEnabled;
  final String initialSearchQuery;

  @override
  State<ProTableToolbar> createState() => _ProTableToolbarState();
}

class _ProTableToolbarState extends State<ProTableToolbar> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialSearchQuery);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final hasTitle = widget.title != null || widget.subtitle != null;
    final hasSearch = widget.searchEnabled && widget.onSearchChanged != null;
    final hasActions = widget.actions != null && widget.actions!.isNotEmpty;
    if (!hasTitle && !hasSearch && !hasActions) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
      child: LayoutBuilder(builder: (context, constraints) {
        final narrow = constraints.maxWidth < 600;
        final titleBlock = hasTitle
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (widget.title != null)
                    Text(widget.title!, style: widget.theme.titleTextStyle),
                  if (widget.subtitle != null) ...[
                    const SizedBox(height: 2),
                    Text(widget.subtitle!,
                        style: widget.theme.subtitleTextStyle),
                  ],
                ],
              )
            : null;

        final searchBox = hasSearch
            ? ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: narrow ? double.infinity : 280,
                  minWidth: narrow ? 0 : 200,
                ),
                child: TextField(
                  controller: _controller,
                  onChanged: widget.onSearchChanged,
                  decoration: InputDecoration(
                    hintText: widget.searchHint ?? 'Search…',
                    prefixIcon:
                        Icon(Icons.search, color: widget.theme.iconColor),
                    suffixIcon: _controller.text.isEmpty
                        ? null
                        : IconButton(
                            icon: const Icon(Icons.clear),
                            color: widget.theme.iconColor,
                            onPressed: () {
                              _controller.clear();
                              widget.onSearchChanged?.call('');
                              setState(() {});
                            },
                          ),
                    isDense: true,
                    border: const OutlineInputBorder(),
                  ),
                ),
              )
            : null;

        final actionsBlock = hasActions
            ? Wrap(
                spacing: 8,
                runSpacing: 8,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: widget.actions!,
              )
            : null;

        if (narrow) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              if (titleBlock != null) titleBlock,
              if (titleBlock != null && (searchBox != null || actionsBlock != null))
                const SizedBox(height: 12),
              if (searchBox != null) searchBox,
              if (searchBox != null && actionsBlock != null)
                const SizedBox(height: 12),
              if (actionsBlock != null) actionsBlock,
            ],
          );
        }

        return Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (titleBlock != null) Expanded(child: titleBlock) else const Spacer(),
            if (searchBox != null) ...[
              const SizedBox(width: 12),
              searchBox,
            ],
            if (actionsBlock != null) ...[
              const SizedBox(width: 12),
              actionsBlock,
            ],
          ],
        );
      }),
    );
  }
}
