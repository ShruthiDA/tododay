import 'package:flutter/material.dart';

import '../services/theme_services.dart';

class MyButton extends StatelessWidget {
  final String label;
  final Function()? onTap;

  const MyButton({Key? key, required this.label, required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 130,
        height: 40,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: ColorConstants.buttonColor),
        child: Center(
            child: Text(
          label,
          style: TextStyle(color: Colors.white),
        )),
      ),
    );
  }
}
