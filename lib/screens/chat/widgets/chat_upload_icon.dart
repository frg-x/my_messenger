import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:my_messenger/constants.dart';
import 'package:my_messenger/cubit/chat/chat_cubit.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

Widget chatUploadIcon({required ChatState state}) {
  if (state is UploadInProgress) {
    return CircularPercentIndicator(
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
    );
  } else {
    return SvgPicture.asset('assets/icons/doc_downloaded_my.svg');
  }
}
