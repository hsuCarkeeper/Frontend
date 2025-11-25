class TripResponse {
  final List<TripItem> items;
  final String? nextCursor;

  TripResponse({
    required this.items,
    this.nextCursor,
  });

  factory TripResponse.fromJson(Map<String, dynamic> json) {
    return TripResponse(
      items: (json['items'] as List)
          .map((item) => TripItem.fromJson(item))
          .toList(),
      nextCursor: json['nextCursor'],
    );
  }
}

class TripItem {
  final String id;
  final String title;
  final String country;
  final String city;
  final String startDate;
  final String endDate;
  final int nights;
  final int days;
  final int dDay;
  final String flagEmoji;
  final double progress;

  TripItem({
    required this.id,
    required this.title,
    required this.country,
    required this.city,
    required this.startDate,
    required this.endDate,
    required this.nights,
    required this.days,
    required this.dDay,
    required this.flagEmoji,
    required this.progress,
  });

  factory TripItem.fromJson(Map<String, dynamic> json) {
    return TripItem(
      id: json['id'],
      title: json['title'],
      country: json['country'],
      city: json['city'],
      startDate: json['startDate'],
      endDate: json['endDate'],
      nights: json['nights'],
      days: json['days'],
      dDay: json['dDay'],
      flagEmoji: json['flagEmoji'],
      progress: (json['progress'] as num).toDouble(),
    );
  }

  // 진행률을 퍼센트로 변환
  int get progressPercentage => (progress * 100).round();

  // 날짜 포맷 (예: 3/15 - 3/20)
  String get dateRangeFormatted {
    final start = DateTime.parse(startDate);
    final end = DateTime.parse(endDate);
    return '${start.month}/${start.day} - ${end.month}/${end.day}';
  }

  // 여행 기간 (예: 5박 6일)
  String get tripDuration => '$nights박 $days일';
}
