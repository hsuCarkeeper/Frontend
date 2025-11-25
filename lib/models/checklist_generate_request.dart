// ==========================================
// Enums
// ==========================================

enum TripPurpose {
  tourism('관광'),
  business('비즈니스'),
  vacation('휴양'),
  adventure('모험'),
  culturalExperience('문화체험'),
  visitingFriends('친구 방문'),
  other('기타');

  final String value;
  const TripPurpose(this.value);
}

enum LodgingType {
  hotel('호텔'),
  resort('리조트'),
  guestHouse('게스트하우스'),
  airbnb('에어비앤비'),
  hostel('호스텔'),
  other('기타');

  final String value;
  const LodgingType(this.value);
}

enum TransportMode {
  airplane('항공기'),
  train('기차'),
  bus('버스'),
  car('자동차'),
  ship('선박'),
  other('기타');

  final String value;
  const TransportMode(this.value);
}

enum ChecklistCategory {
  documents('서류'),
  transportation('교통'),
  accommodation('숙박'),
  insurance('보험'),
  finance('금융'),
  essentials('준비물');

  final String value;
  const ChecklistCategory(this.value);
}

// ==========================================
// Request Models
// ==========================================

class DestinationInfo {
  final String country;
  final String city;

  DestinationInfo({
    required this.country,
    required this.city,
  });

  Map<String, dynamic> toJson() {
    return {
      'country': country,
      'city': city,
    };
  }
}

class PeriodInfo {
  final String startDate; // YYYY-MM-DD
  final String endDate; // YYYY-MM-DD
  final int nights;
  final int days;

  PeriodInfo({
    required this.startDate,
    required this.endDate,
    required this.nights,
    required this.days,
  });

  Map<String, dynamic> toJson() {
    return {
      'startDate': startDate,
      'endDate': endDate,
      'nights': nights,
      'days': days,
    };
  }
}

class TravelersInfo {
  final int count;

  TravelersInfo({required this.count});

  Map<String, dynamic> toJson() {
    return {
      'count': count,
    };
  }
}

class BudgetInfo {
  final String rawInput;

  BudgetInfo({required this.rawInput});

  Map<String, dynamic> toJson() {
    return {
      'rawInput': rawInput,
    };
  }
}

class LodgingInfo {
  final LodgingType type;

  LodgingInfo({required this.type});

  Map<String, dynamic> toJson() {
    return {
      'type': type.value,
    };
  }
}

class TransportationInfo {
  final TransportMode type;

  TransportationInfo({required this.type});

  Map<String, dynamic> toJson() {
    return {
      'type': type.value,
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

  Map<String, dynamic> toJson() {
    return {
      'total': total,
      'done': done,
      'progress': progress,
    };
  }
}

class ChecklistItemInfo {
  final String id;
  final String title;
  final bool checked;

  ChecklistItemInfo({
    required this.id,
    required this.title,
    required this.checked,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'checked': checked,
    };
  }
}

class ExistingChecklistInfo {
  final ChecklistSummary summary;
  final List<ChecklistItemInfo> items;

  ExistingChecklistInfo({
    required this.summary,
    required this.items,
  });

  Map<String, dynamic> toJson() {
    return {
      'summary': summary.toJson(),
      'items': items.map((item) => item.toJson()).toList(),
    };
  }
}

/// LLM에게 넘길 체크리스트 생성 요청 타입
class ChecklistGenerateRequest {
  final String tripId;
  final String? locale;
  final DestinationInfo destination;
  final PeriodInfo period;
  final TravelersInfo travelers;
  final BudgetInfo? budget;
  final String purpose;
  final LodgingInfo lodging;
  final TransportationInfo transportation;
  final ExistingChecklistInfo? existingChecklist;

  ChecklistGenerateRequest({
    required this.tripId,
    this.locale = 'ko',
    required this.destination,
    required this.period,
    required this.travelers,
    this.budget,
    required this.purpose,
    required this.lodging,
    required this.transportation,
    this.existingChecklist,
  });

  Map<String, dynamic> toJson() {
    return {
      'tripId': tripId,
      if (locale != null) 'locale': locale,
      'destination': destination.toJson(),
      'period': period.toJson(),
      'travelers': travelers.toJson(),
      if (budget != null) 'budget': budget!.toJson(),
      'purpose': purpose,
      'lodging': lodging.toJson(),
      'transportation': transportation.toJson(),
      if (existingChecklist != null)
        'existingChecklist': existingChecklist!.toJson(),
    };
  }
}
