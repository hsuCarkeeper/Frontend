import 'package:flutter/material.dart';

class CustomFAB extends StatelessWidget {
  final VoidCallback onPressed;
  final IconData icon;
  final Color? backgroundColor;
  final Color? foregroundColor;

  const CustomFAB({
    super.key,
    required this.onPressed,
    this.icon = Icons.add,
    this.backgroundColor,
    this.foregroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: onPressed,
      backgroundColor: backgroundColor ?? const Color(0xFF2E6BFF),
      foregroundColor: foregroundColor ?? Colors.white,
      child: Icon(icon, size: 28),
    );
  }
}
