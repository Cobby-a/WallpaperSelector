import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/wallpaper_model.dart';

class WallpaperProvider with ChangeNotifier {
  List<WallpaperCategory> _categories = [];
  Wallpaper? _activeWallpaper;
  bool _isGridView = true;
  
  List<WallpaperCategory> get categories => _categories;
  Wallpaper? get activeWallpaper => _activeWallpaper;
  bool get isGridView => _isGridView;
  
  List<Wallpaper> get allWallpapers {
    return _categories.expand((cat) => cat.wallpapers).toList();
  }
  
  List<Wallpaper> get favoriteWallpapers {
    return allWallpapers.where((w) => w.isFavorite).toList();
  }

  WallpaperProvider() {
    _initializeSampleData();
    _loadFavorites();
    _loadActiveWallpaper();
  }

  void _initializeSampleData() {
    _categories = [
      WallpaperCategory(
        id: 'nature',
        name: 'Nature',
        description: 'Mountains, Forest and Landscapes',
        wallpapers: List.generate(
          6,
          (i) => Wallpaper(
            id: 'nature_${i + 1}',
            name: 'Nature ${i + 1}',
            categoryId: 'nature',
            categoryName: 'Nature',
            imagePath: 'assets/wallpapers/nature_${i + 1}.png',
            description: 'Discover the pure beauty of "Natural Essence" - your gateway to authentic, nature-inspired experiences. Let this unique collection elevate your senses and connect you with the unrefined art.',
            tags: ['Nature', 'Ambience', 'Flowers'],
          ),
        ),
      ),
      WallpaperCategory(
        id: 'abstract',
        name: 'Abstract',
        description: 'Modern Geomentric and artistic designs',
        wallpapers: List.generate(
          6,
          (i) => Wallpaper(
            id: 'abstract_${i + 1}',
            name: 'Abstract ${i + 1}',
            categoryId: 'abstract',
            categoryName: 'Abstract',
            imagePath: 'assets/wallpapers/abstract_${i + 1}.jpg',
            description: 'Modern abstract designs that inspire creativity.',
            tags: ['Abstract', 'Modern', 'Art'],
          ),
        ),
      ),
      WallpaperCategory(
    id: 'urban',
    name: 'Urban',
    description: 'Cities, architecture and street',
    wallpapers: List.generate(
      6,
      (i) => Wallpaper(
        id: 'urban_${i + 1}',
        name: 'Urban ${i + 1}',
        categoryId: 'urban',
        categoryName: 'Urban',
        imagePath: 'assets/wallpapers/urban_${i + 1}.jpg',
        description: 'Stylish city life and night lights captured beautifully.',
        tags: ['City', 'Street', 'Architecture'],
      ),
    ),
  ),

  WallpaperCategory(
    id: 'space',
    name: 'Space',
    description: 'Cosmos, planets, and galaxies',
    wallpapers: List.generate(
      6,
      (i) => Wallpaper(
        id: 'space_${i + 1}',
        name: 'Space ${i + 1}',
        categoryId: 'space',
        categoryName: 'Space',
        imagePath: 'assets/wallpapers/space_${i + 1}.jpg',
        description: 'Explore breathtaking images of the universe and beyond.',
        tags: ['Galaxy', 'Stars', 'Universe'],
      ),
    ),
  ),

  WallpaperCategory(
    id: 'minimalist',
    name: 'Minimalist',
    description: 'Clean, simple, and elegant',
    wallpapers: List.generate(
      6,
      (i) => Wallpaper(
        id: 'minimalist_${i + 1}',
        name: 'Minimalist ${i + 1}',
        categoryId: 'minimalist',
        categoryName: 'Minimalist',
        imagePath: 'assets/wallpapers/minimalist_${i + 1}.jpg',
        description: 'Sleek designs with soft tones for a calm aesthetic.',
        tags: ['Simple', 'Clean', 'Modern'],
      ),
    ),
  ),

  WallpaperCategory(
    id: 'animals',
    name: 'Animals',
    description: 'Wildlife and nature photography',
    wallpapers: List.generate(
      6,
      (i) => Wallpaper(
        id: 'animals_${i + 1}',
        name: 'Animal ${i + 1}',
        categoryId: 'animals',
        categoryName: 'Animals',
        imagePath: 'assets/wallpapers/animal_${i + 1}.jpg',
        description: 'From majestic lions to adorable pets — nature’s finest.',
        tags: ['Wildlife', 'Nature', 'Pets'],
      ),
    ),
  ),

    ];
  }

  void toggleView() {
    _isGridView = !_isGridView;
    notifyListeners();
  }

  Future<void> toggleFavorite(String wallpaperId) async {
    for (var category in _categories) {
      for (var wallpaper in category.wallpapers) {
        if (wallpaper.id == wallpaperId) {
          wallpaper.isFavorite = !wallpaper.isFavorite;
          await _saveFavorites();
          notifyListeners();
          return;
        }
      }
    }
  }

  Future<void> setActiveWallpaper(Wallpaper wallpaper) async {
    _activeWallpaper = wallpaper;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('active_wallpaper', jsonEncode(wallpaper.toJson()));
    notifyListeners();
  }

  Future<void> _loadActiveWallpaper() async {
    final prefs = await SharedPreferences.getInstance();
    final wallpaperJson = prefs.getString('active_wallpaper');
    if (wallpaperJson != null) {
      _activeWallpaper = Wallpaper.fromJson(jsonDecode(wallpaperJson));
      notifyListeners();
    }
  }

  Future<void> _saveFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final favoriteIds = favoriteWallpapers.map((w) => w.id).toList();
    await prefs.setStringList('favorites', favoriteIds);
  }

  Future<void> _loadFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final favoriteIds = prefs.getStringList('favorites') ?? [];
    
    for (var category in _categories) {
      for (var wallpaper in category.wallpapers) {
        if (favoriteIds.contains(wallpaper.id)) {
          wallpaper.isFavorite = true;
        }
      }
    }
    notifyListeners();
  }

  WallpaperCategory? getCategoryById(String id) {
    try {
      return _categories.firstWhere((cat) => cat.id == id);
    } catch (e) {
      return null;
    }
  }

  Wallpaper? getWallpaperById(String id) {
    for (var category in _categories) {
      try {
        return category.wallpapers.firstWhere((w) => w.id == id);
      } catch (e) {
        continue;
      }
    }
    return null;
  }
}