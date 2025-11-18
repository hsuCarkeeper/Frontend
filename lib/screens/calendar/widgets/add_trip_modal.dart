import 'package:flutter/material.dart';
import '../../../widgets/base/custom_button.dart';
import '../../../widgets/base/custom_card.dart';

class Trip {
  final String destination;
  final String country;
  final String startDate;
  final String endDate;
  final List<String> activities;
  final String memo;

  Trip({
    required this.destination,
    required this.country,
    required this.startDate,
    required this.endDate,
    required this.activities,
    required this.memo,
  });
}

class Country {
  final String name;
  final String flag;
  final List<String> cities;

  Country({required this.name, required this.flag, required this.cities});
}

class Activity {
  final String id;
  final String name;
  final IconData icon;

  Activity({required this.id, required this.name, required this.icon});
}

class AddTripModal extends StatefulWidget {
  final Function(Trip) onSave;

  const AddTripModal({super.key, required this.onSave});

  @override
  State<AddTripModal> createState() => _AddTripModalState();
}

class _AddTripModalState extends State<AddTripModal> {
  int step = 1;
  Country? selectedCountry;
  String destination = '';
  String country = '';
  String startDate = '';
  String endDate = '';
  List<String> selectedActivities = [];
  String memo = '';

  final List<Country> countries = [
    Country(name: '일본', flag: '🇯🇵', cities: ['도쿄', '오사카', '교토', '후쿠오카']),
    Country(name: '프랑스', flag: '🇫🇷', cities: ['파리', '니스', '리옹', '마르세유']),
    Country(name: '이탈리아', flag: '🇮🇹', cities: ['로마', '밀라노', '베니스', '피렌체']),
    Country(
        name: '스페인', flag: '🇪🇸', cities: ['마드리드', '바르셀로나', '세비야', '발렌시아']),
    Country(name: '독일', flag: '🇩🇪', cities: ['베를린', '뮌헨', '함부르크', '쾰른']),
    Country(name: '영국', flag: '🇬🇧', cities: ['런던', '에든버러', '맨체스터', '리버풀']),
  ];

  final List<Activity> activities = [
    Activity(id: 'city', name: '도시관광', icon: Icons.location_city),
    Activity(id: 'nature', name: '자연탐방', icon: Icons.nature),
    Activity(id: 'hiking', name: '하이킹', icon: Icons.hiking),
    Activity(id: 'beach', name: '해변', icon: Icons.beach_access),
    Activity(id: 'culture', name: '문화체험', icon: Icons.museum),
    Activity(id: 'food', name: '맛집투어', icon: Icons.restaurant),
    Activity(id: 'shopping', name: '쇼핑', icon: Icons.shopping_bag),
    Activity(id: 'spa', name: '온천/스파', icon: Icons.spa),
  ];

  bool canProceed() {
    switch (step) {
      case 1:
        return selectedCountry != null;
      case 2:
        return destination.isNotEmpty;
      case 3:
        return startDate.isNotEmpty && endDate.isNotEmpty;
      case 4:
        return true;
      default:
        return false;
    }
  }

  void handleSave() {
    if (destination.isNotEmpty && startDate.isNotEmpty && endDate.isNotEmpty) {
      widget.onSave(Trip(
        destination: destination,
        country: country,
        startDate: startDate,
        endDate: endDate,
        activities: selectedActivities,
        memo: memo,
      ));
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.9,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        children: [
          // 헤더
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                ),
                const Text(
                  '새 여행 추가',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(width: 48),
              ],
            ),
          ),

