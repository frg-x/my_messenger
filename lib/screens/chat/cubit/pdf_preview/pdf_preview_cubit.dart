import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:native_pdf_renderer/native_pdf_renderer.dart';
import 'package:path/path.dart' as path;

part 'pdf_preview_state.dart';

class PdfPreviewCubit extends Cubit<PdfPreviewState> {
  PdfPreviewCubit() : super(PdfPreviewInitial());

  bool isPDFLoaded = false;

  bool isFileExists(String fullPath) {
    File file = File(fullPath);
    return file.existsSync() ? true : false;
  }

  void getPDFPreview(String fullPath, String cachedImagePath) async {
    String pdfCacheDir = path.dirname(cachedImagePath);

    final isDirExists = Directory(pdfCacheDir).existsSync();
    if (!isDirExists) {
      Directory(pdfCacheDir).createSync(recursive: true);
    }

    if (!isFileExists(cachedImagePath)) {
      var document = await PdfDocument.openFile(fullPath);
      var page = await document.getPage(1);
      PdfPageImage? preview = await page.render(
        width: (page.width ~/ 3).toInt(),
        height: (page.height ~/ 3).toInt(),
        format: PdfPageFormat.JPEG,
      );

      File file = File(cachedImagePath);
      file.writeAsBytes(preview!.bytes);

      await page.close();

      isPDFLoaded = true;
      emit(PdfPreviewDone(preview));
    } else {
      isPDFLoaded = true;
      emit(PdfCachedPreviewDone(cachedImagePath));
    }
  }
}
