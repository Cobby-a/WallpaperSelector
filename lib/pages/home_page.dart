import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import '../models/wallpaper_model.dart';
import '../providers/wallpaper_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/wallpaper_card.dart';
import 'wallpaper_detail_page.dart';
import '../main.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

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
            if (provider.activeWallpaper != null)
              _buildActiveWallpaperCard(context, provider.activeWallpaper!)
            else
              _buildWelcomeSection(context, isMobile),
            
            const SizedBox(height: 50),
            
            _buildCategoriesHeader(context),
            
            const SizedBox(height: 24),
            
            _buildCategoriesGrid(context, provider),
          ],
        ),
      ),
    );
  }

  Widget _buildWelcomeSection(BuildContext context, bool isMobile) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ShaderMask(
          shaderCallback: (bounds) => AppTheme.orangeGradient.createShader(bounds),
          blendMode: BlendMode.srcIn,
          child: Text(
            'Discover Beautiful Wallpapers',
            style: isMobile
            ? AppTheme.displayHeadingMobile.copyWith(
                fontSize: responsiveFontSize(context, base: 48, min: 22, max: 60),
              )
            : AppTheme.displayHeadingDesktop.copyWith(
                fontSize: responsiveFontSize(context, base: 60, min: 36, max: 72),
              ),
          ),
        ),
        const SizedBox(height: 16),
        Text(
          'Discover curated collections of stunning wallpapers. Browse by\n'
          'category, preview in full-screen, and set your favorites.',
          style: isMobile
          ? AppTheme.subtitleMobile.copyWith(
              fontSize: responsiveFontSize(context, base: 18, min: 14, max: 22),
            )
          : AppTheme.subtitleDesktop.copyWith(
              fontSize: responsiveFontSize(context, base: 24, min: 18, max: 28),
            ),
        ),
      ],
    );
  }

  Widget _buildActiveWallpaperCard(BuildContext context, Wallpaper wallpaper) {
    final isMobile = Responsive.isMobile(context);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(40),
        border: Border.all(
          color: AppTheme.primaryBlack.withValues(alpha: 0.1),
          width: 1,
        ),
      ),
      child: isMobile
          ? Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildWallpaperImage(wallpaper),
                const SizedBox(width: 10),
                _buildActiveWallpaperContent(context, wallpaper, isMobile),
              ],
            )
          : Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildWallpaperImage(wallpaper),
                const SizedBox(width: 20),
                Expanded(
                  child: _buildActiveWallpaperContent(context, wallpaper, isMobile),
                ),
              ],
            ),
    );
  }

  Widget _buildWallpaperImage(Wallpaper wallpaper) {
    return Container(
      height: 210,
      width: 116,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(26),
        border: Border.all(color: const Color(0xFFE3E3E3), width: 3),
        image: DecorationImage(
          image: AssetImage(wallpaper.imagePath),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _buildActiveWallpaperContent(
    BuildContext context,
    Wallpaper wallpaper,
    bool isMobile,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(height: 28),
        ShaderMask(
          shaderCallback: (bounds) => AppTheme.orangeGradient.createShader(bounds),
          blendMode: BlendMode.srcIn,
          child: Text(
            'Your Active Wallpaper',
            style: isMobile
            ? AppTheme.displayHeadingMobile.copyWith(
                fontSize: responsiveFontSize(context, base: 24, min: 16, max: 20),
              )
            : AppTheme.displayHeadingDesktop.copyWith(
                fontSize: responsiveFontSize(context, base: 36, min: 20, max: 48),
              ),
          ),
        ),
        SizedBox(
  width: MediaQuery.of(context).size.width * 0.9,
  child: Text(
    'This wallpaper is currently set as your active background',
    softWrap: true,
    overflow: TextOverflow.visible,
    style: AppTheme.bodyMedium.copyWith(
      color: const Color(0xFF808080),
      fontSize: responsiveFontSize(context, base: 20, min: 16, max: 24),
    ),
  ),
),

        const SizedBox(height: 16),
        RichText(
          text: TextSpan(
            style: AppTheme.bodyMedium,
            children: [
              TextSpan(
                text: 'Category: ',
                style: AppTheme.bodyMedium.copyWith(color: AppTheme.iconGrey, fontSize: responsiveFontSize(context, base: 16, min: 14, max: 20),),
              ),
              TextSpan(
                text: wallpaper.categoryName,
                style: AppTheme.bodyMedium.copyWith(fontSize: responsiveFontSize(context, base: 16, min: 14, max: 20),),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        RichText(
          text: TextSpan(
            style: AppTheme.bodyMedium,
            children: [
              TextSpan(
                text: 'Selection: ',
                style: AppTheme.bodyMedium.copyWith(color: AppTheme.iconGrey, fontSize: responsiveFontSize(context, base: 16, min: 14, max: 20),),
              ),
              TextSpan(
                text: wallpaper.name,
                style: AppTheme.bodyMedium.copyWith(fontSize: responsiveFontSize(context, base: 16, min: 14, max: 20),),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment:
              isMobile ? MainAxisAlignment.start : MainAxisAlignment.end,
          children: [
            _buildIconButton('assets/icons/share.svg', () {}),
            const SizedBox(width: 12),
            _buildIconButton('assets/icons/settings.svg', () {}),
          ],
        ),
      ],
    );
  }

  Widget _buildIconButton(String iconPath, VoidCallback onPressed) {
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

  Widget _buildCategoriesHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text('Categories', style: AppTheme.categoryHeading.copyWith(
            fontSize: responsiveFontSize(context, base: 32, min: 20, max: 40),
        )),
        TextButton(
          onPressed: () {
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(
                  builder: (context) => const MainScreen(initialIndex: 1),
                ),
                (route) => false,
              );
            },
          child: Text(
            'See All',
            style: AppTheme.bodyMedium.copyWith(
              color: AppTheme.seeAll,
                fontSize: responsiveFontSize(context, base: 24, min: 16, max: 28),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCategoriesGrid(BuildContext context, WallpaperProvider provider) {
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
        childAspectRatio: cardAspectRatio
      ),
      itemCount: provider.categories.length,
      itemBuilder: (context, index) {
        final category = provider.categories[index];
        return SizedBox(
          width: cardWidth,
          height: cardHeight,
        child: WallpaperCategoryCard(
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
}