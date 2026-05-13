import 'package:flutter/material.dart';
import 'package:flutter_pro_table/flutter_pro_table.dart';
import 'package:flutter_test/flutter_test.dart';

class _Person {
  _Person(this.name, this.age, this.role);
  final String name;
  final int age;
  final String role;
}

final _data = [
  _Person('Alice', 30, 'Engineer'),
  _Person('Bob', 24, 'Designer'),
  _Person('Carol', 41, 'Manager'),
  _Person('Dan', 28, 'Engineer'),
];

Widget _wrap(Widget child) => MaterialApp(
      home: Scaffold(body: SizedBox(width: 800, height: 600, child: child)),
    );

void main() {
  group('ProTable basics', () {
    testWidgets('renders rows and headers', (tester) async {
      await tester.pumpWidget(_wrap(ProTable<_Person>(
        rows: _data,
        columns: [
          ProColumn(id: 'name', title: 'Name', value: (r) => r.name),
          ProColumn(id: 'age', title: 'Age', value: (r) => r.age),
        ],
      )));
      await tester.pumpAndSettle();
      expect(find.text('Name'), findsOneWidget);
      expect(find.text('Age'), findsOneWidget);
      expect(find.text('Alice'), findsOneWidget);
      expect(find.text('Bob'), findsOneWidget);
    });

    testWidgets('search filters rows', (tester) async {
      await tester.pumpWidget(_wrap(ProTable<_Person>(
        title: 'People',
        rows: _data,
        columns: [
          ProColumn(id: 'name', title: 'Name', value: (r) => r.name),
          ProColumn(id: 'role', title: 'Role', value: (r) => r.role),
        ],
      )));
      await tester.pumpAndSettle();
      await tester.enterText(find.byType(TextField).first, 'Carol');
      await tester.pumpAndSettle();
      // 'Carol' shows up both in the search field AND the visible row.
      expect(find.text('Carol'), findsNWidgets(2));
      expect(find.text('Alice'), findsNothing);
    });

    testWidgets('sort toggles when header tapped', (tester) async {
      await tester.pumpWidget(_wrap(ProTable<_Person>(
        rows: _data,
        columns: [
          ProColumn(
            id: 'age',
            title: 'Age',
            value: (r) => r.age,
            sortable: true,
          ),
        ],
      )));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Age'));
      await tester.pumpAndSettle();
      // First row should now be the youngest (24).
      expect(find.text('24'), findsOneWidget);
    });

    testWidgets('pagination shows correct page count', (tester) async {
      final many = List.generate(35, (i) => _Person('P$i', 20 + i, 'r$i'));
      await tester.pumpWidget(_wrap(ProTable<_Person>(
        rows: many,
        columns: [
          ProColumn(id: 'name', title: 'Name', value: (r) => r.name),
        ],
        pagination: const ProPagination(pageSize: 10),
      )));
      await tester.pumpAndSettle();
      expect(find.text('Showing 1–10 of 35'), findsOneWidget);
    });
  });

  group('Pagination math', () {
    test('totalPages rounds up', () {
      const p = ProPagination(pageSize: 10);
      expect(p.totalPages(0), 1);
      expect(p.totalPages(10), 1);
      expect(p.totalPages(11), 2);
      expect(p.totalPages(99), 10);
    });
  });
}
