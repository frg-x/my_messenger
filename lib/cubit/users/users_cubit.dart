import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:my_messenger/data/users_repository.dart';
import 'package:my_messenger/models/user_profile.dart';

part 'users_state.dart';

class UsersCubit extends Cubit<UsersState> {
  UsersCubit(this.users) : super(UsersInitial());

  var fireStore = UsersRepository();

  List<UserProfile> users;

  Future<void> getUsers() async {
    users = [];
    users = await fireStore.getUsers();
    emit(UsersList(users));
  }
}
