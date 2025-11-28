import 'package:flutter/material.dart';
import 'package:hancord_test/core/utils/textStyles..dart';

class CategoryChipsWidget extends StatelessWidget {
  final List<String> categories;
  final int selectedCategoryIndex;
  final Function(int) onCategorySelected;

  const CategoryChipsWidget({
    super.key,
    required this.categories,
    required this.selectedCategoryIndex,
    required this.onCategorySelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      color: Color(0xFFD7FFEA), // Light green background
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final isSelected = index == selectedCategoryIndex;

          if (isSelected) {
            // Selected category with gradient green background
            return GestureDetector(
              onTap: () => onCategorySelected(index),
              child: Container(
                margin: const EdgeInsets.only(right: 12),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Color(0xFF5FCD70), // Lighter green
                      Color(0xFF0E826B), // Lighter green
                    ],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Text(
                    categories[index],
                    style: getTextStylNunito(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            );
          } else {
            // Unselected category - plain text on light green background
            return GestureDetector(
              onTap: () => onCategorySelected(index),
              child: Container(
                margin: const EdgeInsets.only(right: 12),
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
                child: Center(
                  child: Text(
                    categories[index],
                    style: getTextStylNunito(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: Color(0xff040404),
                    ),
                  ),
                ),
              ),
            );
          }
        },
      ),
    );
  }
}

