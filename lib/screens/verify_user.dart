import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_messenger/cubit/sign_in/sign_in_cubit.dart';
import 'package:my_messenger/screens/login/login_screen.dart';
import 'package:my_messenger/screens/users/users_screen.dart';

class VerifyUser extends StatefulWidget {
  @override
  _VerifyUserState createState() => _VerifyUserState();
}

class _VerifyUserState extends State<VerifyUser> {
  @override
  Widget build(BuildContext context) {
    context.read<SignInCubit>().checkCurrentUserStatus();
    return StreamBuilder<Object>(
        stream: context.read<SignInCubit>().checkConnectionStatus(),
        builder: (context, snapshot) {
          //print(snapshot.data);
          if (snapshot.hasData) {
            //context.read<SignInCubit>().isConnected = snapshot.data as bool;
            if (snapshot.data as bool) {
              return BlocBuilder<SignInCubit, SignInState>(
                builder: (context, state) {
                  if (state is LoggedOut) {
                    return LoginScreen();
                  } else if (state is SignedIn) {
                    return UsersScreen();
                  } else {
                    return Center(
                      child: CircularProgressIndicator(color: Colors.white),
                    );
                  }
                },
              );
            } else {
              return Scaffold(
                body: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.error),
                      Text('Not connected to internet'),
                    ],
                  ),
                ),
              );
            }
          } else {
            return Center(
              child: CircularProgressIndicator(color: Colors.white),
            );
          }
        });
  }
}
