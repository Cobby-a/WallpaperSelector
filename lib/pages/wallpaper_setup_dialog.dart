import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class WallpaperSetupDialog extends StatefulWidget {
  final bool isMobile;

  const WallpaperSetupDialog({super.key, required this.isMobile});

  @override
  State<WallpaperSetupDialog> createState() => _WallpaperSetupDialogState();
}

class _WallpaperSetupDialogState extends State<WallpaperSetupDialog> {
  String selectedDisplayMode = 'Fit';
  bool autoRotation = false;
  bool lockWallpaper = false;
  bool syncAcrossDevices = false;
  bool isActivated = true;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      alignment: Alignment.centerRight,
      insetPadding: EdgeInsets.symmetric(
        horizontal: widget.isMobile ? 0 : 0,
        vertical: 0,
      ),
      child: Container(
        constraints: const BoxConstraints(maxWidth: 500),
        decoration: BoxDecoration(
          color: Colors.white,
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisSize: MainAxisSize.min,
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
                const SizedBox(height: 32),
                
                Text(
                  'Activate Wallpaper',
                  style: AppTheme.bodyLarge.copyWith(fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 8),
                Text(
                  'Set the selected wallpaper as your desktop background',
                  style: AppTheme.bodySmall.copyWith(color: AppTheme.textGrey),
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE8F5E9),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: const Color(0xFF4CAF50)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.check_circle,
                        color: Color(0xFF4CAF50),
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Activated',
                        style: AppTheme.bodySmall.copyWith(
                          color: const Color(0xFF4CAF50),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: 32),
                
                Text(
                  'Display mode',
                  style: AppTheme.bodyLarge.copyWith(fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 16),
                _buildRadioOption('Fit', 'Scale to fit without cropping'),
                _buildRadioOption('Fill', 'Scale to fill the entire screen'),
                _buildRadioOption('Stretch', 'Stretch to fill the screen'),
                _buildRadioOption('Tile', 'Repeat the image to fill the screen'),
                
                const SizedBox(height: 32),
                
                _buildToggleOption(
                  'Auto - Rotation',
                  'Automatically change your wallpaper at regular intervals',
                  autoRotation,
                  (value) => setState(() => autoRotation = value),
                ),
                
                const SizedBox(height: 32),
                
                Text(
                  'Advanced Settings',
                  style: AppTheme.bodyLarge.copyWith(fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 16),
                
                _buildToggleOption(
                  'Lock Wallpaper',
                  'Prevent accidental changes',
                  lockWallpaper,
                  (value) => setState(() => lockWallpaper = value),
                ),
                
                const SizedBox(height: 16),
                
                _buildToggleOption(
                  'Sync Across Devices',
                  'Keep wallpaper consistent on all devices',
                  syncAcrossDevices,
                  (value) => setState(() => syncAcrossDevices = value),
                ),
                
                const SizedBox(height: 32),
                
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(context),
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
                          Navigator.pop(context);
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
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRadioOption(String title, String subtitle) {
    final isSelected = selectedDisplayMode == title;
    
    return InkWell(
      onTap: () => setState(() => selectedDisplayMode = title),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          children: [
            Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected
                      ? AppTheme.orangeGradientStart
                      : AppTheme.iconGrey,
                  width: 2,
                ),
              ),
              child: isSelected
                  ? Center(
                      child: Container(
                        width: 10,
                        height: 10,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppTheme.orangeGradientStart,
                        ),
                      ),
                    )
                  : null,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTheme.bodyMedium.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: AppTheme.bodySmall.copyWith(
                      color: AppTheme.textGrey,
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

  Widget _buildToggleOption(
    String title,
    String subtitle,
    bool value,
    Function(bool) onChanged,
  ) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: AppTheme.bodyMedium.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: AppTheme.bodySmall.copyWith(
                  color: AppTheme.textGrey,
                ),
              ),
            ],
          ),
        ),
        Switch(
          value: value,
          onChanged: onChanged,
          activeThumbColor: AppTheme.orangeGradientStart,
        ),
      ],
    );
  }
}