import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../widgets/base/custom_button.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),
              const Icon(
                Icons.flight_takeoff,
                size: 100,
                color: Color(0xFF2E6BFF),
              ),
              const SizedBox(height: 32),
              const Text(
                'Check&Go',
                style: TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF111111),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                '여행 준비를 더 쉽고 체계적으로',
                style: TextStyle(fontSize: 18, color: Color(0xFF555555)),
                textAlign: TextAlign.center,
              ),
              const Spacer(),
              CustomButton(
                text: '시작하기',
                fullWidth: true,
                onPressed: () => context.go('/auth/login'),
              ),
              const SizedBox(height: 12),
              CustomButton(
                text: '둘러보기',
                variant: ButtonVariant.outline,
                fullWidth: true,
                onPressed: () => context.go('/'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
