import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/category_provider.dart';

class CategoryDropdown extends StatelessWidget {
  const CategoryDropdown({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<CategoryProvider>(
      builder: (context, provider, child) {
        if (provider.isLoading) {
          return const CircularProgressIndicator();
        }

        // 'All' 옵션을 포함한 드롭다운 아이템 생성
        final dropdownItems = [
          DropdownMenuItem<String>(
            value: null,
            child: Text(
              'All Categories',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).appBarTheme.foregroundColor,
              ),
            ),
          ),
          ...provider.categories.map((category) {
            return DropdownMenuItem<String>(
              value: category.id,
              child: Text(
                category.name,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).appBarTheme.foregroundColor,
                ),
              ),
            );
          }),
        ];

        return DropdownButton<String>(
          value: provider.selectedCategoryId,
          items: dropdownItems,
          onChanged: (String? newValue) {
            provider.updateSelectedCategory(newValue);
            // TODO: 여기서 선택된 카테고리에 따른 이벤트 필터링 로직 추가
          },
          underline: Container(), // 밑줄 제거
          icon: const Icon(Icons.arrow_drop_down),
          iconSize: 24,
          elevation: 16,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).appBarTheme.foregroundColor,
          ),
          dropdownColor: Theme.of(context).appBarTheme.backgroundColor,
        );
      },
    );
  }
}
