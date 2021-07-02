part of 'users_cubit.dart';

@immutable
abstract class UsersState {}

class UsersInitial extends UsersState {}

class UsersList extends UsersInitial {
  final List<UserProfile> users;
  UsersList(this.users);
}
