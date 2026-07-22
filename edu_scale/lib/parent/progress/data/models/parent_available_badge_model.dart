class ParentAvailableBadgeModel {
  final int id;
  final String name;
  final String description;
  final String iconUrl;
  final String category;
  final String requirement;
  final int requirementValue;
  final DateTime createdAt;

  const ParentAvailableBadgeModel({
    required this.id,
    required this.name,
    required this.description,
    required this.iconUrl,
    required this.category,
    required this.requirement,
    required this.requirementValue,
    required this.createdAt,
  });

  factory ParentAvailableBadgeModel.fromJson(Map<String, dynamic> json) {
    return ParentAvailableBadgeModel(
      id: json['id'] as int,
      name: json['name'] as String,
      description: json['description'] as String,
      iconUrl: json['icon_url'] as String,
      category: json['category'] as String,
      requirement: json['requirement'] as String,
      requirementValue: json['requirement_value'] as int,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'icon_url': iconUrl,
      'category': category,
      'requirement': requirement,
      'requirement_value': requirementValue,
      'created_at': createdAt.toIso8601String(),
    };
  }

  @override
  String toString() {
    return 'ParentAvailableBadgeModel(id: $id, name: $name, category: $category)';
  }
}
