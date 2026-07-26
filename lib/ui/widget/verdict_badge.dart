import 'package:flutter/material.dart';

// small pill badge for history rows
class VerdictBadge extends StatelessWidget {
  final String verdict;

  const VerdictBadge({super.key, required this.verdict});

  @override
  Widget build(BuildContext context) {
    Color bgColor;
    Color textColor;

    if (verdict == 'Safe') {
      bgColor = const Color(0xFFF0FDF4);
      textColor = const Color(0xFF15803D);
    } else if (verdict == 'Suspicious') {
      bgColor = const Color(0xFFFFFBEB);
      textColor = const Color(0xFFB45309);
    } else {
      bgColor = const Color(0xFFFEF2F2);
      textColor = const Color(0xFFB91C1C);
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(99),
      ),
      child: Text(
        verdict,
        style: TextStyle(
          fontSize: 10.5,
          fontWeight: FontWeight.w600,
          color: textColor,
        ),
      ),
    );
  }
}
