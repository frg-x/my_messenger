import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_messenger/constants.dart';
import 'package:my_messenger/cubit/messages/chat_cubit.dart';
import 'package:my_messenger/screens/chat/widgets/chat_upload_icon.dart';

class TempFileBubble extends StatefulWidget {
  TempFileBubble({required this.name, required this.size});

  final String name;
  final String size;

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

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        BlocBuilder<ChatCubit, ChatState>(
          builder: (context, state) {
            //print(state);
            if (state is UploadInProgress) {
              fileInfo = '${((state).percent * 100).toStringAsFixed(0)}% uploaded';
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
                    border: Border.all(color: Color(0xFF7F48FB)),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                      bottomLeft: Radius.circular(20),
                    ),
                    color: Color(0xFF7F48FB),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        child: chatUploadIcon(
                          state: state,
                          filename: widget.name,
                          size: widget.size,
                        ),
                        width: 32,
                        height: 40,
                      ),
                      SizedBox(width: 10),
                      Container(
                        constraints:
                            BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.6),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              state.fileName,
                              style: AllStyles.font15w500white.copyWith(
                                color: Color(0xFFFFFFFF),
                              ),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 10,
                              softWrap: true,
                            ),
                            Text(
                              fileInfo,
                              style: AllStyles.font14w400white.copyWith(
                                color: Color(0xFFFFFFFF).withOpacity(0.7),
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
            } else
              return Container();
          },
        ),
      ],
    );
  }
}
