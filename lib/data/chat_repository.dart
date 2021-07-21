import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class ChatRepository {
  FirebaseStorage storage = FirebaseStorage.instance;
  CollectionReference messages = FirebaseFirestore.instance.collection('messages');

  String getChannelId({required List<String> currentUsers}) {
    if (currentUsers[0].hashCode <= currentUsers[1].hashCode) {
      return (currentUsers[1].hashCode - currentUsers[0].hashCode).toString();
    } else {
      return (currentUsers[0].hashCode - currentUsers[1].hashCode).toString();
    }
  }

  Future<dynamic> getFileMetadata(String url) async {
    return await storage.refFromURL(url).getMetadata();
  }

  void addMessage({
    required String content,
    required int contentType,
    required String channelId,
    required List currentUsers,
    Map<String, String>? metaData,
  }) async {
    var timestamp = FieldValue.serverTimestamp();

    messages.doc(channelId).collection(channelId).add({
      'content': content,
      'type': contentType,
      'timestamp': timestamp,
      'idFrom': currentUsers[0],
      'idTo': currentUsers[1],
      'metadata': metaData ?? {},
    });
  }
}
