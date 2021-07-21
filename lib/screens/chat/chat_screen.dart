import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:my_messenger/constants.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_messenger/cubit/messages/chat_cubit.dart';
import 'package:my_messenger/screens/chat/widgets/chat_bottom_nav_bar.dart';
import 'package:my_messenger/screens/chat/widgets/chat_file_bubble.dart';
import 'package:my_messenger/screens/chat/widgets/chat_image_preview_bubble.dart';
import 'package:my_messenger/screens/chat/widgets/chat_temp_file_bubble.dart';
import 'package:my_messenger/screens/chat/widgets/chat_text_bubble.dart';

class ChatScreen extends StatefulWidget {
  static const routeName = '/chat';

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  late String partnerId;
  late String channelId;

  @override
  Widget build(BuildContext context) {
    partnerId = ModalRoute.of(context)!.settings.arguments as String;
    String myId = context.read<ChatCubit>().userId;
    context.read<ChatCubit>().setPartnerId(partnerId: partnerId);
    context.read<ChatCubit>().checkDownloadsDir();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Container(
                height: 25,
                width: 25,
                alignment: Alignment.center,
                color: Colors.white,
                child: SvgPicture.asset('assets/icons/close.svg'),
              ),
            ),
          ],
        ),
      ),
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      bottomNavigationBar: ChatBottomNavBar(userId: partnerId),
      extendBody: true,
      body: BlocConsumer<ChatCubit, ChatState>(
        listener: (context, state) {
          if (state is UploadFinished) {
            context.read<ChatCubit>().sendFile(content: '');
          }
        },
        builder: (context, state) {
          //print(state);
          if (state is! ChatInitial) {
            var channelId = context.read<ChatCubit>().channelId;
            return channelId.isEmpty
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Center(
                        child: Text(
                          'No messages here yet',
                          style: AllStyles.font15w400lightGrayAnother,
                        ),
                      ),
                      SizedBox(height: MediaQuery.of(context).viewInsets.bottom + 56),
                    ],
                  )
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      StreamBuilder(
                        stream: FirebaseFirestore.instance
                            .collection('messages')
                            .doc(channelId)
                            .collection(channelId)
                            .orderBy('timestamp', descending: true)
                            //.limit(_limit)
                            .snapshots(),
                        builder: (context, AsyncSnapshot snapshot) {
                          if (!snapshot.hasData || (snapshot.data as QuerySnapshot).docs.isEmpty) {
                            return Center(
                              child: Text(
                                'No messages here yet',
                                style: AllStyles.font15w400lightGrayAnother,
                              ),
                            );
                          } else {
                            var messageList = snapshot.data!.docs;
                            return Expanded(
                              child: ListView.builder(
                                physics: BouncingScrollPhysics(),
                                padding: EdgeInsets.symmetric(horizontal: 24),
                                itemBuilder: (context, int index) {
                                  if (index == 0) {
                                    return TempFileBubble(name: 'test', size: '123456');
                                  } else {
                                    index--;
                                    var message = messageList[index];
                                    var messageData = message.data();
                                    if ((messageData['type'] as int) ==
                                        MessageContentType.text.index) {
                                      return TextBubble(
                                        content: message['content'],
                                        isMe: message['idFrom'] == myId,
                                      );
                                    } else if (messageData['type'] ==
                                        MessageContentType.file.index) {
                                      return FileBubble(
                                        content: messageData['content'],
                                        senderIsMe: messageData['idFrom'] == myId,
                                        metaData: messageData['metadata'],
                                      );
                                    } else {
                                      return ImagePreviewBubble(
                                        content: messageData['content'],
                                        isMe: messageData['idFrom'] == myId,
                                        metadata: messageData['metadata'],
                                      );
                                    }
                                  }
                                },
                                itemCount: (snapshot.data.docs.length) + 1,
                                reverse: true,
                                //shrinkWrap: true,
                                //controller: listScrollController,
                              ),
                            );
                          }
                        },
                      ),
                      SizedBox(height: MediaQuery.of(context).viewInsets.bottom + 56),
                    ],
                  );
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}
