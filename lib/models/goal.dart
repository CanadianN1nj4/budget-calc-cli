class Goal {
  final String id;
  final String name;
  final DateTime endDate;
  final double startingAmount;
  final double targetAmount;

  Goal({
    required this.id,
    required this.name,
    required this.endDate,
    required this.startingAmount,
    required this.targetAmount,
  });

  @override
  String toString() {
    return 'Goal(id: $id, name: $name, endDate: $endDate, startingAmount: $startingAmount, targetAmount: $targetAmount)';
  }
}
