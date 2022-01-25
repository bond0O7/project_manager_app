import 'package:project_manager_app/model/user.dart';
import 'package:project_manager_app/database/db.dart';

const USER_TABLE_NAME = 'USERS';
Future<bool> checkUser(
    {required String username, required String password}) async {
  final db = await Database.dbObject();
  return (await db.query(USER_TABLE_NAME,
          where: 'username = ? AND password = ?',
          whereArgs: [username, password]))
      .isNotEmpty;
}

Future<bool> exist(String username) async {
  final db = await Database.dbObject();
  return (await db
          .query(USER_TABLE_NAME, where: 'username = ?', whereArgs: [username]))
      .isNotEmpty;
}

void register(User user) async {
  final db = await Database.dbObject();
  await db.insert(USER_TABLE_NAME, user.toJson());
}

Future<List<User>> allUsers() async {
  final db = await Database.dbObject();
  return (await db.query(USER_TABLE_NAME))
      .map((u) => User.fromJson(u))
      .toList();
}

Future<User?> userByUsername(String username) async {
  final db = await Database.dbObject();
  final users = (await db
          .query(USER_TABLE_NAME, where: 'username = ?', whereArgs: [username]))
      .map((e) => User.fromJson(e))
      .toList();
  return users.isEmpty ? null : users.first;
}
