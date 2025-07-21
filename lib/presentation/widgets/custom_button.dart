// lib/core/widgets/custom_button.dart
import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';

enum ButtonType { primary, secondary, outline, text }
enum ButtonSize { small, medium, large }

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final ButtonType type;
  final ButtonSize size;
  final IconData? icon;
  final bool isLoading;
  final bool isDisabled;
  final Color? customColor;
  final double? width;

  const CustomButton({
    Key? key,
    required this.text,
    this.onPressed,
    this.type = ButtonType.primary,
    this.size = ButtonSize.medium,
    this.icon,
    this.isLoading = false,
    this.isDisabled = false,
    this.customColor,
    this.width,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isEnabled = !isDisabled && !isLoading && onPressed != null;

    return SizedBox(
      width: width,
      height: _getHeight(),
      child: _buildButton(context, isEnabled),
    );
  }

  Widget _buildButton(BuildContext context, bool isEnabled) {
    switch (type) {
      case ButtonType.primary:
        return _buildPrimaryButton(context, isEnabled);
      case ButtonType.secondary:
        return _buildSecondaryButton(context, isEnabled);
      case ButtonType.outline:
        return _buildOutlineButton(context, isEnabled);
      case ButtonType.text:
        return _buildTextButton(context, isEnabled);
    }
  }

  Widget _buildPrimaryButton(BuildContext context, bool isEnabled) {
    return ElevatedButton(
      onPressed: isEnabled ? onPressed : null,
      style: ElevatedButton.styleFrom(
        backgroundColor: customColor ?? AppColors.primary,
        foregroundColor: Colors.white,
        disabledBackgroundColor: AppColors.onSurfaceVariant.withOpacity(0.12),
        disabledForegroundColor: AppColors.onSurfaceVariant.withOpacity(0.38),
        elevation: isEnabled ? 2 : 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(_getBorderRadius()),
        ),
        padding: _getPadding(),
      ),
      child: _buildButtonContent(context),
    );
  }

  Widget _buildSecondaryButton(BuildContext context, bool isEnabled) {
    return ElevatedButton(
      onPressed: isEnabled ? onPressed : null,
      style: ElevatedButton.styleFrom(
        backgroundColor: customColor ?? AppColors.secondary,
        foregroundColor: Colors.white,
        disabledBackgroundColor: AppColors.onSurfaceVariant.withOpacity(0.12),
        disabledForegroundColor: AppColors.onSurfaceVariant.withOpacity(0.38),
        elevation: isEnabled ? 2 : 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(_getBorderRadius()),
        ),
        padding: _getPadding(),
      ),
      child: _buildButtonContent(context),
    );
  }

  Widget _buildOutlineButton(BuildContext context, bool isEnabled) {
    return OutlinedButton(
      onPressed: isEnabled ? onPressed : null,
      style: OutlinedButton.styleFrom(
        foregroundColor: customColor ?? AppColors.primary,
        disabledForegroundColor: AppColors.onSurfaceVariant.withOpacity(0.38),
        side: BorderSide(
          color: isEnabled
              ? (customColor ?? AppColors.primary)
              : AppColors.onSurfaceVariant.withOpacity(0.12),
          width: 1.5,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(_getBorderRadius()),
        ),
        padding: _getPadding(),
      ),
      child: _buildButtonContent(context),
    );
  }

  Widget _buildTextButton(BuildContext context, bool isEnabled) {
    return TextButton(
      onPressed: isEnabled ? onPressed : null,
      style: TextButton.styleFrom(
        foregroundColor: customColor ?? AppColors.primary,
        disabledForegroundColor: AppColors.onSurfaceVariant.withOpacity(0.38),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(_getBorderRadius()),
        ),
        padding: _getPadding(),
      ),
      child: _buildButtonContent(context),
    );
  }

  Widget _buildButtonContent(BuildContext context) {
    if (isLoading) {
      return SizedBox(
        width: _getLoadingSize(),
        height: _getLoadingSize(),
        child: CircularProgressIndicator(
          color: type == ButtonType.primary || type == ButtonType.secondary
              ? Colors.white
              : (customColor ?? AppColors.primary),
          strokeWidth: 2,
        ),
      );
    }

    if (icon != null) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: _getIconSize()),
          SizedBox(width: _getIconSpacing()),
          Text(
            text,
            style: _getTextStyle(context),
          ),
        ],
      );
    }

    return Text(
      text,
      style: _getTextStyle(context),
      textAlign: TextAlign.center,
    );
  }

  double _getHeight() {
    switch (size) {
      case ButtonSize.small:
        return 36;
      case ButtonSize.medium:
        return 48;
      case ButtonSize.large:
        return 56;
    }
  }

  double _getBorderRadius() {
    switch (size) {
      case ButtonSize.small:
        return 8;
      case ButtonSize.medium:
        return 12;
      case ButtonSize.large:
        return 16;
    }
  }

  EdgeInsets _getPadding() {
    switch (size) {
      case ButtonSize.small:
        return const EdgeInsets.symmetric(horizontal: 12, vertical: 8);
      case ButtonSize.medium:
        return const EdgeInsets.symmetric(horizontal: 16, vertical: 12);
      case ButtonSize.large:
        return const EdgeInsets.symmetric(horizontal: 24, vertical: 16);
    }
  }

  double _getLoadingSize() {
    switch (size) {
      case ButtonSize.small:
        return 16;
      case ButtonSize.medium:
        return 20;
      case ButtonSize.large:
        return 24;
    }
  }

  double _getIconSize() {
    switch (size) {
      case ButtonSize.small:
        return 16;
      case ButtonSize.medium:
        return 20;
      case ButtonSize.large:
        return 24;
    }
  }

  double _getIconSpacing() {
    switch (size) {
      case ButtonSize.small:
        return 6;
      case ButtonSize.medium:
        return 8;
      case ButtonSize.large:
        return 12;
    }
  }

  TextStyle _getTextStyle(BuildContext context) {
    final baseStyle = Theme.of(context).textTheme.labelLarge?.copyWith(
      fontWeight: FontWeight.w600,
    );

    switch (size) {
      case ButtonSize.small:
        return baseStyle?.copyWith(fontSize: 12) ?? const TextStyle(fontSize: 12);
      case ButtonSize.medium:
        return baseStyle?.copyWith(fontSize: 14) ?? const TextStyle(fontSize: 14);
      case ButtonSize.large:
        return baseStyle?.copyWith(fontSize: 16) ?? const TextStyle(fontSize: 16);
    }
  }
}

