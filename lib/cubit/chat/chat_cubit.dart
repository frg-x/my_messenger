import 'dart:async';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:my_messenger/constants.dart';
import 'package:my_messenger/data/chat_repository.dart';
import 'package:path_provider/path_provider.dart';
part 'chat_state.dart';

class ChatCubit extends Cubit<ChatState> {
  ChatCubit() : super(ChatInitial());

  FirebaseStorage cloudStorage = FirebaseStorage.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  String userId = FirebaseAuth.instance.currentUser!.uid;
  String partnerId = '';
  String channelId = '';
  List<String> currentUsers = [];
  var chatRepo = ChatRepository();
  var pageImage;
  late UploadTask task;
  var pickedFile;

  Map<String, String> pickedFileInfo = {};
  Map<String, String> fileInfo = {};
  late String url;
  String fileName = '';
  String filePath = '';
  late String extension;
  late MessageContentType attachmentType;

  String downloadsDir = '';

  void cloudStorageInit() {
    cloudStorage.setMaxUploadRetryTime(Duration(seconds: 5));
    cloudStorage.setMaxDownloadRetryTime(Duration(seconds: 5));
    cloudStorage.setMaxOperationRetryTime(Duration(seconds: 5));
  }

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

  String getPDFCache() {
    if (Platform.isIOS) {
      return '$downloadsDir/pdf_cache';
    } else {
      return '$downloadsDir/My Messenger/pdf_cache';
    }
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

  void pickAndUpload({
    required MessageContentType attachmentType,
  }) async {
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
    final cachedFilesDir = '$downloadsDir';
    final checkDirExistence = await Directory(cachedFilesDir).exists();
    if (!checkDirExistence) {
      Directory(cachedFilesDir).create().then((_) {
        file.copy('$cachedFilesDir/$fileName');
      });
    } else {
      file.copy('$cachedFilesDir/$fileName');
    }

    cloudStorageInit();
    Reference storageRef = cloudStorage.ref('messages/$channelId/$fileName');
    bool? hasConnection = await _hasConnection();
    task = storageRef.putFile(file);

    if (!hasConnection) {
      emit(UploadError(fileName));
      return;
    }
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
        });
        emit(UploadFinished(fileInfo, channelId));
      } else if (snapshot.state == TaskState.error) {
        emit(ChatInfo(channelId));
      } else {
        emit(ChatInfo(channelId));
      }
    }).onError((e) {
      if (!hasConnection) {
        emit(UploadError(fileName));
        throw Exception('You\'re not connected to internet!');
      } else {
        emit(UploadCancelled());
      }
    });
  }

  void resendFile() async {
    cloudStorageInit();

    Reference storageRef = cloudStorage.ref('messages/$channelId/$fileName');

    File file = File(filePath);

    bool? hasConnection = await _hasConnection();

    task = storageRef.putFile(file);

    if (!hasConnection) {
      emit(UploadError(fileName));
      return;
    }

    task.snapshotEvents.listen((TaskSnapshot snapshot) async {
      if (snapshot.state == TaskState.running) {
        emit(UploadInProgress(
            snapshot.bytesTransferred / snapshot.totalBytes, fileName));
        //throw Exception('Error');
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
      } else if (snapshot.state == TaskState.error) {
        emit(UploadError(fileName));
      } else {
        emit(ChatInfo(channelId));
      }
    }).onError((e) {
      if (!hasConnection) {
        emit(UploadError(fileName));
        throw Exception('You\'re not connected to internet!');
      } else {
        emit(UploadCancelled());
      }
    });
  }

  void deleteFailedMessage() {
    emit(ChatInfo(channelId));
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

  Future<bool> _hasConnection() async {
    try {
      var request = await http
          .get(Uri.parse('https://api.ipify.org/?format=json'))
          .timeout(const Duration(seconds: 2));
      if (request.statusCode == 200) {
        return true;
      }
    } on TimeoutException catch (e) {
      print('Timeout Error: $e');
      return false;
    } on SocketException catch (e) {
      print('Socket Error: $e');
      return false;
    } on Error catch (e) {
      print('General Error: $e');
      return false;
    }
    return false;
  }
}
