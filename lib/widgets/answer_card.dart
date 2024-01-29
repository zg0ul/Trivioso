import 'package:flutter/material.dart';
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
            color: Colors.white,
            boxShadow: const [
              BoxShadow(
                color: Colors.black26,
                offset: Offset(0, 2),
                blurRadius: 4,
              ),
            ],
            borderRadius: BorderRadius.circular(100),
            border: Border.all(
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
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: isDisplayingAnswer && isCorrect
                        ? FontWeight.bold
                        : FontWeight.w400,
                  ),
                ),
              ),
              if (isDisplayingAnswer)
                isCorrect
                    ? const CircularIcon(icon: Icons.check, color: Colors.green)
                    : isSelected
                        ? const CircularIcon(
                            icon: Icons.close, color: Colors.red)
                        : const SizedBox.shrink(),
            ],
          )),
    );
  }
}
