import 'package:flutter/material.dart';
import '../../../widgets/base/custom_button.dart';

class ChecklistItemData {
  final String title;
  final String category;
  final String priority;
  final int? daysBeforeDeparture;

  ChecklistItemData({
    required this.title,
    required this.category,
    required this.priority,
    this.daysBeforeDeparture,
  });
}

class AddItemModal extends StatefulWidget {
  final Function(ChecklistItemData) onSave;

  const AddItemModal({super.key, required this.onSave});

  @override
  State<AddItemModal> createState() => _AddItemModalState();
}

class _AddItemModalState extends State<AddItemModal> {
  String title = '';
  String selectedCategory = '서류';
  String selectedPriority = 'medium';
  int daysBeforeDeparture = 7;

  final List<String> categories = ['서류', '교통', '숙박', '보험', '금융', '준비물'];
  final List<Map<String, dynamic>> priorities = [
    {
      'id': 'high',
      'name': '높음',
      'icon': Icons.error_outline,
      'color': Colors.red
    },
    {
      'id': 'medium',
      'name': '보통',
      'icon': Icons.info_outline,
      'color': Colors.orange
    },
    {
      'id': 'low',
      'name': '낮음',
      'icon': Icons.check_circle_outline,
      'color': Colors.green
    },
  ];

  void handleSave() {
    if (title.isNotEmpty) {
      widget.onSave(ChecklistItemData(
        title: title,
        category: selectedCategory,
        priority: selectedPriority,
        daysBeforeDeparture: daysBeforeDeparture,
      ));
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.75,
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
                  '새 항목 추가',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(width: 48),
              ],
            ),
          ),

          // 콘텐츠
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 제목
                  const Text(
                    '항목 제목',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    decoration: InputDecoration(
                      hintText: '예: 여권 유효기간 확인',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onChanged: (value) => setState(() => title = value),
                  ),
                  const SizedBox(height: 20),

                  // 카테고리
                  const Text(
                    '카테고리',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: categories.map((category) {
                      final isSelected = selectedCategory == category;
                      return GestureDetector(
                        onTap: () =>
                            setState(() => selectedCategory = category),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 10),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? const Color(0xFF2E6BFF)
                                : Colors.grey[100],
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            category,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color:
                                  isSelected ? Colors.white : Colors.grey[700],
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 20),

                  // 우선순위
                  const Text(
                    '우선순위',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 8),
                  ...priorities.map((priority) {
                    final isSelected = selectedPriority == priority['id'];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: GestureDetector(
                        onTap: () =>
                            setState(() => selectedPriority = priority['id']),
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? (priority['color'] as Color).withOpacity(0.1)
                                : Colors.grey[50],
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: isSelected
                                  ? (priority['color'] as Color)
                                  : Colors.grey[200]!,
                              width: 2,
                            ),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                priority['icon'] as IconData,
                                color: priority['color'] as Color,
                                size: 20,
                              ),
                              const SizedBox(width: 12),
                              Text(
                                priority['name'],
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                  color: isSelected
                                      ? Colors.black87
                                      : Colors.grey[700],
                                ),
                              ),
                              const Spacer(),
                              if (isSelected)
                                Icon(
                                  Icons.check_circle,
                                  color: priority['color'] as Color,
                                  size: 20,
                                ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                  const SizedBox(height: 20),

                  // 출발 전 며칠
                  const Text(
                    '출발 전 며칠',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      IconButton(
                        onPressed: () {
                          if (daysBeforeDeparture > 1) {
                            setState(() => daysBeforeDeparture--);
                          }
                        },
                        icon: const Icon(Icons.remove_circle_outline),
                        color: const Color(0xFF2E6BFF),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 12),
                        decoration: BoxDecoration(
                          color: const Color(0xFF2E6BFF).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          '$daysBeforeDeparture일',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF2E6BFF),
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () => setState(() => daysBeforeDeparture++),
                        icon: const Icon(Icons.add_circle_outline),
                        color: const Color(0xFF2E6BFF),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // 하단 버튼
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(top: BorderSide(color: Colors.grey[200]!)),
            ),
            child: CustomButton(
              text: '추가하기',
              fullWidth: true,
              onPressed: title.isNotEmpty ? handleSave : null,
            ),
          ),
        ],
      ),
    );
  }
}
