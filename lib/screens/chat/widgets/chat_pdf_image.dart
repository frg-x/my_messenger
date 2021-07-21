import 'package:flutter/material.dart';

class PdfToImage extends StatefulWidget {
  PdfToImage({required this.filePath, required this.uniqueId, required this.bytes});

  final String filePath;
  final String uniqueId;
  final bytes;

  @override
  _PdfToImageState createState() => _PdfToImageState();
}

class _PdfToImageState extends State<PdfToImage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Hero(
            tag: widget.uniqueId,
            child: Image.memory(widget.bytes),
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
