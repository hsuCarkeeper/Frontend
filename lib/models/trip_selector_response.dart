class TripSelectorResponse {
  final List<TripSelectorItem> items;

  TripSelectorResponse({required this.items});

  factory TripSelectorResponse.fromJson(Map<String, dynamic> json) {
    return TripSelectorResponse(
      items: (json['items'] as List)
          .map(
              (item) => TripSelectorItem.fromJson(item as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'items': items.map((item) => item.toJson()).toList(),
    };
  }
}

class TripSelectorItem {
  final String id;
  final String title;
  final String country;
  final String city;
  final String startDate;
  final String endDate;
  final String flagEmoji;
  final int? dDay;

  TripSelectorItem({
    required this.id,
    required this.title,
    required this.country,
    required this.city,
    required this.startDate,
    required this.endDate,
    required this.flagEmoji,
    this.dDay,
  });

  factory TripSelectorItem.fromJson(Map<String, dynamic> json) {
    return TripSelectorItem(
      id: json['id'] as String,
      title: json['title'] as String,
      country: json['country'] as String,
      city: json['city'] as String,
      startDate: json['startDate'] as String,
      endDate: json['endDate'] as String,
      flagEmoji: json['flagEmoji'] as String,
      dDay: json['dDay'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'country': country,
      'city': city,
      'startDate': startDate,
      'endDate': endDate,
      'flagEmoji': flagEmoji,
      if (dDay != null) 'dDay': dDay,
    };
  }

  DateTime get startDateTime => DateTime.parse(startDate);
  DateTime get endDateTime => DateTime.parse(endDate);

  String get dateRangeFormatted {
    final start = startDateTime;
    final end = endDateTime;
    return '${start.month}/${start.day} - ${end.month}/${end.day}';
  }

  int get calculatedDDay {
    if (dDay != null) return dDay!;
    final now = DateTime.now();
    final difference = startDateTime.difference(now).inDays;
    return difference;
  }
}
