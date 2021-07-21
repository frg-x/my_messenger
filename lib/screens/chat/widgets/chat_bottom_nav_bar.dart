import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:my_messenger/constants.dart';
import 'package:my_messenger/cubit/messages/chat_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChatBottomNavBar extends StatefulWidget {
  final String userId;
  ChatBottomNavBar({required this.userId});

  @override
  _ChatBottomNavBarState createState() => _ChatBottomNavBarState();
}

class _ChatBottomNavBarState extends State<ChatBottomNavBar> {
  var _textController = TextEditingController();

  bool isTextEmpty = true;

  void checkTextIsEmpty() {
    setState(() {
      isTextEmpty = _textController.text.isEmpty ? true : false;
    });
  }

  Widget modalSheetDivider() {
    return Container(
      height: 3.0,
      width: 32.0,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(100.0)),
        color: Color(0XFFEBEBEB),
      ),
    );
  }

  void attachmentPickerBottomSheet({
    required String channelId,
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
                    context.read<ChatCubit>().pickAndUpload(
                          channelId: channelId,
                          attachmentType: MessageContentType.media,
                        );
                  },
                  child: Container(
                    color: Colors.transparent,
                    child: Row(
                      children: [
                        SvgPicture.asset('assets/icons/media.svg'),
                        const SizedBox(width: 18),
                        Text(
                          'Photo or Video',
                          style: AllStyles.font15w500darkGray,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 32),
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                    context.read<ChatCubit>().pickAndUpload(
                          channelId: channelId,
                          attachmentType: MessageContentType.file,
                        );
                  },
                  child: Container(
                    color: Colors.transparent,
                    child: Row(
                      children: [
                        SvgPicture.asset('assets/icons/file.svg'),
                        const SizedBox(width: 18),
                        Text(
                          'File',
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
    String channelId = context.read<ChatCubit>().channelId;
    return Padding(
      padding: MediaQuery.of(context).viewInsets,
      child: Container(
        height: 56.0,
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        color: Colors.white,
        alignment: Alignment.topCenter,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            GestureDetector(
              child: Container(
                height: 32.0,
                width: 32.0,
                child: SvgPicture.asset(
                  'assets/icons/plus.svg',
                  height: 14.0,
                  width: 14.0,
                  fit: BoxFit.scaleDown,
                ),
                decoration: BoxDecoration(
                  color: Color(0xFFEEEEEE),
                  borderRadius: BorderRadius.circular(16.0),
                ),
              ),
              onTap: () => attachmentPickerBottomSheet(channelId: channelId, context: context),
            ),
            const SizedBox(width: 8.0),
            Expanded(
              child: SizedBox(
                height: 40,
                child: Stack(
                  alignment: Alignment.centerRight,
                  children: [
                    TextField(
                      controller: _textController,
                      onChanged: (value) => checkTextIsEmpty(),
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.only(top: 22, left: 12, right: 42),
                        hintText: 'Send a message...',
                        hintStyle: AllStyles.font15w400lightGrayAnother,
                        border: AllStyles.messageBorderStyle,
                        enabledBorder: AllStyles.messageBorderStyle,
                        disabledBorder: AllStyles.messageBorderStyle,
                        focusedBorder: AllStyles.messageBorderStyle,
                      ),
                      style: AllStyles.font15w400black,
                      cursorColor: Colors.black,
                      onTap: () {},
                    ),
                    Positioned(
                      right: 4.0,
                      child: GestureDetector(
                        child: SvgPicture.asset(isTextEmpty
                            ? 'assets/icons/send_inactive.svg'
                            : 'assets/icons/send_active.svg'),
                        onTap: isTextEmpty
                            ? null
                            : () {
                                //print('Sent: ${_textController.text}');
                                context.read<ChatCubit>().sendMessage(
                                      content: _textController.text,
                                      contentType: MessageContentType.text,
                                    );
                                _textController.clear();
                                setState(() {
                                  isTextEmpty = true;
                                });
                              },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
