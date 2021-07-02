import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_svg/svg.dart';
import 'package:my_messenger/constants.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_messenger/cubit/sign_in/sign_in_cubit.dart';
import 'package:my_messenger/models/user_profile.dart';
import 'package:my_messenger/screens/users/users_screen.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_core/firebase_core.dart';

class ProfileScreen extends StatefulWidget {
  static const routeName = '/profile';
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _formKey = GlobalKey<FormState>();

  bool isSaveVisible = true;
  bool isFirstBuild = true;

  var fNameController = TextEditingController();
  var lNameController = TextEditingController();
  var phoneController = TextEditingController();
  var addressController = TextEditingController();
  var genderController = TextEditingController();
  var maritalStatusController = TextEditingController();
  var preferLangController = TextEditingController();

  late File imageFile = File('');
  String avatarUrl = '';
  String email = '';
  List<String> channels = [];

  @override
  void dispose() {
    fNameController.dispose();
    lNameController.dispose();
    phoneController.dispose();
    addressController.dispose();
    genderController.dispose();
    maritalStatusController.dispose();
    preferLangController.dispose();
    super.dispose();
  }

  Widget modalSheetDivider() {
    return Container(
      height: 3.0,
      width: 32.0,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(100.0)),
        color: Color(0XFFEBEBEB),
      ),
    );
  }

  Future<void> uploadFile(String filePath, String userId) async {
    File file = File(filePath);
    try {
      await FirebaseStorage.instance
          .ref()
          .child('users/avatar_$userId.png')
          .putFile(file);

      FirebaseStorage.instance
          .ref('users/avatar_$userId.png')
          .getDownloadURL()
          .then((value) {
        setState(() {
          avatarUrl = value;
        });
      });
    } on FirebaseException catch (e) {
      // e.g, e.code == 'canceled'
      print(e);
    }
  }

  void showSaveBottomSheet() {
    showModalBottomSheet(
        isDismissible: false,
        context: context,
        barrierColor: Colors.black.withOpacity(0.8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20.0),
            topRight: Radius.circular(20.0),
          ),
        ),
        builder: (BuildContext context) {
          return Container(
            height: 220,
            padding: EdgeInsets.only(top: 8, left: 24, right: 24),
            child: Column(
              children: [
                modalSheetDivider(),
                const SizedBox(height: 29.0),
                Text(
                  'Save changes?',
                  style: AllStyles.font20w500darkGray,
                ),
                const SizedBox(height: 40.0),
                Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                          setState(() {
                            isSaveVisible = true;
                          });
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 24, vertical: 16),
                          decoration: BoxDecoration(
                              color: Color(0xFFEEEEEE),
                              borderRadius: BorderRadius.circular(100)),
                          child: Text(
                            'Quit',
                            style: AllStyles.font15w500darkGray,
                          ),
                          alignment: Alignment.center,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8.0),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          UserProfile newUserInfo = UserProfile(
                            id: context.read<SignInCubit>().userProfile.id,
                            firstName: fNameController.text,
                            lastName: lNameController.text,
                            phone: phoneController.text,
                            address: addressController.text,
                            email: email,
                            gender: genderController.text,
                            maritalStatus: maritalStatusController.text,
                            preferLanguage: preferLangController.text,
                            avatarUrl: avatarUrl,
                            channels: channels,
                          );
                          context
                              .read<SignInCubit>()
                              .updateCurrentUserInfo(newUserInfo);
                          context.read<SignInCubit>().avatarUrl = avatarUrl;
                          context.read<SignInCubit>().email = email;
                          setState(() {
                            isSaveVisible = true;
                          });
                          Navigator.popAndPushNamed(
                              context, UsersScreen.routeName);
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 24, vertical: 16),
                          decoration: BoxDecoration(
                              color: Color(0xFF7F48FB),
                              borderRadius: BorderRadius.circular(100)),
                          child: Text(
                            'Save',
                            style: AllStyles.font15w500white,
                          ),
                          alignment: Alignment.center,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        });
  }

  void imagePickerBottomSheet(UserProfile userInfo) {
    showModalBottomSheet(
        context: context,
        barrierColor: Colors.black.withOpacity(0.8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20.0),
            topRight: Radius.circular(20.0),
          ),
        ),
        builder: (BuildContext context) {
          return Container(
            height: 166,
            padding: EdgeInsets.only(top: 8, left: 24, right: 24),
            child: Column(
              children: [
                modalSheetDivider(),
                const SizedBox(height: 24.0),
                GestureDetector(
                  onTap: () async {
                    PickedFile? pickedFile = await ImagePicker().getImage(
                      source: ImageSource.camera,
                      maxWidth: 400,
                      maxHeight: 400,
                    );
                    if (pickedFile != null) {
                      Navigator.pop(context);
                      uploadFile(pickedFile.path, userInfo.id);
                    }
                  },
                  child: Row(
                    children: [
                      SvgPicture.asset('assets/icons/camera.svg'),
                      const SizedBox(width: 18),
                      Text(
                        'Take a Photo',
                        style: AllStyles.font15w500darkGray,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),
                GestureDetector(
                  onTap: () async {
                    PickedFile? pickedFile = await ImagePicker().getImage(
                      source: ImageSource.gallery,
                      maxWidth: 400,
                      maxHeight: 400,
                      preferredCameraDevice: CameraDevice.front,
                    );
                    if (pickedFile != null) {
                      try {
                        Navigator.pop(context);
                        uploadFile(pickedFile.path, userInfo.id);
                      } on FirebaseException catch (e) {
                        // e.g, e.code == 'canceled'
                        print(e);
                      }
                    }
                  },
                  child: Row(
                    children: [
                      SvgPicture.asset('assets/icons/library.svg'),
                      const SizedBox(width: 18),
                      Text(
                        'Choose from Library',
                        style: AllStyles.font15w500darkGray,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        });
  }

  Future<void> validateAndSave() async {
    {
      if (_formKey.currentState!.validate()) {
        setState(() {
          isSaveVisible = false;
        });
        showSaveBottomSheet();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    UserProfile userInfo = context.read<SignInCubit>().userProfile;

    //if (isFirstBuild) {
    fNameController.text = userInfo.firstName;
    lNameController.text = userInfo.lastName;
    phoneController.text = userInfo.phone;
    addressController.text = userInfo.address;
    genderController.text = userInfo.gender;
    maritalStatusController.text = userInfo.maritalStatus;
    preferLangController.text = userInfo.preferLanguage;
    avatarUrl = userInfo.avatarUrl;
    email = userInfo.email;
    //isFirstBuild = false;
    //}
    return Scaffold(
      appBar: ProfileAppBar(
          validate: validateAndSave, isSaveVisible: isSaveVisible),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.only(left: 25, right: 22),
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.only(top: 24),
                child: Center(
                  child: GestureDetector(
                    onTap: () => imagePickerBottomSheet(userInfo),
                    child: avatarUrl != ''
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(36),
                            child: Container(
                              width: 72,
                              height: 72,
                              color: Colors.white54,
                              child: Image.network(avatarUrl),
                            ),
                          )
                        : Container(
                            padding: const EdgeInsets.all(24),
                            width: 72,
                            height: 72,
                            decoration: BoxDecoration(
                              color: Color(0xFFF2F2F2),
                              borderRadius: BorderRadius.circular(36),
                            ),
                            child: Container(
                              child:
                                  SvgPicture.asset('assets/icons/camera.svg'),
                              width: 24,
                              height: 24,
                            ),
                          ),
                  ),
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.only(left: 25, right: 22, top: 48),
              child: Column(
                children: [
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Flexible(
                              child: Container(
                                height: 42,
                                child: TextFormField(
                                  controller: fNameController,
                                  style: AllStyles.font15w500darkGray,
                                  cursorColor: AllColors.darkGray,
                                  decoration: AllStyles.myProfileInputDecoration
                                      .copyWith(hintText: 'First Name'),
                                  validator: (v) {
                                    if (v!.isNotEmpty) {
                                      return null;
                                    } else {
                                      return 'Please enter a first name';
                                    }
                                  },
                                ),
                              ),
                            ),
                            const SizedBox(width: 24),
                            Flexible(
                              child: Container(
                                height: 42,
                                child: TextFormField(
                                  controller: lNameController,
                                  style: AllStyles.font15w500darkGray,
                                  cursorColor: AllColors.darkGray,
                                  decoration: AllStyles.myProfileInputDecoration
                                      .copyWith(hintText: 'Last Name'),
                                  validator: (v) {
                                    if (v!.isNotEmpty) {
                                      return null;
                                    } else {
                                      return 'Please enter a last name';
                                    }
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 40),
                        Container(
                          height: 42,
                          child: TextFormField(
                            controller: phoneController,
                            keyboardType: TextInputType.phone,
                            cursorRadius: Radius.circular(2.0),
                            style: AllStyles.font15w500darkGray,
                            cursorColor: AllColors.darkGray,
                            decoration: AllStyles.myProfileInputDecoration
                                .copyWith(hintText: 'Phone'),
                            validator: (v) {
                              if (v!.isNotEmpty) {
                                return null;
                              } else {
                                return 'Please enter a phone number';
                              }
                            },
                          ),
                        ),
                        const SizedBox(height: 40),
                        Container(
                          height: 42,
                          child: TextFormField(
                            controller: addressController,
                            style: AllStyles.font15w500darkGray,
                            cursorColor: AllColors.darkGray,
                            decoration: AllStyles.myProfileInputDecoration
                                .copyWith(hintText: 'Address'),
                            validator: (v) {
                              if (v!.isNotEmpty) {
                                return null;
                              } else {
                                return 'Please enter an address';
                              }
                            },
                          ),
                        ),
                        const SizedBox(height: 32),
                        Container(
                          height: 42,
                          child: TextFormField(
                            controller: genderController,
                            style: AllStyles.font15w500darkGray,
                            cursorColor: AllColors.darkGray,
                            decoration: AllStyles.myProfileInputDecoration
                                .copyWith(hintText: 'Gender'),
                            validator: (v) {
                              if (v!.isNotEmpty) {
                                return null;
                              } else {
                                return 'Please enter a gender';
                              }
                            },
                          ),
                        ),
                        SizedBox(height: 40),
                        Container(
                          height: 42,
                          child: TextFormField(
                            controller: maritalStatusController,
                            style: AllStyles.font15w500darkGray,
                            cursorColor: AllColors.darkGray,
                            decoration: AllStyles.myProfileInputDecoration
                                .copyWith(hintText: 'Marital Status'),
                            validator: (v) {
                              if (v!.isNotEmpty) {
                                return null;
                              } else {
                                return 'Please enter a marital status';
                              }
                            },
                          ),
                        ),
                        SizedBox(height: 40),
                        Container(
                          height: 42,
                          child: TextFormField(
                            controller: preferLangController,
                            style: AllStyles.font15w500darkGray,
                            cursorColor: AllColors.darkGray,
                            decoration: AllStyles.myProfileInputDecoration
                                .copyWith(hintText: 'Prefer Language'),
                            validator: (v) {
                              if (v!.isNotEmpty) {
                                return null;
                              } else {
                                return 'Please enter a prefer language';
                              }
                            },
                          ),
                        ),
                        SizedBox(height: 40),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      backgroundColor: Colors.white,
    );
  }
}

class ProfileAppBar extends StatelessWidget implements PreferredSizeWidget {
  final double appBarHeight = 44;

  final bool isSaveVisible;
  final Function validate;

  ProfileAppBar({required this.validate, required this.isSaveVisible});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 24.0,
          color: Colors.white,
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 24),
          height: 44.0,
          color: Colors.white,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                child: SvgPicture.asset('assets/icons/back.svg'),
                onTap: () => Navigator.pop(context),
              ),
              Text(
                'My Profile',
                style: AllStyles.font15w400black,
              ),
              isSaveVisible
                  ? GestureDetector(
                      onTap: () => validate(),
                      child: Text(
                        'Save',
                        style: AllStyles.font15w500purple,
                        textAlign: TextAlign.right,
                      ),
                    )
                  : Text(
                      'Save',
                      style: TextStyle(color: Colors.transparent),
                      textAlign: TextAlign.right,
                    ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(appBarHeight);
}
