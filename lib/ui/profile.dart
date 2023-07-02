import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_progress_tracker/services/theme_services.dart';
import 'package:my_progress_tracker/ui/theme.dart';
import '../services/user_detail_service.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePagePageState();
}

class _ProfilePagePageState extends State<ProfilePage> {
  var notifyService;
  var userName = UserDetailService().userName ?? "User Name";
  String? imagePath = UserDetailService().profileImagePath;
  var isLightModeSelected;
  var isDarkModeSelected;
  var isNotificationEnabled;
  bool refreshed = true;
  var _selectedColorIndex;

  @override
  void initState() {
    super.initState();
    isLightModeSelected = Get.isDarkMode == true ? false : true;
    isDarkModeSelected = Get.isDarkMode == true ? true : false;
    _selectedColorIndex = UserDetailService().selectedPrimaryColorIndex;
  }

  _getBody() {
    return Container(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          SizedBox(height: 15),
          Padding(
            padding: const EdgeInsets.only(left: 16.0),
            child: Text("Choose Theme Mode", style: subHeadingStyle),
          ),
          SizedBox(height: 20),
          ListTile(
              trailing: Transform.scale(
                  scale: 0.8,
                  child: CupertinoSwitch(
                    activeColor: ColorConstants.buttonColor,
                    value: isLightModeSelected,
                    onChanged: (value) {
                      buildShowDialog(context);
                      isLightModeSelected = value;
                      switchTheme();
                      setState(() {
                        isDarkModeSelected = !value;
                        updateColor();
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
                  child: Icon(Icons.light_mode,
                      size: 20,
                      color: Get.isDarkMode ? Colors.white : Colors.black)),
              title: Text("Light Mode", style: subHeadingNormalStyle)),
          ListTile(
            trailing: Transform.scale(
              scale: 0.8,
              child: CupertinoSwitch(
                activeColor: ColorConstants.buttonColor,
                value: isDarkModeSelected,
                onChanged: (value) {
                  buildShowDialog(context);
                  isDarkModeSelected = value;
                  switchTheme();
                  setState(() {
                    isLightModeSelected = !value;
                    updateColor();
                  });
                },
              ),
            ),
            leading: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(180),
                  color: ColorConstants.buttonColor.withOpacity(0.3),
                ),
                child: Icon(Icons.dark_mode,
                    size: 20,
                    color: Get.isDarkMode ? Colors.white : Colors.black)),
            title: Text(
              "Dark Mode",
              style: subHeadingNormalStyle,
            ),
          ),
          SizedBox(height: 15),
          Padding(
            padding: const EdgeInsets.only(left: 16.0),
            child: Text("Choose Theme Color", style: subHeadingStyle),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 16.0, top: 10.0, right: 16.0),
            child: Text(
              "Choose the color to apply on all buttons and icons in the app.",
              style: subHeadingNormalStyle,
            ),
          ),
          SizedBox(height: 20),
          _chooseColorNew(),
          SizedBox(height: 20),
        ],
      ),
    );
  }

  updateColor() {
    Timer(Duration(seconds: 1), () {
      setState(() {
        Navigator.of(context).pop();
        refreshed = true;
      });
    });
  }

  buildShowDialog(BuildContext context) {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return Center(
              child: CircularProgressIndicator(
                  color:
                      ThemeService.getAppPrimaryClr(_selectedColorIndex ?? 0)));
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: _appBar(context),
        body: refreshed == true ? _getBody() : _getBody());
  }

  _chooseColorNew() {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16),
      child: GridView.count(
          shrinkWrap: true,
          // Create a grid with 2 columns. If you change the scrollDirection to
          // horizontal, this produces 2 rows.
          crossAxisCount: 6,
          // Generate 100 widgets that display their index in the List.
          children: List.generate(6, (index) {
            return GestureDetector(
                onTap: () => {
                      setState(() {
                        // myEditBoard?.setColor(index);
                        _selectedColorIndex = index;
                        UserDetailService().updatePrimaryColorIndex(index);
                        ColorConstants.updatePrimaryColorCode(
                            ThemeService.getAppPrimaryClr(index));
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
                      backgroundColor: ThemeService.getAppPrimaryClr(index)),
                )));
          })),
    );
  }

  void switchTheme() {
    ThemeService().switchTheme();
    if (UserDetailService().isNotificationEnabled == true) {
      notifyService.displayNotification(
          title: "Theme changed",
          body: Get.isDarkMode
              ? "Activated Light theme"
              : "Activated Dark Theme");
    }
    //notifyService.scheduledNotification();
  }

  _appBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      leading: IconButton(
        icon: Icon(Icons.arrow_back_ios, color: ColorConstants.iconColor),
        onPressed: () => Navigator.of(context).pop(),
      ),
      title: Text("Themes", style: toolbarTitleStyle),
      centerTitle: true,
    );
  }
}
