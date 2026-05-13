import 'package:flutter/material.dart';
import 'package:flutter_pro_table/flutter_pro_table.dart';

void main() => runApp(const ProTableExampleApp());

class ProTableExampleApp extends StatefulWidget {
  const ProTableExampleApp({super.key});

  @override
  State<ProTableExampleApp> createState() => _ProTableExampleAppState();
}

class _ProTableExampleAppState extends State<ProTableExampleApp> {
  ThemeMode _mode = ThemeMode.system;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'flutter_pro_table demo',
      debugShowCheckedModeBanner: false,
      themeMode: _mode,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF4F46E5)),
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF4F46E5),
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
      home: HomePage(
        onToggleTheme: () => setState(() {
          _mode = _mode == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
        }),
      ),
    );
  }
}

// ─── data ───

class Employee {
  Employee({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    required this.team,
    required this.salary,
    required this.status,
    required this.startDate,
  });

  final int id;
  final String name;
  final String email;
  final String role;
  final String team;
  final double salary;
  final String status; // active / vacation / inactive
  final DateTime startDate;
}

final _employees = List.generate(57, (i) {
  const names = [
    'Alice Johnson', 'Bob Smith', 'Carol Davis', 'Dan Brown',
    'Eve Wilson', 'Frank Miller', 'Grace Taylor', 'Henry Anderson',
    'Iris Thomas', 'Jack White', 'Kate Harris', 'Liam Martin',
    'Mia Jackson', 'Noah Garcia', 'Olivia Clark', 'Paul Lewis',
  ];
  const roles = ['Engineer', 'Designer', 'Manager', 'PM', 'QA', 'DevOps'];
  const teams = ['Platform', 'Mobile', 'Web', 'Data', 'Infra'];
  const statuses = ['active', 'vacation', 'inactive'];
  final n = names[i % names.length];
  return Employee(
    id: 1000 + i,
    name: '$n ${i + 1}',
    email: '${n.toLowerCase().replaceAll(' ', '.')}.${i + 1}@example.com',
    role: roles[i % roles.length],
    team: teams[i % teams.length],
    salary: 60000 + (i * 1750) + (i % 7) * 3500,
    status: statuses[i % statuses.length],
    startDate: DateTime(2018 + (i % 7), 1 + (i % 12), 1 + (i % 27)),
  );
});

// ─── home with multiple demos ───

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.onToggleTheme});

  final VoidCallback onToggleTheme;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  late final TabController _tabs = TabController(length: 6, vsync: this);

  @override
  void dispose() {
    _tabs.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('flutter_pro_table'),
        actions: [
          IconButton(
            icon: const Icon(Icons.brightness_6),
            tooltip: 'Toggle theme',
            onPressed: widget.onToggleTheme,
          ),
        ],
        bottom: TabBar(
          controller: _tabs,
          isScrollable: true,
          tabs: const [
            Tab(text: 'Full demo'),
            Tab(text: 'ERP-style'),
            Tab(text: 'Frozen columns'),
            Tab(text: 'Merged cells'),
            Tab(text: 'Compact'),
            Tab(text: 'Loading states'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabs,
        children: const [
          _FullDemo(),
          _ErpDemo(),
          _FrozenDemo(),
          _MergedDemo(),
          _CompactDemo(),
          _LoadingDemo(),
        ],
      ),
    );
  }
}

// ─── full feature demo ───

class _FullDemo extends StatefulWidget {
  const _FullDemo();

  @override
  State<_FullDemo> createState() => _FullDemoState();
}

