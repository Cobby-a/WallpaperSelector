import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:wallpaper_selector/theme/app_theme.dart';

class MyWidget extends StatelessWidget {
  const MyWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
class DetailNavItem extends StatelessWidget {
  final String icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  final double screenWidth;

  const DetailNavItem({
    super.key,
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
    required this.screenWidth,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: AppTheme.buttonRadius,
      child: Container(
        padding: EdgeInsets.symmetric(
          vertical: screenWidth * (10 / 1440),
          horizontal: screenWidth * (16 / 1440),
        ),
        decoration: isSelected
            ? BoxDecoration(
                color: AppTheme.buttonBg,
                borderRadius: AppTheme.buttonRadius,
                border: Border.all(
                  color: AppTheme.primaryBlack.withValues(alpha: 0.1),
                  width: 1,
                ),
              )
            : null,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SvgPicture.asset(
              'assets/icons/$icon.svg',
              width: 18,
              height: 18,
              colorFilter: ColorFilter.mode(
                isSelected
                    ? AppTheme.primaryBlack
                    : AppTheme.primaryBlack.withValues(alpha: 0.5),
                BlendMode.srcIn,
              ),
            ),
            const SizedBox(width: 12),
            Text(
              label,
              style: AppTheme.navText.copyWith(
                color: isSelected
                    ? AppTheme.primaryBlack
                    : AppTheme.primaryBlack.withValues(alpha: 0.5),
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}