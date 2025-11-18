import 'package:flutter/material.dart';
import '../../widgets/feature/top_nav_bar.dart';
import '../../widgets/feature/bottom_nav_bar.dart';
import '../../widgets/base/custom_card.dart';

class ChecklistItem {
  final String id;
  final String title;
  final String category;
  bool isCompleted;
  final String priority; // 'high', 'medium', 'low'
  final int? daysBeforeDeparture;

  ChecklistItem({
    required this.id,
    required this.title,
    required this.category,
    required this.isCompleted,
    required this.priority,
    this.daysBeforeDeparture,
  });
}

class Trip {
  final String id;
  final String title;
  final String destination;
  final String startDate;
  final String endDate;
  final String flag;

  Trip({
    required this.id,
    required this.title,
    required this.destination,
    required this.startDate,
    required this.endDate,
    required this.flag,
  });
}

class ChecklistScreen extends StatefulWidget {
  final String? tripId;

  const ChecklistScreen({super.key, this.tripId});

  @override
  State<ChecklistScreen> createState() => _ChecklistScreenState();
}

class _ChecklistScreenState extends State<ChecklistScreen> {
  Trip? selectedTrip;
  String selectedCategory = '전체';

  final List<String> categories = ['전체', '서류', '교통', '숙박', '보험', '금융', '준비물'];

  final List<Trip> trips = [
    Trip(
      id: '1',
      title: '도쿄 여행',
      destination: '일본 도쿄',
      startDate: '2024-03-15',
      endDate: '2024-03-20',
      flag: '🇯🇵',
    ),
    Trip(
      id: '2',
      title: '파리 여행',
      destination: '프랑스 파리',
      startDate: '2024-04-10',
      endDate: '2024-04-17',
      flag: '🇫🇷',
    ),
    Trip(
      id: '3',
      title: '방콕 여행',
      destination: '태국 방콕',
      startDate: '2024-05-01',
      endDate: '2024-05-07',
      flag: '🇹🇭',
    ),
  ];

  final List<ChecklistItem> checklistItems = [
    ChecklistItem(
      id: '1',
      title: '여권 유효기간 확인',
      category: '서류',
      isCompleted: true,
      priority: 'high',
      daysBeforeDeparture: 30,
    ),
    ChecklistItem(
      id: '2',
      title: '비자 신청',
      category: '서류',
      isCompleted: false,
      priority: 'high',
      daysBeforeDeparture: 21,
    ),
    ChecklistItem(
      id: '3',
      title: '항공권 예약',
      category: '교통',
      isCompleted: true,
      priority: 'high',
      daysBeforeDeparture: 14,
    ),
    ChecklistItem(
      id: '4',
      title: '숙소 예약',
      category: '숙박',
      isCompleted: false,
      priority: 'high',
      daysBeforeDeparture: 14,
    ),
    ChecklistItem(
      id: '5',
      title: '여행자 보험 가입',
      category: '보험',
      isCompleted: false,
      priority: 'medium',
      daysBeforeDeparture: 7,
    ),
    ChecklistItem(
      id: '6',
      title: '현지 통화 환전',
      category: '금융',
      isCompleted: false,
      priority: 'medium',
      daysBeforeDeparture: 3,
    ),
    ChecklistItem(
      id: '7',
      title: '짐 싸기',
      category: '준비물',
      isCompleted: false,
      priority: 'medium',
      daysBeforeDeparture: 1,
    ),
    ChecklistItem(
      id: '8',
      title: '충전기 및 어댑터',
      category: '준비물',
      isCompleted: false,
      priority: 'low',
      daysBeforeDeparture: 1,
    ),
  ];

  @override
  void initState() {
    super.initState();
    if (widget.tripId != null && trips.isNotEmpty) {
      selectedTrip = trips.firstWhere(
        (trip) => trip.id == widget.tripId,
        orElse: () => trips.first,
      );
    } else if (trips.isNotEmpty) {
      selectedTrip = trips.first;
    }
  }

  void toggleItem(String id) {
    setState(() {
      final item = checklistItems.firstWhere((item) => item.id == id);
      item.isCompleted = !item.isCompleted;
    });
  }

  List<ChecklistItem> get filteredItems {
    if (selectedCategory == '전체') {
      return checklistItems;
    }
    return checklistItems
        .where((item) => item.category == selectedCategory)
        .toList();
  }

  int get completedCount =>
      checklistItems.where((item) => item.isCompleted).length;
  int get completionRate =>
      ((completedCount / checklistItems.length) * 100).round();

