import 'package:flutter/material.dart';

class AddTripModal2 extends StatelessWidget {
  const AddTripModal2({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 500, // 원하는 높이 조정 가능
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
      child: const SizedBox.expand(), // 완전 빈 화면
    );
  }
}