class _FullDemoState extends State<_FullDemo> {
  final _selected = <Object>{};

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: ProTable<Employee>(
        title: 'Employees',
        subtitle:
            '${_employees.length} total · ${_selected.length} selected · long-press a column header to drag-reorder',
        rows: _employees,
        actions: [
          OutlinedButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.file_download),
            label: const Text('Export'),
          ),
          FilledButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.add),
            label: const Text('Add'),
          ),
        ],
        selectionMode: ProSelectionMode.multi,
        rowKey: (e) => e.id,
        onSelectionChanged: (s) => setState(() {
          _selected
            ..clear()
            ..addAll(s);
        }),
        // Allow user to drag-reorder columns
        enableColumnReorder: true,
        // Auto-grow rows when content is taller than rowHeight
        autoSizeRows: true,
        // Alternating row colors (also see rowStyleResolver below for
        // conditional, value-based coloring)
        oddRowColor: Theme.of(context).colorScheme.surfaceContainerLowest,
        initialSort: const ProSort(
            columnId: 'name', direction: ProSortDirection.ascending),
        expandedRowBuilder: (context, row) => _employeeDetail(row),
        // Tint rows differently based on a row value (status).
        rowStyleResolver: (row, _) {
          if (row.status == 'inactive') {
            return const ProCellStyle(
              backgroundColor: Color(0x14FF0000),
              textStyle: TextStyle(color: Colors.grey),
            );
          }
          if (row.status == 'vacation') {
            return const ProCellStyle(
              backgroundColor: Color(0x14F59E0B),
            );
          }
          return const ProCellStyle();
        },
        columns: [
          ProColumn(
            id: 'name',
            title: 'Name',
            value: (r) => r.name,
            sortable: true,
            expandable: true,
            width: const ProColumnWidth.flex(2),
            // Per-cell tap → opens a detail page (here we just show a
            // SnackBar, but you'd typically Navigator.push something).
            onCellTap: (r, _) => ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Open profile of ${r.name}'),
                duration: const Duration(seconds: 2),
              ),
            ),
            cellBuilder: (ctx, r, _) => Row(
              children: [
                CircleAvatar(
                  radius: 14,
                  backgroundColor:
                      Theme.of(ctx).colorScheme.primaryContainer,
                  child: Text(
                    r.name.substring(0, 1),
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(ctx).colorScheme.onPrimaryContainer,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(r.name, overflow: TextOverflow.ellipsis),
                      Text(
                        r.email,
                        style: Theme.of(ctx).textTheme.bodySmall,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          ProColumn(
            id: 'role',
            title: 'Role',
            value: (r) => r.role,
            sortable: true,
            width: const ProColumnWidth.fixed(140),
          ),
          ProColumn(
            id: 'team',
            title: 'Team',
            value: (r) => r.team,
            sortable: true,
            width: const ProColumnWidth.fixed(120),
          ),
          ProColumn(
            id: 'salary',
            title: 'Salary',
            value: (r) => r.salary,
            sortable: true,
            alignment: Alignment.centerRight,
            width: const ProColumnWidth.fixed(120),
            cellBuilder: (_, r, _) => Text(
              '\$${r.salary.toStringAsFixed(0)}',
              style: const TextStyle(
                  fontFeatures: [FontFeature.tabularFigures()]),
            ),
          ),
          ProColumn(
            id: 'status',
            title: 'Status',
            value: (r) => r.status,
            sortable: true,
            width: const ProColumnWidth.fixed(120),
            cellBuilder: (_, r, _) => _StatusBadge(status: r.status),
          ),
          ProColumn(
            id: 'startDate',
            title: 'Start',
            value: (r) => r.startDate,
            sortable: true,
            width: const ProColumnWidth.fixed(120),
            cellBuilder: (_, r, _) => Text(
              '${r.startDate.year}-${r.startDate.month.toString().padLeft(2, '0')}-${r.startDate.day.toString().padLeft(2, '0')}',
            ),
          ),
        ],
        pagination: const ProPagination(
          page: 1,
          pageSize: 10,
          pageSizeOptions: [10, 25, 50],
        ),
      ),
    );
  }

  Widget _employeeDetail(Employee r) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(r.name, style: const TextStyle(fontWeight: FontWeight.w600)),
        const SizedBox(height: 8),
        Wrap(
          spacing: 24,
          runSpacing: 8,
          children: [
            _detailItem('Email', r.email),
            _detailItem('Team', r.team),
            _detailItem('Role', r.role),
            _detailItem('Started',
                r.startDate.toIso8601String().split('T').first),
            _detailItem('Salary', '\$${r.salary.toStringAsFixed(0)}'),
          ],
        ),
      ],
    );
  }

  Widget _detailItem(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: TextStyle(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
                fontSize: 12)),
        Text(value),
      ],
    );
  }
}

// ─── frozen columns demo ───

