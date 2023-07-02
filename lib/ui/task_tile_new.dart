import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:my_progress_tracker/ui/dol_durma_clipper.dart';
import 'package:get/get.dart';
import 'package:my_progress_tracker/ui/home.dart';
import 'package:my_progress_tracker/ui/theme.dart';
import '../models/task.dart';

class TaskTileNew extends StatelessWidget {
  final Task? task;
  final int? colorId;
  final bool shouldShowCompleteStatus;

  TaskTileNew(this.task, this.colorId, this.shouldShowCompleteStatus);

  @override
  Widget build(BuildContext context) {
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
                      color: _getBGClr(colorId!),
                    ),
                    width: MediaQuery.of(context).size.width,
                    padding: EdgeInsets.all(15),
                    child: Row(children: [
                      Expanded(
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                            Padding(
                              padding: const EdgeInsets.only(right: 25),
                              child: Text(task?.title ?? "",
                                  maxLines: 1, style: boldTextStyle16),
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
                                  "${task!.startTime} - ${task!.endTime}",
                                  style: GoogleFonts.lato(
                                    textStyle: normalTextStyle12,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 12),
                            Padding(
                              padding: const EdgeInsets.only(right: 10),
                              child: Text(task?.note ?? "",
                                  style: GoogleFonts.lato(
                                    textStyle: normalTextStyle14,
                                  ),
                                  maxLines: 2),
                            ),
                          ])),
                      RotatedBox(
                        quarterTurns: 3,
                        child: Text(
                          _getStatus(),
                          // shouldShowCompleteStatus == true
                          //     ? task!.isCompleted == 1
                          //         ? "COMPLETED"
                          //         : "TODO"
                          //     : "TODO",
                          style: GoogleFonts.lato(
                            textStyle: boldTextStyle14,
                          ),
                        ),
                      ),
                    ])),
              )
            ]));
  }

  _getStatus() {
    var status = "TODO";
    if (shouldShowCompleteStatus == true) {
      if (task!.isCompleted == 1 && task!.taskStatusUpdatedOn != null) {
        //check when was the status last updated; if not updated today then display as TODO
        var lastUpdatedDate = DateTime.parse(task!.taskStatusUpdatedOn!);
        var islastUpdatedIsToday = lastUpdatedDate.isSameDate(DateTime.now());
        if (task!.taskStatusUpdatedOn != null && islastUpdatedIsToday) {
          status = "COMPLETED";
        } else {
          status = "TODO";
        }
      } else
        status = "TODO";
    } else {
      status = "TODO";
    }
    return status;
  }

  _getBGClr(int no) {
    switch (no) {
      case 0:
        return Color(0xFFfd7f6f).withOpacity(Get.isDarkMode ? 1.0 : 0.5);
      case 1:
        return Color(0xFF7eb0d5).withOpacity(Get.isDarkMode ? 1.0 : 0.5);
      case 2:
        return Color(0xFFb2e061).withOpacity(Get.isDarkMode ? 1.0 : 0.5);
      case 3:
        return Color(0xFFbd7ebe).withOpacity(Get.isDarkMode ? 1.0 : 0.5);
      case 4:
        return Color(0xFFffb55a).withOpacity(Get.isDarkMode ? 1.0 : 0.5);
      case 5:
        return Color(0xFFffee65).withOpacity(Get.isDarkMode ? 1.0 : 0.5);
      case 6:
        return Color(0xFFbeb9db).withOpacity(Get.isDarkMode ? 1.0 : 0.5);
      case 7:
        return Color(0xFFfdcce5).withOpacity(Get.isDarkMode ? 1.0 : 0.5);
      case 8:
        return Color(0xFF8bd3c7).withOpacity(Get.isDarkMode ? 1.0 : 0.5);
      default:
        return Color(0xFF6cd4c5).withOpacity(Get.isDarkMode ? 1.0 : 0.5);
    }
  }
}
