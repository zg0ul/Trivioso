import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:html_character_entities/html_character_entities.dart';
import 'package:trivioso/widgets/circular_icon.dart';

class AnswerCard extends StatelessWidget {
  final String answer;
  final bool isSelected;
  final bool isCorrect;
  final bool isDisplayingAnswer;
  final VoidCallback onTap;
  const AnswerCard({
    super.key,
    required this.answer,
    required this.isSelected,
    required this.isCorrect,
    required this.isDisplayingAnswer,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(
          vertical: 12,
          horizontal: 20,
        ),
        padding: const EdgeInsets.symmetric(
          vertical: 12,
          horizontal: 20,
        ),
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.transparent,
          // boxShadow: const [
          //   BoxShadow(
          //     color: Colors.black26,
          //     offset: Offset(0, 2),
          //     blurRadius: 4,
          //   ),
          // ],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            width: 1,
            color: isDisplayingAnswer
                ? isCorrect
                    ? Colors.green
                    : isSelected
                        ? Colors.red
                        : Colors.white
                : Colors.white,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              child: Text(
                HtmlCharacterEntities.decode(answer),
                style: GoogleFonts.barlow(
                  color: isDisplayingAnswer && isCorrect
                      ? Colors.green
                      : Colors.white,
                  fontSize: 14,
                  fontWeight: isDisplayingAnswer && isCorrect
                      ? FontWeight.w600
                      : FontWeight.w500,
                ),
              ),
            ),
            // always show an empty circle if not displaying answer but change it to green check if answer is correct or rex x if answer is wrong
            CircularIcon(
              icon: isDisplayingAnswer
                  ? (isCorrect
                      ? Icons.check_rounded
                      : (isSelected ? Icons.close : null))
                  : null,
              color: isDisplayingAnswer
                  ? (isCorrect
                      ? Colors.green
                      : (isSelected ? Colors.red : Colors.transparent))
                  : Colors.transparent,
            ),
          ],
        ),
      ),
    );
  }
}
