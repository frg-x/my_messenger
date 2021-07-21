part of 'download_cubit.dart';

@immutable
abstract class DownloadState {}

class DownloadInitial extends DownloadState {}

class DownloadInProgress extends DownloadState {
  DownloadInProgress(this.percent);
  final double percent;
}

class DownloadFinished extends DownloadState {
  DownloadFinished(this.localPath);
  final String localPath;
}