// Convenience constructors
class PrimaryButton extends CustomButton {
  const PrimaryButton({
    Key? key,
    required String text,
    VoidCallback? onPressed,
    ButtonSize size = ButtonSize.medium,
    IconData? icon,
    bool isLoading = false,
    bool isDisabled = false,
    Color? customColor,
    double? width,
  }) : super(
    key: key,
    text: text,
    onPressed: onPressed,
    type: ButtonType.primary,
    size: size,
    icon: icon,
    isLoading: isLoading,
    isDisabled: isDisabled,
    customColor: customColor,
    width: width,
  );
}

class SecondaryButton extends CustomButton {
  const SecondaryButton({
    Key? key,
    required String text,
    VoidCallback? onPressed,
    ButtonSize size = ButtonSize.medium,
    IconData? icon,
    bool isLoading = false,
    bool isDisabled = false,
    Color? customColor,
    double? width,
  }) : super(
    key: key,
    text: text,
    onPressed: onPressed,
    type: ButtonType.secondary,
    size: size,
    icon: icon,
    isLoading: isLoading,
    isDisabled: isDisabled,
    customColor: customColor,
    width: width,
  );
}

class OutlineButton extends CustomButton {
  const OutlineButton({
    Key? key,
    required String text,
    VoidCallback? onPressed,
    ButtonSize size = ButtonSize.medium,
    IconData? icon,
    bool isLoading = false,
    bool isDisabled = false,
    Color? customColor,
    double? width,
  }) : super(
    key: key,
    text: text,
    onPressed: onPressed,
    type: ButtonType.outline,
    size: size,
    icon: icon,
    isLoading: isLoading,
    isDisabled: isDisabled,
    customColor: customColor,
    width: width,
  );
}