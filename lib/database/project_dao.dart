import 'package:project_manager_app/model/project.dart';
import 'package:project_manager_app/database/db.dart';

const PROJECT_TABLE_NAME = 'PROJECTS';
void insert(Project p) async {
  final db = await Database.dbObject();
  db.insert(PROJECT_TABLE_NAME, p.toJson());
}

void update(Project p) async {
  final db = await Database.dbObject();
  db.update(PROJECT_TABLE_NAME, p.toJson(), where: 'id = ?', whereArgs: [p.id]);
}

void remove(int id) async {
  final db = await Database.dbObject();
  db.delete(PROJECT_TABLE_NAME, where: 'id = ?', whereArgs: [id]);
}

Future<List<Project>> query(String user) async {
  final db = await Database.dbObject();
  return (await db.query(
    PROJECT_TABLE_NAME,
    where: 'user = ?',
    whereArgs: [user],
  ))
      .map((project) => Project.fromJson(project))
      .toList();
}

Future<Project?> queryProjectById(int id) async {
  final db = await Database.dbObject();
  return (await db.query(PROJECT_TABLE_NAME, where: 'id = ?', whereArgs: [id]))
      .map((e) => Project.fromJson(e))
      .first;
}

Future<int> nextId() async {
  final db = await Database.dbObject();
  final list = (await db.query(PROJECT_TABLE_NAME))
      .map((e) => Project.fromJson(e))
      .toList();
  return list.isEmpty ? 0 : list.last.id + 1;
}
