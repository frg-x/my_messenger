import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ImagePreviewBubble extends StatelessWidget {
  const ImagePreviewBubble({Key? key, required this.content, required this.isMe, this.metadata})
      : super(key: key);

  final String content;
  final bool isMe;
  final metadata;

  @override
  Widget build(BuildContext context) {
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
                    return BigImage(
                      url: metadata['url'],
                      uniqueId: uniqueId,
                    );
                  },
                  maintainState: true,
                ));
          },
          child: Container(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.8,
              maxHeight: 150,
            ),
            padding: EdgeInsets.all(4.0),
            margin: EdgeInsets.symmetric(vertical: 2),
            decoration: BoxDecoration(
              border:
                  Border.all(color: isMe ? Color(0xFF7F48FB).withOpacity(0.3) : Color(0xFFEEEEEE)),
              borderRadius: BorderRadius.circular(4.0),
              color: isMe ? Color(0xFF7F48FB).withOpacity(0.1) : Colors.white,
            ),
            child: Hero(
              tag: uniqueId,
              child: CachedNetworkImage(
                imageUrl: metadata['url'],
                placeholder: (context, url) => CircularProgressIndicator(),
                errorWidget: (context, url, error) => Icon(Icons.error),
              ),
              transitionOnUserGestures: true,
            ),
          ),
        ),
      ],
    );
  }
}

class BigImage extends StatefulWidget {
  BigImage({required this.url, required this.uniqueId});

  final String url;
  final String uniqueId;

  @override
  _BigImageState createState() => _BigImageState();
}

class _BigImageState extends State<BigImage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Hero(
            tag: widget.uniqueId,
            child: CachedNetworkImage(
              imageUrl: widget.url,
              placeholder: (context, url) => CircularProgressIndicator(),
              errorWidget: (context, url, error) => Icon(Icons.error),
            ),
            transitionOnUserGestures: true,
          ),
        ),
        onTap: () {
          FocusScope.of(context).unfocus();
          Navigator.pop(context);
        },
      ),
    );
  }
}
