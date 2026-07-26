import 'package:flutter/material.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';

// big banner on top of result screen
class VerdictBanner extends StatelessWidget {
  final String verdict;

  const VerdictBanner({super.key, required this.verdict});

  @override
  Widget build(BuildContext context) {
    Color bgColor;
    Color textColor;
    IconData icon;
    String subtitle;

    if (verdict == 'Safe') {
      bgColor = const Color(0xFFF0FDF4);
      textColor = const Color(0xFF15803D);
      icon = TablerIcons.shield_check;
      subtitle = 'Looks good';
    } else if (verdict == 'Suspicious') {
      bgColor = const Color(0xFFFFFBEB);
      textColor = const Color(0xFFB45309);
      icon = TablerIcons.alert_triangle;
      subtitle = 'Be careful with this link';
    } else {
      bgColor = const Color(0xFFFEF2F2);
      textColor = const Color(0xFFB91C1C);
      icon = TablerIcons.shield_x;
      subtitle = "Don't open this link";
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: textColor, size: 40),
          const SizedBox(height: 10),
          Text(
            verdict,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: textColor,
            ),
          ),
          const SizedBox(height: 2),
          Text(subtitle, style: TextStyle(fontSize: 12, color: textColor)),
        ],
      ),
    );
  }
}
