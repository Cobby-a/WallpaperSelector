import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  String selectedQuality = 'High ( Best Quality )';
  bool notifications = true;

  @override
  Widget build(BuildContext context) {
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
            _buildHeader(isMobile),
            const SizedBox(height: 16),
            _buildSubtitle(isMobile),
            const SizedBox(height: 50),
            isMobile ? _buildMobileLayout() : _buildDesktopLayout(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(bool isMobile) {
    return ShaderMask(
      shaderCallback: (bounds) => AppTheme.orangeGradient.createShader(bounds),
      blendMode: BlendMode.srcIn,
      child: Text(
        'Settings',
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

  Widget _buildSubtitle(bool isMobile) {
    return Text(
      'Customize your Wallpaper Studio experience',
      style: isMobile ? AppTheme.subtitleMobile : AppTheme.subtitleDesktop,
    );
  }

  Widget _buildDesktopLayout() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 1,
          child: Container(
            padding: const EdgeInsets.all(40),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: AppTheme.primaryBlack.withValues(alpha: 0.1),
              ),
            ),
            child: _buildSettingsContent(),
          ),
        ),
        const SizedBox(width: 32),
        Expanded(
          flex: 1,
          child: _buildPhonePreview(),
        ),
      ],
    );
  }

  Widget _buildMobileLayout() {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: AppTheme.primaryBlack.withValues(alpha: 0.1),
            ),
          ),
          child: _buildSettingsContent(),
        ),
        const SizedBox(height: 32),
        _buildPhonePreview(),
      ],
    );
  }

  Widget _buildSettingsContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Wallpaper Setup',
          style: AppTheme.categoryHeading.copyWith(fontSize: 24),
        ),
        const SizedBox(height: 8),
        Text(
          'Configure your wallpaper settings and enable auto-rotation',
          style: AppTheme.bodySmall.copyWith(color: AppTheme.textGrey),
        ),
        const SizedBox(height: 40),
        
        Text(
          'Image Quality',
          style: AppTheme.bodyLarge.copyWith(fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 16),
        DropdownButtonFormField<String>(
          initialValue: selectedQuality,
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 12,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: AppTheme.primaryBlack.withValues(alpha: 0.2),
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: AppTheme.primaryBlack.withValues(alpha: 0.2),
              ),
            ),
          ),
          items: [
            'High ( Best Quality )',
            'Medium',
            'Low',
          ].map((quality) {
            return DropdownMenuItem(
              value: quality,
              child: Text(quality, style: AppTheme.bodyMedium),
            );
          }).toList(),
          onChanged: (value) {
            if (value != null) {
              setState(() => selectedQuality = value);
            }
          },
        ),
        
        const SizedBox(height: 40),
        
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Notification',
                    style: AppTheme.bodyMedium.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Get notified about new wallpapers and updates',
                    style: AppTheme.bodySmall.copyWith(
                      color: AppTheme.textGrey,
                    ),
                  ),
                ],
              ),
            ),
            Switch(
              value: notifications,
              onChanged: (value) => setState(() => notifications = value),
              activeThumbColor: AppTheme.orangeGradientStart,
            ),
          ],
        ),
        
        const SizedBox(height: 40),
        
        Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: () {},
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppTheme.primaryBlack,
                  side: BorderSide(
                    color: AppTheme.primaryBlack.withValues(alpha: 0.2),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text('Cancel'),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: ElevatedButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Settings saved successfully!'),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.orangeGradientStart,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text('Save Settings'),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildPhonePreview() {
    return Container(
      padding: const EdgeInsets.all(40),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppTheme.primaryBlack.withValues(alpha: 0.1),
        ),
      ),
      child: Center(
        child: Container(
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
                  child: Container(
                    color: AppTheme.backgroundColor,
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: const BoxDecoration(
                              color: Color(0xFFE8F5E9),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.link,
                              size: 40,
                              color: Color(0xFF4CAF50),
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Connected to device',
                            style: AppTheme.bodyMedium.copyWith(
                              color: const Color(0xFF4CAF50),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 8),
                          TextButton(
                            onPressed: () {},
                            child: Text(
                              'Click to disconnect',
                              style: AppTheme.bodySmall.copyWith(
                                color: AppTheme.textGrey,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
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
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}