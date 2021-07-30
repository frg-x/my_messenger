part of 'chat_cubit.dart';

@immutable
abstract class ChatState {}

class ChatInitial extends ChatState {}

class ChatInfo extends ChatState {
  ChatInfo(this.channelId);
  final String channelId;
}

class UploadInProgress extends ChatState {
  UploadInProgress(this.percent, this.fileName);
  final double percent;
  final String fileName;
}

class UploadFinished extends ChatState {
  UploadFinished(this.fileInfo, this.channelId);
  final Map<String, dynamic> fileInfo;
  final String channelId;
}

class UploadCancelled extends ChatState {}

class UploadError extends ChatState {
  UploadError(this.fileName);
  final String fileName;
}
