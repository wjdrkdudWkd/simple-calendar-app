import 'package:flutter/foundation.dart';
import '../app_database.dart';
import '../models/category_item.dart';

class CategoryProvider extends ChangeNotifier {
  List<CategoryItem> _categories = [];
  bool _isLoading = false;

  List<CategoryItem> get categories => _categories;
  bool get isLoading => _isLoading;

  Future<void> loadCategories() async {
    _isLoading = true;
    notifyListeners();

    try {
      final db = AppDatabase.instance;
      final result = await db.getCategories();
      _categories = result
          .map((item) => CategoryItem.fromMap(Map<String, dynamic>.from(item)))
          .toList();
    } catch (e) {
      print('Error loading categories: $e');
      _categories = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addCategory({
    required String name,
    required String description,
    required String iconName,
  }) async {
    try {
      final category = CategoryItem(
        name: name,
        description: description,
        iconName: iconName,
      );

      final db = AppDatabase.instance;
      await db.insertCategory(category.toMap());
      await loadCategories();
    } catch (e) {
      print('Error adding category: $e');
    }
  }

  Future<void> toggleCategorySelection(int id) async {
    try {
      final categoryIndex = _categories.indexWhere((c) => c.id == id);
      if (categoryIndex != -1) {
        final category = _categories[categoryIndex];
        final updatedCategory =
            category.copyWith(isSelected: !category.isSelected);

        final db = AppDatabase.instance;
        await db.updateCategory(id, updatedCategory.toMap());
        await loadCategories();
      }
    } catch (e) {
      print('Error toggling category: $e');
    }
  }

  Future<void> deleteCategory(int id) async {
    try {
      final db = AppDatabase.instance;
      await db.deleteCategory(id);
      await loadCategories();
    } catch (e) {
      print('Error deleting category: $e');
    }
  }
}