  Color getPriorityColor(String priority) {
    switch (priority) {
      case 'high':
        return Colors.red;
      case 'medium':
        return Colors.orange;
      case 'low':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  IconData getPriorityIcon(String priority) {
    switch (priority) {
      case 'high':
        return Icons.error_outline;
      case 'medium':
        return Icons.info_outline;
      case 'low':
        return Icons.check_circle_outline;
      default:
        return Icons.check_circle_outline;
    }
  }

  String formatDate(String dateString) {
    final date = DateTime.parse(dateString);
    return '${date.month}/${date.day}';
  }

  void showTripSelectorModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.7,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          children: [
            // 핸들
            Container(
              margin: const EdgeInsets.symmetric(vertical: 12),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            // 헤더
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    '여행 선택',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),
            const Divider(),
            // 여행 목록
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: trips.length,
                itemBuilder: (context, index) {
                  final trip = trips[index];
                  final isSelected = selectedTrip?.id == trip.id;
                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    child: CustomCard(
                      onTap: () {
                        setState(() {
                          selectedTrip = trip;
                        });
                        Navigator.pop(context);
                      },
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          border: isSelected
                              ? Border.all(
                                  color: const Color(0xFF2E6BFF), width: 2)
                              : null,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            Text(
                              trip.flag,
                              style: const TextStyle(fontSize: 40),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    trip.title,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    trip.destination,
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    '${formatDate(trip.startDate)} - ${formatDate(trip.endDate)}',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey[400],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            if (isSelected)
                              const Icon(
                                Icons.check_circle,
                                color: Color(0xFF2E6BFF),
                                size: 28,
                              ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TopNavBar(
        title: '체크리스트',
        showBack: widget.tripId != null,
        actions: [
          IconButton(
            icon: const Icon(Icons.list),
            onPressed: showTripSelectorModal,
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // 선택된 여행 정보
            if (selectedTrip != null)
              Padding(
                padding: const EdgeInsets.all(16),
                child: CustomCard(
                  onTap: showTripSelectorModal,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Text(
                            selectedTrip!.flag,
                            style: const TextStyle(fontSize: 32),
                          ),
                          const SizedBox(width: 12),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                selectedTrip!.title,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              Text(
                                selectedTrip!.destination,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey[600],
                                ),
                              ),
                              Text(
                                '${formatDate(selectedTrip!.startDate)} - ${formatDate(selectedTrip!.endDate)}',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey[400],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const Icon(Icons.keyboard_arrow_down, color: Colors.grey),
                    ],
                  ),
                ),
              ),

            // 진행률 카드
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF2E6BFF), Color(0xFF00B894)],
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              '여행 준비 현황',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '$completedCount/${checklistItems.length} 항목 완료',
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.8),
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              '$completionRate%',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              '완료율',
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.8),
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: LinearProgressIndicator(
                        value: completionRate / 100,
                        minHeight: 8,
                        backgroundColor: Colors.white.withOpacity(0.2),
                        valueColor:
                            const AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // 카테고리 필터
            SizedBox(
              height: 50,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: categories.length,
                itemBuilder: (context, index) {
                  final category = categories[index];
                  final isSelected = selectedCategory == category;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ChoiceChip(
                      label: Text(category),
                      selected: isSelected,
                      onSelected: (selected) {
                        setState(() {
                          selectedCategory = category;
                        });
                      },
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 16),

            // 체크리스트 아이템들
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: filteredItems.length,
              itemBuilder: (context, index) {
                final item = filteredItems[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: CustomCard(
                    onTap: () => toggleItem(item.id),
                    child: Row(
                      children: [
                        Container(
                          width: 24,
                          height: 24,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: item.isCompleted
                                  ? const Color(0xFF2E6BFF)
                                  : Colors.grey[300]!,
                              width: 2,
                            ),
                            color: item.isCompleted
                                ? const Color(0xFF2E6BFF)
                                : Colors.transparent,
                          ),
                          child: item.isCompleted
                              ? const Icon(
                                  Icons.check,
                                  size: 16,
                                  color: Colors.white,
                                )
                              : null,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item.title,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  decoration: item.isCompleted
                                      ? TextDecoration.lineThrough
                                      : null,
                                  color: item.isCompleted ? Colors.grey : null,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8, vertical: 2),
                                    decoration: BoxDecoration(
                                      color: Colors.grey[100],
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Text(
                                      item.category,
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey[600],
                                      ),
                                    ),
                                  ),
                                  if (item.daysBeforeDeparture != null) ...[
                                    const SizedBox(width: 8),
                                    Text(
                                      '출발 ${item.daysBeforeDeparture}일 전',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey[400],
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                            ],
                          ),
                        ),
                        Icon(
                          getPriorityIcon(item.priority),
                          size: 20,
                          color: getPriorityColor(item.priority),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),

            if (filteredItems.isEmpty)
              const Padding(
                padding: EdgeInsets.all(48),
                child: Column(
                  children: [
                    Icon(Icons.check_box_outline_blank,
                        size: 64, color: Colors.grey),
                    SizedBox(height: 16),
                    Text(
                      '해당 카테고리에 항목이 없어요',
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  ],
                ),
              ),

            const SizedBox(height: 80),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // TODO: AddItemModal 구현
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('항목 추가 기능은 준비 중입니다')),
          );
        },
        child: const Icon(Icons.add),
      ),
      bottomNavigationBar: const BottomNavBar(currentPath: '/checklist'),
    );
  }
}
