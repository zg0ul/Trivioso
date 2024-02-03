import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:trivioso/providers/providers.dart';

class QuestionNumberInput extends ConsumerWidget {
  const QuestionNumberInput({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final questionNumberController =
        ref.watch(questionNumberControllerProvider);
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.8,
      child: TextField(
        controller: questionNumberController,
        decoration: const InputDecoration(
          fillColor: Color.fromARGB(20, 255, 255, 255),
          filled: true,
          contentPadding: EdgeInsets.all(15),
          hintText: 'Number of Questions',
          hintStyle: TextStyle(
            color: Colors.white,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(15)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(15)),
          ),
        ),
        style: GoogleFonts.barlow(
          fontSize: 15,
          color: Colors.white,
        ),
        keyboardType: TextInputType.number,
        textDirection: TextDirection.ltr,
        cursorColor: Colors.cyan,
        onChanged: (String value) {
          int? number = int.tryParse(value);
          if (number != null) {
            ref.read(numberOfQuestionsProvider.notifier).state = number;
            ref.read(questionNumberControllerProvider.notifier).state.value =
                TextEditingValue(
              text: number.toString(),
              selection: TextSelection.fromPosition(
                TextPosition(offset: questionNumberController.text.length),
              ),
            );
          }
        },
      ),
    );
  }
}
