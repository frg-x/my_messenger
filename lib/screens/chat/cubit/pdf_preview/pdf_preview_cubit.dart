import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:native_pdf_renderer/native_pdf_renderer.dart';
import 'package:path/path.dart';

part 'pdf_preview_state.dart';

class PdfPreviewCubit extends Cubit<PdfPreviewState> {
  PdfPreviewCubit() : super(PdfPreviewInitial());

  bool isPDFLoaded = false;

  void getPDFPreview(String fullPath) async {
    var document = await PdfDocument.openFile(fullPath);
    var page = await document.getPage(1);
    PdfPageImage? preview = await page.render(
      width: page.width,
      height: page.height,
      format: PdfPageFormat.JPEG,
    );
    await page.close();

    //File file = File(fullPath);
    //String basename = basenameWithoutExtension(file.path);
    //File(fullPath).writeAsBytes(preview!.bytes);
    emit(PdfPreviewDone(preview!));
    isPDFLoaded = true;
  }
}
