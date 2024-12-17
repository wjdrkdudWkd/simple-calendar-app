import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/category_provider.dart';
import '../models/category_item.dart';

class CategoryDropdown extends StatelessWidget {
  const CategoryDropdown({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<CategoryProvider>(
      builder: (context, provider, child) {
        return DropdownButton<CategoryItem>(
          dropdownColor: Colors.grey[850],
          underline: Container(),
          icon: const Icon(Icons.arrow_drop_down, color: Colors.white),
          items: provider.categories.map((category) {
            return DropdownMenuItem<CategoryItem>(
              value: category,
              child: Row(
                children: [
                  Icon(
                    _getIconData(category.iconName),
                    color: Colors.pink,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    category.name,
                    style: const TextStyle(color: Colors.white),
                  ),
                ],
              ),
            );
          }).toList(),
          onChanged: (CategoryItem? category) {
            if (category != null && category.id != null) {
              provider.toggleCategorySelection(category.id!);
            }
          },
        );
      },
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
