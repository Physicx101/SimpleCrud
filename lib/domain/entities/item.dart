class Item {
  final String id;
  final String name;
  final Map<String, dynamic>? data;

  Item({
    required this.id,
    required this.name,
    this.data,
  });
}
