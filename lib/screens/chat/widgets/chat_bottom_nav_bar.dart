import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
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

  void checkIsEmpty() {
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

  void uploadAndSend({required String channelId, required MessageContentType contentType}) async {
    var metadata = await uploadAttachment(attachmentType: contentType, channelId: channelId);
    if (metadata.isNotEmpty) {
      context.read<ChatCubit>().sendMessage(
            content: '',
            contentType: contentType,
            metaData: metadata,
          );
    }
  }

  Future<Map<String, String>> uploadAttachment({
    required MessageContentType attachmentType,
    required String channelId,
  }) async {
    //String uuid = Uuid().v1().toString();
    Map<String, String> fileInfo = {};
    late String filePath;
    late String fileName;
    FilePickerResult? pickedFile;

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

      File file = File(filePath);

      Reference storageRef = FirebaseStorage.instance.ref('messages/$channelId/$fileName');

      try {
        await storageRef.putFile(file);
        fileInfo.addAll({'url': await storageRef.getDownloadURL()});
        fileInfo.addAll({'name': fileName});
        fileInfo.addAll(
            {'size': await storageRef.getMetadata().then((value) => value.size.toString())});
      } on FirebaseException catch (e) {
        print(e);
      }
    } else {}
    return fileInfo;
  }

  void attachmentPickerBottomSheet({required String channelId}) async {
    showModalBottomSheet(
        context: context,
        barrierColor: Colors.black.withOpacity(0.8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20.0),
            topRight: Radius.circular(20.0),
          ),
        ),
        builder: (BuildContext context) {
          return Container(
            height: 164,
            padding: EdgeInsets.only(top: 8, left: 28, right: 28),
            child: Column(
              children: [
                modalSheetDivider(),
                const SizedBox(height: 22.0),
                GestureDetector(
                  onTap: () async {
                    uploadAndSend(channelId: channelId, contentType: MessageContentType.media);
                    Navigator.pop(context);
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
                  onTap: () async {
                    uploadAndSend(channelId: channelId, contentType: MessageContentType.file);
                    Navigator.pop(context);
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
              onTap: () => attachmentPickerBottomSheet(channelId: channelId),
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
                      onChanged: (value) => checkIsEmpty(),
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
