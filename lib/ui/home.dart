import 'dart:async';
import 'dart:io';

import 'package:date_picker_timeline/date_picker_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:my_progress_tracker/controllers/task_controller.dart';
import 'package:my_progress_tracker/db/db_helper.dart';
import 'package:my_progress_tracker/models/task.dart';
import 'package:my_progress_tracker/services/local_notify_manager.dart';
import 'package:my_progress_tracker/services/user_detail_service.dart';
import 'package:my_progress_tracker/ui/add_task.dart';
import 'package:my_progress_tracker/ui/button.dart';
import 'package:my_progress_tracker/ui/task_detail.dart';
import 'package:my_progress_tracker/ui/task_list.dart';
import 'package:my_progress_tracker/ui/task_tile_new.dart';
import 'package:my_progress_tracker/ui/theme.dart';
import 'package:my_progress_tracker/ui/profile.dart';
import '../models/board.dart';
import '../models/quotes.dart';
import '../services/api_service.dart';
import '../services/theme_services.dart';
import 'boards_list.dart';
import 'custom_alert_dialog.dart';
import 'dol_durma_clipper.dart';
import 'edit_profile.dart';
import 'notification_detail.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var notifyService;
  final _taskController = Get.put(TaskController());
  var userName = UserDetailService().userName ?? "";
  String? imagePath = UserDetailService().profileImagePath;
  bool isNotificationEnabled =
      UserDetailService().isNotificationEnabled ?? true;
  bool isThemeUpdated = false;
  Quotes? data;
  DateTime selectedDate = DateTime.now();
  bool isDarkTheme = Get.isDarkMode;
  int todoCount = 0, completedCount = 0;
  bool showCount = false;

  @override
  void initState() {
    super.initState();

    //APi cal, Uncomment later
    //getQuotes();
    _taskController.getTaskBoard();
    _updateCount();
    localNotifyManager.setOnNotificationRecieve(onNotificationRecieve);
    localNotifyManager.setOnNotificationClick(onNotificationClick);
  }

  void onNotificationRecieve(ReceieveNotification noti) {
    print("onNotificationRecieve -> ${noti.id}");
  }

  void onNotificationClick(String payload) {
    print("onNotificationClick ->  ${payload}");
    Get.to(() => NotificationDetailPage(label: payload));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: _appBar(),
        drawer: Drawer(
          shadowColor: Colors.black,
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              SizedBox(
                height: 300,
                child: DrawerHeader(
                    decoration: BoxDecoration(), child: _getDrawerHeader()),
              ),
              _showCategory(context),
              GestureDetector(
                onTap: () async {
                  Navigator.pop(context);
                  await Get.to(ProfilePage());

                  setState(() {
                    isThemeUpdated = isThemeUpdated;
                  });
                },
                child: ListTile(
                    leading: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(180),
                          color: ColorConstants.buttonColor.withOpacity(0.3),
                        ),
                        child: Icon(Icons.color_lens,
                            size: 20,
                            color:
                                Get.isDarkMode ? Colors.white : Colors.black)),
                    title: Text(
                      "Theme",
                      style: subHeadingNormalStyle,
                    )),
              ),
              ListTile(
                  trailing: Transform.scale(
                      scale: 0.8,
                      child: CupertinoSwitch(
                        activeColor: ColorConstants.buttonColor,
                        value: isNotificationEnabled,
                        onChanged: (value) {
                          UserDetailService().updateNotificationEnanbled(value);
                          setState(() {
                            isNotificationEnabled = value;
                            if (value == false) {
                              localNotifyManager.cancelAllNotification();
                            }
                          });
                        },
                      )),
                  leading: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(180),
                        color: ColorConstants.buttonColor.withOpacity(0.3),
                      ),
                      child: Icon(Icons.notifications,
                          size: 20,
                          color: Get.isDarkMode ? Colors.white : Colors.black)),
                  title: Text("Notification", style: subHeadingNormalStyle)),
              _showLogout(context),
            ],
          ),
        ),
        body: Column(children: [
          _addTaskBar(),
          _showQuote(),
          SizedBox(height: 10),
          _taskTitle(),
          showCount
              ? Padding(
                  padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Text("TODO : ${todoCount}"),
                          SizedBox(width: 15),
                          Text("COMPLETED : ${completedCount}")
                        ],
                      ),
                      SizedBox(height: 5),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Container(
                          height: 20,
                          child: LinearProgressIndicator(
                            value: todoCount == 0
                                ? 1
                                : completedCount == 0
                                    ? 0
                                    : (completedCount * 100) /
                                        ((todoCount + completedCount) * 100),
                            valueColor: AlwaysStoppedAnimation<Color>(
                                ColorConstants.progressColor),
                            backgroundColor:
                                ColorConstants.progressColor.withOpacity(0.2),
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                    ],
                  ),
                )
              : Container(),
          SizedBox(height: 15),
          _showTasks()
        ]));
  }

  _showTitle() {
    return Container(child: Obx(() {
      if (_taskController.taskList.length > 0) {
        return Container(
            child: Column(children: [
          Text("My Tasks",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          SizedBox(height: 20)
        ]));
      }
      return Container();
    }));
  }

  Widget _getDrawerHeader() {
    return Column(children: [
      SizedBox(
          width: 100,
          height: 100,
          child: ClipRRect(
              borderRadius: BorderRadius.circular(80), child: _loadImage())),
      SizedBox(height: 10),
      Text(
        userName,
        style: subHeadingStyle,
      ),
      Container(
          margin: EdgeInsets.only(top: 14),
          child: MyButton(
              label: "Edit Profile",
              onTap: () async {
                await Get.to(EditProfilePage());
                //Set state to reload User name & profile pic if updated
                setState(() {
                  userName = UserDetailService().userName ?? "User Name";
                  imagePath = UserDetailService().profileImagePath;
                });
              })),
      SizedBox(height: 20),
    ]);
  }

  _appBar() {
    return AppBar(
      iconTheme: IconThemeData(color: ColorConstants.iconColor),
      backgroundColor: Colors.transparent,
      elevation: 0,
      actions: [
        GestureDetector(onTap: () async {}, child: _loadImage()),
        SizedBox(width: 20),
      ],
    );
    // SizedBox(width: 10));
  }

  Widget _loadImage() {
    if (imagePath == null) {
      return CircleAvatar(
          child: Icon(
            Icons.person,
            color: Colors.black,
          ),
          radius: 20,
          backgroundColor: Colors.grey);
    } else {
      return Container(
          width: 40.0,
          height: 40.0,
          decoration: BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(
                  fit: BoxFit.fill, image: FileImage(File(imagePath!)))));
    }
  }

  _childWidget() {
    double mWidth = MediaQuery.of(context).size.width;
    double mHeight = MediaQuery.of(context).size.height;
    return Container(
      width: mWidth,
      height: mHeight * 0.75,
    );
  }

  _updateCount() {
    Timer(Duration(seconds: 1), () {
      int c1 = 0;
      int c2 = 0;
      if (_taskController.taskList.length == 0) {
        setState(() {
          showCount = false;
        });
      } else {
        _taskController.taskList.forEach((task) => {
              if (_checkShouldShowTask(task))
                {
                  if (_showMarkAsCompleteOption(task)) {c1++} else {c2++}
                }
            });

        setState(() {
          showCount = true;
          todoCount = c1;
          completedCount = c2;
        });
      }

      if (todoCount == 0 && completedCount == 0) showCount = false;
    });
  }

  _checkShouldShowTask(Task task) {
    String selectedDay = DateFormat('EEEE').format(selectedDate);
    var shouldShow = false;
    if (task.repeat == "Everyday") {
      shouldShow = true;
    } else if (task.repeat == "Weekend" &&
        (selectedDay == "Saturday" || selectedDay == "Sunday")) {
      shouldShow = true;
    } else if (task.repeat == "Weekdays" &&
        (selectedDay != "Saturday" && selectedDay != "Sunday")) {
      shouldShow = true;
    } else if (task.repeat == "None" &&
        selectedDate.isSameDate(DateTime.parse(task.date!))) {
      shouldShow = true;
    }
    return shouldShow;
  }

  _addTaskBar() {
    _taskController.getTasks();

    return Container(
      margin: EdgeInsets.all(16),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text("Hi ${userName}", style: boldHeadingTextStyle),
          SizedBox(height: 10),
          Text(
            "Today - ${DateFormat.yMMMMd().format(DateTime.now())}",
            style: subHeadingStyle,
          ),
        ]),
        MyButton(
            label: "Add Task",
            onTap: () async {
              await Get.to(AddTaskPage());
              //Wait & fetch list again to refresh the list on home page.
              _taskController.getTasks();
              _updateCount();
            })
      ]),
    );
  }

  _taskTitle() {
    return Container(
      margin: EdgeInsets.all(16),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text("Today's Task", style: toolbarTitleStyle),
        ]),
        GestureDetector(
          onTap: () async {
            await Get.to(TaskListPage());
            //Wait & fetch list again to refresh the list on home page.
            _taskController.getTasks();
            _updateCount();
          },
          child: Text(
            'View All Tasks',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: ColorConstants.buttonColor,
              decoration: TextDecoration.underline,
            ),
          ),
        ),
      ]),
    );
  }

  _addDatePicker() {
    return Container(
      child: DatePicker(
        DateTime.now(),
        height: 80,
        width: 60,
        initialSelectedDate: selectedDate,
        onDateChange: (date) {
          setState(() {
            selectedDate = date;
          });
        },
        selectionColor: Get.isDarkMode
            ? ColorConstants.buttonColor
            : ColorConstants.buttonColor,
        selectedTextColor: Colors.white,
        deactivatedColor: Colors.white,
        monthTextStyle: GoogleFonts.lato(
            textStyle: TextStyle(
                fontSize: 11, fontWeight: FontWeight.w400, color: Colors.grey)),
        dateTextStyle: GoogleFonts.lato(
            textStyle: TextStyle(
                fontSize: 16, fontWeight: FontWeight.w800, color: Colors.grey)),
        dayTextStyle: GoogleFonts.lato(
            textStyle: TextStyle(
                fontSize: 12, fontWeight: FontWeight.w400, color: Colors.grey)),
      ),
    );
  }

  Future<Null> getQuotes() async {
    data = await ApiService.getQuotes();
    setState(() {});
  }

  _showTasks() {
    return Expanded(child: Obx(() {
      if (_taskController.taskList.length == 0 || showCount == false) {
        return Container(
          child: Center(
              child: Text("No tasks for today.\nCreate one now",
                  style: headingStyle, textAlign: TextAlign.center)),
        );
      }

      return ListView.builder(
          itemCount: _taskController.taskList.length,
          itemBuilder: (context, index) {
            Task currentTask = _taskController.taskList[index];

            String selectedDay = DateFormat('EEEE').format(selectedDate);

            var shouldShow = false;
            if (currentTask.repeat == "Everyday") {
              shouldShow = true;
            } else if (currentTask.repeat == "Weekend" &&
                (selectedDay == "Saturday" || selectedDay == "Sunday")) {
              shouldShow = true;
            } else if (currentTask.repeat == "Weekdays" &&
                (selectedDay != "Saturday" && selectedDay != "Sunday")) {
              shouldShow = true;
            } else if (currentTask.repeat == "None" &&
                selectedDate.isSameDate(DateTime.parse(currentTask.date!))) {
              shouldShow = true;
            }

            if (shouldShow == true) {
              var showMarkCompleteOption =
                  _showMarkAsCompleteOption(currentTask);
              return AnimationConfiguration.staggeredList(
                  position: index,
                  child: GestureDetector(
                      onTap: () async {
                        if (showMarkCompleteOption) {
                          _showBottomSheet(context, currentTask);
                        } else {
                          await Get.to(TaskDetailPage(
                              taskDetail: currentTask,
                              shouldShowEdit: _showShouldEdit(currentTask)));
                          _taskController.getTasks();
                          _updateCount();
                        }
                      },
                      child: TaskTileNew(currentTask,
                          getColorIndex(currentTask.boardId!), true)));
            } else {
              return Container();
            }
          });
    }));
  }

  _getNewTaskTile() {
    return Container(
        padding: EdgeInsets.symmetric(horizontal: 20),
        width: MediaQuery.of(context).size.width,
        margin: EdgeInsets.only(bottom: 12),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ClipPath(
                clipper: DolDurmaClipper(right: 40, holeRadius: 20),
                child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(
                        Radius.circular(15),
                      ),
                      color: Colors.blueAccent,
                    ),
                    width: MediaQuery.of(context).size.width,
                    padding: EdgeInsets.all(15),
                    child: Row(children: [
                      Expanded(
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                            Text(
                              "task?.title " ?? "",
                              style: GoogleFonts.lato(
                                textStyle: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black87),
                              ),
                            ),
                            SizedBox(
                              height: 12,
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.access_time_rounded,
                                  color: Colors.black87,
                                  size: 18,
                                ),
                                SizedBox(width: 4),
                                Text(
                                  "task.startTime - task!.endTime",
                                  style: GoogleFonts.lato(
                                    textStyle: TextStyle(
                                        fontSize: 13, color: Colors.black87),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 12),
                            Text(
                              "task?.note" ?? "",
                              style: GoogleFonts.lato(
                                textStyle: TextStyle(
                                    fontSize: 15, color: Colors.black87),
                              ),
                            ),
                          ])),
                      RotatedBox(
                        quarterTurns: 3,
                        child: Text(
                          "COMPLETED",
                          style: GoogleFonts.lato(
                            textStyle: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: Colors.black),
                          ),
                        ),
                      ),
                    ])),
              )
            ]));
  }

  getColorIndex(int boardId) {
    Board? b = _taskController.boardList
        .firstWhereOrNull((element) => element.id == boardId);
    if (b != null) {
      return b.color;
    } else {
      return 0;
    }
  }

  _showMarkAsCompleteOption(Task task) {
    var showMarkAsCompleteOption;

    if (task.isCompleted == 1) {
      //check when was the status last updated; if not updated today then display the option
      var lastUpdatedDate = DateTime.parse(task.taskStatusUpdatedOn!);
      var islastUpdatedIsToday = lastUpdatedDate.isSameDate(DateTime.now());
      if (task.taskStatusUpdatedOn != null && islastUpdatedIsToday) {
        showMarkAsCompleteOption = false;
      } else {
        showMarkAsCompleteOption = true;
      }
    } else {
      showMarkAsCompleteOption = true;
    }
    return showMarkAsCompleteOption;
  }

  _showBottomSheet(BuildContext context, Task task) {
    Get.bottomSheet(Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20), topRight: Radius.circular(20)),
            color: Get.isDarkMode ? Colors.grey.shade800 : Colors.white),
        padding: EdgeInsets.all(10),
        height: MediaQuery.of(context).size.height * 0.38,
        child: Column(
          children: [
            Container(
              height: 6,
              width: 120,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50), color: Colors.grey),
            ),
            SizedBox(height: 20),
            _bottomSheetButton(
                context: context,
                label: "View Task",
                color: ColorConstants.buttonColor,
                onTap: () async {
                  Get.back();

                  await Get.to(TaskDetailPage(
                      taskDetail: task, shouldShowEdit: _showShouldEdit(task)));
                  _taskController.getTasks();
                  _updateCount();
                }),
            _bottomSheetButton(
                context: context,
                label: "Mark as Complete",
                color: ColorConstants.buttonColor,
                onTap: () {
                  _taskController.updateStatus(
                      task.id!, DateTime.now().toString());
                  _taskController.getTasks();
                  _updateCount();
                  Get.back();
                }),
            _bottomSheetButton(
                context: context,
                label: "Delete Task",
                color: ColorConstants.buttonColor,
                onTap: () {
                  _taskController.delete(task);
                  _taskController.getTasks();
                  _updateCount();
                  Get.back();
                }),
            SizedBox(height: 15),
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

  buildShowDialog(BuildContext context) {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return Center(
              child:
                  CircularProgressIndicator(color: ColorConstants.iconColor));
        });
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

  _showQuote() {
    var size = MediaQuery.of(context).size;
    var height = size.height;
    var width = size.width;
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 10,
      ),
      child: Card(
        color: Get.isDarkMode
            ? ColorConstants.buttonColor.withOpacity(0.1)
            : ColorConstants.buttonColor.withOpacity(0.1),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        elevation: 0,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '${data?.content ?? "Don't talk about what you have done or what you are going to do."}',
                textAlign: TextAlign.justify,
                style: quotesTextStyle,
              ),
              SizedBox(height: 10),
              Align(
                  alignment: Alignment.bottomRight,
                  child: Text(
                    data?.author ?? "Thomas Jefferson",
                    textAlign: TextAlign.justify,
                    style: quotesTextStyle,
                  ))
            ],
          ),
        ),
      ),
    );
  }

  _showLogout(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pop(context);
        print("Logout called");
        showLogoutAlert(context);
      },
      child: ListTile(
          leading: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(80),
                color: ColorConstants.buttonColor.withOpacity(0.3),
              ),
              child: Icon(Icons.logout,
                  size: 20,
                  color: Get.isDarkMode ? Colors.white : Colors.black)),
          title: Text(
            "Log out",
            style: subHeadingNormalStyle,
          )),
    );
  }

  showLogoutAlert(BuildContext context) {
    var dialog = CustomAlertDialog(
        bgColor: Get.isDarkMode
            ? ColorConstants.alertDarkBg
            : ColorConstants.alertLightBg,
        title: "LOGOUT",
        message: "Are you sure? Logout will remove all the tasks created.",
        onPostivePressed: () async {
          await DBHelper.deleteDataInDB();
          await DBHelper.createBoard();
          Navigator.pop(context);
          _taskController.getTasks();
          _updateCount();
        },
        positiveBtnText: 'Yes',
        negativeBtnText: 'No');

    showDialog(context: context, builder: (BuildContext context) => dialog);
  }
}

