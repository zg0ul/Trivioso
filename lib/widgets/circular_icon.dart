import 'package:flutter/material.dart';

class CircularIcon extends StatelessWidget {
  final IconData? icon;
  final Color color;
  const CircularIcon({
    super.key,
    this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 24,
      width: 24,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        border: Border.all(
          width: 1,
          color: color == Colors.transparent ? Colors.white : color,
        ),
        // boxShadow: const [
        //   BoxShadow(
        //     color: Colors.black26,
        //     offset: Offset(0, 2),
        //     blurRadius: 4,
        //   ),
        // ],
      ),
      child: icon == null
          ? const SizedBox.shrink()
          : Icon(
              icon,
              color: Colors.white,
              size: 16,
            ),
    );
  }
}
