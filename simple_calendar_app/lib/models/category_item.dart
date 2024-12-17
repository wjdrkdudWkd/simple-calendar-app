class CategoryItem {
  final int? id;
  final String name;
  final String description;
  final String iconName;
  final bool isSelected;

  CategoryItem({
    this.id,
    required this.name,
    required this.description,
    required this.iconName,
    this.isSelected = false,
  });

  factory CategoryItem.fromMap(Map<String, dynamic> map) {
    return CategoryItem(
      id: map['id'] as int?,
      name: map['name'] as String,
      description: map['description'] as String,
      iconName: map['iconName'] as String,
      isSelected: map['isSelected'] == 1,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'iconName': iconName,
      'isSelected': isSelected ? 1 : 0,
    };
  }

  CategoryItem copyWith({
    int? id,
    String? name,
    String? description,
    String? iconName,
    bool? isSelected,
  }) {
    return CategoryItem(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      iconName: iconName ?? this.iconName,
      isSelected: isSelected ?? this.isSelected,
    );
  }

  @override
  String toString() {
    return 'CategoryItem(id: $id, name: $name, description: $description, iconName: $iconName, isSelected: $isSelected)';
  }
}
