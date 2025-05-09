import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/user_model.dart';

class UserService {
  static Future<List<User>> fetchUsers() async {
    List<User> users = [];

    for (int page = 1; page <= 2; page++) {
      final response = await http.get(Uri.parse('https://reqres.in/api/users?page=$page'));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        List list = data['data'];
        users.addAll(list.map((e) => User.fromJson(e)).toList());
      }
    }

    return users;
  }
}
