import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:my_progress_tracker/db/db_helper.dart';

import '../models/board.dart';
import '../services/theme_services.dart';

class BoardTile extends StatelessWidget {
  final Board? board;
  final int? taskCount;

  BoardTile(this.board, this.taskCount);

  @override
  Widget build(BuildContext context) {
    //DBHelper.getBoardTaskCount(board!);
    //print("Task count is .... ${taskCount}");
    return Container(
      padding: EdgeInsets.all(8),
      width: MediaQuery.of(context).size.width,
      child: Container(
        //padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: ThemeService.getBGClr(board?.color ?? 0),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Container(
              margin: const EdgeInsets.only(top: 20.0, left: 20.0, right: 20.0),
              child: Text(
                overflow: TextOverflow.ellipsis,
                board?.boardName ?? "",
                style: GoogleFonts.lato(
                  textStyle: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF454545)),
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 5.0),
              alignment: Alignment.center,
              child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ThemeService.getBoardIcon(board!.boardName!)),
            ),
            Spacer(),
            Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(16),
                      bottomRight: Radius.circular(16)),
                  color: Colors.white.withOpacity(0.3),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(
                      top: 12.0, left: 16.0, bottom: 12.0),
                  child: Text(
                    taskCount == 0
                        ? "No tasks"
                        : taskCount == 1
                            ? "${taskCount} task"
                            : "${taskCount} tasks",
                    textAlign: TextAlign.left,
                    style: GoogleFonts.lato(
                      textStyle: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF454545)),
                    ),
                  ),
                )),
          ],
        ),
      ),
    );
  }
}
