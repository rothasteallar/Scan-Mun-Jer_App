//Connect everything togther
//Decide the work flow

// What it needs to do:

// Take a URL and source qr or manual as input
// Call GoogleSafeBrowsingApi().checkUrl(url) first (Layer 1)
// If threat found, create ScanResult with verdict 'High Risk', skip Layer 2
// If clean, call RuleEngine().analyzeUrl(url) (Layer 2) - get verdict from score
// Save the ScanResult to database via DatabaseHelper()
// Return the ScanResult so the screen can display it
// Also provide getAllScans(), deleteScan(), deleteAllScans() for History screen — these just call DatabaseHelper() directly
import '../database_helper.dart';
import '../google_safebrowsing_api.dart';
import '../rule_engine.dart';
import '../../models/scan_result.dart';

class ScanRepository {
  static final ScanRepository instance = ScanRepository._internal();
  factory ScanRepository() => instance;
  ScanRepository._internal();

  final GoogleSafebrowsingApi api = GoogleSafebrowsingApi();
  final RuleEngine ruleEngine = RuleEngine();
  final DatabaseHelper db = DatabaseHelper();

  //Main method, run full scan on a url
  Future<ScanResult> scan(String url, String source) async {
    //Layer 1: Check with google safe browsing api
    final apiResult = await api.checkUrl(url);

    final ScanResult result;

    if (apiResult.isThreat) {
      result = ScanResult(
        url: url,
        verdict: 'High Risk',
        riskScore: 100,
        source: source,
        timestamp: DateTime.now().millisecondsSinceEpoch,
        triggeredRules: [],
        threatTypes: apiResult.threatTypes,
      );
    } else {
      //Layer 2: Check with local rules
      final ruleResult = ruleEngine.analyzeUrl(url);
      result = ScanResult(
        url: url,
        verdict: ruleResult.verdict,
        riskScore: ruleResult.score,
        source: source,
        timestamp: DateTime.now().millisecondsSinceEpoch,
        triggeredRules: ruleResult.triggeredRules
            .map((triggerRule) => triggerRule.name)
            .toList(),
        threatTypes: [],
      );
    }

    // //Save to database
    // await db.insertScan(result);

    // return result;
    final int id = await db.insertScan(result);
    return result.copyWith(id: id);
  }

  //get all scan for history screen
  Future<List<ScanResult>> getAllScans() async {
    return await db.getAllScans();
  }

  //Delete one scan
  Future<void> deleteScan(int id) async {
    await db.deleteScan(id);
  }

    // delete all scans
  Future<void> deleteAllScans() async {
    await db.deleteAllScans();
  }
}
