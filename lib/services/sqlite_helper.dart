import '../models/user_model.dart';
import 'sqlite_service.dart';

class SQLiteHelper {
  static Future<List<User>> getFavorites() async {
    return await SQLiteService.instance.getUsers();
  }

  static Future<void> saveFavorites(List<User> users) async {
    final db = await SQLiteService.instance.database;
    for (var user in users) {
      await SQLiteService.instance.insertUser(user);
    }
  }

  static Future<void> toggleFavorite(User user, bool isFavorite) async {
    await SQLiteService.instance.toggleFavorite(user);
  }

  static Future<Set<int>> getFavoriteIds() async {
    final users = await SQLiteService.instance.getUsers();
    return users.map((user) => user.id).toSet();
  }

  static Future<bool> isFavorite(User user) async {
    return await SQLiteService.instance.isFavorite(user.id);
  }

  static Future<void> clearFavorites() async {
    await SQLiteService.instance.clearAllFavorites();
  }
}