class _FrozenDemo extends StatelessWidget {
  const _FrozenDemo();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: ProTable<Employee>(
        title: 'Pinned columns',
        subtitle:
            'The "Name" column is pinned left and "Salary" is pinned right.',
        rows: _employees,
        rowKey: (e) => e.id,
        columns: [
          ProColumn(
            id: 'name',
            title: 'Name',
            value: (r) => r.name,
            pin: ColumnPin.left,
            sortable: true,
            width: const ProColumnWidth.fixed(220),
          ),
          ProColumn(
            id: 'role',
            title: 'Role',
            value: (r) => r.role,
            width: const ProColumnWidth.fixed(140),
          ),
          ProColumn(
            id: 'team',
            title: 'Team',
            value: (r) => r.team,
            width: const ProColumnWidth.fixed(140),
          ),
          ProColumn(
            id: 'email',
            title: 'Email',
            value: (r) => r.email,
            width: const ProColumnWidth.fixed(280),
          ),
          ProColumn(
            id: 'startDate',
            title: 'Start',
            value: (r) => r.startDate,
            width: const ProColumnWidth.fixed(140),
            cellBuilder: (_, r, _) => Text(
                '${r.startDate.year}-${r.startDate.month.toString().padLeft(2, '0')}-${r.startDate.day.toString().padLeft(2, '0')}'),
          ),
          ProColumn(
            id: 'status',
            title: 'Status',
            value: (r) => r.status,
            width: const ProColumnWidth.fixed(140),
            cellBuilder: (_, r, _) => _StatusBadge(status: r.status),
          ),
          ProColumn(
            id: 'salary',
            title: 'Salary',
            value: (r) => r.salary,
            pin: ColumnPin.right,
            sortable: true,
            alignment: Alignment.centerRight,
            width: const ProColumnWidth.fixed(140),
            cellBuilder: (_, r, _) =>
                Text('\$${r.salary.toStringAsFixed(0)}'),
          ),
        ],
      ),
    );
  }
}

// ─── merged cells demo ───

class _MergedDemo extends StatelessWidget {
  const _MergedDemo();

