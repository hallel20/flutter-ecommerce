import 'package:flutter/material.dart';

/// Reusable custom button widget with consistent styling
/// Provides different button variants for various use cases
class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final ButtonStyle? style;
  final Widget? icon;
  final bool isLoading;
  final ButtonType type;

  const CustomButton({
    super.key,
    required this.text,
    this.onPressed,
    this.style,
    this.icon,
    this.isLoading = false,
    this.type = ButtonType.elevated,
  });

  /// Factory constructor for primary button
  const CustomButton.primary({
    super.key,
    required this.text,
    this.onPressed,
    this.icon,
    this.isLoading = false,
  }) : type = ButtonType.elevated,
       style = null;

  /// Factory constructor for secondary button
  const CustomButton.secondary({
    super.key,
    required this.text,
    this.onPressed,
    this.icon,
    this.isLoading = false,
  }) : type = ButtonType.outlined,
       style = null;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    /// Show loading indicator when button is in loading state
    if (isLoading) {
      return SizedBox(
        height: 48,
        child: Center(
          child: SizedBox(
            width: 24,
            height: 24,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(
                theme.colorScheme.primary,
              ),
            ),
          ),
        ),
      );
    }

    switch (type) {
      case ButtonType.elevated:
        return icon != null
            ? ElevatedButton.icon(
                onPressed: onPressed,
                icon: icon!,
                label: Text(text),
                style: style,
              )
            : ElevatedButton(
                onPressed: onPressed,
                style: style,
                child: Text(text),
              );
      
      case ButtonType.outlined:
        return icon != null
            ? OutlinedButton.icon(
                onPressed: onPressed,
                icon: icon!,
                label: Text(text),
                style: style,
              )
            : OutlinedButton(
                onPressed: onPressed,
                style: style,
                child: Text(text),
              );
      
      case ButtonType.text:
        return icon != null
            ? TextButton.icon(
                onPressed: onPressed,
                icon: icon!,
                label: Text(text),
                style: style,
              )
            : TextButton(
                onPressed: onPressed,
                style: style,
                child: Text(text),
              );
    }
  }
}

/// Enum for different button types
enum ButtonType {
  elevated,
  outlined,
  text,
}