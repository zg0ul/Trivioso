import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:trivioso/controllers/quiz/quiz_state.dart';
import 'package:trivioso/models/question_model.dart';
import 'package:trivioso/providers/providers.dart';

class QuizResults extends ConsumerWidget {
  final QuizState state;
  final List<Question> questions;
  const QuizResults({super.key, required this.state, required this.questions});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          '${state.correct.length} / ${questions.length}',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 60,
            fontWeight: FontWeight.w600,
          ),
        ),
        const Text(
          'CORRECT',
          style: TextStyle(
            color: Colors.white,
            fontSize: 48,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 40),
        ElevatedButton(
          onPressed: () {
            ref.invalidate(quizRepositoryProvider);
            ref.invalidate(quizTabStatusProvider);
            ref.invalidate(currentIndexProvider);
            ref.read(quizControllerProvider.notifier).reset();
          },
          child: const Text('Play Again'),
        ),
      ],
    );
  }
}
