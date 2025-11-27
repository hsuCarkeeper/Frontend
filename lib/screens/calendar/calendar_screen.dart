import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../models/trip.dart';
import '../../widgets/base/custom_card.dart';
import '../../widgets/feature/top_nav_bar.dart';
import 'widgets/add_trip_modal.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  DateTime selectedDate = DateTime.now();
  List<Trip> trips = [];

  void handleAddTrip(Trip trip) {
    setState(() {
      trips.add(trip);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('${trip.destination} 여행이 추가되었습니다.')),
    );
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
    for (int i = 0; i < startingDayOfWeek; i++) {
      days.add(null);
    }
    for (int day = 1; day <= daysInMonth; day++) {
      days.add(day);
    }
    return days;
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

  @override
  Widget build(BuildContext context) {
    final monthNames = [
      '1월', '2월', '3월', '4월', '5월', '6월', '7월', '8월', '9월', '10월', '11월', '12월'
    ];
    final dayNames = ['일', '월', '화', '수', '목', '금', '토'];

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: const TopNavBar(title: '여행 캘린더'),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${selectedDate.year}년 ${monthNames[selectedDate.month - 1]}',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF111111),
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    '다가오는 여행을 확인하고 관리하세요',
                    style: TextStyle(fontSize: 12, color: Color(0xFFABA9A9)),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // 캘린더 카드
              CustomCard(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                            onPressed: () => navigateMonth(-1),
                            icon: const Icon(Icons.chevron_left, color: Color(0xFF555555)),
                          ),
                          Text(
                            '${selectedDate.year}년 ${monthNames[selectedDate.month - 1]}',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF111111),
                            ),
                          ),
                          IconButton(
                            onPressed: () => navigateMonth(1),
                            icon: const Icon(Icons.chevron_right, color: Color(0xFF555555)),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                    Row(
                      children: dayNames.asMap().entries.map((entry) {
                        final index = entry.key;
                        final day = entry.value;
                        return Expanded(
                          child: Center(
                            child: Text(
                              day,
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: index == 0
                                    ? Colors.red
                                    : index == 6
                                    ? Colors.blue
                                    : const Color(0xFF555555),
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 8),

                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 7,
                        childAspectRatio: 1,
                      ),
                      itemCount: getDaysInMonth().length,
                      itemBuilder: (context, index) {
                        final day = getDaysInMonth()[index];
                        if (day == null) return const SizedBox();

                        final isToday = day == DateTime.now().day &&
                            selectedDate.month == DateTime.now().month &&
                            selectedDate.year == DateTime.now().year;

                        return Center(
                          child: Container(
                            width: 28,
                            height: 28,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: isToday ? const Color(0xFF2E6BFF) : Colors.transparent,
                            ),
                            child: Center(
                              child: Text(
                                day.toString(),
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                  color: isToday ? Colors.white : const Color(0xFF111111),
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),

                    const Padding(
                      padding: EdgeInsets.only(top: 16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.circle, size: 10, color: Color(0xFF2E80EC)),
                          SizedBox(width: 4),
                          Text("오늘", style: TextStyle(fontSize: 11, color: Color(0xFF555555))),
                          SizedBox(width: 16),
                          Icon(Icons.circle, size: 10, color: Color(0xFFE3F2FD)),
                          SizedBox(width: 4),
                          Text("여행 일정", style: TextStyle(fontSize: 11, color: Color(0xFF555555))),
                        ],
                      ),
                    )
                  ],
                ),
              ),
              const SizedBox(height: 12),

              // [수정] 새 여행 추가 카드 (너비 356 고정)
              Center(
                child: SizedBox(
                  width: 356,
                  child: CustomCard(
                    onTap: () {
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        backgroundColor: Colors.transparent,
                        builder: (context) => AddTripModal(onSave: handleAddTrip),
                      );
                    },

                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 24),
                      child: Column(
                        children: [
                          Container(
                            width: 90,
                            height: 48,
                            decoration: BoxDecoration(
                              color: const Color(0xFFE8F0FE),
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: const Icon(
                              Icons.add,
                              color: Color(0xFF2E80EC),
                              size: 28,
                            ),
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            '새 여행 추가',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF111111),
                            ),
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            '새로운 여행을 계획하세요',
                            style: TextStyle(fontSize: 12, color: Color(0xFF555555)),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomNavBar(context),
    );
  }

  Widget _buildBottomNavBar(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Colors.grey.shade200, width: 1)),
      ),
      child: SafeArea(
        child: SizedBox(
          height: 64,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _NavItem(
                icon: Icons.home_outlined,
                activeIcon: Icons.home,
                label: '홈',
                isActive: false,
                onTap: () => context.go('/'),
              ),
              _NavItem(
                icon: Icons.calendar_today_outlined,
                activeIcon: Icons.calendar_today,
                label: '캘린더',
                isActive: true,
                onTap: () {},
              ),
              _NavItem(
                icon: Icons.check_box_outlined,
                activeIcon: Icons.check_box,
                label: '체크리스트',
                isActive: false,
                onTap: () => context.go('/checklist'),
              ),
              _NavItem(
                icon: Icons.settings_outlined,
                activeIcon: Icons.settings,
                label: '설정',
                isActive: false,
                onTap: () => context.go('/settings'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final IconData activeIcon;
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const _NavItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              isActive ? activeIcon : icon,
              color: isActive ? const Color(0xFF2E80EC) : const Color(0xFF555555),
              size: 24,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: isActive ? const Color(0xFF2E80EC) : const Color(0xFF555555),
                fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}