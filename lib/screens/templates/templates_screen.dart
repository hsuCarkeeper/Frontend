import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../widgets/feature/top_nav_bar.dart';
import '../../widgets/feature/bottom_nav_bar.dart';
import '../../widgets/base/custom_card.dart';
import '../../widgets/base/custom_button.dart';

class Template {
  final String id;
  final String title;
  final String description;
  final String country;
  final String flag;
  final String duration;
  final int itemCount;
  final String category;
  final String difficulty; // 'easy', 'medium', 'hard'
  final List<String> tags;
  final List<String> items;

  Template({
    required this.id,
    required this.title,
    required this.description,
    required this.country,
    required this.flag,
    required this.duration,
    required this.itemCount,
    required this.category,
    required this.difficulty,
    required this.tags,
    required this.items,
  });
}

class TemplatesScreen extends StatefulWidget {
  const TemplatesScreen({super.key});

  @override
  State<TemplatesScreen> createState() => _TemplatesScreenState();
}

class _TemplatesScreenState extends State<TemplatesScreen> {
  String selectedCategory = '전체';
  Template? selectedTemplate;

  final List<String> categories = ['전체', '아시아', '유럽', '미주', '오세아니아', '아프리카'];

  final List<Template> templates = [
    Template(
      id: '1',
      title: '일본 도쿄 여행',
      description: '첫 일본 여행을 위한 완벽한 준비 가이드',
      country: '일본',
      flag: '🇯🇵',
      duration: '3-5일',
      itemCount: 24,
      category: '아시아',
      difficulty: 'easy',
      tags: ['첫여행', '도시여행', '문화체험'],
      items: [
        '여권 유효기간 확인 (6개월 이상)',
        '항공권 예약',
        '숙소 예약 (호텔/료칸)',
        '여행자 보험 가입',
        'JR 패스 구매',
        '엔화 환전',
        '포켓 와이파이 렌탈',
        '구글 번역기 앱 설치',
      ],
    ),
    Template(
      id: '2',
      title: '프랑스 파리 여행',
      description: '로맨틱한 파리 여행을 위한 체크리스트',
      country: '프랑스',
      flag: '🇫🇷',
      duration: '5-7일',
      itemCount: 32,
      category: '유럽',
      difficulty: 'medium',
      tags: ['로맨틱', '문화', '미술관'],
      items: [
        '여권 유효기간 확인',
        '비자 확인 (90일 무비자)',
        '항공권 예약',
        '숙소 예약',
        '여행자 보험 가입',
        '유로화 환전',
        '국제운전면허증 발급',
        '유럽 심카드 구매',
      ],
    ),
    Template(
      id: '3',
      title: '태국 방콕 여행',
      description: '동남아 배낭여행 필수 준비사항',
      country: '태국',
      flag: '🇹🇭',
      duration: '4-6일',
      itemCount: 28,
      category: '아시아',
      difficulty: 'easy',
      tags: ['배낭여행', '음식', '쇼핑'],
      items: [
        '여권 유효기간 확인',
        '비자 확인 (30일 무비자)',
        '항공권 예약',
        '숙소 예약',
        '여행자 보험 가입',
        '태국 바트 환전',
        '태국 심카드 구매',
        '황열병 예방접종',
      ],
    ),
    Template(
      id: '4',
      title: '미국 뉴욕 여행',
      description: '빅애플 뉴욕 완전정복 가이드',
      country: '미국',
      flag: '🇺🇸',
      duration: '7-10일',
      itemCount: 38,
      category: '미주',
      difficulty: 'hard',
      tags: ['도시여행', '쇼핑', '브로드웨이'],
      items: [
        '여권 유효기간 확인',
        'ESTA 신청',
        '항공권 예약',
        '숙소 예약',
        '여행자 보험 가입',
        '달러 환전',
        '미국 심카드 구매',
        '자유의 여신상 페리 예약',
      ],
    ),
    Template(
      id: '5',
      title: '호주 시드니 여행',
      description: '오세아니아 대자연과 도시의 조화',
      country: '호주',
      flag: '🇦🇺',
      duration: '8-12일',
      itemCount: 42,
      category: '오세아니아',
      difficulty: 'medium',
      tags: ['자연', '액티비티', '해변'],
      items: [
        '여권 유효기간 확인',
        '호주 비자 신청 (ETA)',
        '항공권 예약',
        '숙소 예약',
        '여행자 보험 가입',
        '호주 달러 환전',
        '호주 심카드 구매',
        '시드니 오페라하우스 투어',
      ],
    ),
    Template(
      id: '6',
      title: '영국 런던 여행',
      description: '클래식한 영국 문화 체험 여행',
      country: '영국',
      flag: '🇬🇧',
      duration: '6-8일',
      itemCount: 35,
      category: '유럽',
      difficulty: 'medium',
      tags: ['역사', '문화', '박물관'],
      items: [
        '여권 유효기간 확인',
        '영국 비자 확인',
        '항공권 예약',
        '숙소 예약',
        '여행자 보험 가입',
        '파운드 환전',
        '영국 심카드 구매',
        '버킹엄 궁전 투어',
      ],
    ),
  ];

  List<Template> get filteredTemplates {
    if (selectedCategory == '전체') {
      return templates;
    }
    return templates
        .where((template) => template.category == selectedCategory)
        .toList();
  }

