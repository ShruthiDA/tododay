import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:my_progress_tracker/models/task.dart';
import 'package:my_progress_tracker/services/theme_services.dart';
import 'package:my_progress_tracker/ui/button.dart';
import 'package:my_progress_tracker/ui/theme.dart';
import '../models/board.dart';
import '../controllers/task_controller.dart';
import '../services/local_notify_manager.dart';
import '../services/user_detail_service.dart';
import 'input_feild.dart';

class AddTaskPage extends StatefulWidget {
  final Task? editTask;

  AddTaskPage({Key? key, this.editTask}) : super(key: key);

  @override
  State<AddTaskPage> createState() => _AddTaskPageState(editTask);
}

class _AddTaskPageState extends State<AddTaskPage> {
  Task? myEditTask;
  //var notifyService;
  _AddTaskPageState(Task? editTask) {
    this.myEditTask = editTask;
  }

  @override
  void initState() {
    super.initState();
    _titleController.text = myEditTask?.title == null ? "" : myEditTask!.title!;
    _noteController.text = myEditTask?.note == null ? "" : myEditTask!.note!;
  }

  TaskController _taskController = Get.put(TaskController());
  TextEditingController _titleController = TextEditingController();
  TextEditingController _noteController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  TimeOfDay _startTime = TimeOfDay.now();
  TimeOfDay _endTime = TimeOfDay.now();
  List<int> remindList = [5, 10, 15, 20];
  int _remindBefore = 5;
  int _selectedColorIndex = 0;
  List<String> repeatList = ["None", "Everyday", "Weekdays", "Weekend"];
  String _repeat = "None";
  Board? _selectedBoard = Get.put(TaskController()).boardList[0];
  String? _selectedBoardName =
      Get.put(TaskController()).boardList[0].boardName!;

