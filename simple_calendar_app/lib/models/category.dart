class Category {
  final int? id;
  final String name;
  final String description;
  final String iconName;
  final bool isSelected;

  Category({
    this.id,
    required this.name,
    required this.description,
    required this.iconName,
    this.isSelected = false,
  });

  // Map에서 Category 객체로 변환
  factory Category.fromMap(Map<String, dynamic> map) {
    return Category(
      id: map['id'] as int?,
      name: map['name'] as String,
      description: map['description'] as String,
      iconName: map['iconName'] as String,
      isSelected: map['isSelected'] == 1,
    );
  }

  // Category 객체를 Map으로 변환
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'iconName': iconName,
      'isSelected': isSelected ? 1 : 0,
    };
  }

  // 객체 복사본 생성 (상태 변경 시 사용)
  Category copyWith({
    int? id,
    String? name,
    String? description,
    String? iconName,
    bool? isSelected,
  }) {
    return Category(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      iconName: iconName ?? this.iconName,
      isSelected: isSelected ?? this.isSelected,
    );
  }

  @override
  String toString() {
    return 'Category(id: $id, name: $name, description: $description, iconName: $iconName, isSelected: $isSelected)';
  }
}