_showCategory(BuildContext context) {
  return GestureDetector(
    onTap: () {
      Navigator.pop(context);
      Get.to(BoardsListPage());
    },
    child: ListTile(
        leading: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(180),
              color: ColorConstants.buttonColor.withOpacity(0.3),
            ),
            child: Icon(Icons.category,
                size: 20, color: Get.isDarkMode ? Colors.white : Colors.black)),
        title: Text(
          "Task Board",
          style: subHeadingNormalStyle,
        )),
  );
}

_showShouldEdit(Task task) {
  var showMarkAsCompleteOption;

  if (task.isCompleted == 1) {
    //check when was the status last updated; if not updated today then display the option
    var lastUpdatedDate = DateTime.parse(task.taskStatusUpdatedOn!);
    var islastUpdatedIsToday = lastUpdatedDate.isSameDate(DateTime.now());
    if (task.taskStatusUpdatedOn != null && islastUpdatedIsToday) {
      showMarkAsCompleteOption = false;
    } else {
      showMarkAsCompleteOption = true;
    }
  } else {
    showMarkAsCompleteOption = true;
  }
  return showMarkAsCompleteOption;
}

_showTheme(BuildContext context) {}

extension DateOnlyCompare on DateTime {
  bool isSameDate(DateTime other) {
    var isSame = year == other.year && month == other.month && day == other.day;
    return isSame;
  }
}