  @override
  Widget build(BuildContext context) {
    if (myEditTask != null) {
      _repeat = myEditTask!.repeat!;
      _remindBefore = myEditTask!.remind!;
      _selectedDate = DateTime.parse(myEditTask!.date!);
      _selectedBoard = Get.put(TaskController())
          .boardList
          .firstWhere((element) => element.id == myEditTask!.boardId!);

      _selectedBoardName = _selectedBoard?.boardName;
      _startTime = stringToTimeOfDay(myEditTask!.startTime!);
      _endTime = stringToTimeOfDay(myEditTask!.endTime!);
    }

    return Scaffold(
      appBar: _appBar(context),
      body: Container(
          margin: EdgeInsets.all(8),
          child: SingleChildScrollView(
              child: Column(
            children: [
              TextInputFeild(
                  hint: myEditTask == null
                      ? "Add task title"
                      : myEditTask!.title!,
                  label: "Title",
                  widget: null,
                  controller: _titleController),
              TextInputFeild(
                hint: myEditTask == null ? "Add a note" : myEditTask!.note!,
                label: "Note",
                widget: null,
                controller: _noteController,
              ),
              TextInputFeild(
                  controller: null,
                  hint: DateFormat.yMMMd().format(_selectedDate),
                  label: "Date",
                  widget: IconButton(
                      onPressed: () => {_selectDate()},
                      icon: Icon(
                        Icons.calendar_month_outlined,
                        color: ColorConstants.iconColor.withOpacity(0.6),
                      ))),
              Row(children: [
                Expanded(
                    child: TextInputFeild(
                        controller: null,
                        hint: _startTime.format(context),
                        label: "Start time",
                        widget: IconButton(
                            onPressed: () => {_selectStartTime()},
                            icon: Icon(
                              Icons.timelapse_rounded,
                              color: ColorConstants.iconColor.withOpacity(0.6),
                            )))),
                Expanded(
                    child: TextInputFeild(
                        controller: null,
                        hint: _endTime.format(context),
                        label: "End time",
                        widget: IconButton(
                            onPressed: () => {_selectEndTime()},
                            icon: Icon(
                              Icons.timelapse_rounded,
                              color: ColorConstants.iconColor.withOpacity(0.6),
                            ))))
              ]),
              TextInputFeild(
                controller: null,
                hint: "Remind $_remindBefore mins before",
                label: "Remind",
                widget: DropdownButton<String>(
                  underline: Container(),
                  icon: Icon(
                    Icons.keyboard_arrow_down,
                    color: ColorConstants.iconColor.withOpacity(0.6),
                  ),
                  iconSize: 24,
                  elevation: 4,
                  onChanged: (String? newValue) {
                    setState(() {
                      myEditTask?.setRemind(int.parse(newValue!));
                      _remindBefore = int.parse(newValue!);
                    });
                  },
                  // value: _remindBefore.toString(),
                  items: remindList.map<DropdownMenuItem<String>>((int value) {
                    return DropdownMenuItem<String>(
                      value: value.toString(),
                      child: Text(value.toString()),
                    );
                  }).toList(),
                ),
              ),
              TextInputFeild(
                controller: null,
                hint: "$_repeat",
                label: "Repeat",
                widget: DropdownButton<String>(
                  underline: Container(),
                  icon: Icon(
                    Icons.keyboard_arrow_down,
                    color: ColorConstants.iconColor.withOpacity(0.6),
                  ),
                  iconSize: 24,
                  elevation: 4,
                  onChanged: (String? newValue) {
                    setState(() {
                      myEditTask?.setRepeat(newValue!);
                      _repeat = newValue!;
                    });
                  },
                  // value: _remindBefore.toString(),
                  items:
                      repeatList.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value.toString()),
                    );
                  }).toList(),
                ),
              ),
              TextInputFeild(
                controller: null,
                hint: "$_selectedBoardName",
                label: "Choose Board",
                widget: DropdownButton<Board>(
                  underline: Container(),
                  icon: Icon(
                    Icons.keyboard_arrow_down,
                    color: ColorConstants.iconColor.withOpacity(0.6),
                  ),
                  iconSize: 24,
                  elevation: 4,
                  onChanged: (Board? newValue) {
                    setState(() {
                      myEditTask?.setBoardId(newValue!.id!);
                      _selectedBoard = newValue;
                      _selectedBoardName = newValue!.boardName!;
                    });
                  },
                  items: _taskController.boardList
                      .map<DropdownMenuItem<Board>>((Board board) {
                    return DropdownMenuItem<Board>(
                      value: board,
                      child: Text(board.boardName.toString()),
                    );
                  }).toList(),
                ),
              ),
              SizedBox(height: 20),
              Container(
                  margin: EdgeInsets.only(right: 14),
                  child: MyButton(
                      label: myEditTask == null ? "Add Task" : "Update Task",
                      onTap: () => {_validateInputData()}))
            ],
          ))),
    );
  }

  _getCategory() {
    return Wrap(
      children: List<Widget>.generate(
          3,
          (index) => GestureDetector(
              onTap: () => {
                    setState(() {
                      _selectedColorIndex = index;
                    })
                  },
              child: Padding(
                padding: const EdgeInsets.only(right: 10, top: 10),
                child: CircleAvatar(
                  child: index == _selectedColorIndex
                      ? Icon(Icons.done, color: Colors.white)
                      : Container(),
                  radius: 18,
                  backgroundColor: index == 0
                      ? Colors.lightBlue[200]
                      : index == 1
                          ? Colors.pink[100]
                          : Colors.green[100],
                ),
              ))),
    );
  }

  _getTaskType() {
    return Wrap(
      children: List<Widget>.generate(
          3,
          (index) => GestureDetector(
              onTap: () => {
                    setState(() {
                      _selectedColorIndex = index;
                    })
                  },
              child: Padding(
                padding: const EdgeInsets.only(right: 10, top: 10),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                        topRight: Radius.circular(40.0),
                        bottomRight: Radius.circular(40.0),
                        topLeft: Radius.circular(40.0),
                        bottomLeft: Radius.circular(40.0)),
                  ),
                  child: Text("hello"),
                ),
              ))),
    );
  }

  _selectDate() async {
    DateTime? _pickeddate = await showDatePicker(
        context: context,
        initialDate: _selectedDate,
        firstDate: getInitialDate(),
        lastDate: DateTime.now().add(Duration(days: 30)));
    if (_pickeddate != null) {
      setState(() {
        myEditTask?.setDate(_pickeddate.toString());
        _selectedDate = _pickeddate;
      });
    }
  }

  //Check for edit Task
  DateTime getInitialDate() {
    DateTime now = DateTime.now().subtract(Duration(days: 0));
    if (_selectedDate.isBefore(now)) {
      return _selectedDate;
    } else
      return now;
  }

  _selectStartTime() async {
    TimeOfDay? _pickedStartTime =
        await showTimePicker(context: context, initialTime: _startTime);
    if (_pickedStartTime != null) {
      if (_endTime.compareTo(_pickedStartTime) == 1) {
        setState(() {
          myEditTask?.setStartTime(_pickedStartTime.format(context));
          _startTime = _pickedStartTime;
        });
      } else {
        Get.snackbar("Error", "Start time can not be after end time",
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: ColorConstants.iconColor,
            colorText: Colors.white,
            icon: Icon(Icons.warning, color: Colors.white));
      }
    }
  }

  _selectEndTime() async {
    TimeOfDay? _pickedEndTime =
        await showTimePicker(context: context, initialTime: _endTime);

    if (_pickedEndTime != null) {
      if (_startTime.compareTo(_pickedEndTime) == -1) {
        setState(() {
          myEditTask?.setEndTime(_pickedEndTime.format(context));
          _endTime = _pickedEndTime;
        });
      } else {
        Get.snackbar("Error", "End time can not be before start time",
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: ColorConstants.iconColor,
            colorText: Colors.white,
            icon: Icon(Icons.warning, color: Colors.white));
      }
    }
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
        myEditTask == null ? "Create Task" : "Update Task",
        style: toolbarTitleStyle,
      ),
      centerTitle: true,
    );
  }

  _validateInputData() {
    if (_titleController.text.isNotEmpty && _noteController.text.isNotEmpty) {
      if (myEditTask != null) {
        _updateTaskInDB();
      } else {
        _addTaskToDB();
      }
      //Save data & go back to home screen
      Get.back();
    } else if (_titleController.text.isEmpty || _noteController.text.isEmpty) {
      Get.snackbar("Required", "Please fill all feilds",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: ColorConstants.iconColor,
          colorText: Colors.white,
          icon: Icon(Icons.warning, color: Colors.white));
    }
  }

  getCreateTaskObject() {
    return Task(
        title: _titleController.text,
        note: _noteController.text,
        date: _selectedDate.toString(),
        startTime: _startTime.format(context),
        endTime: _endTime.format(context),
        repeat: _repeat,
        boardId: _selectedBoard?.id!,
        isCompleted: 0,
        remind: _remindBefore);
  }

  getUpdateTaskObject() {
    return Task(
        id: myEditTask?.id,
        title: _titleController.text,
        note: _noteController.text,
        date: _selectedDate.toString(),
        startTime: _startTime.format(context),
        endTime: _endTime.format(context),
        repeat: _repeat,
        boardId: _selectedBoard?.id!,
        isCompleted: myEditTask?.isCompleted,
        taskStatusUpdatedOn: myEditTask?.taskStatusUpdatedOn,
        remind: _remindBefore);
  }

  _updateTaskInDB() async {
    int? value = await _taskController.updateTask(getUpdateTaskObject());
  }

  _addTaskToDB() async {
    Task task = getCreateTaskObject();
    int? value = await _taskController.addTask(task: getCreateTaskObject());

    var scheduleTime = _selectedDate.applyTimeOfDay(
        hour: _startTime.hour, minute: _startTime.minute);

    //await localNotifyManager.showWeeklyAtDayTimeNotification2();
    if (UserDetailService().isNotificationEnabled ?? true) {
      if (_repeat == "Everyday") {
        await localNotifyManager.showDailyAtTimeNotification(
            value ?? 0, task, _startTime);
      } else if (_repeat == "None") {
        await localNotifyManager.showScheduledNotification(
            value ?? 0, task, scheduleTime);
      } else {
        await localNotifyManager.showWeeklyAtDayTimeNotification(
            value ?? 0, task, _startTime);
      }
    }
    // notifyService.scheduledNotificationNew(
    //   _startTime.hour,
    //   _startTime.minute,
    //   getCreateTaskObject(),
    //   _selectedDate,
    // );
  }

  TimeOfDay stringToTimeOfDay(String tod) {
    final format = DateFormat.jm(); //"6:00 AM"
    return TimeOfDay.fromDateTime(format.parse(tod));
  }
}

extension DateTimeExt on DateTime {
  DateTime applyTimeOfDay({required int hour, required int minute}) {
    return DateTime(year, month, day, hour, minute, 0, 0, 0);
  }
}

extension TimeOfDayExtension on TimeOfDay {
  //To compare start & end time
  int compareTo(TimeOfDay other) {
    if (hour < other.hour) return -1;
    if (hour > other.hour) return 1;
    if (minute < other.minute) return -1;
    if (minute > other.minute) return 1;
    return 0;
  }

  //Add hour to current time for end time
  TimeOfDay add({int hour = 0, int minute = 0}) {
    return replacing(hour: hour + hour, minute: minute + minute);
  }
}
