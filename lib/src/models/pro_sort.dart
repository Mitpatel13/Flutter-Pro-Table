enum ProSortDirection { ascending, descending }

class ProSort {
  const ProSort({required this.columnId, required this.direction});

  final String columnId;
  final ProSortDirection direction;

  ProSort flip() => ProSort(
        columnId: columnId,
        direction: direction == ProSortDirection.ascending
            ? ProSortDirection.descending
            : ProSortDirection.ascending,
      );

  @override
  bool operator ==(Object other) =>
      other is ProSort &&
      other.columnId == columnId &&
      other.direction == direction;

  @override
  int get hashCode => Object.hash(columnId, direction);
}
