import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

// =========================================
// 1. 데이터 모델
// =========================================
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

  // 날짜 포맷 게터 (예: 3박 4일)
  String get dateRange {
    final diff = endDate.difference(startDate).inDays;
    return '$diff박 ${diff + 1}일';
  }
}

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
      title: Text(
          title,
          style: const TextStyle(color: Color(0xFF111111), fontWeight: FontWeight.bold)
      ),
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
          color: gradient == null ? backgroundColor : null, // 그라데이션이 없으면 backgroundColor 사용
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
        backgroundColor: isGhost ? Colors.white.withOpacity(0.2) : const Color(0xFF2E6BFF),
        padding: EdgeInsets.symmetric(
          horizontal: size == ButtonSize.sm ? 12 : 16,
          vertical: size == ButtonSize.sm ? 8 : 12,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: isGhost ? const BorderSide(color: Colors.white, width: 1) : BorderSide.none,
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

// =========================================
// 3. HomeScreen (메인)
// =========================================

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<Trip> trips = [];

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
              '최근 여행',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF000000),
              ),
            ),
            const SizedBox(height: 36),

            if (trips.isNotEmpty) ...trips.map((trip) =>
            //여기에 일정 추가되면 컨테이너 들어와야됌
            Container()
            ) else ...[
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
                          style: TextStyle(fontSize: 14,  color: Color(0xFFFFFFFF)),
                        ),
                      ],
                    ),
                  ),
                  CustomButton(
                    text: '시작하기',
                    variant: ButtonVariant.ghost,
                    size: ButtonSize.md,
                    onPressed: () => context.go('/calendar'),
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