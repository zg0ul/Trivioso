import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:trivioso/providers/providers.dart';

// A button to go to the next question or finish the quiz
class StartQuizButton extends ConsumerWidget {
  const StartQuizButton({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedCategory = ref.watch(selectedCategoryProvider);
    final selectedDifficulty = ref.watch(selectedDifficultyProvider);
    return GestureDetector(
      onTap: () {
        if (selectedCategory != null && selectedDifficulty != null) {
          context.go('/quiz');
        } else {
          if (selectedCategory == null) {
            ref.read(shouldShowCategorySelectionErrorProvider.notifier).state =
                true;
          }
          if (selectedDifficulty == null) {
            ref.read(shouldShowDifficultySelectionErrorProvider.notifier).state =
                true;
          }
        }
      },
      child: Container(
        height: 50,
        width: MediaQuery.of(context).size.width / 1.5,
        decoration: BoxDecoration(
          color: selectedCategory != null && selectedDifficulty != null
              ? Colors.cyan.shade400
              : Colors.grey,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Center(
          child: Text(
            'Start Quiz',
            style: GoogleFonts.barlow(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}
