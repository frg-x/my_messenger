part of 'chat_cubit.dart';

@immutable
abstract class ChatState {}

class ChatInitial extends ChatState {}

class ChatInfo extends ChatState {
  ChatInfo(this.channelId);
  final String channelId;
}
