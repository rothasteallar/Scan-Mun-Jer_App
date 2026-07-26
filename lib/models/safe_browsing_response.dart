// Google API returns JSON
//          To
// SafeBrowsingResponse
//          To
// Extract isThreat + threatTypes
//          To
// Put into ScanResult, save to sqlite



class SafeBrowsingResponse {
  final bool isThreat;
  //google provide many threat types in one url
  final List<String> threatTypes;

  SafeBrowsingResponse({

    required this.isThreat,
    required this.threatTypes,

  });


}
