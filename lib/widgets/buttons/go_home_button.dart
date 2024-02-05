import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:trivioso/providers/providers.dart';

class GoHomeButton extends ConsumerWidget {
  const GoHomeButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      onTap: () {
        ref.invalidate(quizRepositoryProvider);
        ref.invalidate(quizTabStatusProvider);
        ref.invalidate(currentIndexProvider);
        ref.read(quizControllerProvider.notifier).reset();
        context.go('/');
      },
      child: Container(
          height: 50,
          width: 50,
          decoration: BoxDecoration(
            color: Colors.grey,
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Icon(
            Icons.home,
            color: Colors.white,
            size: 24,
          )),
    );
  }
}
