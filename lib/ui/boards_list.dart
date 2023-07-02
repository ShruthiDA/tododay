import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_progress_tracker/services/theme_services.dart';
import 'package:my_progress_tracker/ui/add_board.dart';
import 'package:my_progress_tracker/ui/theme.dart';

import '../controllers/task_controller.dart';
import '../models/board.dart';
import 'board_tile.dart';
import 'button.dart';
import 'custom_alert_dialog.dart';

class BoardsListPage extends StatefulWidget {
  const BoardsListPage({super.key});

  @override
  State<BoardsListPage> createState() => BoardsListPageState();
}

class BoardsListPageState extends State<BoardsListPage> {
  List<int> countArr = List.empty(growable: true);

  @override
  void initState() {
    super.initState();
    _taskController.getTaskBoard();
    _taskController.getTasks();
  }

  _getTaskCountForBoard(int boardId) {
    int count = 0;
    _taskController.taskList.forEach((task) {
      if (task.boardId == boardId) {
        count++;
      }
    });
    print("task........${countArr}");
    return count;
  }

  TaskController _taskController = Get.put(TaskController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: _appBar(context), body: _displayCategoryOld());
  }

  _appBar(BuildContext context) {
    _taskController.getTaskBoard();
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      leading: IconButton(
        icon: Icon(Icons.arrow_back_ios, color: ColorConstants.iconColor),
        onPressed: () => Navigator.of(context).pop(),
      ),
      title: Text("Task Board", style: toolbarTitleStyle),
      centerTitle: true,
      actions: [
        GestureDetector(
          onTap: () async {
            await Get.to(AddBoardPage());
            //Wait & fetch list again to refresh the list on home page.
            _taskController.getTaskBoard();
          },
          child: Icon(Icons.add, color: ColorConstants.iconColor),
        ),
        SizedBox(width: 20),
      ],
    );
  }

  _displayCategoryOld() {
    // print("Length is    ");
    //  print(_taskController.boardList.length);
    return Container(child: Obx(() {
      if (_taskController.boardList.length == 0) {
        return Container(
          child: Center(
              child: Column(children: [
            Text("No Boards, create one now",
                style: subHeadingStyle, textAlign: TextAlign.center),
            MyButton(
                label: "Add Board",
                onTap: () async {
                  await Get.to(AddBoardPage());
                  //Wait & fetch list again to refresh the list on home page.
                  _taskController.getTaskBoard();
                })
          ])),
        );
      } else {
        return Padding(
          padding:
              const EdgeInsets.only(top: 10, bottom: 10, right: 8, left: 8),
          child: GridView.count(
              // Create a grid with 2 columns. If you change the scrollDirection to
              // horizontal, this produces 2 rows.
              crossAxisCount: 2,
              // Generate 100 widgets that display their index in the List.
              children:
                  List.generate(_taskController.boardList.length, (index) {
                return GestureDetector(
                    onTap: () {
                      _showBottomSheet(
                          context, _taskController.boardList[index]);
                    },
                    child: BoardTile(
                        _taskController.boardList[index],
                        _getTaskCountForBoard(
                            _taskController.boardList[index].id!)));
              })),
        );
      }
    }));
  }

  _showBottomSheet(BuildContext context, Board board) {
    Get.bottomSheet(Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20), topRight: Radius.circular(20)),
            color: Get.isDarkMode ? Colors.grey.shade800 : Colors.white),
        padding: EdgeInsets.all(10),
        height: board.isPredefined == 1
            ? MediaQuery.of(context).size.height * 0.24
            : MediaQuery.of(context).size.height * 0.32,
        child: Column(
          children: [
            Container(
              height: 6,
              width: 120,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50), color: Colors.grey),
            ),
            SizedBox(height: 10),
            _bottomSheetButton(
                context: context,
                label: "Edit Board",
                color: ColorConstants.buttonColor,
                onTap: () {
                  Get.back();
                  Get.to(AddBoardPage(editBoard: board));
                }),
            SizedBox(height: 5),
            if (board.isPredefined == 1)
              Container()
            else
              _bottomSheetButton(
                  context: context,
                  label: "Delete Board",
                  color: ColorConstants.buttonColor,
                  onTap: () {
                    Get.back();
                    var dialog = CustomAlertDialog(
                        bgColor: Get.isDarkMode
                            ? ColorConstants.alertDarkBg
                            : ColorConstants.alertLightBg,
                        title: "Delete Board",
                        message:
                            "Are you sure? Deleting board will delete all tasks under it.",
                        onPostivePressed: () {
                          Navigator.of(context).pop();
                          _taskController.deleteBoard(board);
                          _taskController.getTaskBoard();
                          Timer(Duration(seconds: 1), () {});
                        },
                        positiveBtnText: 'Yes',
                        negativeBtnText: 'No');

                    showDialog(
                        context: context,
                        builder: (BuildContext context) => dialog);
                  }),
            SizedBox(height: 5),
            _bottomSheetButton(
                context: context,
                label: "Close",
                color: Colors.white,
                onTap: () {
                  Get.back();
                },
                isClose: true),
          ],
        )));
  }

  _bottomSheetButton(
      {required BuildContext context,
      required String label,
      required Function() onTap,
      required Color color,
      bool isClose = false}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.all(5),
        height: 50,
        width: MediaQuery.of(context).size.width * 0.9,
        decoration: BoxDecoration(
            border: Border.all(
                width: 2, color: isClose == true ? Colors.red : color),
            borderRadius: BorderRadius.circular(10),
            color: isClose ? Colors.transparent : color),
        child: Center(
            child: Text(
          label,
          style: TextStyle(
              color: isClose
                  ? Get.isDarkMode
                      ? Colors.white
                      : Colors.black
                  : Colors.white),
        )),
      ),
    );
  }
}