  Color getDifficultyColor(String difficulty) {
    switch (difficulty) {
      case 'easy':
        return Colors.green;
      case 'medium':
        return Colors.orange;
      case 'hard':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  String getDifficultyText(String difficulty) {
    switch (difficulty) {
      case 'easy':
        return '쉬움';
      case 'medium':
        return '보통';
      case 'hard':
        return '어려움';
      default:
        return '보통';
    }
  }

  void showTemplatePreview(Template template) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.9,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        builder: (context, scrollController) => Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.only(top: 12),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Expanded(
                child: ListView(
                  controller: scrollController,
                  padding: const EdgeInsets.all(20),
                  children: [
                    Row(
                      children: [
                        Text(
                          template.flag,
                          style: const TextStyle(fontSize: 40),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                template.title,
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                template.description,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Icon(Icons.access_time,
                            size: 16, color: Colors.grey[400]),
                        const SizedBox(width: 4),
                        Text(
                          template.duration,
                          style:
                              TextStyle(fontSize: 14, color: Colors.grey[600]),
                        ),
                        const SizedBox(width: 16),
                        Icon(Icons.check_box,
                            size: 16, color: Colors.grey[400]),
                        const SizedBox(width: 4),
                        Text(
                          '${template.itemCount}개 항목',
                          style:
                              TextStyle(fontSize: 14, color: Colors.grey[600]),
                        ),
                        const Spacer(),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: getDifficultyColor(template.difficulty)
                                .withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            getDifficultyText(template.difficulty),
                            style: TextStyle(
                              fontSize: 12,
                              color: getDifficultyColor(template.difficulty),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: template.tags.map((tag) {
                        return Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.grey[100],
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            '#$tag',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      '포함된 항목',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    ...template.items.asMap().entries.map((entry) {
                      final index = entry.key;
                      final item = entry.value;
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: 24,
                              height: 24,
                              margin: const EdgeInsets.only(top: 2),
                              decoration: BoxDecoration(
                                color: const Color(0xFF2E6BFF).withOpacity(0.1),
                                shape: BoxShape.circle,
                              ),
                              child: Center(
                                child: Text(
                                  '${index + 1}',
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF2E6BFF),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                item,
                                style: const TextStyle(fontSize: 14),
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                    const SizedBox(height: 80),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      offset: const Offset(0, -2),
                      blurRadius: 8,
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: CustomButton(
                        text: '닫기',
                        variant: ButtonVariant.outline,
                        onPressed: () => Navigator.pop(context),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: CustomButton(
                        text: '사용하기',
                        onPressed: () {
                          Navigator.pop(context);
                          context.push('/checklist/template-${template.id}');
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const TopNavBar(
        title: '템플릿',
        showBack: false,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 헤더 섹션
            const Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '여행 템플릿 📋',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    '미리 준비된 체크리스트로 빠르게 시작하세요',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),

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

            // 템플릿 카드들
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: filteredTemplates.length,
              itemBuilder: (context, index) {
                final template = filteredTemplates[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: CustomCard(
                    onTap: () => showTemplatePreview(template),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              template.flag,
                              style: const TextStyle(fontSize: 28),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    template.title,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                  Text(
                                    template.description,
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Icon(Icons.access_time,
                                size: 14, color: Colors.grey[400]),
                            const SizedBox(width: 4),
                            Text(
                              template.duration,
                              style: TextStyle(
                                  fontSize: 12, color: Colors.grey[600]),
                            ),
                            const SizedBox(width: 12),
                            Icon(Icons.check_box,
                                size: 14, color: Colors.grey[400]),
                            const SizedBox(width: 4),
                            Text(
                              '${template.itemCount}개 항목',
                              style: TextStyle(
                                  fontSize: 12, color: Colors.grey[600]),
                            ),
                            const Spacer(),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(
                                color: getDifficultyColor(template.difficulty)
                                    .withOpacity(0.1),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                getDifficultyText(template.difficulty),
                                style: TextStyle(
                                  fontSize: 11,
                                  color:
                                      getDifficultyColor(template.difficulty),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Wrap(
                          spacing: 6,
                          runSpacing: 6,
                          children: template.tags.map((tag) {
                            return Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.grey[100],
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                '#$tag',
                                style: TextStyle(
                                  fontSize: 11,
                                  color: Colors.grey[600],
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(
                              child: CustomButton(
                                text: '미리보기',
                                variant: ButtonVariant.outline,
                                onPressed: () => showTemplatePreview(template),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: CustomButton(
                                text: '사용하기',
                                onPressed: () => context
                                    .push('/checklist/template-${template.id}'),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),

            // 빈 상태
            if (filteredTemplates.isEmpty)
              const Padding(
                padding: EdgeInsets.all(48),
                child: Column(
                  children: [
                    Icon(Icons.bookmark_border, size: 64, color: Colors.grey),
                    SizedBox(height: 16),
                    Text(
                      '해당 지역의 템플릿이 없어요',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      '다른 카테고리를 선택해보세요',
                      style: TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                  ],
                ),
              ),

            // 커스텀 템플릿 만들기
            Padding(
              padding: const EdgeInsets.all(16),
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF00B894), Color(0xFF2E6BFF)],
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            '나만의 템플릿 만들기',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '자주 사용하는 체크리스트를 템플릿으로 저장하세요',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.white.withOpacity(0.8),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: IconButton(
                        icon: const Icon(Icons.add, color: Colors.white),
                        onPressed: () => context.push('/checklist'),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 80),
          ],
        ),
      ),
      bottomNavigationBar: const BottomNavBar(currentPath: '/templates'),
    );
  }
}
