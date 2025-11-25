import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../models/trip_response.dart';
import '../../services/trip_service.dart';
import '../calendar/widgets/add_trip_modal.dart';

// =========================================
// 2. 공통 위젯 (TopNavBar, CustomCard, CustomButton, BottomNavBar)
// =========================================

class TopNavBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;

  const TopNavBar({
    super.key,
    required this.title,
    this.actions,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(title,
          style: const TextStyle(
              color: Color(0xFF111111), fontWeight: FontWeight.bold)),
      backgroundColor: const Color(0xFFF5F5F5), // 배경색 맞춤
      elevation: 0,
      centerTitle: true,
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
  final Gradient? gradient; // ⭐️ 그라데이션 추가

  const CustomCard({
    super.key,
    required this.child,
    this.onTap,
    this.backgroundColor = Colors.white, // 기본값 유지
    this.gradient, // 그라데이션 초기화
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: gradient == null
              ? backgroundColor
              : null, // 그라데이션이 없으면 backgroundColor 사용
          gradient: gradient, // 그라데이션 적용
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

enum ButtonVariant { primary, ghost }

enum ButtonSize { sm, md }

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final ButtonVariant variant;
  final ButtonSize size;

  const CustomButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.variant = ButtonVariant.primary,
    this.size = ButtonSize.md,
  });

  @override
  Widget build(BuildContext context) {
    final isGhost = variant == ButtonVariant.ghost;
    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        backgroundColor:
            isGhost ? Colors.white.withOpacity(0.2) : const Color(0xFF2E6BFF),
        padding: EdgeInsets.symmetric(
          horizontal: size == ButtonSize.sm ? 12 : 16,
          vertical: size == ButtonSize.sm ? 8 : 12,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: isGhost
              ? const BorderSide(color: Colors.white, width: 1)
              : BorderSide.none,
        ),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: isGhost ? Colors.white : Colors.white,
          fontWeight: FontWeight.w600,
          fontSize: size == ButtonSize.sm ? 12 : 14,
        ),
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
              color:
                  isActive ? const Color(0xFF2E6BFF) : const Color(0xFF555555),
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

// =========================================
// 3. HomeScreen (메인)
// =========================================

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<TripItem> trips = [];
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    _loadTrips();
  }

  Future<void> _loadTrips() async {
    try {
      setState(() {
        isLoading = true;
        errorMessage = null;
      });

      // TODO: 실제 API 연동 시 TripService.getTrips()로 변경
      final response = await TripService.getMockTrips();

      setState(() {
        trips = response.items;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = '여행 목록을 불러오는데 실패했습니다.';
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5), //배경색을 연한 회색으로
      appBar: TopNavBar(
        title: 'Check&Go',
        // actions는 이전에 제거되었으므로 필요하다면 다시 추가하세요.
        // actions: [
        //   IconButton(
        //     icon: const Icon(Icons.search, color: Color(0xFF555555)),
        //     onPressed: () {},
        //   ),
        // ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 헤더 섹션
            const SizedBox(height: 8),
            const Text(
              '안녕하세요! 👋',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF000000),
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              '다가오는 여행을 준비해보세요',
              style: TextStyle(fontSize: 16, color: Color(0xFF6F6F6F)),
            ),
            const SizedBox(height: 20),

            // 최근 여행
            const Text(
              '다음 여행 일정',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF000000),
              ),
            ),
            const SizedBox(height: 16),

            // 로딩 중
            if (isLoading)
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(40.0),
                  child: CircularProgressIndicator(),
                ),
              )
            // 에러 발생
            else if (errorMessage != null)
              Center(
                child: Column(
                  children: [
                    const SizedBox(height: 32),
                    const Icon(Icons.error_outline,
                        size: 48, color: Colors.red),
                    const SizedBox(height: 16),
                    Text(
                      errorMessage!,
                      style: const TextStyle(color: Colors.red),
                    ),
                    const SizedBox(height: 16),
                    TextButton(
                      onPressed: _loadTrips,
                      child: const Text('다시 시도'),
                    ),
                  ],
                ),
              )
            // 여행 목록이 있을 때
            else if (trips.isNotEmpty)
              ...trips.map((trip) => Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: CustomCard(
                      onTap: () => context.go('/checklist/${trip.id}'),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // 여행지 정보
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    trip.flagEmoji,
                                    style: const TextStyle(fontSize: 32),
                                  ),
                                  const SizedBox(width: 12),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        trip.title,
                                        style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xFF111111),
                                        ),
                                      ),
                                      Text(
                                        '${trip.country} ${trip.city}',
                                        style: const TextStyle(
                                          fontSize: 14,
                                          color: Color(0xFF555555),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF2E80EC)
                                          .withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Text(
                                      'D-${trip.dDay}',
                                      style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF2E80EC),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    trip.dateRangeFormatted,
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: Color(0xFFAAAAAA),
                                    ),
                                  ),
                                  Text(
                                    trip.tripDuration,
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: Color(0xFFAAAAAA),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),

                          // 진행률
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                '준비 완료',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Color(0xFF555555),
                                ),
                              ),
                              Text(
                                '${trip.progressPercentage}%',
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF2E80EC),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: LinearProgressIndicator(
                              value: trip.progress,
                              backgroundColor: Colors.grey.shade200,
                              color: const Color(0xFF2E80EC),
                              minHeight: 8,
                            ),
                          ),
                          const SizedBox(height: 12),

                          // 체크리스트 보기
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                '체크리스트 보기',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Color(0xFFAAAAAA),
                                ),
                              ),
                              Icon(
                                Icons.arrow_forward_ios,
                                size: 14,
                                color: Colors.grey.shade400,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ))
            // 여행이 없을 때
            else ...[
              Center(
                child: Column(
                  children: [
                    const SizedBox(height: 32),
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(40),
                      ),
                      child: const Icon(
                        Icons.flight_takeoff,
                        size: 40,
                        color: Color(0xFFCCCCCC),
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      '아직 일정이 없어요',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF6F6F6F),
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      '아래 버튼으로 첫 일정을 만들어보세요',
                      style: TextStyle(fontSize: 14, color: Color(0xFFAAAAAA)),
                    ),
                  ],
                ),
              ),
            ],

            const SizedBox(height: 60),
            CustomCard(
              //그라데이션 적용
              gradient: LinearGradient(
                colors: [
                  const Color(0xFF2E80EC).withOpacity(0.7), //피그마 파랑
                  const Color(0xFF009A6B).withOpacity(0.4), //피그마 녹색
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomRight,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '새 여행 계획하기',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFFFFFFFF),
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          '목적지와 일정을 추가해보세요',
                          style:
                              TextStyle(fontSize: 14, color: Color(0xFFFFFFFF)),
                        ),
                      ],
                    ),
                  ),
                  CustomButton(
                    text: '시작하기',
                    variant: ButtonVariant.ghost,
                    size: ButtonSize.md,
                    onPressed: () {
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        backgroundColor: Colors.transparent,
                        builder: (context) => AddTripModal(
                          onSave: (trip) {
                            // TODO: 여행 추가 후 목록 새로고침
                            _loadTrips();
                            Navigator.pop(context);
                          },
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            const SizedBox(height: 80), // BottomNavBar가 가리지 않도록 충분한 하단 여백
          ],
        ),
      ),
      bottomNavigationBar: const BottomNavBar(currentPath: '/'),
    );
  }
}
