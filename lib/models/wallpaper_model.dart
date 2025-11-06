class Wallpaper {
  final String id;
  final String name;
  final String categoryId;
  final String categoryName;
  final String imagePath;
  final String description;
  final List<String> tags;
  bool isFavorite;

  Wallpaper({
    required this.id,
    required this.name,
    required this.categoryId,
    required this.categoryName,
    required this.imagePath,
    required this.description,
    required this.tags,
    this.isFavorite = false,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'categoryId': categoryId,
    'categoryName': categoryName,
    'imagePath': imagePath,
    'description': description,
    'tags': tags,
    'isFavorite': isFavorite,
  };

  factory Wallpaper.fromJson(Map<String, dynamic> json) => Wallpaper(
    id: json['id'],
    name: json['name'],
    categoryId: json['categoryId'],
    categoryName: json['categoryName'],
    imagePath: json['imagePath'],
    description: json['description'],
    tags: List<String>.from(json['tags']),
    isFavorite: json['isFavorite'] ?? false,
  );
}

class WallpaperCategory {
  final String id;
  final String name;
  final String description;
  final List<Wallpaper> wallpapers;

  WallpaperCategory({
    required this.id,
    required this.name,
    required this.description,
    required this.wallpapers,
  });

  int get wallpaperCount => wallpapers.length;
}