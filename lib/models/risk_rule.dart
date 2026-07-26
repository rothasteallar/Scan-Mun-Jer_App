class RiskRule {
  final int pointWeight; //how many point this rule add to the risk score
  final String description;
  final String name; //a local rule, put in the triggeredRules list

  RiskRule({
    required this.description,
    required this.pointWeight,
    required this.name,
  });
}
