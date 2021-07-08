import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_messenger/cubit/sign_in/sign_in_cubit.dart';
import 'package:my_messenger/screens/login/login_screen.dart';
import 'package:my_messenger/screens/users/users_screen.dart';

class VerifyUser extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    context.read<SignInCubit>().checkCurrentUserStatus();
    return BlocBuilder<SignInCubit, SignInState>(
      builder: (context, state) {
        //print(state);
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
  }
}
