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

class TopNavBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool showBack;
  final List<Widget>? actions;
  const TopNavBar({super.key, required this.title, this.showBack = false, this.actions});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(title, style: const TextStyle(color: Color(0xFF111111), fontWeight: FontWeight.bold)),
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

class CustomCard extends StatelessWidget {
  final Widget child;
  final VoidCallback? onTap;
  const CustomCard({super.key, required this.child, this.onTap});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.05), blurRadius: 10, spreadRadius: 1)],
        ),
        child: child,
      ),
    );
  }
}



class ChecklistScreen extends StatefulWidget {
  final String? tripId;

  const ChecklistScreen({super.key, this.tripId});

  @override
  State<ChecklistScreen> createState() => _ChecklistScreenState();
}

class _ChecklistScreenState extends State<ChecklistScreen> {
  String filterStatus = 'all';
  Trip? selectedTrip;

  // 임시 데이터
  final List<Trip> trips = [
    Trip(
      id: '1',
      destination: '도쿄',
      country: '일본',
      startDate: DateTime(2024, 3, 15),
      endDate: DateTime(2024, 3, 20),
      completionRate: 0,
      daysLeft: 12,
      weather: '☀️',
      flag: '🇯🇵',
    ),
  ];

  final List<ChecklistItem> checklistItems = [
    ChecklistItem(id: '1', title: '여권 챙기기', isCompleted: true),
    ChecklistItem(id: '2', title: '환전하기', isCompleted: false),
    ChecklistItem(id: '3', title: '돼지코 어댑터', isCompleted: false),
    ChecklistItem(id: '4', title: '비상약', isCompleted: false),
  ];

  @override
  void initState() {
    super.initState();
    if (widget.tripId != null && trips.isNotEmpty) {
      selectedTrip = trips.firstWhere(
            (t) => t.id == widget.tripId,
        orElse: () => trips.first,
      );
    } else if (trips.isNotEmpty) {
      selectedTrip = trips.first;
    }
  }

  List<ChecklistItem> get filteredItems {
    switch (filterStatus) {
      case 'checked':
        return checklistItems.where((item) => item.isCompleted).toList();
      case 'unchecked':
        return checklistItems.where((item) => !item.isCompleted).toList();
      default:
        return checklistItems;
    }
  }

  int get completedCount => checklistItems.where((item) => item.isCompleted).length;
  int get completionRate => checklistItems.isEmpty
      ? 0
      : ((completedCount / checklistItems.length) * 100).round();

  void toggleItem(String id) {
    setState(() {
      final item = checklistItems.firstWhere((item) => item.id == id);
      item.isCompleted = !item.isCompleted;
    });
  }

