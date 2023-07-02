import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:my_progress_tracker/ui/theme.dart';
import '../services/theme_services.dart';
import '../services/user_detail_service.dart';
import 'button.dart';
import 'input_feild.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  String? imagePath = UserDetailService().profileImagePath;
  TextEditingController _userNameController =
      TextEditingController(text: UserDetailService().userName);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: _appBar(context),
        body: SingleChildScrollView(
            child: Container(
                padding: EdgeInsets.all(16),
                child: Column(children: [
                  Stack(children: [
                    SizedBox(
                        width: 140,
                        height: 140,
                        child: ClipRRect(
                            borderRadius: BorderRadius.circular(120),
                            child: _loadImage())),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: GestureDetector(
                        onTap: () {
                          _showBottomSheet(context);
                        },
                        child: Container(
                            width: 30,
                            height: 30,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(180),
                              color: ColorConstants.iconColor,
                            ),
                            child: Icon(
                              Icons.edit,
                              color: Colors.white,
                              size: 18,
                            )),
                      ),
                    )
                  ]),
                  TextInputFeild(
                    hint: UserDetailService().userName ?? "",
                    label: "Your name",
                    widget: null,
                    controller: _userNameController,
                  ),
                  Container(
                      margin: EdgeInsets.only(top: 14),
                      child: MyButton(
                          label: "Update Profile",
                          onTap: () {
                            //validate user name
                            _updateUserName();
                          })),
                  SizedBox(height: 20),
                  Divider(),
                  SizedBox(height: 20),
                ]))));
  }

  Widget _loadImage() {
    if (imagePath == null) {
      return CircleAvatar(
          child: Icon(
            Icons.person,
            color: Colors.black,
            size: 80,
          ),
          backgroundColor: Colors.grey);
    } else {
      //image: AssetImage("images/profile_pic.jpeg")
      return Container(
          decoration: BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(
                  fit: BoxFit.fill, image: FileImage(File(imagePath!)))));
    }
  }

  _updateUserName() {
    if (_userNameController.text.isNotEmpty) {
      UserDetailService().updateUserName(_userNameController.text);
      Get.back();
    } else if (_userNameController.text.isEmpty) {
      Get.snackbar("Required", "User name can not be empty",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: ColorConstants.iconColor,
          icon: Icon(Icons.warning));
    }
  }

  _appBar(BuildContext context) {
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.transparent,
      leading: IconButton(
        icon: Icon(Icons.arrow_back_ios, color: ColorConstants.iconColor),
        onPressed: () => Navigator.of(context).pop(),
      ),
      title: Text("Edit Profile", style: toolbarTitleStyle),
      centerTitle: true,
    );
  }

  _showBottomSheet(BuildContext context) {
    Get.bottomSheet(Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20), topRight: Radius.circular(20)),
            color: Get.isDarkMode ? Colors.grey.shade800 : Colors.white),
        padding: EdgeInsets.all(10),
        height: 200,
        child: Column(
          children: [
            Container(
              height: 6,
              width: 120,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50), color: Colors.grey),
            ),
            SizedBox(height: 20),
            Row(
              children: [
                _bottomSheetButton(
                    context: context,
                    label: "From Camera",
                    color: ColorConstants.iconColor,
                    icon: Icons.camera_alt,
                    onTap: () {
                      pickImage(ImageSource.camera);
                    }),
                _bottomSheetButton(
                    context: context,
                    label: "From Gallery",
                    color: ColorConstants.iconColor,
                    icon: Icons.image,
                    onTap: () {
                      pickImage(ImageSource.gallery);
                    }),
              ],
            )
          ],
        )));
  }

  Future pickImage(ImageSource imageSource) async {
    Get.back();
    try {
      final image = await ImagePicker().pickImage(source: imageSource);
      if (image == null) return;
      final imageTemp = File(image.path);
      setState(() => this.imagePath = image.path);
      UserDetailService().updateProfilePic(image.path);
    } on PlatformException catch (e) {
      UserDetailService().updateProfilePic(null);
    }
  }

  _bottomSheetButton(
      {required BuildContext context,
      required String label,
      required Function() onTap,
      required Color color,
      required IconData icon,
      bool isClose = false}) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          margin: EdgeInsets.all(5),
          decoration: BoxDecoration(
              border: Border.all(
                  width: 2, color: isClose == true ? Colors.red : color),
              borderRadius: BorderRadius.circular(10),
              color: isClose ? Colors.transparent : color),
          child: Column(children: [
            SizedBox(height: 20),
            Icon(icon, color: Colors.black),
            SizedBox(height: 10),
            Center(
                child: Text(
              label,
              style: TextStyle(
                  color: isClose
                      ? Get.isDarkMode
                          ? Colors.white
                          : Colors.black
                      : Colors.black),
            )),
            SizedBox(height: 10),
          ]),
        ),
      ),
    );
  }
}
