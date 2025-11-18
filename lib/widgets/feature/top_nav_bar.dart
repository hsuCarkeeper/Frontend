import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class TopNavBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool showBack;
  final List<Widget>? actions;

  const TopNavBar({
    super.key,
    required this.title,
    this.showBack = false,
    this.actions,
  });

  @override
  Size get preferredSize => const Size.fromHeight(64);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 1,
      leading: showBack
          ? IconButton(
              icon: const Icon(Icons.arrow_back, color: Color(0xFF111111)),
              onPressed: () => context.pop(),
            )
          : null,
      title: Text(
        title,
        style: const TextStyle(
          color: Color(0xFF111111),
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
      ),
      actions: actions,
    );
  }
}
