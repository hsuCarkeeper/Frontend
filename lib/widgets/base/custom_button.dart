import 'package:flutter/material.dart';

enum ButtonVariant { primary, secondary, outline, ghost }

enum ButtonSize { sm, md, lg }

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final ButtonVariant variant;
  final ButtonSize size;
  final bool fullWidth;
  final Widget? icon;

  const CustomButton({
    super.key,
    required this.text,
    this.onPressed,
    this.variant = ButtonVariant.primary,
    this.size = ButtonSize.md,
    this.fullWidth = false,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    Color getBackgroundColor() {
      switch (variant) {
        case ButtonVariant.primary:
          return const Color(0xFF2E6BFF);
        case ButtonVariant.secondary:
          return const Color(0xFF00B894);
        case ButtonVariant.outline:
          return Colors.transparent;
        case ButtonVariant.ghost:
          return Colors.transparent;
      }
    }

    Color getForegroundColor() {
      switch (variant) {
        case ButtonVariant.primary:
        case ButtonVariant.secondary:
          return Colors.white;
        case ButtonVariant.outline:
          return const Color(0xFF2E6BFF);
        case ButtonVariant.ghost:
          return const Color(0xFF555555);
      }
    }

    BorderSide? getBorderSide() {
      if (variant == ButtonVariant.outline) {
        return const BorderSide(color: Color(0xFF2E6BFF), width: 2);
      }
      return null;
    }

    EdgeInsets getPadding() {
      switch (size) {
        case ButtonSize.sm:
          return const EdgeInsets.symmetric(horizontal: 12, vertical: 8);
        case ButtonSize.md:
          return const EdgeInsets.symmetric(horizontal: 16, vertical: 12);
        case ButtonSize.lg:
          return const EdgeInsets.symmetric(horizontal: 24, vertical: 16);
      }
    }

    double getFontSize() {
      switch (size) {
        case ButtonSize.sm:
          return 14;
        case ButtonSize.md:
          return 16;
        case ButtonSize.lg:
          return 18;
      }
    }

    return SizedBox(
      width: fullWidth ? double.infinity : null,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: getBackgroundColor(),
          foregroundColor: getForegroundColor(),
          padding: getPadding(),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: getBorderSide() ?? BorderSide.none,
          ),
          elevation: variant == ButtonVariant.ghost ? 0 : 2,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (icon != null) ...[icon!, const SizedBox(width: 8)],
            Text(
              text,
              style: TextStyle(
                fontSize: getFontSize(),
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
