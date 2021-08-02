import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:my_messenger/constants.dart';
import 'package:my_messenger/screens/chat/cubit/download/download_cubit.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

bool isFileExists(String fullPath) {
  File file = File(fullPath);
  return file.existsSync() ? true : false;
}

Widget chatDownloadIcon({
  required BuildContext context,
  required DownloadState state,
  required String size,
  required String filename,
  required String downloadsDir,
  required bool isMe,
}) {
  String fullPath = '';

  fullPath = '$downloadsDir/$filename';

  if (state is DownloadInitial) {
    if (isFileExists(fullPath)) {
      return SvgPicture.asset(
        isMe
            ? 'assets/icons/doc_downloaded_my.svg'
            : 'assets/icons/doc_downloaded_not_my.svg',
      );
    } else {
      return SvgPicture.asset(isMe
          ? 'assets/icons/doc_to_download_my.svg'
          : 'assets/icons/doc_to_download_my_not.svg');
    }
  } else if (state is DownloadInProgress) {
    return isMe
        ? CircularPercentIndicator(
            radius: 32,
            percent: state.percent,
            backgroundColor: AllColors.lightPurple,
            progressColor: AllColors.white,
            lineWidth: 2.0,
            center: Icon(
              Icons.close,
              color: AllColors.white,
              size: 20,
            ),
          )
        : CircularPercentIndicator(
            radius: 32,
            percent: state.percent,
            backgroundColor: AllColors.lightGray,
            progressColor: AllColors.purple,
            lineWidth: 2.0,
            center: Icon(
              Icons.close,
              color: AllColors.purple,
              size: 20,
            ),
          );
  } else if (state is DownloadFinished) {
    return SvgPicture.asset(isMe
        ? 'assets/icons/doc_downloaded_my.svg'
        : 'assets/icons/doc_downloaded_not_my.svg');
  } else {
    return SvgPicture.asset(isMe
        ? 'assets/icons/doc_to_download_my.svg'
        : 'assets/icons/doc_to_download_my_not.svg');
  }
}
