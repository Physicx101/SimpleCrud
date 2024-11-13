class Item {
  final String id;
  final String name;
  final Map<String, dynamic>? data;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Item({
    required this.id,
    required this.name,
    this.data,
    this.createdAt,
    this.updatedAt,
  });
}
