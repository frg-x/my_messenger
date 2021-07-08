import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:my_messenger/constants.dart';
import 'package:url_launcher/url_launcher.dart';

class FileBubble extends StatelessWidget {
  FileBubble({
    Key? key,
    required this.content,
    required this.isMe,
    this.metaData,
  }) : super(key: key);

  final String content;
  final bool isMe;
  final metaData;

  void launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  String sizeToString(int size) {
    double calculatedSize;
    if (size >= 1024 && size < 1024 * 1024) {
      calculatedSize = size / 1024;
      return '${calculatedSize.toStringAsFixed(2)} kB';
    } else if (size >= 1024 * 1024 && size < 1024 * 1024 * 1024) {
      calculatedSize = size / 1024 / 1024;
      return '${calculatedSize.toStringAsFixed(2)} Mb';
    } else {
      calculatedSize = size as double;
      return '${calculatedSize.toStringAsFixed(2)} bytes';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: () => launchURL(metaData['url']),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            margin: EdgeInsets.symmetric(vertical: 2),
            decoration: BoxDecoration(
              border: Border.all(color: isMe ? Color(0xFF7F48FB) : Color(0xFFEEEEEE)),
              borderRadius: isMe
                  ? BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                      bottomLeft: Radius.circular(20),
                    )
                  : BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                      bottomRight: Radius.circular(20),
                    ),
              color: isMe ? Color(0xFF7F48FB) : Colors.white,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  child: SvgPicture.asset(isMe
                      ? 'assets/icons/doc_ready_is_me.svg'
                      : 'assets/icons/doc_ready_is_not_me.svg'),
                  width: 32,
                  height: 40,
                ),
                SizedBox(width: 10),
                Container(
                  constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.6),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        metaData['name'],
                        style: AllStyles.font15w500white.copyWith(
                          color: isMe ? Colors.white : Color(0xFF333333),
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 10,
                        softWrap: true,
                      ),
                      Text(
                        sizeToString(int.parse(metaData['size'])),
                        style: AllStyles.font14w400white.copyWith(
                            color: isMe ? Colors.white.withOpacity(0.7) : Color(0xFF787878)),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
