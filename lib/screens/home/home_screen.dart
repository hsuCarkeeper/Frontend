/// HomeScreen - 메인 홈 화면
/// 
/// [주요 기능]
/// - 사용자의 여행 목록을 카드 형태로 표시
/// - 각 여행의 D-day, 진행률, 날짜 정보 표시
/// - 여행 카드 클릭 시 해당 여행의 체크리스트 화면으로 이동
/// - '새 여행 계획하기' 버튼으로 AddTripModal 호출
/// 
/// [API 연동]
/// - TripService.getMockTrips()로 여행 목록 조회 (TODO: 실제 API로 전환)
/// - 로딩, 에러, 빈 목록 상태 처리
/// 
/// [사용 위젯]
/// - TopNavBar: 상단 앱바
/// - CustomCard: 여행 카드 및 새 여행 추가 카드
/// - CustomButton: '시작하기' 버튼
/// - BottomNavBar: 하단 네비게이션 바
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../models/trip_response.dart';
import '../../services/trip_service.dart';
import '../../widgets/feature/top_nav_bar.dart';
import '../../widgets/feature/bottom_nav_bar.dart';
import '../../widgets/base/custom_card.dart';
import '../../widgets/base/custom_button.dart';
import '../calendar/widgets/add_trip_modal.dart';

// =========================================
// HomeScreen (메인)
// =========================================

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  /// 여행 목록 데이터
  List<TripItem> trips = [];
  
  /// 로딩 상태 플래그
  bool isLoading = true;
  
  /// 에러 메시지 (에러 발생 시에만 값 존재)
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    _loadTrips();
  }

  /// 여행 목록을 API에서 불러오는 메서드
  /// 
  /// [동작]
  /// 1. 로딩 상태 활성화
  /// 2. TripService를 통해 여행 목록 조회
  /// 3. 성공 시 trips 리스트 업데이트, 실패 시 에러 메시지 표시
  /// 
  /// TODO: Mock 데이터를 실제 API(TripService.getTrips())로 교체 필요
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
