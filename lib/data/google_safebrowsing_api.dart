// Take a URL as input
// Send HTTP POST request to Google Safe Browsing API
// Parse the JSON response
// Return a SafeBrowsingResponse object

import 'dart:convert';

import 'package:http/http.dart';
import 'package:http/http.dart' as http;
import '../models/safe_browsing_response.dart';

const String _apiKey = "AIzaSyBMlANx483SnodfYmHpA-UcCX7VRs59eVc";
const String _apiUrl =
    "https://safebrowsing.googleapis.com/v4/threatMatches:find?key=$_apiKey";



const Map<String, String> threatDescriptions = {
  'MALWARE': 'This link may install harmful software on your device',
  'SOCIAL_ENGINEERING':'This link tries to steal your password or personal info',
  'UNWANTED_SOFTWARE': 'This link may install unwanted software on your device',
  'POTENTIALLY_HARMFUL_APPLICATION': 'This link may install a harmful app on your device',
};

class GoogleSafebrowsingApi {
  Future<SafeBrowsingResponse> checkUrl(String url) async {
    try {
      Response response = await http.post(
        Uri.parse(_apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "client": {"clientId": "Scan-Mun-Jer", "clientVersion": "1.0"},
          "threatInfo": {
            "threatTypes": [
              "MALWARE",
              "SOCIAL_ENGINEERING",
              'UNWANTED_SOFTWARE',
              'POTENTIALLY_HARMFUL_APPLICATION',
            ],
            "platformTypes": ["ANY_PLATFORM"],
            "threatEntryTypes": ["URL"],
            "threatEntries": [
              {"url": url},
            ],
          },
        }),
      );

      if (response.statusCode != 200) {
        return SafeBrowsingResponse(isThreat: false, threatTypes: []);
      }

      // parse the response
      Map<String, dynamic> result = jsonDecode(response.body);

      //if matches exist = threat found
      if (result['matches'] != null) {
        //extract all threat types from matches
        //threatType isn't response with List as request, but instead it return each threatType with each match(matchs = match1, match2...)
        List<String> threatTypes = [];
        for (var match in result['matches']) {
          threatTypes.add(match['threatType']);
        }
        return SafeBrowsingResponse(isThreat: true, threatTypes: threatTypes);
      }
      
    return SafeBrowsingResponse(isThreat: false, threatTypes: []);
    } catch (e) {
      //no internet or other error
      return SafeBrowsingResponse(isThreat: false, threatTypes: []);
    }

  }
}
