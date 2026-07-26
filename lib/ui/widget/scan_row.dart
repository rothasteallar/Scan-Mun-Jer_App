import 'package:flutter/material.dart';
import 'verdict_badge.dart';

// one row in history list
class ScanRow extends StatelessWidget {
  final String url;
  final String verdict;
  final int timestamp;
  final String source;
  final VoidCallback onTap;
  final VoidCallback onLongPress;

  const ScanRow({
    super.key,
    required this.url,
    required this.verdict,
    required this.timestamp,
    required this.source,
    required this.onTap,
    required this.onLongPress,
  });

  Color get _dotColor {
    if (verdict == 'Safe') return const Color(0xFF22C55E);
    if (verdict == 'Suspicious') return const Color(0xFFF59E0B);
    return const Color(0xFFEF4444);
  }

  // turns timestamp into something like "3:45 PM"
  String _formatTime() {
    final date = DateTime.fromMillisecondsSinceEpoch(timestamp);
    int hour = date.hour;
    final minute = date.minute.toString().padLeft(2, '0');
    final isPM = hour >= 12;
    if (hour == 0) hour = 12;
    if (hour > 12) hour -= 12;
    return '$hour:$minute ${isPM ? 'PM' : 'AM'}';
  }

  String get _sourceLabel {
    if (source == 'qr') return 'QR scan';
    return 'Manual';
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      onLongPress: onLongPress,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 4),
        decoration: const BoxDecoration(
          border: Border(
            bottom: BorderSide(color: Color(0xFFE2E8F0), width: 0.5),
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                color: _dotColor,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    url,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontFamily: 'monospace',
                      fontSize: 13,
                      color: Color(0xFF1E293B),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${_formatTime()} · $_sourceLabel',
                    style: const TextStyle(
                      fontSize: 11,
                      color: Color(0xFF94A3B8),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            VerdictBadge(verdict: verdict),
          ],
        ),
      ),
    );
  }
}
