import 'package:savings_goal_calc_cli/helper.dart';
import 'package:test/test.dart';

void main() {
  group('Helper functions', () {
    group('monthsUntilEndDate', () {
      test('should return 0 for past date', () {
        final DateTime pastDate = DateTime(2020, 1, 1);
        final int months = monthsUntilEndDate(pastDate);
        expect(months, 0);
      });

      test('should return 0 for current date', () {
        final DateTime currentDate = DateTime.now();
        final int months = monthsUntilEndDate(currentDate);
        expect(months, 0);
      });

      test('should return 0 for end of month date', () {
        final DateTime startDate = DateTime(2025, 1, 1);
        final DateTime currentDate = DateTime(2025, 1, 31);
        final int months = monthsUntilEndDate(
          currentDate,
          startDate: startDate,
        );
        expect(months, 0);
      });

      test('should return 1 for the next month', () {
        final DateTime startDate = DateTime(2025, 1, 1);
        final DateTime nextMonth = DateTime(2025, 2, 1);
        final int months = monthsUntilEndDate(nextMonth, startDate: startDate);
        expect(months, 1);
      });

      test('should return correct number of months for future date', () {
        final DateTime startDate = DateTime(2023, 1, 1);
        final DateTime futureDate = DateTime(2025, 7, 1);
        final int months = monthsUntilEndDate(futureDate, startDate: startDate);
        expect(months, 30); // 2 years and 6 months
      });
    });
  });
}
