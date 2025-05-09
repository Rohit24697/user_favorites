import 'package:flutter/material.dart';
import 'package:user_favorites/services/sqlite_helper.dart'; // Import SQLiteService
import 'package:user_favorites/services/sqlite_service.dart';
import '../models/user_model.dart';
import '../widgets/user_tile.dart';
import 'home_screen.dart';

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

  // Load favorite users from the SQLite database
  Future<void> loadFavorites() async {
    final users = await SQLiteService.instance.getUsers(); // Fetch all favorite users from SQLite
    setState(() {
      favorites = users; // Set the state with the list of favorite users
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Favorite Users"),
        actions: [
          IconButton(
            icon: const Icon(Icons.home),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const HomeScreen()),
              );
            },
          )
        ],
      ),
      body: favorites.isEmpty
          ? const Center(child: Text("No favorites"))
          : ListView.builder(
        itemCount: favorites.length,
        itemBuilder: (BuildContext context, int i) {
          return UserTile(
            user: favorites[i],
            isFavorite: true, // No toggle on favorites screen
            onToggleFavorite: () {}, // Disable toggle in favorites screen
          );
        },
      ),
    );
  }
}
