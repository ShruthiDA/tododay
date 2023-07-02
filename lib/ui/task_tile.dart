import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../models/task.dart';

class TaskTile extends StatelessWidget {
  final Task? task;
  final int? colorId;

  TaskTile(this.task, this.colorId);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20),
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.only(bottom: 12),
      child: Container(
        padding: EdgeInsets.all(16),
        //  width: SizeConfig.screenWidth * 0.78,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: _getBGClr(colorId!),
        ),
        child: Row(children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  task?.title ?? "",
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
                      "${task!.startTime} - ${task!.endTime}",
                      style: GoogleFonts.lato(
                        textStyle:
                            TextStyle(fontSize: 13, color: Colors.black87),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 12),
                Text(
                  task?.note ?? "",
                  style: GoogleFonts.lato(
                    textStyle: TextStyle(fontSize: 15, color: Colors.black87),
                  ),
                ),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 10),
            height: 60,
            width: 0.5,
            color: Colors.black12.withOpacity(0.3),
          ),
          RotatedBox(
            quarterTurns: 3,
            child: Text(
              task!.isCompleted == 1 ? "COMPLETED" : "TODO",
              style: GoogleFonts.lato(
                textStyle: TextStyle(
                    backgroundColor: Colors.black,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87),
              ),
            ),
          ),
        ]),
      ),
    );
  }

  _getBGClr(int no) {
    switch (no) {
      case 0:
        return Color(0xFFfd7f6f);
      case 1:
        return Color(0xFF7eb0d5);
      case 2:
        return Color(0xFFb2e061);
      case 3:
        return Color(0xFFbd7ebe);
      case 4:
        return Color(0xFFffb55a);
      case 5:
        return Color(0xFFffee65);
      case 6:
        return Color(0xFFbeb9db);
      case 7:
        return Color(0xFFfdcce5);
      case 8:
        return Color(0xFF8bd3c7);
      default:
        return Color(0xFF6cd4c5);
    }
  }
}
