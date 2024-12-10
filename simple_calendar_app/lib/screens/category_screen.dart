import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:simple_calendar_app/common/botton_navigator.dart';
import 'package:simple_calendar_app/common/common_app_bar.dart';
import '../providers/category_provider.dart';
import '../widgets/category_list_item.dart';

class CategoryScreen extends StatefulWidget {
  const CategoryScreen({super.key});

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
      appBar: const CommonAppBar(
        title: Text(
          'Calendar Categories',
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          Icon(Icons.notifications),
          Icon(Icons.settings),
        ],
      ),
      backgroundColor: const Color(0xFF1A1B1E),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // _buildHeader(),
            const SizedBox(height: 20),
            _buildCategoryList(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFFE91E63),
        child: const Icon(Icons.add),
        onPressed: () => _showAddCategoryModal(context),
      ),
      bottomNavigationBar: const BottomNavigator(currentIndex: 1),
    );
  }

  Widget _buildHeader() {
    return const Row(
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
          return const Center(child: CircularProgressIndicator());
        }

        if (provider.categories.isEmpty) {
          return const Center(
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
      backgroundColor: const Color(0xFF2A2B2E),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => const AddCategoryModal(),
    );
  }
}

class AddCategoryModal extends StatefulWidget {
  const AddCategoryModal({super.key});

  @override
  _AddCategoryModalState createState() => _AddCategoryModalState();
}

class _AddCategoryModalState extends State<AddCategoryModal> {
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  String _selectedIcon = 'fitness';

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Add Category',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.close, color: Colors.white),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
          const SizedBox(height: 20),
          const Text('Category Name', style: TextStyle(color: Colors.white)),
          TextField(
            controller: _nameController,
            decoration: InputDecoration(
              hintText: 'Enter category name',
              hintStyle: const TextStyle(color: Colors.grey),
              filled: true,
              fillColor: const Color(0xFF1A1B1E),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
          const SizedBox(height: 20),
          const Text('Description', style: TextStyle(color: Colors.white)),
          TextField(
            controller: _descriptionController,
            decoration: InputDecoration(
              hintText: 'Enter category description',
              hintStyle: const TextStyle(color: Colors.grey),
              filled: true,
              fillColor: const Color(0xFF1A1B1E),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
          const SizedBox(height: 20),
          const Text('Icon', style: TextStyle(color: Colors.white)),
          Row(
            children: [
              _buildIconOption('fitness', Icons.fitness_center),
              _buildIconOption('study', Icons.book),
              _buildIconOption('work', Icons.work),
              _buildIconOption('finance', Icons.attach_money),
            ],
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFE91E63),
                padding: const EdgeInsets.symmetric(vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: _addCategory,
              child: const Text('Add Category'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIconOption(String iconName, IconData icon) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedIcon = iconName;
        });
      },
      child: Container(
        margin: const EdgeInsets.only(right: 10),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: _selectedIcon == iconName
              ? const Color(0xFFE91E63)
              : const Color(0xFF1A1B1E),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: Colors.white),
      ),
    );
  }

  void _addCategory() {
    final name = _nameController.text;
    final description = _descriptionController.text;

    if (name.isNotEmpty && description.isNotEmpty) {
      context.read<CategoryProvider>().addCategory(
            name: name,
            description: description,
            iconName: _selectedIcon,
          );
      Navigator.pop(context);
    }
  }
}
