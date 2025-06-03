import 'dart:collection';

import 'package:savings_goal_calc_cli/helper.dart' show monthsUntilEndDate;
import 'package:savings_goal_calc_cli/models/enums/calculate_by.dart';
import 'package:savings_goal_calc_cli/models/goal.dart';

class Calculator {
  final List<Goal> goals;
  final double monthlyContribution;
  final CalculateBy calculationType;

  Calculator({
    required this.goals,
    required this.monthlyContribution,
    required this.calculationType,
  });

  double calculateTotalAmountLeftToSave() {
    double amountNeeded = 0.0;

    for (Goal goal in goals) {
      amountNeeded += calculateRemainingAmount(goal);
    }

    return amountNeeded;
  }

  double calculateRemainingAmount(Goal goal) {
    return goal.targetAmount - goal.startingAmount;
  }

  double calculateMonthlySavings(Goal goal) {
    final remainingAmount = calculateRemainingAmount(goal);
    final monthsRemaining = monthsUntilEndDate(goal.endDate);
    return remainingAmount / monthsRemaining;
  }

  double calculateTotalMonthlySavings() {
    double totalMonthlySavings = 0.0;

    for (Goal goal in goals) {
      totalMonthlySavings += calculateMonthlySavings(goal);
    }

    return totalMonthlySavings;
  }

  double calculateSavingsPerGoal() => switch (calculationType) {
    CalculateBy.equalMonthlyCost => calculateTotalMonthlySavings(),
  };

  LinkedHashMap<int, LinkedHashMap<String, double>>
  calculateSavingsDistribution() {
    // Description of hash map: { monthIndex: { 'goalId': amount } }
    LinkedHashMap<int, LinkedHashMap<String, double>> distribution =
        LinkedHashMap<int, LinkedHashMap<String, double>>();

    for (Goal goal in goals) {
      double savings = calculateMonthlySavings(goal);
      final monthsRemaining = monthsUntilEndDate(goal.endDate);

      for (int i = 0; i < monthsRemaining; i++) {
        distribution.update(
          i,
          (previousMonthValue) {
            previousMonthValue.update(
              'Total',
              (totalMonthlyValue) => totalMonthlyValue + savings,
              ifAbsent: () => savings,
            );
            previousMonthValue.putIfAbsent(goal.id, () => savings);
            return previousMonthValue;
          },
          ifAbsent: () => LinkedHashMap<String, double>.from({
            'Total': savings,
            goal.id: savings,
          }),
        );
      }
    }

    return distribution;
  }
}
