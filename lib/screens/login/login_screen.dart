import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_messenger/constants.dart';
import 'package:my_messenger/cubit/sign_in/sign_in_cubit.dart';
import 'package:my_messenger/screens/users/users_screen.dart';

enum screenMode {
  create,
  signIn,
}

class LoginScreen extends StatefulWidget {
  static const routeName = '/login';

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String _email = '';
  String _password = '';
  var initialScreen = screenMode.signIn;

  void validateAndCall(screenMode initialScreen) {
    bool emailValid = RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(_email);

    FocusScope.of(context).requestFocus(FocusNode());

    if (!emailValid) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Email not valid'),
        duration: Duration(seconds: 2),
      ));
      return;
    }

    if (_password == '') {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Password can not be empty'),
        duration: Duration(seconds: 2),
      ));
      return;
    }

    if (initialScreen == screenMode.create) {
      context.read<SignInCubit>().createAccount(_email, _password);
    } else {
      context.read<SignInCubit>().signInWithEmailAndPassword(_email, _password);
    }
  }

  @override
  Widget build(BuildContext context) {
    //print(MediaQuery.of(context).viewInsets.bottom);
    return BlocConsumer<SignInCubit, SignInState>(builder: (context, state) {
      if (state is LoggedOut) {
        return Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: Colors.white38,
          body: Container(
            padding: EdgeInsets.symmetric(horizontal: 36, vertical: 12),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('mY', style: AllStyles.font36w900white),
                    Text('MeSsEnGer', style: AllStyles.font28w900white),
                  ],
                ),
                SizedBox(height: 32),
                Column(
                  children: [
                    SizedBox(
                      height: 40,
                      child: TextField(
                        onChanged: (email) => _email = email,
                        style: TextStyle(fontSize: 16.0, color: Colors.black54),
                        decoration: AllStyles.signInInputDecoration.copyWith(
                          hintText: 'Enter your email',
                        ),
                      ),
                    ),
                    SizedBox(height: 16.0),
                    SizedBox(
                      height: 40,
                      child: TextField(
                        onChanged: (password) => _password = password,
                        obscureText: true,
                        style: TextStyle(fontSize: 16.0, color: Colors.black54),
                        decoration: AllStyles.signInInputDecoration.copyWith(
                          hintText: 'Enter your password',
                        ),
                      ),
                    ),
                    SizedBox(height: 16.0),
                    initialScreen == screenMode.create
                        ? Column(
                            children: [
                              ElevatedButton(
                                onPressed: () => validateAndCall(initialScreen),
                                child: Text(
                                  'Create Account',
                                  style: TextStyle(color: Colors.black54, fontSize: 16),
                                ),
                                style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all(Colors.white),
                                  padding: MaterialStateProperty.all(
                                    EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
                                  ),
                                ),
                              ),
                              TextButton(
                                style: ButtonStyle(
                                  overlayColor: MaterialStateColor.resolveWith(
                                      (states) => Colors.transparent),
                                ),
                                child: Text(
                                  'Sign In',
                                  style: TextStyle(
                                    color: Colors.white,
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                                onPressed: () {
                                  setState(() {
                                    initialScreen = screenMode.signIn;
                                  });
                                },
                              ),
                            ],
                          )
                        : Column(
                            children: [
                              ElevatedButton(
                                onPressed: () => validateAndCall(initialScreen),
                                child: Text(
                                  'Sign In',
                                  style: TextStyle(color: Colors.black54, fontSize: 16),
                                ),
                                style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all(Colors.white),
                                  padding: MaterialStateProperty.all(
                                    EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
                                  ),
                                ),
                              ),
                              TextButton(
                                style: ButtonStyle(
                                  overlayColor: MaterialStateColor.resolveWith(
                                      (states) => Colors.transparent),
                                ),
                                child: Text(
                                  'Create Account',
                                  style: TextStyle(
                                    color: Colors.white,
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                                onPressed: () {
                                  setState(() {
                                    initialScreen = screenMode.create;
                                  });
                                },
                              ),
                            ],
                          ),
                  ],
                ),
                SizedBox(
                  height: MediaQuery.of(context).viewInsets.bottom == 0
                      ? 0
                      : MediaQuery.of(context).viewInsets.bottom - 40,
                ),
              ],
            ),
          ),
        );
      } else {
        return UsersScreen();
      }
    }, listener: (context, state) {
      if (state is LoggedOut && state.errorText.isNotEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(state.errorText),
          duration: Duration(seconds: 2),
        ));
      }
    });
  }
}
//
// Scaffold(
// backgroundColor: Colors.white38,
// body: Container(
// padding: EdgeInsets.symmetric(horizontal: 36, vertical: 12),
// child: Column(
// mainAxisAlignment: MainAxisAlignment.center,
// children: [
// Column(
// mainAxisAlignment: MainAxisAlignment.center,
// children: [
// Text('mY', style: AllStyles.font48w900white),
// Text('MeSsEnGer', style: AllStyles.font36w900white),
// ],
// ),
// SizedBox(height: 32),
// Column(
// children: [
// TextField(
// onChanged: (email) => _email = email,
// style: TextStyle(fontSize: 16.0, color: Colors.black54),
// decoration: AllStyles.signInInputDecoration.copyWith(
// hintText: 'Enter your email',
// ),
// ),
// SizedBox(height: 16.0),
// TextField(
// onChanged: (password) => _password = password,
// obscureText: true,
// style: TextStyle(fontSize: 16.0, color: Colors.black54),
// decoration: AllStyles.signInInputDecoration.copyWith(
// hintText: 'Enter your password',
// ),
// ),
// SizedBox(height: 16.0),
// initialScreen == screenMode.create
// ? Column(
// children: [
// ElevatedButton(
// onPressed: () =>
// validateAndCall(initialScreen),
// child: Text(
// 'Create Account',
// style: TextStyle(
// color: Colors.black54, fontSize: 16),
// ),
// style: ButtonStyle(
// backgroundColor:
// MaterialStateProperty.all(Colors.white),
// padding: MaterialStateProperty.all(
// EdgeInsets.symmetric(
// horizontal: 12.0, vertical: 6.0),
// ),
// ),
// ),
// TextButton(
// style: ButtonStyle(
// overlayColor:
// MaterialStateColor.resolveWith(
// (states) => Colors.transparent),
// ),
// child: Text(
// 'Sign In',
// style: TextStyle(
// color: Colors.white,
// decoration: TextDecoration.underline,
// ),
// ),
// onPressed: () {
// setState(() {
// initialScreen = screenMode.signIn;
// });
// },
// ),
// ],
// )
// : Column(
// children: [
// ElevatedButton(
// onPressed: () =>
// validateAndCall(initialScreen),
// child: Text(
// 'Sign In',
// style: TextStyle(
// color: Colors.black54, fontSize: 16),
// ),
// style: ButtonStyle(
// backgroundColor:
// MaterialStateProperty.all(Colors.white),
// padding: MaterialStateProperty.all(
// EdgeInsets.symmetric(
// horizontal: 12.0, vertical: 6.0),
// ),
// ),
// ),
// TextButton(
// style: ButtonStyle(
// overlayColor:
// MaterialStateColor.resolveWith(
// (states) => Colors.transparent),
// ),
// child: Text(
// 'Create Account',
// style: TextStyle(
// color: Colors.white,
// decoration: TextDecoration.underline,
// ),
// ),
// onPressed: () {
// setState(() {
// initialScreen = screenMode.create;
// });
// },
// ),
// ],
// ),
// ],
// ),
// ],
// ),
// ),
// )
