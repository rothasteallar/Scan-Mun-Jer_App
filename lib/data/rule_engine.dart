import '../models/risk_rule.dart';

// holds the result of local rule
class RuleEngineResult {
  final List<RiskRule> triggeredRules;
  final int score; //total score
  final String verdict;

  RuleEngineResult({
    required this.score,
    required this.triggeredRules,
    required this.verdict,
  });
}

class RuleEngine {
  final List<RiskRule> rules = [
    RiskRule(
      description: 'Uses a number address instead of a real website name',
      pointWeight: 30,
      name: 'ip_based_url',
    ),
    RiskRule(
      name: 'url_shortener',
      description: 'Link is shortened, destination is hidden',
      pointWeight: 20,
    ),
    RiskRule(
      name: 'lookalike_domain',
      description: 'Website name looks like a fake copy of a real one',
      pointWeight: 25,
    ),
    RiskRule(
      name: 'suspicious_tld',
      description: 'Unusual website ending often used in scam links',
      pointWeight: 15,
    ),
    RiskRule(
      name: 'too_many_subdomains',
      description:
          'Overly complicated address — legitimate sites rarely do this',
      pointWeight: 10,
    ),
  ];

  //analyze the url and return result to RuleEngineResult
  RuleEngineResult analyzeUrl(String url) {
    final List<RiskRule> triggered = [];
    int score = 0;
    String verdict;

    // rule 1 - IP-based URL EX: http://192.168.1.1/login
    //remove http/https and take only the first element
    final domain = url
        .replaceAll('http://', '')
        .replaceAll('https://', '')
        .split('/')[0];

    bool isIpAddress(String domain) {
      final parts = domain.split('.');
      if (parts.length != 4) {
        return false;
      }
      for (final part in parts) {
        final number = int.tryParse(part);

        if (number == null) {
          return false;
        }
      }
      return true;
    }

    if (isIpAddress(domain)) {
      triggered.add(rules[0]);
      score += rules[0].pointWeight;
    }

    // rule 2 - known URL shorteners
    final List<String> shorteners = [
      'bit.ly',
      'tinyurl.com',
      't.co',
      'goo.gl',
      'ow.ly',
    ];

    bool isShortener = false;
    for (final shortener in shorteners) {
      if (url.contains(shortener)) {
        isShortener = true;
        break;
      }
    }

    if (isShortener) {
      triggered.add(rules[1]);
      score += rules[1].pointWeight;
    }

    // rule 3 - lookalike domain
    final List<String> lookalikes = [
      'paypa1',
      'g00gle',
      'faceb00k',
      'ab4',
      'amaz0n',
      'app1e',
    ];

    bool isLookalikes = false;
    for (final lookalike in lookalikes) {
      if (url.contains(lookalike)) {
        isLookalikes = true;
        break;
      }
    }

    if (isLookalikes) {
      triggered.add(rules[2]);
      score += rules[2].pointWeight;
    }


    // rule 4 - suspicious TLD (Top-Level Domain)
    final List<String> suspiciousTlds = [
      '.tk',
      '.ml',
      '.xyz',
      '.click',
      '.top',
      '.zip',
      '.gq',
    ];
    bool isSuspiciousTlds = false;
    for (final suspiciousTld in suspiciousTlds) {
      if (url.contains(suspiciousTld)) {
        isSuspiciousTlds = true;
        break;
      }
    }

    if (isSuspiciousTlds) {
      triggered.add(rules[3]);
      score += rules[3].pointWeight;
    }


    // rule 5 — too many subdomains (more than 3 dots in domain)
    if (domain.split('.').length > 4) {
      triggered.add(rules[4]);
      score += rules[4].pointWeight;
    }

    // calculate verdict based on score
    if (score >= 50) {
      verdict = 'High Risk';
    } else if (score >= 21) {
      verdict = 'Suspicious';
    } else {
      verdict = 'Safe';
    }


    return RuleEngineResult(
      triggeredRules: triggered,
      score: score,
      verdict: verdict,
    );
  }
}
