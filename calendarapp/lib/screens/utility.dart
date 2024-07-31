import 'package:flutter/material.dart';

TimeOfDay parseTimeOfDay(String timeString) {
  // Regular expression to match the TimeOfDay format and capture hours and minutes
  final regex = RegExp(r"TimeOfDay\((\d{2}):(\d{2})\)");

  final match = regex.firstMatch(timeString);

  if (match != null && match.groupCount == 2) {
    final hours = int.parse(match.group(1)!);
    final minutes = int.parse(match.group(2)!);

    return TimeOfDay(hour: hours, minute: minutes);
  } else {
    throw FormatException('Invalid time format: $timeString');
  }
}

DateTime parseDateTime(String dateTimeString) {
  try {
    // Attempt to parse the string using DateTime.parse
    return DateTime.parse(dateTimeString);
  } catch (e) {
    throw FormatException('Invalid date-time format: $e');
  }
}
