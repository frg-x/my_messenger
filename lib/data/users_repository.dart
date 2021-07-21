import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:my_messenger/models/user_profile.dart';

class UsersRepository {
  var fireStore = FirebaseFirestore.instance;
  final auth = FirebaseAuth.instance;

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

  void addUser(User user) {
    fireStore.collection('users').doc(user.uid).set({
      'id': user.uid,
      'firstName': '',
      'lastName': '',
      'phone': '',
      'address': '',
      'email': user.email,
      'gender': '',
      'maritalStatus': '',
      'preferLanguage': '',
      'avatarUrl': '',
    });
  }

  Future<List<UserProfile>> getUsers() async {
    List<UserProfile> usersList = [];
    QuerySnapshot querySnapshot =
        await fireStore.collection('users').where('id', isNotEqualTo: auth.currentUser!.uid).get();
    querySnapshot.docs.forEach((item) {
      var userData = item.data() as Map<String, dynamic>;
      UserProfile user = UserProfile.fromJson(userData);
      usersList.add(user);
    });
    return usersList;
  }

  Future<UserProfile> getCurrentUserInfo() async {
    await fireStore
        .collection('users')
        .where('id', isEqualTo: auth.currentUser!.uid)
        .get()
        .then((querySnapshot) {
      userProfile = UserProfile.fromJson(querySnapshot.docs.first.data());
    });

    return userProfile;
  }

  Future<void> updateUserInfo(UserProfile newUserinfo) async {
    userProfile = newUserinfo;
    await fireStore.collection('users').doc(newUserinfo.id).update(newUserinfo.toJson());
  }

  void logOut() {
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
    auth.signOut();
  }
}
