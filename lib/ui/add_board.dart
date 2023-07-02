import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_progress_tracker/ui/button.dart';
import 'package:my_progress_tracker/ui/theme.dart';

import '../controllers/task_controller.dart';
import '../models/board.dart';
import '../services/theme_services.dart';
import 'input_feild.dart';

class AddBoardPage extends StatefulWidget {
  final Board? editBoard;

  AddBoardPage({Key? key, this.editBoard}) : super(key: key);

  @override
  State<AddBoardPage> createState() => _AddBoardPageState(editBoard);
}

class _AddBoardPageState extends State<AddBoardPage> {
  Board? myEditBoard;

  TaskController _taskController = Get.put(TaskController());
  TextEditingController _titleController = TextEditingController();
  int _selectedColorIndex = 0;

  _AddBoardPageState(Board? editBoard) {
    this.myEditBoard = editBoard;
  }

  @override
  void initState() {
    super.initState();
    _titleController.text =
        myEditBoard?.boardName == null ? "" : myEditBoard!.boardName!;
  }

  @override
  Widget build(BuildContext context) {
    if (myEditBoard != null) _selectedColorIndex = myEditBoard!.color!;
    return Scaffold(
        appBar: _appBar(context),
        body: Container(
            margin: EdgeInsets.all(8),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              TextInputFeild(
                  maxLength: 15,
                  hint: _getHint(),
                  label: _getLabel(),
                  widget: null,
                  controller: _titleController,
                  isDisabled: myEditBoard?.isPredefined == 1 ? 1 : 0),
              _showNote(),
              SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.only(left: 10.0),
                child: Text(
                  "Choose Color",
                  textAlign: TextAlign.left,
                  style: inputLabelTextStyle,
                ),
              ),
              SizedBox(height: 5),
              _chooseColorNew(),
              SizedBox(height: 20),
              Container(
                  alignment: Alignment.center,
                  margin: EdgeInsets.only(right: 14),
                  child: MyButton(
                      label: myEditBoard != null ? "Update" : "Create",
                      onTap: () => {_validateInputData()})),
            ])));
  }

  _showNote() {
    if (myEditBoard != null && myEditBoard?.isPredefined == 1) {
      return Padding(
        padding: const EdgeInsets.only(left: 16.0),
        child: Text(
          "Note: Default Board names can't be updated",
          style: TextStyle(
              fontSize: 12,
              color: Get.isDarkMode ? Colors.white38 : Colors.black54),
        ),
      );
    } else
      return Container();
  }

  _getLabel() {
    if (myEditBoard == null) {
      return "Add Board Name";
    } else
      return "Board Name";
  }

  _getHint() {
    if (myEditBoard == null) {
      return "Name";
    } else
      return myEditBoard?.boardName;
  }

  _chooseColorNew() {
    return GridView.count(
        shrinkWrap: true,
        // Create a grid with 2 columns. If you change the scrollDirection to
        // horizontal, this produces 2 rows.
        crossAxisCount: 5,
        // Generate 100 widgets that display their index in the List.
        children: List.generate(10, (index) {
          return GestureDetector(
              onTap: () => {
                    setState(() {
                      myEditBoard?.setColor(index);
                      _selectedColorIndex = index;
                    })
                  },
              child: Container(
                  child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: CircleAvatar(
                    child: index == _selectedColorIndex
                        ? Icon(Icons.done, color: Colors.white)
                        : Container(),
                    radius: 5,
                    backgroundColor: ThemeService.getBGClr(index ?? 0)),
              )));
        }));
  }

  _appBar(BuildContext context) {
    return AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: ColorConstants.iconColor),
          onPressed: () => Get.back(),
        ),
        title: Text(
          myEditBoard == null ? "Create Board" : "Update Board",
          style: toolbarTitleStyle,
        ),
        centerTitle: true);
  }

  _validateInputData() {
    if (myEditBoard != null) {
      _updateBoard();
      _taskController.getTaskBoard();
      Get.back();
    } else if (boardNameExist()) {
      Get.snackbar("Error", "Board already exists",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: ColorConstants.iconColor,
          colorText: Colors.white,
          icon: Icon(Icons.warning, color: Colors.white));
    } else if (_titleController.text.isNotEmpty) {
      //Save data & go back to home screen
      _addBoardToDB();
      Get.back();
    } else if (_titleController.text.isEmpty) {
      Get.snackbar("Required", "Board name can't be empty",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: ColorConstants.iconColor,
          colorText: Colors.white,
          icon: Icon(Icons.warning, color: Colors.white));
    }
  }

  bool boardNameExist() {
    var boardList = _taskController.boardList;
    return boardList.any((element) =>
        element.boardName?.toLowerCase() ==
        _titleController.text.trim().toLowerCase());
  }

  _addBoardToDB() async {
    int? value = await _taskController.addBoard(
        board: Board(
            boardName: _titleController.text,
            color: _selectedColorIndex,
            isPredefined: 0));
    // print("My ID is $value");
  }

  _updateBoard() async {
    _taskController.updateTBoard(Board(
        id: myEditBoard?.id,
        boardName: _titleController.text.isEmpty
            ? myEditBoard?.boardName
            : _titleController.text,
        color: _selectedColorIndex,
        isPredefined: myEditBoard?.isPredefined));
  }
}
