part of 'sign_in_cubit.dart';

@immutable
abstract class SignInState {}

class SignInInitial extends SignInState {}

class SignedIn extends SignInState {}

class LoggedOut extends SignInState {
  final String errorText;
  LoggedOut(this.errorText);
}
//
// class AuthError extends SignInState {
//   final String message;
//   AuthError(this.message);
// }
