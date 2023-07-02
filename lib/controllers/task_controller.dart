import 'dart:ffi';

import 'package:get/get.dart';
import 'package:my_progress_tracker/db/db_helper.dart';
import 'package:my_progress_tracker/models/taskcount.dart';

import '../models/task.dart';
import '../models/board.dart';

class TaskController extends GetxController {
  var taskList = <Task>[].obs;
  var boardList = <Board>[].obs;
  var taskCountList = <int>[].obs;

  @override
  void onReady() {
    super.onReady();
  }

  Future<int?> addTask({Task? task}) async {
    return await DBHelper.insert(task);
  }

  Future<int?> updateTask(Task updatedTask) async {
    return await DBHelper.updateTask(updatedTask);
  }

  void getTasks() async {
    List<Map<String, dynamic>> tasks = await DBHelper.query();
    //print(tasks);
    print("Task list called");
    taskList.assignAll(tasks.map((data) => Task.fromJson(data)).toList());
  }

  void delete(Task task) {
    DBHelper.delete(task);
  }

  void updateStatus(int taskId, String updatedOn) {
    DBHelper.updateTaskStatus(taskId, updatedOn);
  }

  Future<int?> updateTaskFull(Task task) async {
    await DBHelper.updateTaskFull(task);
  }

  Future<int?> addBoard({Board? board}) async {
    return await DBHelper.insertBoard(board);
  }

  void getTaskBoard() async {
    List<Map<String, dynamic>> boards = await DBHelper.queryTaskBoard();
    //print(boards);
    print("Board list called");
    boardList.assignAll(boards.map((data) => Board.fromJson(data)).toList());
  }

  void deleteBoard(Board taskBoard) {
    DBHelper.deleteTaskBoard(taskBoard);
  }

  void updateBoard(Board board) {
    DBHelper.updateTaskBoard(board);
  }

  Future<int?> updateTBoard(Board board) async {
    return await DBHelper.updateBoard(board);
  }

  // void getTaskCount() async {
  //   var countArr = <int>[];
  //   List<Map<String, dynamic>> boards = await DBHelper.queryTaskBoard();
  //   print(boards);
  //   boardList.assignAll(boards.map((data) => Board.fromJson(data)).toList());

  //   boardList.forEach((element) async {
  //     print("board ..... ${element.boardName}");
  //     int c = await DBHelper.getBoardTaskCount(element);
  //     countArr.add(c);
  //     print("count ..........${c}");
  //   });

  //   taskCountList.assignAll(countArr);
  //   print("countArr ....size......${countArr.length}");
  //   print("taskCountList ....size......${taskCountList.length}");
  // }

  void getTaskCount() async {
    getTaskBoard();
    getTasks();
    print(
        "taskCountList ....size......${boardList.length}  ${taskList.length}");
    var countArr = <int>[];
    boardList.forEach((element) {
      int count = 0;
      taskList.forEach((element1) {
        if (element1.boardId == element.id) {
          count++;
        }
      });
      print("board & Task count ....size......${element.boardName}  ${count}");
      countArr.add(count);
    });
    print("taskCountList ....size......${countArr.length}");
  }
}
