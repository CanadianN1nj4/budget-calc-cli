import 'dart:collection' show LinkedHashMap;
import 'dart:io';

import 'package:savings_goal_calc_cli/calculator.dart';
import 'package:savings_goal_calc_cli/helper.dart';
import 'package:savings_goal_calc_cli/models/enums/calculate_by.dart';
import 'package:savings_goal_calc_cli/models/goal.dart';

void main(List<String> arguments) {
  print('Savings Goal Calculator CLI');
  print('How many goals do you want to enter?');
  int goalCount = int.tryParse(stdin.readLineSync() ?? '1') ?? 1;

  List<Goal> goals = [];

  for (int i = 0; i < goalCount; i++) {
    goals.add(createGoal(i));
  }

  goals = checkIfUserWantsToAddAnotherGoal(goals);

  print('What is your monthly contribution?');
  final double monthlyContribution =
      double.tryParse(stdin.readLineSync() ?? '0') ?? 0.0;

  print('How would you like to calculate your savings?');
  print('1. Save for the goals in equal parts');
  final int choice = int.tryParse(stdin.readLineSync() ?? '1') ?? 1;

  final CalculateBy calculationType = CalculateBy.values[choice - 1];

  final Calculator calculator = Calculator(
    goals: goals,
    monthlyContribution: monthlyContribution,
    calculationType: calculationType,
  );

  final double amountToSave = calculator.calculateTotalAmountLeftToSave();
  final LinkedHashMap<int, LinkedHashMap<String, double>> savingsDistribution =
      calculator.calculateSavingsDistribution();

  print('Total amount left to save: \$${amountToSave.toStringAsFixed(2)}');

  print('Savings distribution per month:');
  savingsDistribution.forEach((
    int monthIndex,
    LinkedHashMap<String, double> amounts,
  ) {
    print('Month ${monthIndex + 1}:');
    amounts.forEach((String title, double amount) {
      print('$title: \$${amount.toStringAsFixed(2)}');
    });
  });
}

Goal createGoal(int index) {
  print('Enter details for goal ${index + 1}:');
  print('Name:');
  String name = stdin.readLineSync() ?? 'Goal ${index + 1}';

  print('End Date (YYYY-MM-DD):');
  DateTime endDate = DateTime.parse(
    stdin.readLineSync() ??
        DateTime.now().add(Duration(days: 365)).toIso8601String(),
  );

  print('Starting Amount:');
  double startingAmount = double.tryParse(stdin.readLineSync() ?? '0') ?? 0.0;

  print('Target Amount:');
  double targetAmount = double.tryParse(stdin.readLineSync() ?? '0') ?? 0.0;

  return Goal(
    id: index.toString(),
    name: name,
    endDate: endDate,
    startingAmount: startingAmount,
    targetAmount: targetAmount,
  );
}

List<Goal> checkIfUserWantsToAddAnotherGoal(List<Goal> goals) {
  print('Do you want to add another goal? (y/n)');
  String? response = stdin.readLineSync();
  if (response?.toLowerCase() == 'y') {
    goals.add(createGoal(goals.length));
    goals = checkIfUserWantsToAddAnotherGoal(goals);
  } else {
    print('Goals entered:');
    printGoalsTable(goals);
  }
  return goals;
}
