import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../widgets/feature/top_nav_bar.dart';
import '../../widgets/feature/bottom_nav_bar.dart';
import '../../widgets/base/custom_card.dart';
import '../../widgets/base/custom_button.dart';
import '../../models/trip.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<Trip> trips = [
    Trip(
      id: '1',
      destination: '도쿄',
      country: '일본',
      startDate: DateTime(2024, 3, 15),
      endDate: DateTime(2024, 3, 18),
      completionRate: 75,
      daysLeft: 12,
      weather: '🌧️',
      flag: '🇯🇵',
    ),
    Trip(
      id: '2',
      destination: '파리',
      country: '프랑스',
      startDate: DateTime(2024, 4, 20),
      endDate: DateTime(2024, 4, 25),
      completionRate: 30,
      daysLeft: 48,
      weather: '☀️',
      flag: '🇫🇷',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TopNavBar(
        title: 'Check&Go',
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Color(0xFF555555)),
            onPressed: () {},
          ),
        ],
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
                color: Color(0xFF111111),
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              '다가오는 여행을 준비해보세요',
              style: TextStyle(fontSize: 16, color: Color(0xFF555555)),
            ),
            const SizedBox(height: 24),

            // 최근 여행
            if (trips.isNotEmpty) ...[
              const Text(
                '최근 여행',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF111111),
                ),
              ),
              const SizedBox(height: 16),
              ...trips.map(
                (trip) => Padding(
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
                                  trip.flag,
                                  style: const TextStyle(fontSize: 28),
                                ),
                                const SizedBox(width: 12),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      trip.destination,
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF111111),
                                      ),
                                    ),
                                    Text(
                                      trip.country,
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
                                Row(
                                  children: [
                                    Text(
                                      trip.weather,
                                      style: const TextStyle(fontSize: 18),
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      'D-${trip.daysLeft}',
                                      style: const TextStyle(
                                        fontSize: 14,
                                        color: Color(0xFF555555),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  trip.dateRange,
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
                              '${trip.completionRate}%',
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF2E6BFF),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: LinearProgressIndicator(
                            value: trip.completionRate / 100,
                            backgroundColor: Colors.grey.shade200,
                            color: const Color(0xFF2E6BFF),
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
                ),
              ),
            ] else ...[
              Center(
                child: Column(
                  children: [
                    const SizedBox(height: 48),
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: const Color(0xFFF7F8FA),
                        borderRadius: BorderRadius.circular(40),
                      ),
                      child: const Icon(
                        Icons.flight_takeoff,
                        size: 40,
                        color: Color(0xFFAAAAAA),
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      '아직 일정이 없어요',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF555555),
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      '+ 버튼으로 첫 일정을 만들어보세요',
                      style: TextStyle(fontSize: 14, color: Color(0xFFAAAAAA)),
                    ),
                  ],
                ),
              ),
            ],

            const SizedBox(height: 16),

            // 새 여행 만들기 CTA
            CustomCard(
              backgroundColor: const Color(0xFF2E6BFF),
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
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          '도시와 일정을 추가해보세요',
                          style: TextStyle(fontSize: 14, color: Colors.white70),
                        ),
                      ],
                    ),
                  ),
                  CustomButton(
                    text: '시작하기',
                    variant: ButtonVariant.ghost,
                    size: ButtonSize.sm,
                    onPressed: () => context.go('/calendar'),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // 빠른 액션
            const Text(
              '빠른 액션',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF111111),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: CustomCard(
                    onTap: () => context.go('/templates'),
                    child: Column(
                      children: [
                        Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            color: const Color(0xFF00B894).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(24),
                          ),
                          child: const Icon(
                            Icons.bookmark_outline,
                            color: Color(0xFF00B894),
                            size: 24,
                          ),
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          '템플릿',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF111111),
                          ),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          '미리 만든 체크리스트',
                          style: TextStyle(
                            fontSize: 12,
                            color: Color(0xFF555555),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: CustomCard(
                    onTap: () => context.go('/notifications'),
                    child: Column(
                      children: [
                        Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            color: const Color(0xFFF59E0B).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(24),
                          ),
                          child: const Icon(
                            Icons.notifications_outlined,
                            color: Color(0xFFF59E0B),
                            size: 24,
                          ),
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          '알림 설정',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF111111),
                          ),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          '출발 전 리마인더',
                          style: TextStyle(
                            fontSize: 12,
                            color: Color(0xFF555555),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 80),
          ],
        ),
      ),
      bottomNavigationBar: const BottomNavBar(currentPath: '/'),
    );
  }
}