  @override
  Widget build(BuildContext context) {
    final rows = _employees.take(8).toList();

    return Padding(
      padding: const EdgeInsets.all(16),
      child: ProTable<Employee>(
        title: 'Merged cells',
        subtitle: 'Demonstrates rowSpan/colSpan via ProCellSpan.',
        rows: rows,
        enablePagination: false,
        enableSearch: false,
        rowKey: (e) => e.id,
        cellSpans: [
          ProCellSpan(
            rowIndex: 0,
            columnId: 'team',
            rowSpan: 3,
            builder: (_) => const Center(
              child: Text(
                'Platform',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            style: const ProCellStyle(
              backgroundColor: Color(0xFFE0F2FE),
              textStyle: TextStyle(color: Color(0xFF0369A1)),
            ),
          ),
          ProCellSpan(
            rowIndex: 5,
            columnId: 'salary',
            columnSpan: 2,
            builder: (_) => const Align(
              alignment: Alignment.centerRight,
              child: Text(
                'Pending review',
                style: TextStyle(fontStyle: FontStyle.italic),
              ),
            ),
            style: const ProCellStyle(
              backgroundColor: Color(0xFFFEF3C7),
            ),
          ),
        ],
        columns: [
          ProColumn(
            id: 'name',
            title: 'Name',
            value: (r) => r.name,
            width: const ProColumnWidth.flex(2),
          ),
          ProColumn(
            id: 'team',
            title: 'Team',
            value: (r) => r.team,
            width: const ProColumnWidth.fixed(160),
          ),
          ProColumn(
            id: 'salary',
            title: 'Salary',
            value: (r) => r.salary,
            alignment: Alignment.centerRight,
            width: const ProColumnWidth.fixed(140),
            cellBuilder: (_, r, _) =>
                Text('\$${r.salary.toStringAsFixed(0)}'),
          ),
          ProColumn(
            id: 'status',
            title: 'Status',
            value: (r) => r.status,
            width: const ProColumnWidth.fixed(140),
            cellBuilder: (_, r, _) => _StatusBadge(status: r.status),
          ),
        ],
      ),
    );
  }
}

// ─── compact demo with custom theme ───

class _CompactDemo extends StatelessWidget {
  const _CompactDemo();

  @override
  Widget build(BuildContext context) {
    final base = ProTableTheme.fromContext(context);
    final theme = base.copyWith(
      rowHeight: 40,
      headerHeight: 40,
      cellPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      headerPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      borderRadius: BorderRadius.circular(8),
      striped: false,
      showVerticalDividers: true,
    );

    return Padding(
      padding: const EdgeInsets.all(16),
      child: ProTable<Employee>(
        rows: _employees.take(20).toList(),
        rowKey: (e) => e.id,
        theme: theme,
        title: 'Compact',
        enablePagination: false,
        columns: [
          ProColumn(
              id: 'id',
              title: 'ID',
              value: (r) => r.id,
              width: const ProColumnWidth.fixed(80)),
          ProColumn(
              id: 'name',
              title: 'Name',
              value: (r) => r.name,
              sortable: true,
              width: const ProColumnWidth.flex(2)),
          ProColumn(
              id: 'role',
              title: 'Role',
              value: (r) => r.role,
              width: const ProColumnWidth.fixed(140)),
          ProColumn(
              id: 'team',
              title: 'Team',
              value: (r) => r.team,
              width: const ProColumnWidth.fixed(120)),
        ],
      ),
    );
  }
}

// ─── ERP-style demo (Zoho/Odoo) ───

class _ErpDemo extends StatefulWidget {
  const _ErpDemo();

  @override
  State<_ErpDemo> createState() => _ErpDemoState();
}

class _ErpDemoState extends State<_ErpDemo> {
  ProTableDensity _density = ProTableDensity.standard;
  final _selected = <Object>{};

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: ProTable<Employee>(
        title: 'Sales pipeline',
        subtitle: 'Right-click a header for sort · drag the right edge to resize · use the bulk bar to act on selection',
        rows: _employees,
        rowKey: (e) => e.id,
        density: _density,
        showRowNumbers: true,
        showFooter: true,
        enableColumnResize: true,
        enableColumnVisibilityToggle: true,
        enableColumnReorder: true,
        selectionMode: ProSelectionMode.multi,
        onSelectionChanged: (s) =>
            setState(() => _selected..clear()..addAll(s)),
        actions: [
          DropdownButton<ProTableDensity>(
            value: _density,
            underline: const SizedBox.shrink(),
            items: const [
              DropdownMenuItem(
                  value: ProTableDensity.compact, child: Text('Compact')),
              DropdownMenuItem(
                  value: ProTableDensity.standard, child: Text('Standard')),
              DropdownMenuItem(
                  value: ProTableDensity.comfortable,
                  child: Text('Comfortable')),
            ],
            onChanged: (v) => setState(() => _density = v!),
          ),
          OutlinedButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.file_download),
            label: const Text('Export'),
          ),
        ],
        bulkActionsBuilder: (ctx, selected) => [
          TextButton.icon(
            onPressed: () {
              ScaffoldMessenger.of(ctx).showSnackBar(SnackBar(
                  content: Text('Email ${selected.length} contacts')));
            },
            icon: const Icon(Icons.mail_outline, color: Colors.white),
            label: const Text('Email',
                style: TextStyle(color: Colors.white)),
          ),
          TextButton.icon(
            onPressed: () {
              ScaffoldMessenger.of(ctx).showSnackBar(SnackBar(
                  content: Text('Archive ${selected.length} rows')));
            },
            icon: const Icon(Icons.archive_outlined, color: Colors.white),
            label: const Text('Archive',
                style: TextStyle(color: Colors.white)),
          ),
          TextButton.icon(
            onPressed: () {
              ScaffoldMessenger.of(ctx).showSnackBar(SnackBar(
                  content: Text('Delete ${selected.length} rows')));
            },
            icon: const Icon(Icons.delete_outline, color: Colors.white),
            label: const Text('Delete',
                style: TextStyle(color: Colors.white)),
          ),
        ],
        mobileBreakpoint: 600,
        oddRowColor: Theme.of(context).colorScheme.surfaceContainerLowest,
        columns: [
          ProColumn(
            id: 'name',
            title: 'Name',
            value: (r) => r.name,
            sortable: true,
            hideable: false,
            pin: ColumnPin.left,
            width: const ProColumnWidth.fixed(220),
            footerBuilder: (_, rows) => Text(
              '${rows.length} people',
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
          ProColumn(
            id: 'role',
            title: 'Role',
            value: (r) => r.role,
            sortable: true,
            width: const ProColumnWidth.fixed(140),
          ),
          ProColumn(
            id: 'team',
            title: 'Team',
            value: (r) => r.team,
            sortable: true,
            width: const ProColumnWidth.fixed(140),
          ),
          ProColumn(
            id: 'email',
            title: 'Email',
            value: (r) => r.email,
            width: const ProColumnWidth.fixed(280),
          ),
          ProColumn(
            id: 'status',
            title: 'Status',
            value: (r) => r.status,
            width: const ProColumnWidth.fixed(140),
            cellBuilder: (_, r, _) => _StatusBadge(status: r.status),
            footerBuilder: (_, rows) {
              final active = rows.where((r) => r.status == 'active').length;
              return Text('$active active',
                  style:
                      const TextStyle(fontWeight: FontWeight.w600));
            },
          ),
          ProColumn(
            id: 'salary',
            title: 'Salary',
            value: (r) => r.salary,
            sortable: true,
            pin: ColumnPin.right,
            alignment: Alignment.centerRight,
            width: const ProColumnWidth.fixed(140),
            cellBuilder: (_, r, _) =>
                Text('\$${r.salary.toStringAsFixed(0)}'),
            footerBuilder: (_, rows) {
              final total = rows.fold<double>(0, (a, r) => a + r.salary);
              return Text(
                '\$${total.toStringAsFixed(0)}',
                style: const TextStyle(fontWeight: FontWeight.w700),
              );
            },
          ),
        ],
        pagination: const ProPagination(pageSize: 10),
      ),
    );
  }
}

