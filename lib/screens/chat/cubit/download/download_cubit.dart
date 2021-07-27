import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:meta/meta.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

part 'download_state.dart';

class DownloadCubit extends Cubit<DownloadState> {
  DownloadCubit() : super(DownloadInitial());

  late DownloadTask task;
  Map<String, String> fileInfo = {};
  String localPath = '';
  late File file;

  Future<bool> _getStoragePermission() async {
    if (await Permission.storage.request().isGranted) {
      return true;
    } else {
      return false;
    }
  }

  void cancelDownload() async {
    await task.cancel();
    file.delete();
    emit(DownloadInitial());
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

  void downloadURL({
    required String url,
    required String filename,
  }) async {
    final isPermissionStatusGranted = await _getStoragePermission();

    if (isPermissionStatusGranted) {
      var downloadsDirectory = await _getDownloadsDirectory();

      localPath = '$downloadsDirectory/My-Messenger-Cache-Files/$filename';
      file = File(localPath);
      print(localPath);

      try {
        Reference tst = FirebaseStorage.instance.refFromURL(url);
        Reference storageRef = FirebaseStorage.instance.ref(tst.fullPath);

        task = storageRef.writeToFile(file);

        task.snapshotEvents.listen((TaskSnapshot snapshot) async {
          if (snapshot.state == TaskState.running) {
            double percent = snapshot.bytesTransferred / snapshot.totalBytes;
            emit(DownloadInProgress(percent > 0 ? percent : 0));
          } else if (snapshot.state == TaskState.success) {
            url = await snapshot.ref.getDownloadURL();
            var uploadedMetadata = await snapshot.ref.getMetadata();
            fileInfo.addAll({
              'size': uploadedMetadata.size.toString(),
              'url': url,
              'name': filename,
              'filePath': localPath
            });
            emit(DownloadFinished(localPath));
          } else {
            //emit(ChatInfo(channelId));
          }
        });
      } catch (e) {
        print(e);
      }
    } else {
      throw 'Permission not granted!';
    }
  }
}
