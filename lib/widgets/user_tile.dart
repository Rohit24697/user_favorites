import 'package:flutter/material.dart';
import '../models/user_model.dart';

class UserTile extends StatelessWidget {
  final User user;
  final bool isFavorite;
  final VoidCallback onToggleFavorite;

  const UserTile({required this.user, required this.isFavorite, required this.onToggleFavorite});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(backgroundImage: NetworkImage(user.avatar)),
      title: Text('${user.firstName} ${user.lastName}'),
      trailing: IconButton(
        icon: Icon(isFavorite ? Icons.favorite : Icons.favorite_border, color: Colors.red),
        onPressed: onToggleFavorite,
      ),
    );
  }
}
