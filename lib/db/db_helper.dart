import 'package:sqflite/sqflite.dart';

import '../models/board.dart';
import '../models/task.dart';

class DBHelper {
  static Database? _db;
  static final int _version = 1;
  static final String _tableName = "tasks";
  static final String _categoryTableName = "taskboards";
  static final String _dbName = "tasks.db";

  static Future<void> initDB() async {
    if (_db != null) {
      return;
    }
    try {
      String _path = await getDatabasesPath();
      _path = _path + "/$_dbName";
      //  print("path is $_path");
      _db =
          await openDatabase(_path, version: _version, onCreate: (db, version) {
        db.execute("CREATE TABLE $_tableName("
            "id INTEGER PRIMARY KEY AUTOINCREMENT, "
            "title STRING, note TEXT, date STRING, "
            "startTime STRING, endTime STRING, "
            "remind INTEGER, repeat STRING, "
            "boardId INTEGER, taskStatusUpdatedOn STRING, isCompleted INTEGER )");
        db.execute("CREATE TABLE $_categoryTableName("
            "id INTEGER PRIMARY KEY AUTOINCREMENT, "
            "boardName STRING, "
            "color INTEGER, "
            "isPredefined INTEGER, "
            "UNIQUE(boardName) )");
        return;
      });
    } catch (e) {
      print("Exception creating databse   $e");
    }
  }

  static Future<void> deleteDataInDB() async {
    await _db!.execute("DELETE FROM tasks");
    await _db!.execute("DELETE FROM taskboards");
  }

  //Tasks
  static Future<int?> insert(Task? task) async {
    return await _db?.insert(_tableName, task!.toJson());
  }

  //Tasks
  static Future<int?> updateTask(Task? task) async {
    return await _db?.update(_tableName, task!.toJson(),
        where: "id = ?", whereArgs: [task.id]);
  }

  static Future<List<Map<String, dynamic>>> query() async {
    return await _db!.query(_tableName);
  }

  static delete(Task task) async {
    await _db!.delete(_tableName, where: 'id=?', whereArgs: [task.id]);
  }

  static updateTaskStatus(int id, String updatedOn) async {
    await _db!.rawUpdate('''
      UPDATE tasks SET isCompleted = ?, taskStatusUpdatedOn = ? WHERE id = ? ''',
        [1, updatedOn, id]);
  }

  static updateTaskFull(Task task) async {
    await _db!.rawUpdate(
        '''
      UPDATE tasks SET id = ?, title = ?, note = ?, date = ?, startTime = ?, endTime = ?, remind = ?, repeat = ?, boardId = ?, isCompleted = ?, taskStatusUpdatedOn = ?  WHERE id = ? ''',
        [
          task.id,
          task.title,
          task.note,
          task.date,
          task.startTime,
          task.endTime,
          task.remind,
          task.repeat,
          task.boardId,
          task.isCompleted,
          task.taskStatusUpdatedOn,
          task.id
        ]);
  }

  //Task Board
  static Future<int?> insertBoard(Board? taskBoard) async {
    return await _db?.insert(_categoryTableName, taskBoard!.toJson(),
        conflictAlgorithm: ConflictAlgorithm.ignore);
  }

  static Future<List<Map<String, dynamic>>> queryTaskBoard() async {
    return await _db!.query(_categoryTableName);
  }

  static deleteTaskBoard(Board board) async {
    deleteAllTasksByBoardId(board);
    await _db!.delete(_categoryTableName, where: 'id=?', whereArgs: [board.id]);
  }

  static deleteAllTasksByBoardId(Board board) async {
    await _db!.delete(_tableName, where: 'boardId=?', whereArgs: [board.id]);
  }

  static updateTaskBoard(Board board) async {
    await _db!.rawUpdate('''
      UPDATE taskboards SET color = ? WHERE boardName = ? ''',
        [board.color, board.boardName]);
  }

  static Future<int?> updateBoard(Board? board) async {
    return await _db?.update(_categoryTableName, board!.toJson(),
        where: "id = ?", whereArgs: [board.id]);
  }

  static Future<void> createBoard() async {
    Board work = Board(boardName: "Work", color: 1, isPredefined: 1);
    Board selfcare = Board(boardName: "Self care", color: 2, isPredefined: 1);
    Board fitness = Board(boardName: "Fitness", color: 3, isPredefined: 1);
    Board learning = Board(boardName: "Learn", color: 4, isPredefined: 1);
    Board errand = Board(boardName: "Errand", color: 5, isPredefined: 1);
    insertBoard(work);
    insertBoard(selfcare);
    insertBoard(fitness);
    insertBoard(learning);
    insertBoard(errand);
  }

  static getBoardTaskCount(int boardId) async {
    var taskList = <Task>[];
    List<Map<String, dynamic>> tasks = await _db!.rawQuery('''
      SELECT * FROM tasks WHERE boardId = ? ''', [boardId]);
    taskList.addAll(tasks.map((data) => Task.fromJson(data)).toList());
    return taskList.length;
  }
}
