import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../services/api_service.dart';
import '../services/sqlite_service.dart'; // Handles local storage of favorite users
import '../widgets/user_tile.dart';
import 'favorite_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<User> users = []; // List to store all users fetched from API
  Set<int> favoriteIds = {}; // Set to keep track of IDs of favorite users

  @override
  void initState() {
    super.initState();
    loadUsers();     // Load users from API when the screen is initialized
    loadFavorites(); // Load favorite users from SQLite database
  }

  // Fetch users from the API (including both pages)
  Future<void> loadUsers() async {
    try {
      final data = await UserService.fetchUsers(); // Call API to get users
      setState(() {
        users = data; // Update UI with the fetched users
      });
    } catch (e) {
      print("Error loading users: $e");
      // Show error message if API call fails
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to load users")),
      );
    }
  }

  // Load favorite users from local SQLite database
  Future<void> loadFavorites() async {
    final users = await SQLiteService.instance.getUsers(); // Get favorite users
    setState(() {
      // Save their IDs in a Set for quick lookup
      favoriteIds = users.map((user) => user.id).toSet();
    });
  }

  // Add or remove a user from favorites
  Future<void> toggleFavorite(User user) async {
    final isFav = favoriteIds.contains(user.id); // Check if user is already favorite

    // Update UI immediately
    setState(() {
      if (isFav) {
        favoriteIds.remove(user.id); // Unfavorite
      } else {
        favoriteIds.add(user.id); // Mark as favorite
      }
    });

    // Update favorite status in the database
    await SQLiteService.instance.toggleFavorite(user);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("All Users"),
        actions: [
          IconButton(
            icon: const Icon(Icons.favorite),
            onPressed: () {
              // Navigate to FavoriteScreen when favorite icon is tapped
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const FavoriteScreen()),
              ).then((_) => loadFavorites()); // Reload favorites when back
            },
          ),
        ],
      ),
      body: users.isEmpty
      // Show loading spinner while users are being fetched
          ? const Center(child: CircularProgressIndicator())
      // Once loaded, show users in a list with pull-to-refresh
          : RefreshIndicator(
        onRefresh: loadUsers,
        child: ListView.builder(
          itemCount: users.length,
          itemBuilder: (_, i) {
            final user = users[i];
            return UserTile(
              user: user,
              isFavorite: favoriteIds.contains(user.id), // Show if user is favorite
              onToggleFavorite: () => toggleFavorite(user), // Handle tap
            );
          },
        ),
      ),
    );
  }
}
