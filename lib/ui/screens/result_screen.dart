//Recieve scan from ScanResult
//show depend on which layer dectected
//Already has VerdictBanner, RiskScoreBar, RuleCard

import 'package:flutter/material.dart';
import '../../models/risk_rule.dart';
import '../widget/verdict_banner.dart';
import '../widget/risk_score_bar.dart';
import '../widget/rule_card.dart';
import '../../data/repositories/scan_repository.dart'; //To get scan result
import '../../data/rule_engine.dart'; //To find the description of a triggerd rule
import '../../models/scan_result.dart'; //To display the scan data
import '../../data/google_safebrowsing_api.dart';

//Make the screen receive a ScanResult object:
class ResultScreen extends StatelessWidget {
  const ResultScreen({super.key, required this.scan});

  final ScanResult scan;

  //format timestamp to readable date
  String getFormattedDate() {
    final date = DateTime.fromMillisecondsSinceEpoch(scan.timestamp);
    return "${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute}";
  }


    // show confirmation dialog then delete
  void _deleteScan(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Delete this scan?'),
        content: const Text('This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              await ScanRepository().deleteScan(scan.id!);
              Navigator.pop(dialogContext); // close dialog
              Navigator.pop(context); // go back

            },
            child: const Text('Delete', style: TextStyle(color: Color(0xFFEF4444))),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    //Determine which result type you have, api or local
    final bool isGoogleCaught = scan.threatTypes.isNotEmpty;
    final List<RiskRule> allRules = RuleEngine().rules;
    
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF1E293B),
        title: const Text('Scan result'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // verdict banner
            VerdictBanner(verdict: scan.verdict),
            const SizedBox(height: 14),

            // url card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: const Color(0xFFE2E8F0)),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'SCANNED URL',
                    style: TextStyle(fontSize: 11, color: Color(0xFF94A3B8)),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    scan.url,
                    style: const TextStyle(
                      fontSize: 12,
                      fontFamily: 'monospace',
                      color: Color(0xFF6366F1),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "${getFormattedDate()} - ${scan.source == 'qr' ? 'QR scan' : 'Manual'}",
                    style: const TextStyle(
                      fontSize: 11,
                      color: Color(0xFF94A3B8),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),
            //Layer 1 : google caught it
            if (isGoogleCaught) ...[
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: const Color(0xFFFEF2F2),
                  border: Border.all(color: const Color(0xFFFECACA)),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Confirmed dangerous site',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFFB91C1C),
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Detected by Google Safe Browsing',
                      style: TextStyle(fontSize: 12, color: Color(0xFFDC2626)),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),
              const Text(
                'Why is this risky?',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF475569),
                ),
              ),
              const SizedBox(height: 8),
              // one card per threat type
              for (final threatType in scan.threatTypes)
                RuleCard(
                  name: threatType,
                  description:
                      threatDescriptions[threatType]??
                      'This link was flagged as dangerous by Google Safe Browsing',//incase there a new threat return
                ),
            ],
            // Layer 2 — local rules caught it
            if (!isGoogleCaught) ...[
              RiskScoreBar(riskScore: scan.riskScore, verdict: scan.verdict),


              const SizedBox(height: 14),
              if (scan.verdict != 'Safe') ...[
                Text(
                  scan.verdict == 'High Risk'
                      ? 'Why is this risky?'
                      : 'Why is this suspicious?',
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF475569),
                  ),
                ),
                const SizedBox(height: 8),
                // one card per triggered rule
                for (final ruleName in scan.triggeredRules)
                  for (final rule in allRules)
                    if (rule.name == ruleName)
                      RuleCard(
                        name: rule.name,
                        description: rule.description,
                      ),
              
              ],
            ],

            const SizedBox(height: 24),

            
            // delete button
            SizedBox(
              width: double.infinity,
              child: TextButton(
                onPressed: () => _deleteScan(context),
                style: TextButton.styleFrom(
                  backgroundColor: const Color(0xFFFEF2F2),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.delete_outline, color: Color(0xFFDC2626), size: 18),
                    SizedBox(width: 6),
                    Text(
                      'Delete',
                      style: TextStyle(
                        color: Color(0xFFDC2626),
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

          ],
        ),
      ),
    );
  }
}