// ─── loading states demo ───

class _LoadingDemo extends StatefulWidget {
  const _LoadingDemo();

  @override
  State<_LoadingDemo> createState() => _LoadingDemoState();
}

class _LoadingDemoState extends State<_LoadingDemo> {
  bool _loading = true;
  ProLoadingStyle _style = ProLoadingStyle.skeleton;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            FilledButton(
              onPressed: () => setState(() => _loading = !_loading),
              child: Text(_loading ? 'Stop loading' : 'Start loading'),
            ),
            const SizedBox(width: 12),
            DropdownButton<ProLoadingStyle>(
              value: _style,
              items: const [
                DropdownMenuItem(
                    value: ProLoadingStyle.skeleton, child: Text('Skeleton')),
                DropdownMenuItem(
                    value: ProLoadingStyle.spinner, child: Text('Spinner')),
              ],
              onChanged: (v) => setState(() => _style = v!),
            ),
          ]),
          const SizedBox(height: 12),
          Expanded(
            child: ProTable<Employee>(
              title: 'Loading…',
              loading: _loading,
              loadingStyle: _style,
              skeletonRowCount: 8,
              rows: _employees.take(20).toList(),
              rowKey: (e) => e.id,
              columns: [
                ProColumn(
                    id: 'name',
                    title: 'Name',
                    value: (r) => r.name,
                    width: const ProColumnWidth.flex(2)),
                ProColumn(
                    id: 'role',
                    title: 'Role',
                    value: (r) => r.role,
                    width: const ProColumnWidth.fixed(140)),
                ProColumn(
                    id: 'team',
                    title: 'Team',
                    value: (r) => r.team,
                    width: const ProColumnWidth.fixed(140)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─── small UI helper ───

class _StatusBadge extends StatelessWidget {
  const _StatusBadge({required this.status});
  final String status;

  @override
  Widget build(BuildContext context) {
    final (bg, fg, label) = switch (status) {
      'active' => (
          const Color(0xFFDCFCE7),
          const Color(0xFF166534),
          'Active'
        ),
      'vacation' => (
          const Color(0xFFFEF3C7),
          const Color(0xFF92400E),
          'Vacation'
        ),
      _ => (const Color(0xFFE5E7EB), const Color(0xFF374151), 'Inactive'),
    };
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: TextStyle(color: fg, fontSize: 12, fontWeight: FontWeight.w600),
      ),
    );
  }
}
