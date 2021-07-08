import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:my_messenger/constants.dart';
import 'package:my_messenger/data/chat_repository.dart';
part 'chat_state.dart';

class ChatCubit extends Cubit<ChatState> {
  ChatCubit() : super(ChatInitial());

  String userId = FirebaseAuth.instance.currentUser!.uid;
  String partnerId = '';
  String channelId = '';
  List<String> currentUsers = [];
  var chatRepo = ChatRepository();

  void setPartnerId({required String partnerId}) async {
    emit(ChatInfo(''));
    currentUsers = [userId, partnerId];
    this.partnerId = partnerId;
    await getChannelId();
    emit(ChatInfo(channelId));
  }

  Future<String> getChannelId() async {
    channelId = chatRepo.getChannelId(currentUsers: currentUsers);
    return channelId;
  }

  // void createChatCollections() {
  //   chatRepo.createChatCollections(
  //       channelId: channelId, userId: userId, currentUsers: currentUsers);
  // }

  void sendMessage({
    required String content,
    required MessageContentType contentType,
    Map<String, String>? metaData,
  }) async {
    chatRepo.addMessage(
      content: content,
      channelId: channelId,
      contentType: contentType.index,
      currentUsers: currentUsers,
      metaData: metaData,
    );
  }
}
