import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:my_messenger/constants.dart';
import 'package:my_messenger/cubit/chat/chat_cubit.dart';
import 'package:my_messenger/screens/chat/widgets/chat_upload_icon.dart';

class TempFileBubble extends StatefulWidget {
  @override
  _TempFileBubbleState createState() => _TempFileBubbleState();
}

class _TempFileBubbleState extends State<TempFileBubble> {
  String fileInfo = '';

  String formatFileSize(int size) {
    double calculatedSize;
    if (size >= 1024 && size < 1024 * 1024) {
      calculatedSize = size / 1024;
      return '${calculatedSize.toStringAsFixed(1)} kB';
    } else if (size >= 1024 * 1024 && size < 1024 * 1024 * 1024) {
      calculatedSize = size / 1024 / 1024;
      return '${calculatedSize.toStringAsFixed(1)} Mb';
    } else {
      calculatedSize = size.toDouble();
      return '${calculatedSize.toString()} bytes';
    }
  }

  Widget modalSheetDivider() {
    return Container(
      height: 3.0,
      width: 32.0,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(100.0)),
        color: AllColors.modalSheetLine,
      ),
    );
  }

  void tryAgainBottomSheet({
    required BuildContext context,
  }) async {
    showModalBottomSheet(
        context: context,
        barrierColor: Colors.black.withOpacity(0.8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20.0),
            topRight: Radius.circular(20.0),
          ),
        ),
        builder: (BuildContext modalContext) {
          return Container(
            height: 164,
            padding: EdgeInsets.only(top: 8, left: 28, right: 28),
            child: Column(
              children: [
                modalSheetDivider(),
                const SizedBox(height: 22.0),
                GestureDetector(
                  onTap: () {
                    Navigator.pop(modalContext);
                    context.read<ChatCubit>().resendFile();
                  },
                  child: Container(
                    color: Colors.transparent,
                    child: Row(
                      children: [
                        SvgPicture.asset('assets/icons/resend.svg'),
                        const SizedBox(width: 18),
                        Text(
                          'Resend',
                          style: AllStyles.font15w500darkGray,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 32),
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).pop();
                    context.read<ChatCubit>().deleteFailedMessage();
                  },
                  child: Container(
                    color: Colors.transparent,
                    child: Row(
                      children: [
                        SvgPicture.asset('assets/icons/delete.svg'),
                        const SizedBox(width: 18),
                        Text(
                          'Delete',
                          style: AllStyles.font15w500darkGray,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        BlocBuilder<ChatCubit, ChatState>(
          builder: (context, state) {
            //print(state);
            if (state is UploadInProgress) {
              fileInfo =
                  '${((state).percent * 100).toStringAsFixed(0)}% uploaded';
              return GestureDetector(
                onTap: () {
                  if (state is UploadInProgress) {
                    context.read<ChatCubit>().cancelUploading();
                  } else if (state is UploadError) {
                    // openFile(filePath);
                  } else {
                    // openFile(filePath);
                  }
                },
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  margin: EdgeInsets.symmetric(vertical: 2),
                  decoration: BoxDecoration(
                    border: Border.all(color: AllColors.purple),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                      bottomLeft: Radius.circular(20),
                    ),
                    color: AllColors.purple,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        child: chatUploadIcon(state: state),
                        width: 32,
                        height: 40,
                      ),
                      SizedBox(width: 10),
                      Container(
                        constraints: BoxConstraints(
                            maxWidth: MediaQuery.of(context).size.width * 0.6),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              state.fileName,
                              style: AllStyles.font15w500white.copyWith(
                                color: AllColors.white,
                              ),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 10,
                              softWrap: true,
                            ),
                            Text(
                              fileInfo,
                              style: AllStyles.font14w400white.copyWith(
                                color: AllColors.white.withOpacity(0.7),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            } else if (state is UploadCancelled) {
              return Container();
            } else if (state is UploadError) {
              return GestureDetector(
                onTap: () {
                  tryAgainBottomSheet(context: context);
                },
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      margin: EdgeInsets.symmetric(vertical: 2),
                      decoration: BoxDecoration(
                        border: Border.all(color: AllColors.purple),
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20),
                          bottomLeft: Radius.circular(20),
                        ),
                        color: AllColors.purple,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            child: chatUploadIcon(state: state),
                            width: 32,
                            height: 40,
                          ),
                          SizedBox(width: 10),
                          Container(
                            constraints: BoxConstraints(
                                maxWidth:
                                    MediaQuery.of(context).size.width * 0.6),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  state.fileName,
                                  style: AllStyles.font15w500white.copyWith(
                                    color: AllColors.white,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 10,
                                  softWrap: true,
                                ),
                                Text(
                                  'Failed to send',
                                  style: AllStyles.font14w400white.copyWith(
                                    color: AllColors.white.withOpacity(0.7),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 4),
                    SvgPicture.asset('assets/icons/upload_error.svg'),
                  ],
                ),
              );
            } else
              return Container();
          },
        ),
      ],
    );
  }
}
