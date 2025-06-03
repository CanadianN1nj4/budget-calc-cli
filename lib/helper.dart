// Helper function for formatting strings for table cells
// It handles padding and optional truncation with ellipsis.
import 'package:savings_goal_calc_cli/models/goal.dart';

String _formatCell(
  String text,
  int width, {
  bool alignLeft = true,
  bool truncate = false,
}) {
  if (truncate && text.length > width) {
    if (width < 3) {
      // Not enough space for "..."
      // Just truncate if width is too small for ellipsis
      text = text.length > width ? text.substring(0, width) : text;
    } else {
      text = "${text.substring(0, width - 3)}...";
    }
  }
  return alignLeft ? text.padRight(width) : text.padLeft(width);
}

void printGoalsTable(List<Goal> goals) {
  if (goals.isEmpty) {
    print("\nNo goals to display.");
    return;
  }

  // Define column widths - adjust as needed
  const int idWidth = 5;
  const int nameWidth = 25;
  const int dateWidth = 10; // For YYYY-MM-DD
  const int amountWidth = 12; // For currency amounts

  // Helper to format DateTime to 'YYYY-MM-DD'
  String formatDate(DateTime date) {
    return "${date.year.toString().padLeft(4, '0')}-"
        "${date.month.toString().padLeft(2, '0')}-"
        "${date.day.toString().padLeft(2, '0')}";
  }

  final String separator = " | ";

  // Headers
  final String idHeader = _formatCell("ID", idWidth);
  final String nameHeader = _formatCell("Name", nameWidth);
  final String endDateHeader = _formatCell("End Date", dateWidth);
  final String startAmountHeader = _formatCell(
    "Start Amt",
    amountWidth,
    alignLeft: false,
  );
  final String targetAmountHeader = _formatCell(
    "Target Amt",
    amountWidth,
    alignLeft: false,
  );

  final String headerRow =
      "$idHeader$separator$nameHeader$separator$endDateHeader$separator$startAmountHeader$separator$targetAmountHeader";

  // Calculate total width for the horizontal line separator
  final int totalWidth =
      idWidth +
      nameWidth +
      dateWidth +
      dateWidth +
      amountWidth +
      amountWidth +
      (5 * separator.length);
  final String lineSeparator = '-' * totalWidth;

  print(
    "\n$lineSeparator",
  ); // Add a newline for better spacing before the table
  print(headerRow);
  print(lineSeparator);

  for (final goal in goals) {
    final String idStr = _formatCell(goal.id, idWidth, truncate: true);
    final String nameStr = _formatCell(goal.name, nameWidth, truncate: true);
    final String endDateStr = _formatCell(formatDate(goal.endDate), dateWidth);
    final String startingAmountStr = _formatCell(
      goal.startingAmount.toStringAsFixed(2),
      amountWidth,
      alignLeft: false,
    );
    final String targetAmountStr = _formatCell(
      goal.targetAmount.toStringAsFixed(2),
      amountWidth,
      alignLeft: false,
    );

    print(
      "$idStr$separator$nameStr$separator$endDateStr$separator$startingAmountStr$separator$targetAmountStr",
    );
  }
  print(lineSeparator);
}

// Helper function to determine how many months are left until a goal's end date
int monthsUntilEndDate(DateTime endDate) {
  final now = DateTime.now();
  final months = (endDate.year - now.year) * 12 + (endDate.month - now.month);
  return months > 0 ? months : 0; // Ensure non-negative
}
