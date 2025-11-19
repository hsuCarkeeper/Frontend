import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

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
}

class TopNavBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool showBack;
  final List<Widget>? actions;

  const TopNavBar({
    super.key,
    required this.title,
    this.showBack = false,
    this.actions,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
          title,
          style: const TextStyle(color: Color(0xFF111111), fontWeight: FontWeight.bold)
      ),
      backgroundColor: Colors.white,
      elevation: 0,
      centerTitle: true,
      automaticallyImplyLeading: showBack,
      actions: actions,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class CustomCard extends StatelessWidget {
  final Widget child;
  final VoidCallback? onTap;
  final Color? backgroundColor;

  const CustomCard({
    super.key,
    required this.child,
    this.onTap,
    this.backgroundColor = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.05),
              spreadRadius: 1,
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: child,
      ),
    );
  }
}

class AddTripModal extends StatelessWidget {
  final void Function(Trip) onSave;
  const AddTripModal({super.key, required this.onSave});

  @override
  Widget build(BuildContext context) {
    const int step = 1;

    return Container(
      height: MediaQuery.of(context).size.height * 0.9,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 16, left: 16, right: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const SizedBox(width: 48),
                const Text(
                  '새 여행 계획',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          ),

          //진행 표시
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: LinearProgressIndicator(
              value: step / 4,
              backgroundColor: Colors.grey[200],
              valueColor: const AlwaysStoppedAnimation<Color>(
                Color(0xFF2E6BFF),
              ),
              minHeight: 8,
              borderRadius: BorderRadius.circular(4),
            ),
          ),

          const Expanded(child: SizedBox()),
        ],
      ),
    );
  }
}

class BottomNavBar extends StatelessWidget {
  final String currentPath;

  const BottomNavBar({super.key, required this.currentPath});

  @override
  Widget build(BuildContext context) {
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
                path: '/',
                isActive: currentPath == '/',
                onTap: () => context.go('/'),
              ),
              _NavItem(
                icon: Icons.calendar_today_outlined,
                activeIcon: Icons.calendar_today,
                label: '캘린더',
                path: '/calendar',
                isActive: currentPath == '/calendar',
                onTap: () => context.go('/calendar'),
              ),
              _NavItem(
                icon: Icons.check_box_outlined,
                activeIcon: Icons.check_box,
                label: '체크리스트',
                path: '/checklist',
                isActive: currentPath == '/checklist',
                onTap: () => context.go('/checklist'),
              ),
              _NavItem(
                icon: Icons.settings_outlined,
                activeIcon: Icons.settings,
                label: '설정',
                path: '/settings',
                isActive: currentPath == '/settings',
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
  final String path;
  final bool isActive;
  final VoidCallback onTap;

  const _NavItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
    required this.path,
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
              color: isActive
                  ? const Color(0xFF2E6BFF)
                  : const Color(0xFF555555),
              size: 24,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: isActive
                    ? const Color(0xFF2E6BFF)
                    : const Color(0xFF555555),
                fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}


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
      appBar: const TopNavBar(title: '내 여행 일정'),
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
                  const SizedBox(height: 4),
                  const Text(
                    '다가오는 여행을 확인하고 관리하세요',
                    style: TextStyle(fontSize: 14, color: Color(0xFF555555)),
                  ),
                ],
              ),
              const SizedBox(height: 20),


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
                          Icon(Icons.circle, size: 10, color: Color(0xFF2E6BFF)),
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
              const SizedBox(height: 16),

              CustomCard(
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
                        width: 56,
                        height: 56,
                        decoration: const BoxDecoration(
                          color: Color(0xFFE8F0FE),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.add,
                          color: Color(0xFF2E6BFF),
                          size: 32,
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
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const BottomNavBar(currentPath: '/calendar'),
    );
  }
}