  void showAddItemDialog() {
    final TextEditingController controller = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('새 항목 추가'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            hintText: '챙겨야 할 물건을 입력하세요',
            border: OutlineInputBorder(),
          ),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('취소', style: TextStyle(color: Colors.grey)),
          ),
          TextButton(
            onPressed: () {
              if (controller.text.isNotEmpty) {
                setState(() {
                  checklistItems.add(ChecklistItem(
                    id: DateTime.now().millisecondsSinceEpoch.toString(),
                    title: controller.text,
                    isCompleted: false,
                  ));
                });
                Navigator.pop(context);
              }
            },
            child: const Text('추가', style: TextStyle(color: Color(0xFF2E80EC))),
          ),
        ],
      ),
    );
  }

  void showTripSelectorModal() {
    if (trips.isEmpty) return;

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('여행 선택', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            ...trips.map((trip) => ListTile(
              leading: Text(trip.flag, style: const TextStyle(fontSize: 24)),
              title: Text('${trip.destination} 여행'),
              subtitle: Text('${trip.startDate.month}/${trip.startDate.day} - ${trip.endDate.month}/${trip.endDate.day}'),
              onTap: () {
                setState(() {
                  selectedTrip = trip;
                });
                Navigator.pop(context);
              },
              trailing: selectedTrip?.id == trip.id
                  ? const Icon(Icons.check, color: Color(0xFF2E80EC))
                  : null,
            )),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (selectedTrip == null) {
      return Scaffold(
        appBar: const TopNavBar(title: '체크리스트'),
        body: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.luggage_outlined, size: 64, color: Colors.grey),
              SizedBox(height: 16),
              Text('등록된 여행이 없습니다.', style: TextStyle(fontSize: 16, color: Colors.grey)),
            ],
          ),
        ),
        bottomNavigationBar: const BottomNavBar(currentPath: '/checklist'),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: TopNavBar(
        title: '체크리스트',
        actions: [
          IconButton(
            icon: const Icon(Icons.swap_horiz),
            onPressed: showTripSelectorModal,
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  // 여행 정보 카드
                  CustomCard(
                    onTap: showTripSelectorModal,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Text(selectedTrip!.flag, style: const TextStyle(fontSize: 32)),
                            const SizedBox(width: 12),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${selectedTrip!.destination} 여행',
                                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                                ),
                                Text(
                                  '${selectedTrip!.country} ${selectedTrip!.destination}',
                                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                                ),
                                Text(
                                  '${selectedTrip!.startDate.month}/${selectedTrip!.startDate.day} - ${selectedTrip!.endDate.month}/${selectedTrip!.endDate.day}',
                                  style: TextStyle(fontSize: 12, color: Colors.grey[400]),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const Icon(Icons.keyboard_arrow_down, color: Colors.grey),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // 진행률 카드
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                          colors: [
                        const Color(0xFF2E80EC).withOpacity(0.7), //피그마 파랑
                        const Color(0xFF009A6B).withOpacity(0.4), //피그마 녹색
                      ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF2E80EC).withOpacity(0.3),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
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
                                  style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  '$completedCount/${checklistItems.length} 항목 완료',
                                  style: TextStyle(color: Colors.white.withOpacity(0.9), fontSize: 14),
                                ),
                              ],
                            ),
                            Text(
                              '$completionRate%',
                              style: const TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: LinearProgressIndicator(
                            value: checklistItems.isEmpty ? 0 : completionRate / 100,
                            minHeight: 8,
                            backgroundColor: Colors.white.withOpacity(0.3),
                            valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // 필터 버튼
                  Row(
                    children: [
                      _FilterChip(
                        label: '전체',
                        isSelected: filterStatus == 'all',
                        onTap: () => setState(() => filterStatus = 'all'),
                      ),
                      const SizedBox(width: 8),
                      _FilterChip(
                        label: '체크',
                        isSelected: filterStatus == 'checked',
                        onTap: () => setState(() => filterStatus = 'checked'),
                      ),
                      const SizedBox(width: 8),
                      _FilterChip(
                        label: '미체크',
                        isSelected: filterStatus == 'unchecked',
                        onTap: () => setState(() => filterStatus = 'unchecked'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // 체크리스트 목록
                  if (filteredItems.isEmpty)
                    Padding(
                      padding: const EdgeInsets.all(40.0),
                      child: Center(
                        child: Text(
                          filterStatus == 'all' ? '항목을 추가해보세요!' : '해당하는 항목이 없습니다.',
                          style: const TextStyle(color: Colors.grey),
                        ),
                      ),
                    )
                  else
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
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
                                    color: item.isCompleted ? const Color(0xFF2E80EC) : Colors.transparent,
                                    border: Border.all(
                                      color: item.isCompleted ? const Color(0xFF2E80EC) : Colors.grey[300]!,
                                      width: 2,
                                    ),
                                  ),
                                  child: item.isCompleted
                                      ? const Icon(Icons.check, size: 16, color: Colors.white)
                                      : null,
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Text(
                                    item.title,
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: item.isCompleted ? Colors.grey : Colors.black87,
                                      decoration: item.isCompleted ? TextDecoration.lineThrough : null,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  // 스크롤 영역 하단 여백
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
          // 새 항목 추가 버튼
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(top: BorderSide(color: Colors.grey.shade200)),
            ),
            child: SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: showAddItemDialog,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2E80EC),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  elevation: 0,
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.add, color: Colors.white),
                    SizedBox(width: 8),
                    Text(
                      '새 항목 추가',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: const BottomNavBar(currentPath: '/checklist'),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _FilterChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF2E80EC) : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: isSelected ? null : Border.all(color: Colors.grey[300]!),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.grey[600],
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}