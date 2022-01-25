import 'dart:io';

import 'package:sqflite/sqflite.dart' as SqliteDB;

class Database {
  static void init() async {
    await SqliteDB.openDatabase(
      await SqliteDB.getDatabasesPath() + '/uni_project_manager_app_db.db',
      version: 1,
      onCreate: (db, v) async {
        await db.execute('''
      CREATE TABLE IF NOT EXISTS USERS (
        username TEXT PRIMARY KEY NOT NULL,
        password TEXT NOT NULL,
        email    TEXT
        );
      ''');
        await db.execute('''CREATE TABLE IF NOT EXISTS PROJECTS(
            id   INT PRIMARY KEY
                NOT NULL,
    name TEXT   NOT NULL,
    user TEXT   REFERENCES USERS (username) ON DELETE CASCADE
                                            ON UPDATE CASCADE
                NOT NULL);
          ''');
        await db.execute('''
      CREATE TABLE TASKS (
    id        BIGINT  PRIMARY KEY
                      NOT NULL,
    projectId BIGINT  REFERENCES PROJECTS (id) ON DELETE CASCADE
                                               ON UPDATE CASCADE
                      NOT NULL,
    name      TEXT    NOT NULL,
    user      TEXT    REFERENCES USERS (username) ON DELETE CASCADE
                                                  ON UPDATE CASCADE
                      NOT NULL,
    completed INT NOT NULL
                      DEFAULT (0),
    opened    INT     NOT NULL
                      DEFAULT (0) 
);
)
        );
      ''');
      },
      onConfigure: (db) async {
        await db.execute('PRAGMA foreign_keys = ON');
      },
      singleInstance: true,
    );
  }

  static Future<SqliteDB.Database> dbObject() async => SqliteDB.openDatabase(
      (await SqliteDB.getDatabasesPath() + '/uni_project_manager_app_db.db'));
}
