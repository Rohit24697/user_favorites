import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:user_favorites/widgets/user_tile.dart';
import 'dart:convert';

import 'models/user_model.dart';


class FavoriteScreen extends StatefulWidget {
  const FavoriteScreen({super.key});

  @override
  State<FavoriteScreen> createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  List<User> favorites = [];

  @override
  void initState() {
    super.initState();
    loadFavorites();
  }

  Future<void> loadFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final favList = prefs.getStringList('favorites') ?? [];
    setState(() {
      favorites = favList.map((e) => User.fromJson(json.decode(e))).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Favorite Users")),
      body: favorites.isEmpty
          ? Center(child: Text("No favorites"))
          : ListView.builder(
        itemCount: favorites.length,
        itemBuilder: (_, i) {
          return UserTile(
            user: favorites[i],
            isFavorite: true,
            onToggleFavorite: () {}, // No toggle in favorite screen
          );
        },
      ),
    );
  }
}
