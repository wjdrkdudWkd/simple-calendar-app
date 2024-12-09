import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/category_provider.dart';
import '../widgets/category_list_item.dart';
import '../widgets/add_category_modal.dart';

class CategoryScreen extends StatefulWidget {
  @override
  _CategoryScreenState createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(
      () => context.read<CategoryProvider>().loadCategories(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF1A1B1E),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildHeader(),
            SizedBox(height: 20),
            _buildCategoryList(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color(0xFFE91E63),
        child: Icon(Icons.add),
        onPressed: () => _showAddCategoryModal(context),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Calendar Categories',
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildCategoryList() {
    return Consumer<CategoryProvider>(
      builder: (context, provider, child) {
        if (provider.isLoading) {
          return Center(child: CircularProgressIndicator());
        }

        if (provider.categories.isEmpty) {
          return Center(
            child: Text(
              'No categories yet',
              style: TextStyle(color: Colors.white),
            ),
          );
        }

        return Expanded(
          child: ListView.builder(
            itemCount: provider.categories.length,
            itemBuilder: (context, index) {
              return CategoryListItem(
                category: provider.categories[index],
              );
            },
          ),
        );
      },
    );
  }

  void _showAddCategoryModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Color(0xFF2A2B2E),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => AddCategoryModal(),
    );
  }
}
