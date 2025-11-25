class ChecklistResponse {
  final String tripId;
  final ChecklistSummary summary;
  final List<ChecklistItemApi> items;

  ChecklistResponse({
    required this.tripId,
    required this.summary,
    required this.items,
  });

  factory ChecklistResponse.fromJson(Map<String, dynamic> json) {
    return ChecklistResponse(
      tripId: json['tripId'] as String,
      summary:
          ChecklistSummary.fromJson(json['summary'] as Map<String, dynamic>),
      items: (json['items'] as List)
          .map(
              (item) => ChecklistItemApi.fromJson(item as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'tripId': tripId,
      'summary': summary.toJson(),
      'items': items.map((item) => item.toJson()).toList(),
    };
  }
}

class ChecklistSummary {
  final int total;
  final int done;
  final double progress;

  ChecklistSummary({
    required this.total,
    required this.done,
    required this.progress,
  });

  factory ChecklistSummary.fromJson(Map<String, dynamic> json) {
    return ChecklistSummary(
      total: json['total'] as int,
      done: json['done'] as int,
      progress: (json['progress'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'total': total,
      'done': done,
      'progress': progress,
    };
  }

  int get progressPercentage => (progress * 100).round();
}

class ChecklistItemApi {
  final String id;
  final String title;
  final bool checked;
  final String? category;

  ChecklistItemApi({
    required this.id,
    required this.title,
    required this.checked,
    this.category,
  });

  factory ChecklistItemApi.fromJson(Map<String, dynamic> json) {
    return ChecklistItemApi(
      id: json['id'] as String,
      title: json['title'] as String,
      checked: json['checked'] as bool,
      category: json['category'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'checked': checked,
      if (category != null) 'category': category,
    };
  }
}
