import 'package:flutter/material.dart';
import 'package:my_messenger/constants.dart';

class TextBubble extends StatelessWidget {
  const TextBubble({
    Key? key,
    required this.content,
    required this.isMe,
  }) : super(key: key);

  final String content;
  final bool isMe;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        Container(
          constraints:
              BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.8),
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          margin: EdgeInsets.symmetric(vertical: 2),
          decoration: BoxDecoration(
            border: Border.all(
                color: isMe ? AllColors.purple : AllColors.lightGray),
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
            color: isMe ? AllColors.purple : AllColors.white,
          ),
          child: Text(
            content,
            style: AllStyles.font15w400black.copyWith(
              color: isMe ? AllColors.white : AllColors.darkGray,
            ),
            overflow: TextOverflow.clip,
            maxLines: 50,
            softWrap: true,
          ),
        ),
      ],
    );
  }
}
