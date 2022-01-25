import 'package:project_manager_app/model/task.dart';
import 'package:project_manager_app/database/db.dart';

const TASKS_TABLE_NAME = 'TASKS';
void insert(Task task) async {
  final db = await Database.dbObject();
  db.insert(TASKS_TABLE_NAME, task.toJson());
}

Future<List<Task>> tasks(int projectId) async {
  final db = await Database.dbObject();
  return (await db.query(TASKS_TABLE_NAME,
          where: 'projectId = ?', whereArgs: [projectId]))
      .map((json) => Task.fromJson(json))
      .toList();
}

Future<List<Task>> myTasks(String user) async {
  final db = await Database.dbObject();
  return (await db
          .query(TASKS_TABLE_NAME, where: 'user = ?', whereArgs: [user]))
      .map((e) => Task.fromJson(e))
      .toList();
}

void update(Task task) async {
  final db = await Database.dbObject();
  db.update(TASKS_TABLE_NAME, task.toJson(),
      where: 'id = ?', whereArgs: [task.id]);
}

void remove(int id) async {
  final db = await Database.dbObject();
  db.delete(TASKS_TABLE_NAME, where: 'id = ?', whereArgs: [id]);
}

Future<int> nextId() async {
  final db = await Database.dbObject();
  final list =
      (await db.query(TASKS_TABLE_NAME)).map((e) => Task.fromJson(e)).toList();
  return list.isEmpty ? 0 : list.last.id + 1;
}

void markAllTaskAsOpened(String user) async {
  final db = await Database.dbObject();
  db.rawUpdate(
      'UPDATE ${TASKS_TABLE_NAME} SET opened = 1 where user = ?', [user]);
}
