import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class ChatBigImage extends StatefulWidget {
  ChatBigImage({required this.url, required this.uniqueId});

  final String url;
  final String uniqueId;

  @override
  _ChatBigImageState createState() => _ChatBigImageState();
}

class _ChatBigImageState extends State<ChatBigImage> {
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
