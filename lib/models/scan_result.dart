//Reprent Data for Result Screen and manage to put to database(sqlite)
class ScanResult {
  final int? id;
  final String url;
  final String verdict; //'Safe', 'Suspicious', 'High Risk'
  final int riskScore;  //total score
  final String source; //'qr' or 'manual'
  final int timestamp; // milliseconds since epoch, database has no Datetime type
  //There a list of rules
  final List<String> triggeredRules;
  final List<String> threatTypes; // from Google

  ScanResult({
     this.id,
    required this.url,
    required this.verdict,
    required this.riskScore,
    required this.source,
    required this.timestamp,
    required this.triggeredRules,
    required this.threatTypes,
  });

  //Convert object to Map for saving to sqflite(key = column, value = cell)
  //
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'url': url,
      'verdict': verdict,
      'riskScore': riskScore,
      'source': source,
      'timestamp': timestamp,
      //sql can't store List, so join into string
      'triggeredRules': triggeredRules.join(','),
      'threatTypes': threatTypes.join(','),
    };
  }

  //Convert Map to Object for reading from sqlite
  factory ScanResult.fromMap(Map<String, dynamic> map) {
    return ScanResult(
      id: map['id'] as int,
      url: map['url'] as String,
      verdict: map['verdict'] as String,
      riskScore: map['riskScore'] as int,
      source: map['source'] as String,
      timestamp: map['timestamp'] as int,
      //convert string back to a List
      triggeredRules: (map['triggeredRules'] as String).isNotEmpty ? (map['triggeredRules'] as String).split(',') : [],
      threatTypes: (map['threatTypes'] as String).isNotEmpty ? (map['threatTypes'] as String).split(',') : [],
    );
  }



  ScanResult copyWith({int? id}) {
  return ScanResult(
    id: id ?? this.id,
    url: url,
    verdict: verdict,
    riskScore: riskScore,
    source: source,
    timestamp: timestamp,
    triggeredRules: triggeredRules,
    threatTypes: threatTypes,
  );
}
}


