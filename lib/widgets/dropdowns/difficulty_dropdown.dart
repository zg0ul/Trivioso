import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:trivioso/enums/difficulty.dart';
import 'package:trivioso/providers/providers.dart';

class DifficultyDropdownWidget extends ConsumerWidget {
  const DifficultyDropdownWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final Difficulty? selectedDifficulty =
        ref.watch(selectedDifficultyProvider);
    final difficultyController = ref.watch(difficultyControllerProvider);
    final List<DropdownMenuEntry<Difficulty>> difficultyEntries =
        <DropdownMenuEntry<Difficulty>>[];
    for (final Difficulty difficulty in Difficulty.values) {
      difficultyEntries.add(
        DropdownMenuEntry<Difficulty>(
          value: difficulty,
          label: difficulty.name,
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all<Color>(
              selectedDifficulty == difficulty
                  ? Colors.white
                  : Colors.grey.shade900,
            ),
            foregroundColor: MaterialStateProperty.all<Color>(
              selectedDifficulty == difficulty ? Colors.white70 : Colors.white,
            ),
          ),
        ),
      );
    }
    final shouldShowDifficultyError =
        ref.watch(shouldShowDifficultySelectionErrorProvider);

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
      controller: difficultyController,
      errorText:
          shouldShowDifficultyError ? 'You need to choose a difficulty' : null,
      dropdownMenuEntries: difficultyEntries,
      onSelected: (Difficulty? difficulty) {
        ref.read(selectedDifficultyProvider.notifier).state = difficulty;
        ref.read(shouldShowDifficultySelectionErrorProvider.notifier).state =
            false;
      },
    );
  }
}
