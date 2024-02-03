import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:trivioso/models/category_model.dart';
import 'package:trivioso/providers/providers.dart';

class CategoryDropdownWidget extends ConsumerWidget {
  final List<Category> categories;
  const CategoryDropdownWidget({super.key, required this.categories});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final Category? selectedCategory = ref.watch(selectedCategoryProvider);
    final categoryController = ref.watch(categoryControllerProvider);
    final List<DropdownMenuEntry<Category>> categoryEntries =
        <DropdownMenuEntry<Category>>[];
    for (final Category category in categories) {
      categoryEntries.add(
        DropdownMenuEntry<Category>(
          value: category,
          label: category.name,
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all<Color>(
              selectedCategory == category
                  ? Colors.white
                  : Colors.grey.shade900,
            ),
            foregroundColor: MaterialStateProperty.all<Color>(
              selectedCategory == category ? Colors.white70 : Colors.white,
            ),
          ),
        ),
      );
    }
    final shouldShowCategoryError =
        ref.watch(shouldShowCategorySelectionErrorProvider);

    return DropdownMenu(
      menuHeight: 300,
      width: MediaQuery.of(context).size.width * 0.8,
      inputDecorationTheme: const InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(15)),
        ),
        fillColor: Color.fromARGB(20, 255, 255, 255),
        filled: true,
        contentPadding: EdgeInsets.all(15),
      ),
      textStyle: GoogleFonts.barlow(
        fontSize: 15,
        color: Colors.white,
      ),
      menuStyle: MenuStyle(
        backgroundColor: MaterialStatePropertyAll(Colors.grey[900]),
        elevation: const MaterialStatePropertyAll(10),
      ),
      controller: categoryController,
      errorText: shouldShowCategoryError ? 'You need to choose a category' : null,
      dropdownMenuEntries: categoryEntries,
      onSelected: (Category? category) {
        ref.read(selectedCategoryProvider.notifier).state = category;
        ref.read(categoryIdProvider.notifier).state = category!.categoryId;
        ref.read(shouldShowCategorySelectionErrorProvider.notifier).state =
            false;
      },
    );
  }
}
