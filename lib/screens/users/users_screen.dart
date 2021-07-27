import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_messenger/constants.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_messenger/cubit/sign_in/sign_in_cubit.dart';
import 'package:my_messenger/cubit/users/users_cubit.dart';
import 'package:my_messenger/models/user_profile.dart';
import 'package:my_messenger/screens/chat/chat_screen.dart';
import 'package:my_messenger/screens/profile/profile_screen.dart';

class UsersScreen extends StatelessWidget {
  static const routeName = '/users';

  @override
  Widget build(BuildContext context) {
    context.read<SignInCubit>().getCurrentUserInfo();
    return Scaffold(
      appBar: UsersAppBar(),
      body: UsersBody(),
      backgroundColor: Colors.white,
    );
  }
}

class UsersBody extends StatelessWidget {
  final List colors = [
    Colors.green,
    Colors.redAccent,
    Colors.lightBlue,
    Colors.pink,
    Colors.indigo,
    Colors.orange,
  ];

  final Random random = new Random();

  Color darken(Color color, [double amount = .1]) {
    assert(amount >= 0 && amount <= 1);

    final hsl = HSLColor.fromColor(color);
    final hslDark = hsl.withLightness((hsl.lightness - amount).clamp(0.0, 1.0));

    return hslDark.toColor();
  }

  @override
  Widget build(BuildContext context) {
    context.read<UsersCubit>().getUsers();
    return BlocBuilder<UsersCubit, UsersState>(
      builder: (context, state) {
        //print(state);
        if (state is UsersList) {
          //print(state.users.length);
          List<UserProfile> users = state.users;
          return SingleChildScrollView(
            child: RefreshIndicator(
              child: Container(
                height: MediaQuery.of(context).size.height,
                padding: EdgeInsets.only(top: 0),
                color: Colors.white,
                child: ListView.builder(
                    padding: EdgeInsets.symmetric(horizontal: 24.0),
                    shrinkWrap: true,
                    itemBuilder: (context, int index) {
                      Color currentColor = colors[index];
                      return GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(context, ChatScreen.routeName,
                              arguments: users[index].id);
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                color: AllColors.lightGray,
                                width: 1.0,
                              ),
                            ),
                          ),
                          height: 104,
                          child: Row(
                            children: [
                              ClipRRect(
                                child: users[index].avatarUrl.isEmpty
                                    ? Container(
                                        width: 56,
                                        height: 56,
                                        child: Center(
                                          child: Text(
                                            '${users[index].firstName.substring(0, 1)}${users[index].lastName.substring(0, 1)}',
                                            style: TextStyle(
                                              color: darken(currentColor),
                                              fontSize: 14,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ),
                                        color: currentColor.withOpacity(0.4),
                                      )
                                    : Container(
                                        width: 56,
                                        height: 56,
                                        child: Image.network(
                                            users[index].avatarUrl),
                                      ),
                                borderRadius: BorderRadius.circular(28.0),
                              ),
                              SizedBox(width: 24.0),
                              Container(
                                padding: EdgeInsets.only(top: 23),
                                child: Text(
                                  '${users[index].firstName} ${users[index].lastName}',
                                  style: AllStyles.font20w500darkGray,
                                ),
                                alignment: Alignment.topLeft,
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                    itemCount: users.length),
              ),
              onRefresh: () async {
                context.read<UsersCubit>().getUsers();
              },
              color: Colors.black,
            ),
          );
        } else {
          return Container();
        }
      },
    );
  }
}

class UsersAppBar extends StatelessWidget implements PreferredSizeWidget {
  final double appBarHeight = 68;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 44,
          color: Colors.white,
        ),
        Container(
          padding: EdgeInsets.only(left: 28, right: 19),
          height: 44.0,
          color: Colors.white,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: () => showAlertDialog(context),
                child: Text(
                  'Log out',
                  style: AllStyles.font15w400black,
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, ProfileScreen.routeName);
                },
                child: Text(
                  'My Profile',
                  style: AllStyles.font15w400black,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void showAlertDialog(BuildContext context) {
    // set up the buttons
    Widget cancelButton = TextButton(
      child: Text(
        "No",
        style: AllStyles.font15w500darkGray,
      ),
      onPressed: () {
        Navigator.pop(context);
      },
    );
    Widget yesButton = TextButton(
      child: Text(
        "Yes",
        style: AllStyles.font15w500darkGray,
      ),
      onPressed: () {
        Navigator.pop(context);
        context.read<SignInCubit>().logOut();
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Warning"),
      content: Text(
        "Would you like to Log out?",
        style: AllStyles.font15w500darkGray,
      ),
      actions: [
        yesButton,
        cancelButton,
      ],
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(appBarHeight);
}