          // 진행 표시
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            color: const Color(0xFFF7F8FA),
            child: Column(
              children: [
                Row(
                  children: List.generate(4, (index) {
                    final num = index + 1;
                    return Expanded(
                      child: Row(
                        children: [
                          Expanded(
                            child: Container(
                              height: 32,
                              decoration: BoxDecoration(
                                color: step >= num
                                    ? const Color(0xFF2E6BFF)
                                    : Colors.grey[200],
                                shape: BoxShape.circle,
                              ),
                              child: Center(
                                child: Text(
                                  num.toString(),
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: step >= num
                                        ? Colors.white
                                        : Colors.grey[400],
                                  ),
                                ),
                              ),
                            ),
                          ),
                          if (num < 4)
                            Expanded(
                              child: Container(
                                height: 4,
                                color: step > num
                                    ? const Color(0xFF2E6BFF)
                                    : Colors.grey[200],
                              ),
                            ),
                        ],
                      ),
                    );
                  }),
                ),
                const SizedBox(height: 8),
                Text(
                  step == 1
                      ? '국가를 선택해주세요'
                      : step == 2
                          ? '도시를 선택해주세요'
                          : step == 3
                              ? '날짜를 선택해주세요'
                              : '활동을 선택해주세요',
                  style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                ),
              ],
            ),
          ),

          // 콘텐츠
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: _buildStepContent(),
            ),
          ),

          // 하단 버튼
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(top: BorderSide(color: Colors.grey[200]!)),
            ),
            child: Row(
              children: [
                if (step > 1)
                  Expanded(
                    child: CustomButton(
                      text: '이전',
                      variant: ButtonVariant.outline,
                      onPressed: () => setState(() => step--),
                    ),
                  ),
                if (step > 1) const SizedBox(width: 12),
                Expanded(
                  child: CustomButton(
                    text: step < 4 ? '다음' : '저장하기',
                    onPressed: canProceed()
                        ? () {
                            if (step < 4) {
                              setState(() => step++);
                            } else {
                              handleSave();
                            }
                          }
                        : null,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStepContent() {
    switch (step) {
      case 1:
        return Column(
          children: countries.map((c) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: CustomCard(
                onTap: () {
                  setState(() {
                    selectedCountry = c;
                    country = c.name;
                    step = 2;
                  });
                },
                child: Row(
                  children: [
                    Text(c.flag, style: const TextStyle(fontSize: 28)),
                    const SizedBox(width: 12),
                    Text(
                      c.name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        );

      case 2:
        if (selectedCountry == null) return const SizedBox();
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(selectedCountry!.flag,
                    style: const TextStyle(fontSize: 24)),
                const SizedBox(width: 8),
                Text(
                  selectedCountry!.name,
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.w600),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ...selectedCountry!.cities.map((city) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: CustomCard(
                  onTap: () {
                    setState(() {
                      destination = city;
                      step = 3;
                    });
                  },
                  child: Text(
                    city,
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                ),
              );
            }).toList(),
          ],
        );

      case 3:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '출발일',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 8),
            TextField(
              decoration: InputDecoration(
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                hintText: 'YYYY-MM-DD',
              ),
              onChanged: (value) => setState(() => startDate = value),
              onTap: () async {
                final date = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime.now(),
                  lastDate: DateTime.now().add(const Duration(days: 365)),
                );
                if (date != null) {
                  setState(() {
                    startDate = date.toString().split(' ')[0];
                  });
                }
              },
              readOnly: true,
              controller: TextEditingController(text: startDate),
            ),
            const SizedBox(height: 16),
            const Text(
              '도착일',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 8),
            TextField(
              decoration: InputDecoration(
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                hintText: 'YYYY-MM-DD',
              ),
              onChanged: (value) => setState(() => endDate = value),
              onTap: () async {
                final date = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime.now(),
                  lastDate: DateTime.now().add(const Duration(days: 365)),
                );
                if (date != null) {
                  setState(() {
                    endDate = date.toString().split(' ')[0];
                  });
                }
              },
              readOnly: true,
              controller: TextEditingController(text: endDate),
            ),
          ],
        );

      case 4:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 1.5,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
              itemCount: activities.length,
              itemBuilder: (context, index) {
                final activity = activities[index];
                final isSelected = selectedActivities.contains(activity.id);
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      if (isSelected) {
                        selectedActivities.remove(activity.id);
                      } else {
                        selectedActivities.add(activity.id);
                      }
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? const Color(0xFF2E6BFF).withOpacity(0.1)
                          : Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isSelected
                            ? const Color(0xFF2E6BFF)
                            : Colors.grey[300]!,
                        width: 2,
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: isSelected
                                ? const Color(0xFF2E6BFF)
                                : const Color(0xFFF7F8FA),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            activity.icon,
                            size: 20,
                            color: isSelected ? Colors.white : Colors.grey[600],
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          activity.name,
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            color: isSelected
                                ? const Color(0xFF2E6BFF)
                                : Colors.black87,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 16),
            const Text(
              '메모 (선택사항)',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 8),
            TextField(
              decoration: InputDecoration(
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                hintText: '특별한 계획이나 메모를 적어주세요',
              ),
              maxLines: 3,
              onChanged: (value) => setState(() => memo = value),
            ),
          ],
        );

      default:
        return const SizedBox();
    }
  }
}
