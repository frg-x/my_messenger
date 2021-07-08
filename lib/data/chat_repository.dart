import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:my_messenger/constants.dart';
import 'package:uuid/uuid.dart';

class ChatRepository {
  // String get _generateNewChannelId {
  //   return Uuid().v4();
  // }

  // Future<String> getChannelId({required List currentUsers}) async {
  //   try {
  //     var channelSnapshot = await FirebaseFirestore.instance.collection('messages').get();
  //     print(channelSnapshot.docs);
  //     //int channelDocsLength = await channelSnapshot.length;
  //     //channelSnapshot.forEach((element) {
  //     //  print(element.docs);
  //     //});
  //     return '12345';
  //     // if (channelDocsLength != 0) {
  //     //   return channelSnapshot.docs.first.id;
  //     // } else {
  //     //   return _generateNewChannelId;
  //     // }
  //   } catch (e) {
  //     print(e);
  //     return '';
  //   }
  // }

  String getChannelId({required List<String> currentUsers}) {
    if (currentUsers[0].hashCode <= currentUsers[1].hashCode) {
      return (currentUsers[1].hashCode - currentUsers[0].hashCode).toString();
    } else {
      return (currentUsers[0].hashCode - currentUsers[1].hashCode).toString();
    }
  }

  // void createChatCollections({
  //   required String channelId,
  //   required String userId,
  //   required List currentUsers,
  // }) async {
  //   try {
  //     await FirebaseFirestore.instance.collection('messages').add({'users': currentUsers});
  //   } catch (e) {
  //     print(e);
  //   }
  // }

  Future<dynamic> getFileMetadata(String url) async {
    return await FirebaseStorage.instance.refFromURL(url).getMetadata();
  }

  void addMessage({
    required String content,
    required int contentType,
    required String channelId,
    required List currentUsers,
    Map<String, String>? metaData,
  }) async {
    var timestamp = FieldValue.serverTimestamp();

    await FirebaseFirestore.instance
        .collection('messages')
        .doc(channelId)
        .collection(channelId)
        .doc()
        .set({
      'content': content,
      'type': contentType,
      'timestamp': timestamp,
      'idFrom': currentUsers[0],
      'idTo': currentUsers[1],
      'metadata': metaData ?? {},
    });
  }
}
