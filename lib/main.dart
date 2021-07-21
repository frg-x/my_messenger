import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:my_messenger/cubit/messages/chat_cubit.dart';
import 'package:my_messenger/cubit/sign_in/sign_in_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_messenger/cubit/users/users_cubit.dart';
import 'package:my_messenger/screens/chat/chat_screen.dart';
import 'package:my_messenger/screens/login/login_screen.dart';
import 'package:my_messenger/screens/profile/profile_screen.dart';
import 'package:my_messenger/screens/users/users_screen.dart';
import 'package:my_messenger/screens/verify_user.dart';

void main() async {
  //print('void main');
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp, /*DeviceOrientation.portraitDown*/
  ]).then((_) => runApp(MyApp()));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //print('Started app');
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => SignInCubit()),
        BlocProvider(create: (context) => UsersCubit([])),
        BlocProvider(create: (context) => ChatCubit()),
      ],
      child: MaterialApp(
        theme: ThemeData(
          fontFamily: 'Inter',
        ),
        debugShowCheckedModeBanner: false,
        home: VerifyUser(),
        routes: {
          UsersScreen.routeName: (context) => UsersScreen(),
          LoginScreen.routeName: (context) => LoginScreen(),
          ProfileScreen.routeName: (context) => ProfileScreen(),
          ChatScreen.routeName: (context) => ChatScreen(),
        },
      ),
    );
  }
}
