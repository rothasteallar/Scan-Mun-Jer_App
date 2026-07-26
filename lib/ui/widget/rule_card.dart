import 'package:flutter/material.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';

// one card for a rule or threat type reason
class RuleCard extends StatelessWidget {
  final String name;
  final String description;

  const RuleCard({super.key, required this.name, required this.description});

  IconData get _icon {
    if (name == 'ip_based_url') {
      return TablerIcons.network;
    } else if (name == 'url_shortener') {
      return TablerIcons.link;
    } else if (name == 'lookalike_domain') {
      return TablerIcons.copy;
    } else if (name == 'suspicious_tld') {
      return TablerIcons.world;
    } else if (name == 'too_many_subdomains') {
      return TablerIcons.point;
    } else if (name == 'SOCIAL_ENGINEERING') {
      return TablerIcons.fish;
    } else if (name == 'MALWARE') {
      return TablerIcons.skull;
    } else if (name == 'UNWANTED_SOFTWARE') {
      return TablerIcons.bug;
    } else if (name == 'POTENTIALLY_HARMFUL_APPLICATION') {
      return TablerIcons.device_mobile_off;
    } else {
      return TablerIcons.alert_circle;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(_icon, color: const Color(0xFF6366F1), size: 22),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              description,
              style: const TextStyle(
                fontSize: 12.5,
                color: Color(0xFF1E293B),
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
