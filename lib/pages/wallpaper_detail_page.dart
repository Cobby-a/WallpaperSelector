import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:wallpaper_selector/pages/nav_detail.dart';
import '../models/wallpaper_model.dart';
import '../providers/wallpaper_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/wallpaper_card.dart';
import '../services/wallpaper_service.dart';
import 'wallpaper_setup_dialog.dart';
import '../main.dart';

class WallpaperDetailPage extends StatefulWidget {
  final WallpaperCategory category;

  const WallpaperDetailPage({super.key, required this.category});

  @override
  State<WallpaperDetailPage> createState() => _WallpaperDetailPageState();
}

class _WallpaperDetailPageState extends State<WallpaperDetailPage> {
  Wallpaper? selectedWallpaper;
  bool isGridView = true;

  @override
  void initState() {
    super.initState();
    selectedWallpaper = widget.category.wallpapers.first;
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = Responsive.isMobile(context);

    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: Column(
        children: [
          _buildMainNavBar(context),
          
          Container(
            color: AppTheme.backgroundColor,
            padding: EdgeInsets.symmetric(
              horizontal: isMobile ? 20 : 48,
              vertical: 20,
            ),
            child: Align(
              alignment: Alignment.centerLeft,
              child: InkWell(
                onTap: () => Navigator.pop(context),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SvgPicture.asset(
                      'assets/icons/back.svg',
                      width: 18,
                      height: 18,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Back to Categories',
                      style: AppTheme.bodyMedium.copyWith(
                        color: AppTheme.textGrey,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          
          Expanded(
            child: isMobile
                ? _buildMobileLayout(context)
                : _buildDesktopLayout(context),
          ),
        ],
      ),
    );
  }

  Widget _buildMainNavBar(BuildContext context) {
    final isMobile = Responsive.isMobile(context);
    final screenHeight = MediaQuery.of(context).size.height;
    final navBarHeight = screenHeight * (120 / 1024);
    
    return Container(
      height: navBarHeight,
      decoration: BoxDecoration(
        color: AppTheme.navBarBackground,
        boxShadow: AppTheme.navBarShadow,
      ),
      padding: EdgeInsets.symmetric(horizontal: isMobile ? 20 : 48),
      child: Row(
        children: [
          _buildLogo(),
          const Spacer(),
          if (!isMobile) ..._buildNavItems(context),
          if (isMobile) _buildMobileMenuButton(),
        ],
      ),
    );
  }

  Widget _buildLogo() {
    return Row(
      children: [
        Container(
          width: 16,
          height: 16,
          decoration: const BoxDecoration(
            color: Colors.transparent,
          ),
          child: SvgPicture.asset(
            'assets/icons/logo.svg',
            width: 16,
            height: 16,
          ),
        ),
        const SizedBox(width: 8),
        Text(
          'Wallpaper Studio',
          style: AppTheme.bodySmall.copyWith(fontSize: 14),
        ),
      ],
    );
  }
List<Widget> _buildNavItems(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    
    return [
      DetailNavItem(
        icon: 'home',
        label: 'Home',
        isSelected: false,
        onTap: () => Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const MainScreen(initialIndex: 0)),
          (route) => false,
        ),
        screenWidth: screenWidth,
      ),
      const SizedBox(width: 8),
      DetailNavItem(
        icon: 'browse',
        label: 'Browse',
        isSelected: true,
        onTap: () => Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const MainScreen(initialIndex: 1)),
          (route) => false,
        ),
        screenWidth: screenWidth,
      ),
      const SizedBox(width: 8),
      DetailNavItem(
        icon: 'love',
        label: 'Favourites',
        isSelected: false,
        onTap: () => Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const MainScreen(initialIndex: 2)),
          (route) => false,
        ),
        screenWidth: screenWidth,
      ),
      const SizedBox(width: 8),
      DetailNavItem(
        icon: 'settings',
        label: 'Settings',
        isSelected: false,
        onTap: () => Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const MainScreen(initialIndex: 3)),
          (route) => false,
        ),
        screenWidth: screenWidth,
      ),
    ];
  }

  
  Widget _buildMobileMenuButton() {
    return IconButton(
      icon: SvgPicture.asset(
        'assets/icons/menu.svg',
        width: 24,
        height: 24,
      ),
      onPressed: () {},
    );
  }

  Widget _buildDesktopLayout(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 1,
          child: _buildWallpaperList(context),
        ),
        
        Expanded(
          flex: 1,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
            color: Colors.white,
            ),
            child: _buildPreviewPanel(context, false),
          ),
        ),
      ],
    );
  }

  Widget _buildMobileLayout(BuildContext context) {
    return _buildWallpaperList(context);
  }

  Widget _buildWallpaperList(BuildContext context) {
    final provider = Provider.of<WallpaperProvider>(context);
    final isMobile = Responsive.isMobile(context);

    return Transform.translate(
      offset: const Offset(0, -16),
      child: Container(
      color: AppTheme.backgroundColor,
      padding: EdgeInsets.all(isMobile ? 20 : 48),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                widget.category.name,
                style: AppTheme.displayHeading,
              ),
              Row(
                children: [
                  _buildViewToggleButton(
                    iconPath: 'assets/icons/grid.svg',
                    isSelected: isGridView,
                    onTap: () => setState(() => isGridView = true),
                  ),
                  const SizedBox(width: 12),
                  _buildViewToggleButton(
                    iconPath: 'assets/icons/list.svg',
                    isSelected: !isGridView,
                    onTap: () => setState(() => isGridView = false),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 24),
          Expanded(
            child: isGridView
                ? _buildGridView(context, provider, isMobile)
                : _buildListViewContent(context, provider),
          ),
        ],
      )),
    );
  }

  Widget _buildGridView(BuildContext context, WallpaperProvider provider, bool isMobile) {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: isMobile ? 2 : 3,
        childAspectRatio: 190 / 290,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: widget.category.wallpapers.length,
      itemBuilder: (context, index) {
        final wallpaper = widget.category.wallpapers[index];
        return WallpaperGridItem(
          wallpaper: wallpaper,
          onTap: () {
            setState(() => selectedWallpaper = wallpaper);
            if (isMobile) {
              _showMobilePreview(context, wallpaper);
            }
          },
          onFavoriteToggle: () => provider.toggleFavorite(wallpaper.id),
        );
      },
    );
  }

  Widget _buildListViewContent(BuildContext context, WallpaperProvider provider) {
    return ListView.builder(
      itemCount: widget.category.wallpapers.length,
      itemBuilder: (context, index) {
        final wallpaper = widget.category.wallpapers[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: WallpaperGridItem(
            wallpaper: wallpaper,
            onTap: () {
              setState(() => selectedWallpaper = wallpaper);
              if (Responsive.isMobile(context)) {
                _showMobilePreview(context, wallpaper);
              }
            },
            onFavoriteToggle: () => provider.toggleFavorite(wallpaper.id),
          ),
        );
      },
    );
  }

  Widget _buildViewToggleButton({
    required String iconPath,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          color: isSelected ? AppTheme.selectedOrangeBg : AppTheme.iconButtonBg,
          borderRadius: AppTheme.iconButtonRadius,
          border: Border.all(color: const Color(0xFFE5E5E5), width: 0.5),
        ),
        child: Center(
          child: SvgPicture.asset(
            iconPath,
            width: 18,
            height: 18,
            colorFilter: ColorFilter.mode(
              isSelected ? AppTheme.selectedOrange : AppTheme.iconGrey,
              BlendMode.srcIn,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPreviewPanel(BuildContext context, bool isMobile) {
    if (selectedWallpaper == null) return const SizedBox();

    final provider = Provider.of<WallpaperProvider>(context);

    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.all(isMobile ? 20 : 48),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Preview', style: AppTheme.categoryHeading),
                      const SizedBox(height: 32),
                      Text(
                        'Name',
                        style: AppTheme.bodySmall.copyWith(
                          color: AppTheme.iconGrey,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        selectedWallpaper!.name,
                        style: AppTheme.categoryHeading.copyWith(fontSize: 24),
                      ),
                      const SizedBox(height: 24),
                      Text(
                        'Tags',
                        style: AppTheme.bodySmall.copyWith(
                          color: AppTheme.iconGrey,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: selectedWallpaper!.tags.map((tag) {
                          return Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: AppTheme.buttonBg,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: AppTheme.borderGrey),
                            ),
                            child: Text(tag, style: AppTheme.bodySmall),
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 24),
                      Text(
                        'Description',
                        style: AppTheme.bodySmall.copyWith(
                          color: AppTheme.iconGrey,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        selectedWallpaper!.description,
                        style: AppTheme.bodyMedium.copyWith(
                          color: AppTheme.textGrey,
                        ),
                      ),
                      const SizedBox(height: 32),
                      Row(
                        children: [
                          _buildActionButton('assets/icons/share.svg', () {}), // Changed: Use SVG
                          const SizedBox(width: 16),
                          _buildActionButton('assets/icons/fullscreen.svg', () {}), // Changed: Use SVG
                          const SizedBox(width: 16),
                          _buildActionButton(
                            'assets/icons/settings.svg', // Changed: Use SVG
                            () => _showWallpaperSetup(context, isMobile),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 32),
                _buildPhoneMockup(),
              ],
            ),
            const SizedBox(height: 48),
            _buildActionButtons(context, provider),
          ],
        ),
      ),
    );
  }

  Widget _buildPhoneMockup() {
    return Container(
      width: 280,
      height: 560,
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(40),
        border: Border.all(color: Colors.black, width: 8),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(32),
        child: Stack(
          children: [
            Positioned.fill(
              child: Image.asset(
                selectedWallpaper!.imagePath,
                fit: BoxFit.cover,
              ),
            ),
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Container(
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.3),
                ),
                child: Center(
                  child: Container(
                    width: 120,
                    height: 30,
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 10,
              left: 0,
              right: 0,
              child: Center(
                child: Container(
                  width: 140,
                  height: 5,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton(String iconPath, VoidCallback onPressed) {
    return Container(
      width: 32,
      height: 32,
      decoration: AppTheme.iconButtonDecoration,
      child: IconButton(
        icon: SvgPicture.asset(
          iconPath,
          width: 18,
          height: 18,
          colorFilter: ColorFilter.mode(
            AppTheme.iconGrey,
            BlendMode.srcIn,
          ),
        ),
        padding: EdgeInsets.zero,
        onPressed: onPressed,
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context, WallpaperProvider provider) {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton.icon(
            onPressed: () => provider.toggleFavorite(selectedWallpaper!.id),
            icon: Icon(
              selectedWallpaper!.isFavorite ? Icons.favorite : Icons.favorite_border,
              color: AppTheme.primaryBlack,
            ),
            label: const Text('Save to Favorites'),
            style: OutlinedButton.styleFrom(
              foregroundColor: AppTheme.primaryBlack,
              side: BorderSide(color: AppTheme.primaryBlack.withValues(alpha: 0.2)),
              padding: const EdgeInsets.symmetric(vertical: 18),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: ElevatedButton(
            onPressed: () async {
              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (context) => const Center(
                  child: CircularProgressIndicator(),
                ),
              );

              final success = await WallpaperService.setWallpaper(
                selectedWallpaper!.imagePath,
              );

              await provider.setActiveWallpaper(selectedWallpaper!);

              if (context.mounted) {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      success
                          ? 'Wallpaper set successfully!'
                          : 'Wallpaper saved as active. You may need to set it manually.',
                    ),
                  ),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.orangeGradientStart,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 18),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
              ),
            ),
            child: const Text('Set as Wallpaper'),
          ),
        ),
      ],
    );
  }

  void _showMobilePreview(BuildContext context, Wallpaper wallpaper) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.9,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        builder: (_, controller) => Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: _buildPreviewPanel(context, true),
        ),
      ),
    );
  }

  void _showWallpaperSetup(BuildContext context, bool isMobile) {
    showDialog(
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.1),
      builder: (context) => WallpaperSetupDialog(isMobile: isMobile),
    );
  }
}