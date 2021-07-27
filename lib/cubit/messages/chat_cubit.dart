import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:my_messenger/constants.dart';
import 'package:my_messenger/data/chat_repository.dart';
import 'package:native_pdf_renderer/native_pdf_renderer.dart';
import 'package:path_provider/path_provider.dart';
part 'chat_state.dart';

class ChatCubit extends Cubit<ChatState> {
  ChatCubit() : super(ChatInitial());

  FirebaseStorage storage = FirebaseStorage.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  String userId = FirebaseAuth.instance.currentUser!.uid;
  String partnerId = '';
  String channelId = '';
  List<String> currentUsers = [];
  var chatRepo = ChatRepository();
  var pageImage;

  String downloadsDir = '';
  bool isFileUploading = false;

  Future<String> _getDownloadsDirectory() async {
    var downloadsDirectory;
    if (Platform.isIOS) {
      downloadsDirectory = await getApplicationDocumentsDirectory();
      return downloadsDirectory.path;
    } else {
      downloadsDirectory = '/storage/emulated/0';
      return downloadsDirectory;
    }
  }

  void checkDownloadsDir() async {
    downloadsDir = await _getDownloadsDirectory();
  }

  String getDownloadsDir() {
    //print(downloadsDir);
    return downloadsDir;
  }

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

  late UploadTask task;

  Map<String, String> pickedFileInfo = {};
  Map<String, String> fileInfo = {};
  late String url;
  String fileName = '';
  String filePath = '';
  late String extension;
  late MessageContentType attachmentType;

  void pickAndUpload({
    required String channelId,
    required MessageContentType attachmentType,
  }) async {
    var pickedFile;

    fileName = '';

    if (attachmentType == MessageContentType.file) {
      pickedFile = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'doc', 'xlsx', 'xls', 'docx'],
      );
    } else if (attachmentType == MessageContentType.media) {
      pickedFile = await FilePicker.platform.pickFiles(type: FileType.media);
    } else {
      pickedFile = await FilePicker.platform.pickFiles(type: FileType.any);
    }

    if (pickedFile != null) {
      filePath = pickedFile.files.first.path!;
      fileName = pickedFile.files.first.name;
      extension = pickedFile.files.first.extension!;
      this.attachmentType = attachmentType;
    } else
      return;

    File file = File(filePath);
    final cachedFilesDir = '$downloadsDir/My-Messenger-Cache-Files';
    final checkDirExistence = await Directory(cachedFilesDir).exists();
    if (!checkDirExistence) {
      Directory(cachedFilesDir).create().then((_) {
        file.copy('$cachedFilesDir/$fileName');
      });
    } else {
      file.copy('$cachedFilesDir/$fileName');
    }

    //print('$cachedFilesDir/$fileName');

    Reference storageRef =
        FirebaseStorage.instance.ref('messages/$channelId/$fileName');

    try {
      isFileUploading = true;
      task = storageRef.putFile(file);

      task.snapshotEvents.listen((TaskSnapshot snapshot) async {
        if (snapshot.state == TaskState.running) {
          emit(UploadInProgress(
              snapshot.bytesTransferred / snapshot.totalBytes, fileName));
        } else if (snapshot.state == TaskState.success) {
          url = await snapshot.ref.getDownloadURL();
          var uploadedMetadata = await snapshot.ref.getMetadata();
          fileInfo.addAll({
            'size': uploadedMetadata.size.toString(),
            'url': url,
            'name': fileName
            //'filePath': filePath
          });
          emit(UploadFinished(fileInfo, channelId));
          isFileUploading = false;
        } else {
          emit(ChatInfo(channelId));
        }
      });
    } on FirebaseException catch (e) {
      print(e);
    }
  }

  void sendFile({
    required String content,
  }) async {
    chatRepo.addMessage(
      content: content,
      channelId: channelId,
      contentType: attachmentType.index,
      currentUsers: currentUsers,
      metaData: fileInfo,
    );
  }

  void cancelUploading() async {
    if (task.snapshot.state == TaskState.running) {
      await task.cancel();
      emit(UploadCancelled());
    }
  }
}
