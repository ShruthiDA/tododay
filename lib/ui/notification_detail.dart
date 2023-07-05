import 'package:flutter/material.dart';
import 'package:get/get.dart';

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
        Text(this.label.toString().split("|")[0]),
        Text(this.label.toString().split("|")[1])
      ])),
    );
  }
}
