import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:my_messenger/cubit/messages/chat_cubit.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

Widget chatUploadIcon({
  required ChatState state,
  required String size,
  required String filename,
}) {
  if (state is UploadInProgress) {
    return CircularPercentIndicator(
      radius: 32,
      percent: state.percent,
      backgroundColor: Color(0xFFB291FD),
      progressColor: Color(0xFFFFFFFF),
      lineWidth: 2.0,
      center: Icon(
        Icons.close,
        color: Color(0xFFFFFFFF),
        size: 20,
      ),
    );
  } else {
    return SvgPicture.asset('assets/icons/doc_downloaded_my.svg');
  }
}
