import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../widgets/feature/top_nav_bar.dart';
import '../../widgets/feature/bottom_nav_bar.dart';
import '../../widgets/base/custom_card.dart';
import '../../widgets/base/custom_fab.dart';
import 'widgets/add_trip_modal.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  DateTime selectedDate = DateTime.now();
  List<Trip> trips = [
    Trip(
      destination: '도쿄',
      country: '일본',
      startDate: '2024-03-15',
      endDate: '2024-03-20',
      activities: ['city', 'food', 'culture'],
      memo: '벚꽃 시즌 여행',
    ),
    Trip(
      destination: '파리',
      country: '프랑스',
      startDate: '2024-05-10',
      endDate: '2024-05-17',
      activities: ['culture', 'food', 'shopping'],
      memo: '유럽 여행',
    ),
  ];

  void handleAddTrip(Trip trip) {
    setState(() {
      trips.add(trip);
    });
  }

  String formatDate(String dateString) {
    final date = DateTime.parse(dateString);
    return '${date.month}/${date.day}';
  }

  int getDaysUntil(String dateString) {
    final today = DateTime.now();
    final tripDate = DateTime.parse(dateString);
    final diffTime = tripDate.difference(today);
    return diffTime.inDays;
  }

  DateTime getCurrentMonth() {
    return DateTime(selectedDate.year, selectedDate.month, 1);
  }

  List<int?> getDaysInMonth() {
    final firstDay = getCurrentMonth();
    final lastDay = DateTime(firstDay.year, firstDay.month + 1, 0);
    final daysInMonth = lastDay.day;
    final startingDayOfWeek = firstDay.weekday % 7;

    final days = <int?>[];

    // 이전 달의 빈 날짜들
    for (int i = 0; i < startingDayOfWeek; i++) {
      days.add(null);
    }

    // 현재 달의 날짜들
    for (int day = 1; day <= daysInMonth; day++) {
      days.add(day);
    }

    return days;
  }

  bool isDateInTrip(int? day) {
    if (day == null) return false;

    final checkDate = DateTime(selectedDate.year, selectedDate.month, day);
    return trips.any((trip) {
      final startDate = DateTime.parse(trip.startDate);
      final endDate = DateTime.parse(trip.endDate);
      return checkDate.isAfter(startDate.subtract(const Duration(days: 1))) &&
          checkDate.isBefore(endDate.add(const Duration(days: 1)));
    });
  }

  void navigateMonth(int direction) {
    setState(() {
      selectedDate = DateTime(
        selectedDate.year,
        selectedDate.month + direction,
        1,
      );
    });
  }

  String getActivityName(String activity) {
    switch (activity) {
      case 'city':
        return '도시관광';
      case 'food':
        return '맛집투어';
      case 'culture':
        return '문화체험';
      case 'nature':
        return '자연탐방';
      case 'shopping':
        return '쇼핑';
      default:
        return activity;
    }
  }

  @override
  Widget build(BuildContext context) {
    final monthNames = [
      '1월',
      '2월',
      '3월',
      '4월',
      '5월',
      '6월',
      '7월',
      '8월',
      '9월',
      '10월',
      '11월',
      '12월'
    ];
    final dayNames = ['일', '월', '화', '수', '목', '금', '토'];

    return Scaffold(
      appBar: const TopNavBar(title: '캘린더', showBack: false),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 헤더
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '내 여행 일정',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    '다가오는 여행을 확인하고 관리하세요',
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // 달력
              CustomCard(
                child: Column(
                  children: [
                    // 달력 헤더
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          onPressed: () => navigateMonth(-1),
                          icon: const Icon(Icons.chevron_left),
                        ),
                        Text(
                          '${selectedDate.year}년 ${monthNames[selectedDate.month - 1]}',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        IconButton(
                          onPressed: () => navigateMonth(1),
                          icon: const Icon(Icons.chevron_right),
                        ),
                      ],
                    ),

                    // 요일 헤더
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Row(
                        children: dayNames.asMap().entries.map((entry) {
                          final index = entry.key;
                          final day = entry.value;
                          return Expanded(
                            child: Center(
                              child: Text(
                                day,
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: index == 0
                                      ? Colors.red
                                      : index == 6
                                          ? Colors.blue
                                          : Colors.grey[600],
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),

                    // 날짜 그리드
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 7,
                        childAspectRatio: 1,
                      ),
                      itemCount: getDaysInMonth().length,
                      itemBuilder: (context, index) {
                        final day = getDaysInMonth()[index];
                        if (day == null) {
                          return const SizedBox();
                        }

                        final isToday = day == DateTime.now().day &&
                            selectedDate.month == DateTime.now().month &&
                            selectedDate.year == DateTime.now().year;
                        final hasTrip = isDateInTrip(day);

                        return Center(
                          child: Container(
                            width: 32,
                            height: 32,
                            decoration: BoxDecoration(
                              color: isToday
                                  ? const Color(0xFF2E6BFF)
                                  : hasTrip
                                      ? const Color(0xFF2E6BFF).withOpacity(0.1)
                                      : Colors.transparent,
                              shape: BoxShape.circle,
                              border: hasTrip && !isToday
                                  ? Border.all(
                                      color: const Color(0xFF2E6BFF)
                                          .withOpacity(0.2),
                                      width: 2,
                                    )
                                  : null,
                            ),
                            child: Center(
                              child: Text(
                                day.toString(),
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: isToday
                                      ? Colors.white
                                      : hasTrip
                                          ? const Color(0xFF2E6BFF)
                                          : Colors.black87,
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),

                    // 범례
                    Padding(
                      padding: const EdgeInsets.only(top: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            children: [
                              Container(
                                width: 12,
                                height: 12,
                                decoration: const BoxDecoration(
                                  color: Color(0xFF2E6BFF),
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: 4),
                              Text(
                                '오늘',
                                style: TextStyle(
                                    fontSize: 12, color: Colors.grey[600]),
                              ),
                            ],
                          ),
                          const SizedBox(width: 16),
                          Row(
                            children: [
                              Container(
                                width: 12,
                                height: 12,
                                decoration: BoxDecoration(
                                  color:
                                      const Color(0xFF2E6BFF).withOpacity(0.1),
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: const Color(0xFF2E6BFF)
                                        .withOpacity(0.2),
                                    width: 2,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 4),
                              Text(
                                '여행 일정',
                                style: TextStyle(
                                    fontSize: 12, color: Colors.grey[600]),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // 빠른 액션
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          backgroundColor: Colors.transparent,
                          builder: (context) =>
                              AddTripModal(onSave: handleAddTrip),
                        );
                      },
                      child: CustomCard(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          child: Column(
                            children: [
                              Container(
                                width: 48,
                                height: 48,
                                decoration: BoxDecoration(
                                  color:
                                      const Color(0xFF2E6BFF).withOpacity(0.1),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.add,
                                  color: Color(0xFF2E6BFF),
                                  size: 24,
                                ),
                              ),
                              const SizedBox(height: 12),
                              const Text(
                                '새 여행 추가',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '새로운 여행을 계획하세요',
                                style: TextStyle(
                                    fontSize: 12, color: Colors.grey[600]),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: GestureDetector(
                      onTap: () => context.push('/templates'),
                      child: CustomCard(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          child: Column(
                            children: [
                              Container(
                                width: 48,
                                height: 48,
                                decoration: BoxDecoration(
                                  color: Colors.green.withOpacity(0.1),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.calendar_today,
                                  color: Colors.green,
                                  size: 24,
                                ),
                              ),
                              const SizedBox(height: 12),
                              const Text(
                                '템플릿 사용',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '미리 만든 템플릿 활용',
                                style: TextStyle(
                                    fontSize: 12, color: Colors.grey[600]),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // 여행 목록
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    '예정된 여행',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    '${trips.length}개',
                    style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              if (trips.isEmpty)
                CustomCard(
                  child: Padding(
                    padding: const EdgeInsets.all(32),
                    child: Column(
                      children: [
                        Icon(Icons.calendar_month,
                            size: 48, color: Colors.grey[400]),
                        const SizedBox(height: 16),
                        const Text(
                          '아직 계획된 여행이 없습니다',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '새 여행을 추가해서 계획을 시작해보세요',
                          style:
                              TextStyle(fontSize: 14, color: Colors.grey[600]),
                        ),
                      ],
                    ),
                  ),
                )
              else
                ...trips.map((trip) {
                  final daysUntil = getDaysUntil(trip.startDate);
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: CustomCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          trip.destination,
                                          style: const TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        Text(
                                          trip.country,
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.grey[600],
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 8),
                                    Row(
                                      children: [
                                        Icon(Icons.calendar_today,
                                            size: 14, color: Colors.grey[600]),
                                        const SizedBox(width: 4),
                                        Text(
                                          '${formatDate(trip.startDate)} - ${formatDate(trip.endDate)}',
                                          style: TextStyle(
                                            fontSize: 13,
                                            color: Colors.grey[600],
                                          ),
                                        ),
                                        const SizedBox(width: 12),
                                        Icon(Icons.access_time,
                                            size: 14, color: Colors.grey[600]),
                                        const SizedBox(width: 4),
                                        Text(
                                          daysUntil > 0
                                              ? '$daysUntil일 후'
                                              : daysUntil == 0
                                                  ? '오늘'
                                                  : '지난 여행',
                                          style: TextStyle(
                                            fontSize: 13,
                                            color: Colors.grey[600],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              IconButton(
                                icon: Icon(Icons.more_vert,
                                    color: Colors.grey[400]),
                                onPressed: () {},
                              ),
                            ],
                          ),
                          if (trip.memo.isNotEmpty) ...[
                            const SizedBox(height: 12),
                            Text(
                              trip.memo,
                              style: TextStyle(
                                  fontSize: 14, color: Colors.grey[600]),
                            ),
                          ],
                          const SizedBox(height: 12),
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: trip.activities.take(3).map((activity) {
                              return Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color:
                                      const Color(0xFF2E6BFF).withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  getActivityName(activity),
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: Color(0xFF2E6BFF),
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              const SizedBox(height: 80),
            ],
          ),
        ),
      ),
      floatingActionButton: CustomFAB(
        icon: Icons.add,
        onPressed: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            backgroundColor: Colors.transparent,
            builder: (context) => AddTripModal(onSave: handleAddTrip),
          );
        },
      ),
      bottomNavigationBar: const BottomNavBar(currentPath: '/calendar'),
    );
  }
}
