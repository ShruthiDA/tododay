import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_progress_tracker/ui/theme.dart';

class NotificationDetailPage extends StatelessWidget {
  final String? label;
  const NotificationDetailPage({Key? key, required this.label})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () => Get.back(), icon: Icon(Icons.arrow_back_ios)),
        title: Text("Remainder"),
      ),
      body: Center(
          child: Column(children: [
        SizedBox(height: 30),
        Text(
          this.label.toString().split("|")[0],
          style: taskTitleStyle,
        ),
        SizedBox(height: 30),
        Text(this.label.toString().split("|")[1], style: subHeadingStyle)
      ])),
    );
  }
}
