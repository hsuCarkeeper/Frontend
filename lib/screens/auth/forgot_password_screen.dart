import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../widgets/feature/top_nav_bar.dart';
import '../../widgets/base/custom_button.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const TopNavBar(title: '비밀번호 찾기', showBack: true),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 32),
            const Icon(Icons.lock_reset, size: 80, color: Color(0xFF2E6BFF)),
            const SizedBox(height: 32),
            const Text(
              '비밀번호를 잊으셨나요?',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF111111),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            const Text(
              '이메일 주소를 입력하시면\n비밀번호 재설정 링크를 보내드립니다',
              style: TextStyle(fontSize: 16, color: Color(0xFF555555)),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 48),
            TextField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                labelText: '이메일',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.email_outlined),
              ),
            ),
            const SizedBox(height: 24),
            CustomButton(
              text: '재설정 링크 보내기',
              fullWidth: true,
              onPressed: () {
                // Show success message
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(const SnackBar(content: Text('이메일이 전송되었습니다!')));
                context.go('/auth/login');
              },
            ),
          ],
        ),
      ),
    );
  }
}
