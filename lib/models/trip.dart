// 기존 로컬 Trip 모델 (체크리스트 화면용)
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

// 체크리스트 아이템
class ChecklistItem {
  final String id;
  final String title;
  bool isCompleted;

  ChecklistItem({
    required this.id,
    required this.title,
    this.isCompleted = false,
  });
}
