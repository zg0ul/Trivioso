import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:trivioso/providers/providers.dart';

// A button to go to the next question or finish the quiz
class PlayAgainButton extends ConsumerWidget {
  const PlayAgainButton({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      onTap: () {
        // Use invalidate to reset the state of the providers to their initial state
        ref.invalidate(quizRepositoryProvider);
        ref.invalidate(quizTabStatusProvider);
        ref.invalidate(currentIndexProvider);
        ref.read(quizControllerProvider.notifier).reset();
      },
      child: Container(
        height: 50,
        width: MediaQuery.of(context).size.width / 1.5,
        decoration: BoxDecoration(
          color: 
               Colors.cyan.shade400,
              
          borderRadius: BorderRadius.circular(12),
        ),
        child: Center(
          child: Text(
            'Play again',
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
