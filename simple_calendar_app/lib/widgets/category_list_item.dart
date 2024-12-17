import 'package:flutter/material.dart';
import '../models/category_item.dart';

class CategoryListItem extends StatelessWidget {
  final CategoryItem category;
  final VoidCallback? onTap;

  const CategoryListItem({
    super.key,
    required this.category,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.grey[850],
      child: ListTile(
        leading: Icon(
          _getIconData(category.iconName),
          color: Colors.pink,
        ),
        title: Text(
          category.name,
          style: const TextStyle(color: Colors.white),
        ),
        subtitle: Text(
          category.description,
          style: TextStyle(color: Colors.grey[400]),
        ),
        trailing: Switch(
          value: category.isSelected,
          onChanged: (value) {
            if (onTap != null) onTap!();
          },
          activeColor: Colors.pink,
        ),
      ),
    );
  }

  IconData _getIconData(String iconName) {
    switch (iconName) {
      case 'work':
        return Icons.work;
      case 'study':
        return Icons.book;
      case 'fitness':
        return Icons.fitness_center;
      case 'finance':
        return Icons.attach_money;
      default:
        return Icons.category;
    }
  }
}
