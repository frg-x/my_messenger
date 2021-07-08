import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:my_messenger/data/users_repository.dart';
import 'package:my_messenger/models/user_profile.dart';

part 'sign_in_state.dart';

class SignInCubit extends Cubit<SignInState> {
  SignInCubit() : super(SignInInitial());

  late User? user;
  final auth = FirebaseAuth.instance;
  bool isLogged = false;
  var firebase = UsersRepository();
  UserProfile userProfile = UserProfile(
    id: '',
    firstName: '',
    lastName: '',
    phone: '',
    address: '',
    email: '',
    gender: '',
    maritalStatus: '',
    preferLanguage: '',
    avatarUrl: '',
  );

  String avatarUrl = '';
  String email = '';

  List<UserProfile> users = [];

  void createAccount(String email, String password) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      user = userCredential.user!;
      firebase.addUser(user!);
      checkCurrentUserStatus();
      getCurrentUserInfo();
      emit(SignedIn());
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        emit(LoggedOut('The password provided is too weak.'));
        //print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        emit(LoggedOut('The account already exists for that email.'));
        //print('The account already exists for that email.');
      }
    } catch (e) {
      print(e);
    }
  }

  void signInWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password);
      user = userCredential.user!;
      emit(SignedIn());
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        emit(LoggedOut('No user found for that email.'));
        //print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        emit(LoggedOut('Wrong password provided for that user.'));
        //print('Wrong password provided for that user.');
      }
    } catch (e) {
      print(e);
    }
  }

  void checkCurrentUserStatus() {
    auth.authStateChanges().listen((currentUser) {
      if (currentUser == null) {
        isLogged = false;
        emit(LoggedOut(''));
      } else {
        user = currentUser;
        isLogged = true;
        emit(SignedIn());
      }
    });
  }

  void getCurrentUserInfo() async {
    userProfile = await firebase.getCurrentUserInfo();
    //print(userProfile.email);
    //print(userProfile.email);
  }

  Future<void> updateCurrentUserInfo(UserProfile newUserInfo) async {
    await firebase.updateUserInfo(newUserInfo);
    userProfile = await firebase.getCurrentUserInfo();
    //userProfile = newUserInfo;
  }

  void logOut() {
    user = null;
    isLogged = false;
    userProfile = UserProfile(
      id: '',
      firstName: '',
      lastName: '',
      phone: '',
      address: '',
      email: '',
      gender: '',
      maritalStatus: '',
      preferLanguage: '',
      avatarUrl: '',
    );
    avatarUrl = '';
    email = '';
    emit(LoggedOut(''));
    firebase.logOut();
  }
}
