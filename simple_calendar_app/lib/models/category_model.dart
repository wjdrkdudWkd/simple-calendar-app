class Categories {
  final String id;
  final String name;
  final String description;
  final String iconName;
  bool isEnabled;

  Categories({
    required this.id,
    required this.name,
    required this.description,
    required this.iconName,
    this.isEnabled = true,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'iconName': iconName,
      'isEnabled': isEnabled,
    };
  }

  factory Categories.fromMap(Map<String, dynamic> map) {
    return Categories(
      id: map['id'],
      name: map['name'],
      description: map['description'],
      iconName: map['iconName'],
      isEnabled: map['isEnabled'],
    );
  }
}
