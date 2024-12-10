import 'package:flutter/foundation.dart';
import '../models/category_model.dart';
import '../services/database_service.dart';
import 'package:uuid/uuid.dart';

class CategoryProvider extends ChangeNotifier {
  final DatabaseService _databaseService = DatabaseService();
  List<Categories> _categories = [];
  String? _selectedCategoryId;
  bool _isLoading = false;

  List<Categories> get categories => _categories;
  String? get selectedCategoryId => _selectedCategoryId;
  bool get isLoading => _isLoading;

  // 선택된 카테고리 ID 업데이트
  void updateSelectedCategory(String? categoryId) {
    _selectedCategoryId = categoryId;
    notifyListeners();
  }

  Future<void> loadCategories() async {
    _isLoading = true;
    notifyListeners();

    try {
      _categories = await _databaseService.getCategories();
    } catch (e) {
      print('Error loading categories: $e');
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> addCategory({
    required String name,
    required String description,
    required String iconName,
  }) async {
    final category = Categories(
      id: const Uuid().v4(),
      name: name,
      description: description,
      iconName: iconName,
    );

    try {
      await _databaseService.insertCategory(category);
      _categories.add(category);
      notifyListeners();
    } catch (e) {
      print('Error adding category: $e');
    }
  }

  Future<void> toggleCategory(Categories category) async {
    try {
      category.isEnabled = !category.isEnabled;
      await _databaseService.updateCategory(category);
      notifyListeners();
    } catch (e) {
      print('Error toggling category: $e');
    }
  }

  Future<void> deleteCategory(String id) async {
    try {
      await _databaseService.deleteCategory(id);
      _categories.removeWhere((category) => category.id == id);
      notifyListeners();
    } catch (e) {
      print('Error deleting category: $e');
    }
  }
}
