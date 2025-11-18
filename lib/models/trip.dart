class Trip {
  final String id;
  final String destination;
  final String country;
  final DateTime startDate;
  final DateTime endDate;
  final int completionRate;
  final int daysLeft;
  final String weather;
  final String flag;

  Trip({
    required this.id,
    required this.destination,
    required this.country,
    required this.startDate,
    required this.endDate,
    required this.completionRate,
    required this.daysLeft,
    required this.weather,
    required this.flag,
  });

  String get dateRange {
    final nights = endDate.difference(startDate).inDays;
    return '$nights박${nights + 1}일';
  }
}
