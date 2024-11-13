class ItemModel {
  final String id;
  final String name;
  final Map<String, dynamic>? data;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  ItemModel({
    required this.id,
    required this.name,
    this.data,
    this.createdAt,
    this.updatedAt,
  });

  factory ItemModel.fromJson(Map<String, dynamic> json) {
    return ItemModel(
      id: json['id'] as String,
      name: json['name'] as String,
      data:
          json['data'] != null ? Map<String, dynamic>.from(json['data']) : null,
      createdAt:
          json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
      updatedAt:
          json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'data': data,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }
}
