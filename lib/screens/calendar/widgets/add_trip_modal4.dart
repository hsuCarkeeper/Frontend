import 'package:flutter/material.dart';

class AddTripModal4 extends StatefulWidget {
  const AddTripModal4({super.key});

  @override
  State<AddTripModal4> createState() => _AddTripModal4State();
}

class _AddTripModal4State extends State<AddTripModal4> {
  String? selectedStay;
  String? selectedTransport;


  @override
  Widget build(BuildContext context) {
    return Container(
      width: 390,
      height: 688,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 헤더
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 10, 15, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "새 여행 계획",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: Colors.black,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close, color: Colors.black),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          ),

          const SizedBox(height: 28), //헤더 간격 문제로 32->28

          // 진행바
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: LinearProgressIndicator(
              value: 0.75,
              backgroundColor: const Color(0xFFEFEFEF),
              valueColor:
              const AlwaysStoppedAnimation<Color>(Color(0xFF2E80EC)),
              minHeight: 8,
              borderRadius: BorderRadius.circular(10),
            ),
          ),

          const SizedBox(height: 32),





          //이전, 다음 버튼
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 28),
            child: Row(
              children: [
                // 이전
                Expanded(
                  child: SizedBox(
                    height: 44,
                    child: OutlinedButton(
                      onPressed: () {
                        Navigator.pop(context);

                        showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          backgroundColor: Colors.transparent,
                          builder: (ctx) => const AddTripModal4(),
                        );

                      },
                      style: OutlinedButton.styleFrom(
                        side:
                        const BorderSide(color: Color(0xFF2E6BFF), width: 1),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text(
                        "이전",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF2E6BFF),
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(width: 12),

                // 다음
                Expanded(
                  child: SizedBox(
                    height: 44,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        // 여기에 modal4 연결 가능
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF2E6BFF),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text(
                        "완료",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
