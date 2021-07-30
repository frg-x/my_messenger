part of 'pdf_preview_cubit.dart';

@immutable
abstract class PdfPreviewState {}

class PdfPreviewInitial extends PdfPreviewState {}

class PdfPreviewDone extends PdfPreviewState {
  PdfPreviewDone(this.preview);
  final PdfPageImage preview;
}

class PdfCachedPreviewDone extends PdfPreviewState {
  PdfCachedPreviewDone(this.cachedPreviewPath);
  final String cachedPreviewPath;
}
