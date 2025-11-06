import 'package:flutter/material.dart';
import '../models/wallpaper_model.dart';
import '../theme/app_theme.dart';

class WallpaperCategoryCard extends StatelessWidget {
  final WallpaperCategory category;
  final VoidCallback onTap;

  const WallpaperCategoryCard({
    super.key,
    required this.category,
    required this.onTap,
  });

  double responsiveFontSize(BuildContext context, double min, double max, double scaleFactor) {
    final width = MediaQuery.of(context).size.width;
    final calculated = width * scaleFactor;
    return calculated.clamp(min, max);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: AppTheme.cardRadius,
        child: Container(
          constraints: const BoxConstraints(minHeight: 292),
          decoration: const BoxDecoration(
            color: Colors.black12,
          ),
        child: Stack(
          fit: StackFit.expand,
          children: [
            if (category.wallpapers.isNotEmpty)
              Image.asset(
                category.wallpapers.first.imagePath,
                fit: BoxFit.cover,
              ),

            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withValues(alpha: 0.7),
                  ],
                ),
              ),
              padding: const EdgeInsets.fromLTRB(18, 18, 18, 18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    category.name,
                    style: AppTheme.bodyLarge.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                      fontSize: responsiveFontSize(context, 16, 24, 0.018),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    category.description,
                    style: AppTheme.bodySmall.copyWith(
                      color: Colors.white.withValues(alpha: 0.9),
                      fontSize: responsiveFontSize(context, 12, 16, 0.012),
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: AppTheme.glassEffect,
                    child: Text(
                      '${category.wallpaperCount} wallpapers',
                      style: AppTheme.bodySmall.copyWith(
                        color: Colors.white,
                        fontSize: responsiveFontSize(context, 10, 12, 0.009),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ));
  }
}

class WallpaperGridItem extends StatelessWidget {
  final Wallpaper wallpaper;
  final VoidCallback onTap;
  final VoidCallback onFavoriteToggle;

  const WallpaperGridItem({
    super.key,
    required this.wallpaper,
    required this.onTap,
    required this.onFavoriteToggle,
  });

  double responsiveFontSize(BuildContext context, double min, double max, double scaleFactor) {
    final width = MediaQuery.of(context).size.width;
    final calculated = width * scaleFactor;
    return calculated.clamp(min, max);
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 600;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        constraints: const BoxConstraints(minHeight: 292),
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: AppTheme.smallCardRadius,
          image: DecorationImage(
            image: AssetImage(wallpaper.imagePath),
            fit: BoxFit.cover,
          ),
        ),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            borderRadius: AppTheme.smallCardRadius,
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.transparent,
                Colors.black.withValues(alpha: 0.6),
              ],
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Align(
                alignment: Alignment.topRight,
                child: GestureDetector(
                  onTap: onFavoriteToggle,
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: wallpaper.isFavorite
                          ? Colors.white
                          : Colors.white.withValues(alpha: 0.2),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.3),
                        width: 0.5,
                      ),
                    ),
                    child: Icon(
                      wallpaper.isFavorite
                          ? Icons.favorite
                          : Icons.favorite_border,
                      size: isMobile ? 18 : 20,
                      color: wallpaper.isFavorite
                          ? AppTheme.selectedOrange
                          : Colors.white,
                    ),
                  ),
                ),
              ),
              const Spacer(),
              Text(
                wallpaper.name,
                style: AppTheme.bodyMedium.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                  fontSize: responsiveFontSize(context, 14, 20, 0.015),
                ),
              ),
              const SizedBox(height: 4),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: AppTheme.glassEffect,
                child: Text(
                  wallpaper.categoryName,
                  style: AppTheme.bodySmall.copyWith(
                    color: Colors.white,
                    fontSize: responsiveFontSize(context, 10, 12, 0.009),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


class WallpaperListItem extends StatelessWidget {
  final Wallpaper wallpaper;
  final VoidCallback onTap;
  final VoidCallback onFavoriteToggle;
  final int wallpaperCount;

  const WallpaperListItem({
    super.key,
    required this.wallpaper,
    required this.onTap,
    required this.onFavoriteToggle,
    required this.wallpaperCount,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 20),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: AppTheme.primaryBlack.withValues(alpha: 0.1),
              width: 1,
            ),
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 278,
              height: 184,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                image: DecorationImage(
                  image: AssetImage(wallpaper.imagePath),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    wallpaper.categoryName,
                    style: AppTheme.bodyLarge.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    wallpaper.description,
                    style: AppTheme.bodyMedium.copyWith(
                      color: AppTheme.textGrey,
                    ),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: const Color(0x1A878787),
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(
                        color: AppTheme.primaryBlack.withValues(alpha: 0.05),
                        width: 1,
                      ),
                    ),
                    child: Text(
                      '$wallpaperCount wallpapers',
                      style: AppTheme.bodySmall,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}