import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:user_favorites/services/api_service.dart';
import 'package:user_favorites/widgets/user_tile.dart';
import 'dart:convert';

import 'favorite_screen.dart';
import 'models/user_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<User> users = [];
  Set<int> favoriteIds = {};
  Map<int, User> favoriteUsers = {};

  @override
  void initState() {
    super.initState();
    loadUsers();
    loadFavorites();
  }

  Future<void> loadUsers() async {
    final data = await UserService.fetchUsers();
    setState(() => users = data);
  }

  Future<void> loadFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final favList = prefs.getStringList('favorites') ?? [];
    final favMap = {
      for (var jsonStr in favList)
        User.fromJson(json.decode(jsonStr)).id: User.fromJson(json.decode(jsonStr))
    };
    setState(() {
      favoriteIds = favMap.keys.toSet();
      favoriteUsers = favMap;
    });
  }

  Future<void> toggleFavorite(User user) async {
    final prefs = await SharedPreferences.getInstance();
    if (favoriteIds.contains(user.id)) {
      favoriteIds.remove(user.id);
      favoriteUsers.remove(user.id);
    } else {
      favoriteIds.add(user.id);
      favoriteUsers[user.id] = user;
    }
    final list = favoriteUsers.values.map((u) => json.encode(u.toJson())).toList();
    await prefs.setStringList('favorites', list);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("All Users"),
        actions: [
          IconButton(
            icon: Icon(Icons.favorite),
            onPressed: () => Navigator.push(context,
                MaterialPageRoute(builder: (_) => FavoriteScreen())),
          )
        ],
      ),
      body: users.isEmpty
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
        itemCount: users.length,
        itemBuilder: (_, i) {
          final user = users[i];
          return UserTile(
            user: user,
            isFavorite: favoriteIds.contains(user.id),
            onToggleFavorite: () => toggleFavorite(user),
          );
        },
      ),
    );
  }
}
