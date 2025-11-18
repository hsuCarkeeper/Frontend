import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../widgets/feature/top_nav_bar.dart';
import '../../widgets/base/custom_button.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const TopNavBar(title: '회원가입', showBack: true),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 32),
            const Text(
              '환영합니다!',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Color(0xFF111111),
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              '계정을 만들어 시작하세요',
              style: TextStyle(fontSize: 16, color: Color(0xFF555555)),
            ),
            const SizedBox(height: 48),
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: '이름',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.person_outlined),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                labelText: '이메일',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.email_outlined),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: '비밀번호',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.lock_outlined),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _confirmPasswordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: '비밀번호 확인',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.lock_outlined),
              ),
            ),
            const SizedBox(height: 32),
            CustomButton(
              text: '가입하기',
              fullWidth: true,
              onPressed: () => context.go('/'),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('이미 계정이 있으신가요?'),
                TextButton(
                  onPressed: () => context.go('/auth/login'),
                  child: const Text('로그인'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
