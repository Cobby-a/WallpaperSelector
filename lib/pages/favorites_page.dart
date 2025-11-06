import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import '../providers/wallpaper_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/wallpaper_card.dart';
import 'wallpaper_detail_page.dart';
import '../main.dart';

class FavoritesPage extends StatelessWidget {
  const FavoritesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<WallpaperProvider>(context);
    final isMobile = Responsive.isMobile(context);
    final favorites = provider.favoriteWallpapers;

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
            _buildHeader(context, isMobile),
            const SizedBox(height: 16),
            _buildSubtitle(context, isMobile),
            const SizedBox(height: 50),
            favorites.isEmpty
                ? _buildEmptyState(context, isMobile)
                : _buildFavoriteGrid(context, provider, favorites),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, bool isMobile) {
    return ShaderMask(
      shaderCallback: (bounds) => AppTheme.orangeGradient.createShader(bounds),
      blendMode: BlendMode.srcIn,
      child: Text(
        'Saved Wallpapers',
        style: isMobile
         ? AppTheme.displayHeadingMobile.copyWith(
                fontSize: responsiveFontSize(context, base: 48, min: 22, max: 60),
              )
            : AppTheme.displayHeadingDesktop.copyWith(
                fontSize: responsiveFontSize(context, base: 60, min: 36, max: 72),
              ),
      ),
    );
  }

  Widget _buildSubtitle(BuildContext context, bool isMobile) {
    return Text(
      'Your saved wallpapers collection',
      style: isMobile
          ? AppTheme.subtitleMobile.copyWith(
              fontSize: responsiveFontSize(context, base: 18, min: 14, max: 22),
            )
          : AppTheme.subtitleDesktop.copyWith(
              fontSize: responsiveFontSize(context, base: 24, min: 18, max: 28),
            ),
    );
  }

  Widget _buildEmptyState(BuildContext context, bool isMobile) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset('assets/icons/noSaved.svg',
            width: isMobile ? 192 : 196,
            height: isMobile ? 180 : 184,
            color: AppTheme.iconGrey.withValues(alpha: 0.5),
          ),

          const SizedBox(height: 20),
          Text(
            'No Saved Wallpapers',
            style: AppTheme.categoryHeading.copyWith(
              fontSize: isMobile ? 24 : 24,
              color: AppTheme.textGrey,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Start saving your favorite wallpapers to see them here',
            style: AppTheme.bodyMedium.copyWith(
              fontSize: 14,
              color: AppTheme.textGrey,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(
                  builder: (context) => const MainScreen(initialIndex: 1),
                ),
                (route) => false,
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.orangeGradientStart,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
            child: const Text('Browse Wallpapers', 
              style: TextStyle(
                fontSize: 16
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFavoriteGrid(
    BuildContext context,
    WallpaperProvider provider,
    List favorites,
  ) {
    final crossAxisCount = Responsive.getGridCrossAxisCount(context);
    
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        childAspectRatio: 190 / 290,
        crossAxisSpacing: 20,
        mainAxisSpacing: 20,
      ),
      itemCount: favorites.length,
      itemBuilder: (context, index) {
        final wallpaper = favorites[index];
        return WallpaperGridItem(
          wallpaper: wallpaper,
          onTap: () {
            final category = provider.getCategoryById(wallpaper.categoryId);
            if (category != null) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => WallpaperDetailPage(category: category),
                ),
              );
            }
          },
          onFavoriteToggle: () => provider.toggleFavorite(wallpaper.id),
        );
      },
    );
  }
}