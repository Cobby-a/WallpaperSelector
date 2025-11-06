import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import '../providers/wallpaper_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/wallpaper_card.dart';
import 'wallpaper_detail_page.dart';

class BrowsePage extends StatelessWidget {
  const BrowsePage({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<WallpaperProvider>(context);
    final isMobile = Responsive.isMobile(context);

    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.fromLTRB(
          isMobile ? 20 : 48,
          isMobile ? 35 : 50,
          isMobile ? 20 : 48,
          isMobile ? 20 : 48,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(context, provider, isMobile),
            const SizedBox(height: 40),
            _buildCategoriesList(context, provider),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, WallpaperProvider provider, bool isMobile) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ShaderMask(
                    shaderCallback: (bounds) => AppTheme.orangeGradient.createShader(bounds),
                    blendMode: BlendMode.srcIn,
                    child: Text(
                      'Browse Wallpapers',
                      style: isMobile
                          ? AppTheme.displayHeadingMobile.copyWith(
                              fontSize: responsiveFontSize(context, base: 48, min: 22, max: 60),
                            )
                          : AppTheme.displayHeadingDesktop.copyWith(
                              fontSize: responsiveFontSize(context, base: 60, min: 36, max: 72),
                            ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Explore our complete collection of beautiful wallpapers',
                    style: isMobile
                    ? AppTheme.subtitleMobile.copyWith(
                        fontSize: responsiveFontSize(context, base: 18, min: 14, max: 22),
                      )
                    : AppTheme.subtitleDesktop.copyWith(
                        fontSize: responsiveFontSize(context, base: 24, min: 18, max: 28),
                      ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 20),
            Row(
              children: [
                _buildViewToggleButton(
                  iconPath: 'assets/icons/grid.svg',
                  isSelected: provider.isGridView,
                  onTap: () {
                    if (!provider.isGridView) provider.toggleView();
                  },
                ),
                const SizedBox(width: 12),
                _buildViewToggleButton(
                  iconPath: 'assets/icons/list.svg',
                  isSelected: !provider.isGridView,
                  onTap: () {
                    if (provider.isGridView) provider.toggleView();
                  },
                ),
              ],
            ),
          ],
        ),
      ],
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
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: isSelected
              ? AppTheme.selectedOrangeBg
              : AppTheme.iconButtonBg,
          borderRadius: AppTheme.iconButtonRadius,
          border: Border.all(
            color: const Color(0xFFE5E5E5),
            width: 0.5,
          ),
        ),
        child: Center(
          child: SvgPicture.asset(
            iconPath,
            width: 24,
            height: 24,
            colorFilter: ColorFilter.mode(
              isSelected ? AppTheme.selectedOrange : AppTheme.iconGrey,
              BlendMode.srcIn,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCategoriesList(BuildContext context, WallpaperProvider provider) {
    if (provider.isGridView) {
      return _buildGridView(context, provider);
    } else {
      return _buildListView(context, provider);
    }
  }

  Widget _buildGridView(BuildContext context, WallpaperProvider provider) {
    final screenWidth = MediaQuery.of(context).size.width;
  final isMobile = Responsive.isMobile(context);

  int crossAxisCount;
  if (isMobile) {
    crossAxisCount = 1;
  } else if (screenWidth < 1024) {
    crossAxisCount = 2;
  } else {
    crossAxisCount = 3;
  }
    final totalSpacing = 20 * (crossAxisCount - 1);
  final cardWidth = (screenWidth - totalSpacing - (screenWidth * 0.08)) / crossAxisCount;
  const cardAspectRatio = 436 / 292;
  final cardHeight = cardWidth / cardAspectRatio;

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: 20,
        mainAxisSpacing: 20,
        childAspectRatio: cardAspectRatio,
      ),
      itemCount: provider.categories.length,
      itemBuilder: (context, index) {
        final category = provider.categories[index];
        return SizedBox(
          width: cardWidth,
          height: cardHeight,
        child:  WallpaperCategoryCard(
          category: category,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => WallpaperDetailPage(category: category),
              ),
            );
          },
        ),
        );
      },
    );
  }

  Widget _buildListView(BuildContext context, WallpaperProvider provider) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: provider.categories.length,
      itemBuilder: (context, index) {
        final category = provider.categories[index];
        final representativeWallpaper = category.wallpapers.first;
        
        return WallpaperListItem(
          wallpaper: representativeWallpaper,
          wallpaperCount: category.wallpaperCount,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => WallpaperDetailPage(category: category),
              ),
            );
          },
          onFavoriteToggle: () {
            provider.toggleFavorite(representativeWallpaper.id);
          },
        );
      },
    );
  }
}