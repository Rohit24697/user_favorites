import 'dart:convert';

import '../models/user_model.dart';
import 'package:http/http.dart' as http;

class UserService {
  static Future<List<User>> fetchUsers() async {
    List<User> users = [];

    for (int page = 1; page <= 2; page++) {
      try {
        final response = await http.get(Uri.parse('https://reqres.in/api/users?page=$page'));
        if (response.statusCode == 200) {
          final data = json.decode(response.body);
          List list = data['data'];
          users.addAll(list.map((e) => User.fromJson(e)).toList());
        } else {
          print('Failed to fetch page $page: ${response.statusCode}');
        }
      } catch (e) {
        print('Error fetching page $page: $e');
      }
    }

    return users;
  }
}
