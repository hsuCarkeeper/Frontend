import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../models/trip.dart';
import 'add_trip_modal2.dart';

class AddTripModal extends StatefulWidget {
  final void Function(Trip) onSave;

  const AddTripModal({super.key, required this.onSave});

  @override
  State<AddTripModal> createState() => _AddTripModalState();
}

class _AddTripModalState extends State<AddTripModal> {
  final _countryController = TextEditingController();
  final _cityController = TextEditingController();
  DateTime? _startDate;
  DateTime? _endDate;

  @override
  void dispose() {
    _countryController.dispose();
    _cityController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context, bool isStart) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2030),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF2E6BFF),
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        if (isStart) {
          _startDate = picked;
          if (_endDate != null && _endDate!.isBefore(_startDate!)) {
            _endDate = null;
          }
        } else {
          _endDate = picked;
        }
      });
    }
  }

  void _handleSave() {
    if (_countryController.text.isEmpty ||
        _cityController.text.isEmpty ||
        _startDate == null ||
        _endDate == null) {
      return; //입력값 확인 필요
    }

    final newTrip = Trip(
      id: DateTime.now().toString(),
      destination: _cityController.text,
      country: _countryController.text,
      startDate: _startDate!,
      endDate: _endDate!,
      completionRate: 0,
      daysLeft: _startDate!.difference(DateTime.now()).inDays,

    );

    widget.onSave(newTrip);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    //모달 창 시작
    return Container(
      width: double.infinity,
      height: 510,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          //헤더
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 16, 16, 0),//헤더 위치 설정
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  '새 여행 계획',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF000000),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close, color: Colors.black),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          ),

          //진행 바
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            child: LinearProgressIndicator(
              value: 0.25,
              backgroundColor: const Color(0xffEFEFEF),
              valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF2E80EC)),
              minHeight: 8,
              borderRadius: BorderRadius.circular(10),
            ),
          ),

          //내용 영역
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24), //좌우 여백으로 입력창 너비 조정
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 10),
                    const Text(
                      '여행지 정보',
                      style: TextStyle(
                        fontSize: 19,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF000000),
                      ),
                    ),
                    const SizedBox(height: 24),

                    _buildLabel('국가'),
                    const SizedBox(height: 16),
                    _buildTextField(
                      controller: _countryController,
                      hint: '예: 일본, 프랑스, 미국',
                    ),

                    const SizedBox(height: 16),

                    _buildLabel('도시'),
                    const SizedBox(height: 16),
                    _buildTextField(
                      controller: _cityController,
                      hint: '예: 도쿄, 파리, 라스베이거스',
                    ),

                    const SizedBox(height: 12),

                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildLabel('출발일'),
                              const SizedBox(height: 4),
                              _buildDatePickerField(
                                context,
                                date: _startDate,
                                onTap: () => _selectDate(context, true),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildLabel('도착일'),
                              const SizedBox(height: 4),
                              _buildDatePickerField(
                                context,
                                date: _endDate,
                                onTap: () => _selectDate(context, false),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                  ],
                ),
              ),
            ),
          ),

          //확인 버튼
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 20), //확인 버튼 위치 조절
            child: SizedBox(
              width: 350,
              height: 40,
              child: ElevatedButton(
                onPressed: _handleSave,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2E6BFF),
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  '확인',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  //국가, 도시, 출발일, 도착일 text 설정 부분
  Widget _buildLabel(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: Color(0xFF858585),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
  }) {
    return SizedBox(
      height: 48,
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(color: Colors.grey, fontSize: 14), //텍스트 박스 안 예시 텍스트
          contentPadding: const EdgeInsets.symmetric(horizontal: 12),

          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: Color(0xFFBFBFBF)), //텍스트 박스 보더 설정
          ),

          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: Color(0xFFBFBFBF)),
          ),

          focusedBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(8)),
            borderSide: BorderSide(color: Color(0xFF2E6BFF)),
          ),
        ),
      ),
    );
  }


  //출발일, 도착일 커스텀 부분
  Widget _buildDatePickerField(
      BuildContext context, {
        DateTime? date,
        required VoidCallback onTap,
      }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 48,
        decoration: BoxDecoration(
          border: Border.all(color: const Color(0xFFBFBFBF)),
          borderRadius: BorderRadius.circular(8),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              date != null
                  ? DateFormat('yyyy-MM-dd').format(date)
                  : '-/-/-',
              style: TextStyle(
                color: date != null ? Colors.black : Colors.grey, //날짜 선택 전이거나 NULL이면 회색, 선택되면 검정
                fontSize: 14,
              ),
            ),
            Icon(Icons.calendar_today_outlined,
                size: 18, color: Colors.black), //캘린더 아이콘 색깔 설정
          ],
        ),
      ),
    );
  }
}