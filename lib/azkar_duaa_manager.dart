import 'package:shared_preferences/shared_preferences.dart';

/// Manages storage and retrieval of favorites for Azkar and Duaa items.
class AzkarDuaaManager {
  static const String _azkarFavoritesKey = 'azkar_favorites';
  static const String _duaaFavoritesKey = 'duaa_favorites';
  static const String _azkarReadCountKey = 'azkar_read_count';
  static const String _duaaReadCountKey = 'duaa_read_count';

  /// Add an Azkar item to favorites.
  static Future<void> addAzkarFavorite(String azkarId) async {
    final prefs = await SharedPreferences.getInstance();
    final favorites = prefs.getStringList(_azkarFavoritesKey) ?? [];
    if (!favorites.contains(azkarId)) {
      favorites.add(azkarId);
      await prefs.setStringList(_azkarFavoritesKey, favorites);
    }
  }

  /// Remove an Azkar item from favorites.
  static Future<void> removeAzkarFavorite(String azkarId) async {
    final prefs = await SharedPreferences.getInstance();
    final favorites = prefs.getStringList(_azkarFavoritesKey) ?? [];
    favorites.remove(azkarId);
    await prefs.setStringList(_azkarFavoritesKey, favorites);
  }

  /// Get all Azkar favorites.
  static Future<List<String>> getAzkarFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_azkarFavoritesKey) ?? [];
  }

  /// Check if an Azkar item is in favorites.
  static Future<bool> isAzkarFavorite(String azkarId) async {
    final favorites = await getAzkarFavorites();
    return favorites.contains(azkarId);
  }

  /// Add a Duaa item to favorites.
  static Future<void> addDuaaFavorite(String duaaId) async {
    final prefs = await SharedPreferences.getInstance();
    final favorites = prefs.getStringList(_duaaFavoritesKey) ?? [];
    if (!favorites.contains(duaaId)) {
      favorites.add(duaaId);
      await prefs.setStringList(_duaaFavoritesKey, favorites);
    }
  }

  /// Remove a Duaa item from favorites.
  static Future<void> removeDuaaFavorite(String duaaId) async {
    final prefs = await SharedPreferences.getInstance();
    final favorites = prefs.getStringList(_duaaFavoritesKey) ?? [];
    favorites.remove(duaaId);
    await prefs.setStringList(_duaaFavoritesKey, favorites);
  }

  /// Get all Duaa favorites.
  static Future<List<String>> getDuaaFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_duaaFavoritesKey) ?? [];
  }

  /// Check if a Duaa item is in favorites.
  static Future<bool> isDuaaFavorite(String duaaId) async {
    final favorites = await getDuaaFavorites();
    return favorites.contains(duaaId);
  }

  /// Increment read count for an Azkar item.
  static Future<void> incrementAzkarReadCount(String azkarId) async {
    final prefs = await SharedPreferences.getInstance();
    final key = '$_azkarReadCountKey:$azkarId';
    final count = prefs.getInt(key) ?? 0;
    await prefs.setInt(key, count + 1);
  }

  /// Get read count for an Azkar item.
  static Future<int> getAzkarReadCount(String azkarId) async {
    final prefs = await SharedPreferences.getInstance();
    final key = '$_azkarReadCountKey:$azkarId';
    return prefs.getInt(key) ?? 0;
  }

  /// Increment read count for a Duaa item.
  static Future<void> incrementDuaaReadCount(String duaaId) async {
    final prefs = await SharedPreferences.getInstance();
    final key = '$_duaaReadCountKey:$duaaId';
    final count = prefs.getInt(key) ?? 0;
    await prefs.setInt(key, count + 1);
  }

  /// Get read count for a Duaa item.
  static Future<int> getDuaaReadCount(String duaaId) async {
    final prefs = await SharedPreferences.getInstance();
    final key = '$_duaaReadCountKey:$duaaId';
    return prefs.getInt(key) ?? 0;
  }

  /// Clear all data.
  static Future<void> clearAll() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_azkarFavoritesKey);
    await prefs.remove(_duaaFavoritesKey);
  }
}