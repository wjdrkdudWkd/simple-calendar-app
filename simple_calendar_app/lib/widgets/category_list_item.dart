import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/category_model.dart';
import '../providers/category_provider.dart';

class CategoryListItem extends StatelessWidget {
  final Categories category;

  const CategoryListItem({super.key, required this.category});

  IconData _getIconData(String iconName) {
    // 아이콘 이름을 IconData로 변환하는 매핑
    final iconMap = {
      'fitness': Icons.fitness_center,
      'study': Icons.book,
      'work': Icons.work,
      'finance': Icons.attach_money,
      'meal': Icons.restaurant,
      'health': Icons.favorite,
    };
    return iconMap[iconName] ?? Icons.category;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF2A2B2E),
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: Icon(
          _getIconData(category.iconName),
          color: const Color(0xFFE91E63),
        ),
        title: Text(
          category.name,
          style: const TextStyle(color: Colors.white),
        ),
        subtitle: Text(
          category.description,
          style: const TextStyle(color: Colors.grey),
        ),
        trailing: Switch(
          value: category.isEnabled,
          onChanged: (value) {
            context.read<CategoryProvider>().toggleCategory(category);
          },
          activeColor: const Color(0xFFE91E63),
        ),
      ),
    );
  }
}
