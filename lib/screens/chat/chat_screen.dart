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
    return Scaffold(
      //appBar: ChatAppBar(),
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
      body: BlocBuilder<ChatCubit, ChatState>(
        builder: (context, state) {
          if (state is ChatInfo) {
            //print(state.channelId);
            var channelId = state.channelId;
            return Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                channelId.isNotEmpty
                    ? StreamBuilder(
                        stream: FirebaseFirestore.instance
                            .collection('messages')
                            .doc(channelId)
                            .collection(channelId)
                            .orderBy('timestamp', descending: true)
                            //.limit(_limit)
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) {
                            return Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Center(
                                  child: Text(
                                    'No message here yet',
                                    style: AllStyles.font15w400lightGrayAnother,
                                  ),
                                ),
                                SizedBox(
                                  height: MediaQuery.of(context).viewInsets.bottom,
                                ),
                              ],
                            );
                          } else {
                            var messagesListSnapshot = snapshot.data as QuerySnapshot;
                            var messageList = messagesListSnapshot.docs;
                            //print(messages.first['content']);
                            return Expanded(
                              child: ListView.builder(
                                physics: BouncingScrollPhysics(),
                                padding: EdgeInsets.symmetric(horizontal: 24),
                                itemBuilder: (context, int index) {
                                  var message = messageList[index];
                                  if (message['type'] == MessageContentType.text.index) {
                                    return TextBubble(
                                      content: message['content'],
                                      isMe: message['idFrom'] == myId,
                                    );
                                  } else if (message['type'] == MessageContentType.file.index) {
                                    return FileBubble(
                                      content: message['content'],
                                      isMe: message['idFrom'] == myId,
                                      metaData: message['metadata'],
                                    );
                                  } else {
                                    return ImagePreviewBubble(
                                      content: message['content'],
                                      isMe: message['idFrom'] == myId,
                                      metadata: message['metadata'],
                                    );
                                  }
                                },
                                itemCount: messageList.length,
                                reverse: true,
                                //shrinkWrap: true,
                                //controller: listScrollController,
                              ),
                            );
                          }
                        },
                      )
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Center(
                            child: Text(
                              'No message here yet',
                              style: AllStyles.font15w400lightGrayAnother,
                            ),
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).viewInsets.bottom,
                          ),
                        ],
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
