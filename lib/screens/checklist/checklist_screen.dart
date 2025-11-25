import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../models/checklist_response.dart';
import '../../models/trip_selector_response.dart';
import '../../services/checklist_service.dart';
import 'widgets/add_item_modal.dart';

class TopNavBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool showBack;
  final List<Widget>? actions;
  const TopNavBar(
      {super.key, required this.title, this.showBack = false, this.actions});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(title,
          style: const TextStyle(
              color: Color(0xFF111111), fontWeight: FontWeight.bold)),
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
              color:
                  isActive ? const Color(0xFF2E80EC) : const Color(0xFF555555),
              size: 24,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: isActive
                    ? const Color(0xFF2E80EC)
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
          boxShadow: [
            BoxShadow(
                color: Colors.grey.withOpacity(0.05),
                blurRadius: 10,
                spreadRadius: 1)
          ],
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
  // TODO: 실제 API 연동 시 사용
  // final ChecklistService _checklistService = ChecklistService();

  String filterStatus = 'all';
  TripSelectorItem? selectedTrip;
  ChecklistResponse? checklistData;

  bool isLoading = false;
  String? error;

  @override
  void initState() {
    super.initState();
    _loadInitialData();
  }

  Future<void> _loadInitialData() async {
    setState(() {
      isLoading = true;
      error = null;
    });

    try {
      // TODO: 실제 API 연동 시 ChecklistService.getTripSelector()로 변경
      final tripSelectorResponse = await ChecklistService.getMockTripSelector();

      if (tripSelectorResponse.items.isEmpty) {
        setState(() {
          isLoading = false;
        });
        return;
      }

      // tripId가 주어진 경우 해당 여행 선택, 없으면 첫 번째 여행 선택
      TripSelectorItem? tripToSelect;
      if (widget.tripId != null) {
        try {
          tripToSelect = tripSelectorResponse.items.firstWhere(
            (t) => t.id == widget.tripId,
          );
        } catch (_) {
          tripToSelect = tripSelectorResponse.items.first;
        }
      } else {
        tripToSelect = tripSelectorResponse.items.first;
      }

      setState(() {
        selectedTrip = tripToSelect;
      });

      // 선택된 여행의 체크리스트 로드
      await _loadChecklist(tripToSelect.id);
    } catch (e) {
      setState(() {
        isLoading = false;
        error = e.toString();
      });
    }
  }

  Future<void> _loadChecklist(String tripId) async {
    setState(() {
      isLoading = true;
      error = null;
    });

    try {
      // TODO: 실제 API 연동 시 _checklistService.getChecklist(tripId)로 변경
      final response = await ChecklistService.getMockChecklist(tripId);
      setState(() {
        checklistData = response;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
        error = e.toString();
      });
    }
  }

  List<ChecklistItemApi> get filteredItems {
    if (checklistData == null) return [];

    switch (filterStatus) {
      case 'checked':
        return checklistData!.items.where((item) => item.checked).toList();
      case 'unchecked':
        return checklistData!.items.where((item) => !item.checked).toList();
      default:
        return checklistData!.items;
    }
  }

  int get completedCount => checklistData?.summary.done ?? 0;
  int get totalCount => checklistData?.summary.total ?? 0;
  int get completionRate => checklistData?.summary.progressPercentage ?? 0;

  Future<void> toggleItem(String id) async {
    if (selectedTrip == null) return;

    try {
      final item = checklistData!.items.firstWhere((item) => item.id == id);

      // TODO: 실제 API 연동 시 _checklistService.updateItem() 사용
      // await _checklistService.updateItem(
      //   tripId: selectedTrip!.id,
      //   itemId: id,
      //   checked: !item.checked,
      // );

      // Mock 데이터는 로컬에서 업데이트
      setState(() {
        final index = checklistData!.items.indexWhere((item) => item.id == id);
        if (index != -1) {
          checklistData!.items[index] = ChecklistItemApi(
            id: item.id,
            title: item.title,
            checked: !item.checked,
            category: item.category,
          );

          // summary 업데이트
          final doneCount = checklistData!.items.where((i) => i.checked).length;
          final total = checklistData!.items.length;
          checklistData = ChecklistResponse(
            tripId: checklistData!.tripId,
            summary: ChecklistSummary(
              total: total,
              done: doneCount,
              progress: total > 0 ? doneCount / total : 0,
            ),
            items: checklistData!.items,
          );
        }
      });

      // 실제 API 사용 시 전체 체크리스트 리로드
      // await _loadChecklist(selectedTrip!.id);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('항목 업데이트 실패: $e')),
      );
    }
  }

  Future<void> _deleteItem(String id) async {
    if (selectedTrip == null) return;

    try {
      // TODO: 실제 API 연동 시 _checklistService.deleteItem() 사용
      // await _checklistService.deleteItem(
      //   tripId: selectedTrip!.id,
      //   itemId: id,
      // );

      // Mock 데이터는 로컬에서 삭제
      setState(() {
        checklistData!.items.removeWhere((item) => item.id == id);

        // summary 업데이트
        final doneCount = checklistData!.items.where((i) => i.checked).length;
        final total = checklistData!.items.length;
        checklistData = ChecklistResponse(
          tripId: checklistData!.tripId,
          summary: ChecklistSummary(
            total: total,
            done: doneCount,
            progress: total > 0 ? doneCount / total : 0,
          ),
          items: checklistData!.items,
        );
      });

      // 실제 API 사용 시 전체 체크리스트 리로드
      // await _loadChecklist(selectedTrip!.id);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('항목이 삭제되었습니다'),
            duration: Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('항목 삭제 실패: $e')),
        );
      }
    }
  }

  void showAddItemDialog() {
    if (selectedTrip == null) return;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: AddItemModal(
          onSave: (title) async {
            try {
              // TODO: 실제 API 연동 시 _checklistService.createItem() 사용
              // await _checklistService.createItem(
              //   tripId: selectedTrip!.id,
              //   title: title,
              //   category: category,
              // );

              // Mock 데이터는 로컬에서 추가
              setState(() {
                final newItem = ChecklistItemApi(
                  id: 'item_${DateTime.now().millisecondsSinceEpoch}',
                  title: title,
                  checked: false,
                );
                checklistData!.items.add(newItem);

                // summary 업데이트
                final total = checklistData!.items.length;
                final doneCount =
                    checklistData!.items.where((i) => i.checked).length;
                checklistData = ChecklistResponse(
                  tripId: checklistData!.tripId,
                  summary: ChecklistSummary(
                    total: total,
                    done: doneCount,
                    progress: total > 0 ? doneCount / total : 0,
                  ),
                  items: checklistData!.items,
                );
              });

              // 실제 API 사용 시 전체 체크리스트 리로드
              // await _loadChecklist(selectedTrip!.id);
            } catch (e) {
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('항목 추가 실패: $e')),
                );
              }
            }
          },
        ),
      ),
    );
  }

  Future<void> showTripSelectorModal() async {
    try {
      // TODO: 실제 API 연동 시 _checklistService.getTripSelector()로 변경
      final tripSelectorResponse = await ChecklistService.getMockTripSelector();

      if (!mounted) return;
      if (tripSelectorResponse.items.isEmpty) return;

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
              const Text('여행 선택',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              ...tripSelectorResponse.items.map((trip) => ListTile(
                    leading: Text(trip.flagEmoji,
                        style: const TextStyle(fontSize: 24)),
                    title: Text(trip.title),
                    subtitle: Text(trip.dateRangeFormatted),
                    onTap: () {
                      Navigator.pop(context);
                      setState(() {
                        selectedTrip = trip;
                      });
                      _loadChecklist(trip.id);
                    },
                    trailing: selectedTrip?.id == trip.id
                        ? const Icon(Icons.check, color: Color(0xFF2E80EC))
                        : null,
                  )),
            ],
          ),
        ),
      );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('여행 목록 조회 실패: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // 로딩 상태
    if (isLoading && selectedTrip == null) {
      return Scaffold(
        appBar: const TopNavBar(title: '체크리스트'),
        body: const Center(
          child: CircularProgressIndicator(color: Color(0xFF2E80EC)),
        ),
        bottomNavigationBar: const BottomNavBar(currentPath: '/checklist'),
      );
    }

    // 에러 상태
    if (error != null && selectedTrip == null) {
      return Scaffold(
        appBar: const TopNavBar(title: '체크리스트'),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 64, color: Colors.grey),
              const SizedBox(height: 16),
              Text(
                '오류가 발생했습니다',
                style: TextStyle(fontSize: 16, color: Colors.grey[700]),
              ),
              const SizedBox(height: 8),
              Text(
                error!,
                style: TextStyle(fontSize: 12, color: Colors.grey[500]),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _loadInitialData,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2E80EC),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                ),
                child:
                    const Text('다시 시도', style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        ),
        bottomNavigationBar: const BottomNavBar(currentPath: '/checklist'),
      );
    }

    // 여행이 없는 상태
    if (selectedTrip == null) {
      return Scaffold(
        appBar: const TopNavBar(title: '체크리스트'),
        body: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.luggage_outlined, size: 64, color: Colors.grey),
              SizedBox(height: 16),
              Text('등록된 여행이 없습니다.',
                  style: TextStyle(fontSize: 16, color: Colors.grey)),
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
                            Text(selectedTrip!.flagEmoji,
                                style: const TextStyle(fontSize: 32)),
                            const SizedBox(width: 12),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  selectedTrip!.title,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16),
                                ),
                                Text(
                                  '${selectedTrip!.country} ${selectedTrip!.city}',
                                  style: TextStyle(
                                      fontSize: 12, color: Colors.grey[600]),
                                ),
                                Text(
                                  selectedTrip!.dateRangeFormatted,
                                  style: TextStyle(
                                      fontSize: 12, color: Colors.grey[400]),
                                ),
                              ],
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(0xFF2E80EC).withOpacity(0.1),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                'D-${selectedTrip!.calculatedDDay}',
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF2E80EC),
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            const Icon(Icons.keyboard_arrow_down,
                                color: Colors.grey),
                          ],
                        ),
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
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  '$completedCount/$totalCount 항목 완료',
                                  style: TextStyle(
                                      color: Colors.white.withOpacity(0.9),
                                      fontSize: 14),
                                ),
                              ],
                            ),
                            Text(
                              '$completionRate%',
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 32,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: LinearProgressIndicator(
                            value: checklistData?.summary.progress ?? 0,
                            minHeight: 8,
                            backgroundColor: Colors.white.withOpacity(0.3),
                            valueColor: const AlwaysStoppedAnimation<Color>(
                                Colors.white),
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
                          filterStatus == 'all'
                              ? '항목을 추가해보세요!'
                              : '해당하는 항목이 없습니다.',
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
                          child: Dismissible(
                            key: Key(item.id),
                            direction: DismissDirection.endToStart,
                            background: Container(
                              alignment: Alignment.centerRight,
                              padding: const EdgeInsets.only(right: 20),
                              decoration: BoxDecoration(
                                color: Colors.red,
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child:
                                  const Icon(Icons.delete, color: Colors.white),
                            ),
                            confirmDismiss: (direction) async {
                              return await showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: const Text('항목 삭제'),
                                  content:
                                      Text('\'${item.title}\'을(를) 삭제하시겠습니까?'),
                                  actions: [
                                    TextButton(
                                      onPressed: () =>
                                          Navigator.pop(context, false),
                                      child: const Text('취소',
                                          style: TextStyle(color: Colors.grey)),
                                    ),
                                    TextButton(
                                      onPressed: () =>
                                          Navigator.pop(context, true),
                                      child: const Text('삭제',
                                          style: TextStyle(color: Colors.red)),
                                    ),
                                  ],
                                ),
                              );
                            },
                            onDismissed: (direction) async {
                              await _deleteItem(item.id);
                            },
                            child: CustomCard(
                              onTap: () => toggleItem(item.id),
                              child: Row(
                                children: [
                                  Container(
                                    width: 24,
                                    height: 24,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: item.checked
                                          ? const Color(0xFF2E80EC)
                                          : Colors.transparent,
                                      border: Border.all(
                                        color: item.checked
                                            ? const Color(0xFF2E80EC)
                                            : Colors.grey[300]!,
                                        width: 2,
                                      ),
                                    ),
                                    child: item.checked
                                        ? const Icon(Icons.check,
                                            size: 16, color: Colors.white)
                                        : null,
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: Text(
                                      item.title,
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: item.checked
                                            ? Colors.grey
                                            : Colors.black87,
                                        decoration: item.checked
                                            ? TextDecoration.lineThrough
                                            : null,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
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
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  elevation: 0,
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.add, color: Colors.white),
                    SizedBox(width: 8),
                    Text(
                      '새 항목 추가',
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
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
