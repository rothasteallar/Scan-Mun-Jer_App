import 'package:flutter/material.dart';

// score bar on result screen, made with Row + Expanded + flex
class RiskScoreBar extends StatelessWidget {
  final int riskScore;
  final String verdict;

  const RiskScoreBar({
    super.key,
    required this.riskScore,
    required this.verdict,
  });

  Color get _barColor {
    if (verdict == 'Safe') return const Color(0xFF22C55E);
    if (verdict == 'Suspicious') return const Color(0xFFF59E0B);
    return const Color(0xFFEF4444);
  }

  @override
  Widget build(BuildContext context) {
    int score = riskScore;
    if (score > 100) score = 100;
    if (score < 0) score = 0;

    // flex can't be 0 so keep it between 1 and 99
    int filledFlex = score;
    if (filledFlex < 1) filledFlex = 1;
    if (filledFlex > 99) filledFlex = 99;
    int emptyFlex = 100 - filledFlex;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Risk score',
                style: TextStyle(fontSize: 13, color: Color(0xFF475569)),
              ),
              Text(
                '$score',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: _barColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                flex: filledFlex,
                child: Container(height: 8, color: _barColor),
              ),
              Expanded(
                flex: emptyFlex,
                child: Container(height: 8, color: const Color(0xFFE2E8F0)),
              ),
            ],
          ),
          const SizedBox(height: 6),
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Safe',
                style: TextStyle(fontSize: 10, color: Color(0xFF94A3B8)),
              ),
              Text(
                'Suspicious',
                style: TextStyle(fontSize: 10, color: Color(0xFF94A3B8)),
              ),
              Text(
                'High Risk',
                style: TextStyle(fontSize: 10, color: Color(0xFF94A3B8)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
