import 'package:get/get.dart';
import 'package:my_progress_tracker/db/db_helper.dart';

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

  void getTaskCount() async {
    getTaskBoard();
    getTasks();
    var countArr = <int>[];
    boardList.forEach((element) {
      int count = 0;
      taskList.forEach((element1) {
        if (element1.boardId == element.id) {
          count++;
        }
      });
      countArr.add(count);
    });
  }
}
