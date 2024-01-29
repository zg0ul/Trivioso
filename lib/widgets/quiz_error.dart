import 'package:flutter/material.dart';
import 'package:trivioso/repositories/quiz/quiz_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class QuizError extends ConsumerWidget {
  final String message;
  const QuizError({
    Key? key,
    required this.message,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            message,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () => ref.refresh(quizRepositoryProvider),
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }
}
