import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../theme/app_theme.dart';

class AppNavBar extends StatelessWidget implements PreferredSizeWidget{
  final int currentIndex;
  final Function(int) onNavItemTapped;

  const AppNavBar({super.key, required this.currentIndex, required this.onNavItemTapped});

  @override
  Size get preferredSize => const Size.fromHeight(98);

  @override
  Widget build(BuildContext context) {
    final isMobile = Responsive.isMobile(context);
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final navBarHeight = screenHeight * (120 / 1024);

    return Container(
      height: navBarHeight,
      decoration: BoxDecoration(
        color: AppTheme.navBarBackground,
        boxShadow: AppTheme.navBarShadow
      ),
      padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04),
      child: Row(
        children: [
          _buildLogo(),
          const Spacer(),
          if(!isMobile) ..._buildNavItems(context),
          if(isMobile) _buildMobileMenu(context)
        ],
      ),
    );
  }
  Widget _buildLogo(){
  return Row(
    children: [
      Container(
        width: 16,
        height: 16,
        decoration: BoxDecoration(
            color: Colors.transparent,
          ),
        child: SvgPicture.asset('assets/icons/logo.svg', width: 16, height: 16,),
      ),
      const SizedBox(width: 8),
      Text(
        'Wallpaper Studio',
        style: AppTheme.bodySmall.copyWith(fontSize: 14),
      )
    ],
  );
}

List<Widget> _buildNavItems(BuildContext context) {
    final navItems = [
      _NavItem(
        icon: 'home',
        label: 'Home',
        isSelected: currentIndex == 0,
        onTap: () => onNavItemTapped(0),
      ),
      const SizedBox(width: 8),
      _NavItem(
        icon: 'browse',
        label: 'Browse',
        isSelected: currentIndex == 1,
        onTap: () => onNavItemTapped(1),
      ),
      const SizedBox(width: 8),
      _NavItem(
        icon: 'love',
        label: 'Favourites',
        isSelected: currentIndex == 2,
        onTap: () => onNavItemTapped(2),
      ),
      const SizedBox(width: 8),
      _NavItem(
        icon: 'settings',
        label: 'Settings',
        isSelected: currentIndex == 3,
        onTap: () => onNavItemTapped(3),
      ),
    ];

    return navItems;
  }

Widget _buildMobileMenu(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.menu, size: 24),
      onPressed: () => _showMobileDrawer(context),
    );
  }

void _showMobileDrawer(BuildContext context) {
      final screenWidth = MediaQuery.of(context).size.width;
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
      barrierColor: Colors.black54,
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (context, animation, secondaryAnimation) {
        return Align(
          alignment: Alignment.centerRight,
          child: Material(
            color: Colors.transparent,
            child: Container(
              width: 370,
              height: double.infinity,
              decoration: const BoxDecoration(
                color: AppTheme.navBarBackground,
              ),
              padding: EdgeInsets.fromLTRB(screenWidth* (70/1440), screenWidth * (20/1440), screenWidth * (20/1440), screenWidth * (20/1440)),

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _MobileNavItem(
                    icon: 'home',
                    label: 'Home',
                    isSelected: currentIndex == 0,
                    onTap: () {
                      Navigator.pop(context);
                      onNavItemTapped(0);
                    },
                  ),
                  const SizedBox(height: 8),
                  const Divider(color: AppTheme.borderGrey, height: 1),
                  const SizedBox(height: 16),
                  _MobileNavItem(
                    icon: 'browse',
                    label: 'Browse',
                    isSelected: currentIndex == 1,
                    onTap: () {
                      Navigator.pop(context);
                      onNavItemTapped(1);
                    },
                  ),
                  const SizedBox(height: 8),
                  const Divider(color: AppTheme.borderGrey, height: 1),
                  const SizedBox(height: 16),

                  _MobileNavItem(
                    icon: 'love',
                    label: 'Favourites',
                    isSelected: currentIndex == 2,
                    onTap: () {
                      Navigator.pop(context);
                      onNavItemTapped(2);
                    },
                  ),
                  const SizedBox(height: 8),
                  const Divider(color: AppTheme.borderGrey, height: 1),
                  const SizedBox(height: 16),
                  _MobileNavItem(
                    icon: 'settings',
                    label: 'Settings',
                    isSelected: currentIndex == 3,
                    onTap: () {
                      Navigator.pop(context);
                      onNavItemTapped(3);
                    },
                  ),
                  const SizedBox(height: 8),
                  const Divider(color: AppTheme.borderGrey, height: 1),
                  const SizedBox(height: 16),

                ],
              ),
            ),
          ),
        );
      },
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(1.0, 0.0),
            end: Offset.zero,
          ).animate(animation),
          child: child,
        );
      },
    );
  }
}



class _NavItem extends StatelessWidget {
  final String icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _NavItem({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return InkWell(
      onTap: onTap,
      borderRadius: AppTheme.buttonRadius,
      child: Container(
        padding: EdgeInsets.symmetric(
          vertical: screenWidth * (10 / 1440),
          horizontal: screenWidth * (16 / 1440),
        ),
        decoration: isSelected ? BoxDecoration(
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
                width: responsiveFontSize(context, base: 18, min: 14, max: 22),
                height: responsiveFontSize(context, base: 18, min: 14, max: 22),
                colorFilter: ColorFilter.mode(
                  isSelected ? AppTheme.primaryBlack : AppTheme.primaryBlack.withValues(alpha: 0.5),
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
                    fontSize: responsiveFontSize(context, base: 14, min: 12, max: 16),
                  ),
                ),
            ],
          ),
      ),
    );
  }
}

class _MobileNavItem extends StatelessWidget {

  final String icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _MobileNavItem({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Row(
          children: [
            SvgPicture.asset(
                'assets/icons/$icon.svg',
                width: responsiveFontSize(context, base: 20, min: 16, max: 24),
                height: responsiveFontSize(context, base: 20, min: 16, max: 24),
              colorFilter: ColorFilter.mode(
                  isSelected ? AppTheme.primaryBlack
                  : AppTheme.primaryBlack.withValues(alpha: 0.5),
                  BlendMode.srcIn
            )),
            const SizedBox(width: 12),
            Text(
              label,
              style: AppTheme.bodyMedium.copyWith(
                color: isSelected
                    ? AppTheme.primaryBlack
                    : AppTheme.primaryBlack.withValues(alpha: 0.5),
                fontWeight: isSelected ? FontWeight.w500 : FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

