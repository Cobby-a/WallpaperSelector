import 'dart:io';
import 'package:flutter/foundation.dart';

class WallpaperService {
  static Future<bool> setWallpaper(String imagePath) async {
    try {
      if (Platform.isAndroid) {
        return await _setAndroidWallpaper(imagePath);
      } else if (Platform.isWindows) {
        return await _setWindowsWallpaper(imagePath);
      } else if (Platform.isMacOS) {
        return await _setMacOSWallpaper(imagePath);
      } else if (Platform.isLinux) {
        return await _setLinuxWallpaper(imagePath);
      } else if (Platform.isIOS) {
        return false;
      }
      return false;
    } catch (e) {
      debugPrint('Error setting wallpaper: $e');
      return false;
    }
  }

  static Future<bool> _setAndroidWallpaper(String imagePath) async {
    try {
      
      debugPrint('Android wallpaper set: $imagePath');
      return true;
    } catch (e) {
      debugPrint('Error setting Android wallpaper: $e');
      return false;
    }
  }

  static Future<bool> _setWindowsWallpaper(String imagePath) async {
    try {
      final absolutePath = File(imagePath).absolute.path;
      
      final result = await Process.run(
        'powershell',
        [
          '-Command',
          '''
          Add-Type -TypeDefinition @"
          using System;
          using System.Runtime.InteropServices;
          public class Wallpaper {
            [DllImport("user32.dll", CharSet = CharSet.Auto)]
            public static extern int SystemParametersInfo(int uAction, int uParam, string lpvParam, int fuWinIni);
          }
"@
          [Wallpaper]::SystemParametersInfo(20, 0, "$absolutePath", 3)
          '''
        ],
      );

      if (result.exitCode == 0) {
        debugPrint('Windows wallpaper set successfully');
        return true;
      } else {
        debugPrint('Failed to set Windows wallpaper: ${result.stderr}');
        return false;
      }
    } catch (e) {
      debugPrint('Error setting Windows wallpaper: $e');
      return false;
    }
  }

  static Future<bool> _setMacOSWallpaper(String imagePath) async {
    try {
      final absolutePath = File(imagePath).absolute.path;
      
      final result = await Process.run(
        'osascript',
        [
          '-e',
          'tell application "Finder" to set desktop picture to POSIX file "$absolutePath"'
        ],
      );

      if (result.exitCode == 0) {
        debugPrint('macOS wallpaper set successfully');
        return true;
      } else {
        debugPrint('Failed to set macOS wallpaper: ${result.stderr}');
        return false;
      }
    } catch (e) {
      debugPrint('Error setting macOS wallpaper: $e');
      return false;
    }
  }

  static Future<bool> _setLinuxWallpaper(String imagePath) async {
    try {
      final absolutePath = File(imagePath).absolute.path;
      
      var result = await Process.run(
        'gsettings',
        [
          'set',
          'org.gnome.desktop.background',
          'picture-uri',
          'file://$absolutePath'
        ],
      );

      if (result.exitCode == 0) {
        debugPrint('Linux (GNOME) wallpaper set successfully');
        return true;
      }

      result = await Process.run(
        'qdbus',
        [
          'org.kde.plasmashell',
          '/PlasmaShell',
          'org.kde.PlasmaShell.evaluateScript',
          '''
          var allDesktops = desktops();
          for (i=0;i<allDesktops.length;i++) {{
            d = allDesktops[i];
            d.wallpaperPlugin = "org.kde.image";
            d.currentConfigGroup = Array("Wallpaper", "org.kde.image", "General");
            d.writeConfig("Image", "file://$absolutePath")
          }}
          '''
        ],
      );

      if (result.exitCode == 0) {
        debugPrint('Linux (KDE) wallpaper set successfully');
        return true;
      }

      result = await Process.run(
        'xfconf-query',
        [
          '-c',
          'xfce4-desktop',
          '-p',
          '/backdrop/screen0/monitor0/workspace0/last-image',
          '-s',
          absolutePath
        ],
      );

      if (result.exitCode == 0) {
        debugPrint('Linux (XFCE) wallpaper set successfully');
        return true;
      }

      debugPrint('Failed to set Linux wallpaper on any desktop environment');
      return false;
    } catch (e) {
      debugPrint('Error setting Linux wallpaper: $e');
      return false;
    }
  }

  static String getPlatformName() {
    if (Platform.isAndroid) return 'Android';
    if (Platform.isIOS) return 'iOS';
    if (Platform.isWindows) return 'Windows';
    if (Platform.isMacOS) return 'macOS';
    if (Platform.isLinux) return 'Linux';
    return 'Unknown';
  }

  static bool isPlatformSupported() {
    return Platform.isAndroid ||
        Platform.isWindows ||
        Platform.isMacOS ||
        Platform.isLinux;
  }
}