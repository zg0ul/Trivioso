import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:trivioso/providers/providers.dart';

class QuitButton extends ConsumerWidget {
  const QuitButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      onTap: () {
        ref.invalidate(currentIndexProvider);
        context.go('/');
      },
      child: SizedBox(
        height: 50,
        width: MediaQuery.of(context).size.width / 2,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Icon(
              Icons.power_settings_new,
              color: Colors.white,
              size: 24,
            ),
            const SizedBox(width: 8),
            Text(
              'Quit Quiz',
              style: GoogleFonts.barlow(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
