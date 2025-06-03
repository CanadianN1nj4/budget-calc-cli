import 'dart:io';

import 'package:mocktail/mocktail.dart';
import 'package:savings_goal_calc_cli/models/goal.dart';
import 'package:test/test.dart';

import '../bin/savings_goal_calc_cli.dart';
import 'helper.dart' as helper_test;

class FakeStdin extends Mock implements Stdin {}

void main() {
  group('Helper', () {
    helper_test.main();
  });

  group('Create Goal', () {
    final happyGoalResponses = <String?>[
      'Test Goal',
      '2025-12-31',
      '1000.00',
      '5000.00',
    ];

    test('should create a goal with valid input', () {
      final stdin = FakeStdin();
      int readCount = 0;
      when(() => stdin.readLineSync()).thenAnswer((_) {
        if (readCount < happyGoalResponses.length) {
          return happyGoalResponses[readCount++];
        }
        throw StateError('readLineSync called more times than expected');
      });

      IOOverrides.runZoned(() {
        expect(() => createGoal(0), returnsNormally);
      }, stdin: () => stdin);
    });

    test('Goal should match valid user input', () {
      final stdin = FakeStdin();
      int readCount = 0;
      when(() => stdin.readLineSync()).thenAnswer((_) {
        if (readCount < happyGoalResponses.length) {
          return happyGoalResponses[readCount++];
        }
        throw StateError('readLineSync called more times than expected');
      });

      IOOverrides.runZoned(() {
        final actualGoal = createGoal(0);
        // The Goal class does not override == and hashCode.
        // It's better to compare fields individually or use `isA<Goal>().having(...)` matchers.
        // Also, createGoal(0) will produce an id of '0'.
        expect(
          actualGoal,
          isA<Goal>()
              .having((g) => g.id, 'id', '0')
              .having((g) => g.name, 'name', 'Test Goal')
              .having((g) => g.endDate, 'endDate', DateTime(2025, 12, 31))
              .having((g) => g.startingAmount, 'startingAmount', 1000.00)
              .having((g) => g.targetAmount, 'targetAmount', 5000.00),
        );
      }, stdin: () => stdin);
    });

    test('should handle null/empty inputs by using default values', () {
      final stdin = FakeStdin();
      final responses = <String?>[
        null, // Name -> defaults to "Goal N"
        null, // End Date -> defaults to DateTime.now().add(Duration(days: 365))
        null, // Starting Amount -> defaults to 0.0
        null, // Target Amount -> defaults to 0.0
      ];
      int readCount = 0;
      when(() => stdin.readLineSync()).thenAnswer((_) {
        if (readCount < responses.length) {
          return responses[readCount++];
        }
        throw StateError(
          'readLineSync called more times than expected for null/empty input test',
        );
      });

      IOOverrides.runZoned(() {
        // createGoal uses index for the ID and default name.
        // index -1 will result in id: '-1' and default name 'Goal 0'.
        final goalWithDefaults = createGoal(-1);

        expect(goalWithDefaults.id, '-1');
        expect(
          goalWithDefaults.name,
          'Goal 0',
        ); // 'Goal ${index + 1}' -> 'Goal ${-1 + 1}'

        // Default endDate is DateTime.now().add(Duration(days: 365)).
        // Exact assertion is tricky without time mocking.
        // We can check it's roughly a year from now or that it doesn't throw.
        // A simple check is that it's in the future.
        expect(
          goalWithDefaults.endDate.isAfter(
            DateTime.now().subtract(Duration(seconds: 10)),
          ),
          isTrue,
          reason: "Default end date should be in the future",
        );
        expect(
          goalWithDefaults.endDate.isBefore(
            DateTime.now().add(Duration(days: 366)),
          ),
          isTrue,
          reason: "Default end date should be roughly a year from now",
        );

        expect(goalWithDefaults.startingAmount, 0.0);
        expect(goalWithDefaults.targetAmount, 0.0);
      }, stdin: () => stdin);
    });
  });

  group('checkIfUserWantsToAddAnotherGoal', () {});
}
