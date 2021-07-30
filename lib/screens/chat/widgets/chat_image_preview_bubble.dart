import 'package:extended_image/extended_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_messenger/screens/chat/widgets/chat_big_image.dart';

class ImagePreviewBubble extends StatelessWidget {
  const ImagePreviewBubble(
      {Key? key, required this.content, required this.isMe, this.metadata})
      : super(key: key);

  final String content;
  final bool isMe;
  final metadata;

  @override
  Widget build(BuildContext context) {
    //print('image: $metadata');
    String uniqueId = DateTime.now().millisecondsSinceEpoch.toString();
    return Row(
      mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) {
                  return ChatBigImage(
                    url: metadata['url'],
                    uniqueId: uniqueId,
                  );
                },
                maintainState: true,
              ),
            );
          },
          child: Container(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.8,
              maxHeight: 150,
            ),
            padding: EdgeInsets.all(4.0),
            margin: EdgeInsets.symmetric(vertical: 2),
            decoration: BoxDecoration(
              border: Border.all(
                  color: isMe
                      ? Color(0xFF7F48FB).withOpacity(0.3)
                      : Color(0xFFEEEEEE)),
              borderRadius: BorderRadius.circular(8.0),
              color: isMe ? Color(0xFF7F48FB).withOpacity(0.1) : Colors.white,
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(6.0),
              child: Hero(
                tag: uniqueId,
                child: ExtendedImage.network(
                  metadata['url'],
                  fit: BoxFit.fitWidth,
                  cache: true,
                  //cancelToken: cancellationToken,
                ),
                // child: CachedNetworkImage(
                //   imageUrl: metadata['url'],
                //   placeholder: (context, url) => CircularProgressIndicator(),
                //   errorWidget: (context, url, error) => Icon(Icons.error),
                // ),
                transitionOnUserGestures: true,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
