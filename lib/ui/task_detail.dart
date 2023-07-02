import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:my_progress_tracker/ui/theme.dart';

import '../controllers/task_controller.dart';
import '../models/task.dart';
import '../services/theme_services.dart';
import 'add_task.dart';

class TaskDetailPage extends StatefulWidget {
  final Task? taskDetail;
  final bool? shouldShowEdit;

  TaskDetailPage({Key? key, this.taskDetail, this.shouldShowEdit})
      : super(key: key);

  @override
  State<TaskDetailPage> createState() =>
      TaskDetailPageState(taskDetail, shouldShowEdit);
}

class TaskDetailPageState extends State<TaskDetailPage> {
  Task? taskDetail;
  bool? shouldShowEdit;
  final _taskController = Get.put(TaskController());

  TaskDetailPageState(Task? taskDetail, bool? shouldShowEdit) {
    this.taskDetail = taskDetail;
    this.shouldShowEdit = shouldShowEdit;
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var setDate = DateFormat.yMMMd().format(DateTime.parse(taskDetail!.date!));
    var _selectedBoard = Get.put(TaskController())
        .boardList
        .firstWhere((element) => element.id == taskDetail!.boardId!);

    return Scaffold(
        appBar: _appBar(context),
        body: Padding(
            padding: const EdgeInsets.only(left: 24.0, right: 24.0),
            child: Column(children: [
              SizedBox(height: 15),
              Text(taskDetail?.title ?? "",
                  style: taskTitleStyle, textAlign: TextAlign.center),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 15),
                  Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: ColorConstants.buttonColor.withOpacity(0.2)
                          //color: Get.isDarkMode ? Colors.greenAccent: Color.amberAccent)),
                          ),
                      child: Padding(
                        padding: const EdgeInsets.all(30.0),
                        child: Text(taskDetail?.note ?? "",
                            style: normalTextStyle18),
                      )),
                  SizedBox(height: 20),
                  Row(
                    children: [
                      Icon(
                        Icons.notifications,
                        color: ColorConstants.iconColor,
                      ),
                      SizedBox(width: 10),
                      Text("Remind before ${taskDetail?.remind} mins",
                          style: headingStyle),
                    ],
                  ),
                  SizedBox(height: 20),
                  Row(
                    children: [
                      Icon(Icons.repeat, color: ColorConstants.iconColor),
                      SizedBox(width: 10),
                      Text("Repeat ${taskDetail?.repeat}", style: headingStyle),
                    ],
                  ),
                  SizedBox(height: 10),
                  Divider(
                    thickness: 1,
                  ),
                  SizedBox(height: 10),
                  Row(
                    children: [
                      Icon(Icons.calendar_month,
                          color: ColorConstants.iconColor),
                      SizedBox(width: 10),
                      Text(setDate, style: headingStyle),
                    ],
                  ),
                  SizedBox(height: 20),
                  Row(
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Start Time', style: normalTextStyle16),
                          SizedBox(height: 10),
                          Row(
                            children: [
                              Icon(Icons.timelapse,
                                  color: ColorConstants.iconColor),
                              SizedBox(width: 10),
                              Text(taskDetail?.startTime ?? "",
                                  style: headingStyle),
                            ],
                          )
                        ],
                      ),
                      Spacer(),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('End Time', style: normalTextStyle16),
                          SizedBox(height: 10),
                          Row(
                            children: [
                              Icon(Icons.timelapse,
                                  color: ColorConstants.iconColor),
                              SizedBox(width: 10),
                              Text(taskDetail?.endTime ?? "",
                                  style: headingStyle),
                            ],
                          )
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  Divider(
                    thickness: 1,
                  ),
                  SizedBox(height: 10),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Task Board', style: normalTextStyle16),
                      SizedBox(height: 12),
                      Row(
                        children: [
                          ThemeService.getBoardIconForDetail(
                            _selectedBoard.boardName ?? "",
                          ),
                          SizedBox(width: 10),
                          Text(_selectedBoard.boardName ?? "",
                              style: headingStyle),
                        ],
                      )
                    ],
                  ),
                  SizedBox(height: 50),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: GestureDetector(
                        onTap: () {
                          _taskController.delete(taskDetail!);
                          _taskController.getTasks();
                          Get.back();
                        },
                        child: Container(
                          height: 40,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.red.shade400
                              //color: Get.isDarkMode ? Colors.greenAccent: Color.amberAccent)),
                              ),
                          child: Center(
                              child: Text(
                            "Delete Task",
                            style: TextStyle(color: Colors.white),
                          )),
                        )),
                  ),
                  shouldShowEdit == true ? SizedBox(width: 30) : Container(),
                  shouldShowEdit == true
                      ? Expanded(
                          child: GestureDetector(
                              onTap: () async {
                                //Get.back();
                                await Get.to(AddTaskPage(editTask: taskDetail));
                                _taskController.getTasks();
                                Get.back();
                              },
                              child: Container(
                                height: 40,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: ColorConstants.buttonColor),
                                child: Center(
                                    child: Text(
                                  "Edit Task",
                                  style: TextStyle(color: Colors.white),
                                )),
                              )),
                        )
                      : Container(),
                ],
              )
            ])));
  }

  _appBar(BuildContext context) {
    return AppBar(
        iconTheme: IconThemeData(color: ColorConstants.iconColor),
        //backgroundColor: context.theme.backgroundColor,
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: ColorConstants.iconColor),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text("Task Detail", style: toolbarTitleStyle),
        centerTitle: true);
  }
}
