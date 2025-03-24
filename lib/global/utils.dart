import 'dart:math';

Map<DateTime, bool> generateRealisticDummyData() {
  final now = DateTime.now();
  final data = <DateTime, bool>{};
  final random = Random();

  // Generate 30 days of data with streaks
  for (int i = 0; i < 30; i++) {
    final date = now.subtract(Duration(days: 29 - i)); // Last 30 days

    // Create streaks (3-5 active days followed by 0-2 inactive days)
    if (i % 5 < 3 || random.nextDouble() > 0.3) {
      data[DateTime(date.year, date.month, date.day)] = true;
    } else {
      data[DateTime(date.year, date.month, date.day)] = false;
    }
  }

  // Ensure today is active
  data[DateTime(now.year, now.month, now.day)] = true;

  return data;
}
