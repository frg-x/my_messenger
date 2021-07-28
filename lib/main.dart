import 'dart:async';

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
import 'package:connectivity_plus/connectivity_plus.dart';

void main() async {
  //print('void main');
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp, /*DeviceOrientation.portraitDown*/
  ]).then((_) => runApp(MyApp()));
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  ConnectivityResult _connectionStatus = ConnectivityResult.none;
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<ConnectivityResult> _connectivitySubscription;

  @override
  void initState() {
    initConnectivity();
    super.initState();
  }

  @override
  void dispose() {
    _connectivitySubscription.cancel();
    super.dispose();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initConnectivity() async {
    late ConnectivityResult result;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      result = await _connectivity.checkConnectivity();
    } on PlatformException catch (e) {
      print(e.toString());
      return;
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) {
      return Future.value(null);
    }

    return _updateConnectionStatus(result);
  }

  Future<void> _updateConnectionStatus(ConnectivityResult result) async {
    setState(() {
      _connectionStatus = result;
    });
  }

  @override
  Widget build(BuildContext context) {
    print(_connectionStatus.toString());
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
