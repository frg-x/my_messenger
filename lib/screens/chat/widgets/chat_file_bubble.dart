import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_messenger/constants.dart';
import 'package:my_messenger/cubit/chat/chat_cubit.dart';
import 'package:my_messenger/screens/chat/cubit/download/download_cubit.dart';
import 'package:my_messenger/screens/chat/cubit/pdf_preview/pdf_preview_cubit.dart';
import 'package:my_messenger/screens/chat/widgets/chat_download_icon.dart';
import 'package:open_file/open_file.dart';
import 'package:path/path.dart' as path;

class FileBubble extends StatefulWidget {
  FileBubble({
    required this.content,
    required this.senderIsMe,
    this.metaData,
  });

  final String content;
  final bool senderIsMe;
  final metaData;

  @override
  _FileBubbleState createState() => _FileBubbleState();
}

class _FileBubbleState extends State<FileBubble> {
  late String downloadsDir;
  late String cachedImagePath;

  String formatFileSize(int size) {
    double calculatedSize;
    if (size >= 1024 && size < 1024 * 1024) {
      calculatedSize = size / 1024;
      return '${calculatedSize.toStringAsFixed(1)} kB';
    } else if (size >= 1024 * 1024 && size < 1024 * 1024 * 1024) {
      calculatedSize = size / 1024 / 1024;
      return '${calculatedSize.toStringAsFixed(1)} Mb';
    } else {
      calculatedSize = size.toDouble();
      return '${calculatedSize.toString()} bytes';
    }
  }

  void openFile(String filePath) async {
    OpenFile.open(filePath);
  }

  var pageImage;
  bool isPDF = false;

  @override
  void initState() {
    downloadsDir = context.read<ChatCubit>().getDownloadsDir();
    cachedImagePath = context.read<ChatCubit>().getPDFCache();
    isPDF = widget.metaData['name'].toLowerCase().endsWith('.pdf');
    super.initState();
  }

  bool isFileExists(String fullPath) {
    File file = File(fullPath);
    return file.existsSync() ? true : false;
  }

  @override
  Widget build(BuildContext context) {
    String fileInfo = '';
    String filePath = '$downloadsDir/${widget.metaData['name']}';
    String basename = path.basenameWithoutExtension(filePath);
    String size = widget.metaData != null ? widget.metaData['size'] : '0';
    return widget.senderIsMe
        ? MultiBlocProvider(
            providers: [
              BlocProvider(create: (context) => ChatCubit()),
              BlocProvider(create: (context) => DownloadCubit()),
              BlocProvider(create: (context) => PdfPreviewCubit()),
            ],
            child: BlocBuilder<DownloadCubit, DownloadState>(
              builder: (downloadContext, downloadState) {
                if (downloadState is DownloadInProgress) {
                  fileInfo =
                      '${(downloadState.percent * 100).toStringAsFixed(0)}% downloaded';
                } else {
                  fileInfo = formatFileSize(int.parse(size));
                }
                return Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    BlocBuilder<ChatCubit, ChatState>(
                      builder: (context, state) {
                        //print('state: $state');
                        //print('downloadState: $downloadState');
                        if (isFileExists(filePath)) {
                          context.read<PdfPreviewCubit>().getPDFPreview(
                              filePath, '$cachedImagePath/$basename.jpg');
                        }
                        return GestureDetector(
                          onTap: () async {
                            if (downloadState is DownloadInitial) {
                              if (isFileExists(filePath)) {
                                openFile(
                                    '$downloadsDir/${widget.metaData['name']}');
                              } else {
                                //print('Start downloading');
                                context.read<DownloadCubit>().downloadURL(
                                      url: widget.metaData['url'],
                                      filename: widget.metaData['name'],
                                    );
                              }
                            } else if (downloadState is DownloadFinished) {
                              openFile(downloadState.localPath);
                            } else {
                              context.read<DownloadCubit>().cancelDownload();
                            }
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 12, vertical: 8),
                            margin: EdgeInsets.symmetric(vertical: 2),
                            decoration: BoxDecoration(
                              border: Border.all(color: AllColors.purple),
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(20),
                                topRight: Radius.circular(20),
                                bottomLeft: Radius.circular(20),
                              ),
                              color: AllColors.purple,
                            ),
                            width: MediaQuery.of(context).size.width * 0.5,
                            child: (isPDF && isFileExists(filePath))
                                ? ClipRRect(
                                    borderRadius: BorderRadius.circular(6.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        BlocBuilder<PdfPreviewCubit,
                                            PdfPreviewState>(
                                          builder: (context, state) {
                                            if (state is PdfPreviewDone) {
                                              return SizedBox(
                                                  child: Image(
                                                image: MemoryImage(
                                                    state.preview.bytes),
                                                height: 150,
                                              ));
                                            } else if (state
                                                is PdfCachedPreviewDone) {
                                              return SizedBox(
                                                  child: Image.file(
                                                File(state.cachedPreviewPath),
                                                height: 150,
                                              ));
                                            } else {
                                              return SizedBox(
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(4.0),
                                                  child:
                                                      CircularProgressIndicator(
                                                    strokeWidth: 2.5,
                                                  ),
                                                ),
                                                width: 24,
                                                height: 24,
                                              );
                                            }
                                          },
                                        ),
                                        Text(
                                          '${widget.metaData['name']}',
                                          style: AllStyles.font15w500white
                                              .copyWith(
                                            color: AllColors.white,
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 10,
                                          softWrap: true,
                                        ),
                                        Text(
                                          fileInfo,
                                          style: AllStyles.font14w400white
                                              .copyWith(
                                            color: AllColors.lightGray,
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                : Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        //child: chatUploadIcon(state: state),
                                        child: chatDownloadIcon(
                                          isMe: widget.senderIsMe,
                                          context: downloadContext,
                                          state: downloadState,
                                          size: formatFileSize(int.parse(size)),
                                          filename: widget.metaData['name'],
                                          downloadsDir: downloadsDir,
                                        ),
                                        width: 32,
                                        height: 40,
                                      ),
                                      SizedBox(width: 10),
                                      Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.3,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              '${widget.metaData['name']}',
                                              style: AllStyles.font15w500white
                                                  .copyWith(
                                                color: AllColors.white,
                                              ),
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 10,
                                              softWrap: true,
                                            ),
                                            Text(
                                              fileInfo,
                                              style: AllStyles.font14w400white
                                                  .copyWith(
                                                color: AllColors.white
                                                    .withOpacity(0.7),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                          ),
                        );
                      },
                    ),
                  ],
                );
              },
            ),
          )
        : MultiBlocProvider(
            providers: [
              BlocProvider(create: (context) => DownloadCubit()),
              BlocProvider(create: (context) => PdfPreviewCubit()),
            ],
            child: BlocBuilder<DownloadCubit, DownloadState>(
              builder: (context, downloadState) {
                //print(downloadState);
                if (downloadState is DownloadInProgress) {
                  fileInfo =
                      '${(downloadState.percent * 100).toStringAsFixed(0)}% downloaded';
                } else {
                  fileInfo = formatFileSize(int.parse(size));
                }
                bool isPDFLoaded = context.read<PdfPreviewCubit>().isPDFLoaded;
                if (isPDF && isFileExists(filePath) && !isPDFLoaded) {
                  context.read<PdfPreviewCubit>().getPDFPreview(
                      filePath, '$cachedImagePath/$basename.jpg');
                }
                return Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: () async {
                        if (downloadState is DownloadInitial) {
                          if (isFileExists(filePath)) {
                            openFile(
                                '$downloadsDir/${widget.metaData['name']}');
                          } else {
                            //print('Start downloading');
                            context.read<DownloadCubit>().downloadURL(
                                  url: widget.metaData['url'],
                                  filename: widget.metaData['name'],
                                );
                          }
                        } else if (downloadState is DownloadFinished) {
                          openFile(downloadState.localPath);
                        } else {
                          context.read<DownloadCubit>().cancelDownload();
                        }
                      },
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        margin: EdgeInsets.symmetric(vertical: 2),
                        decoration: BoxDecoration(
                          border: Border.all(color: AllColors.lightGray),
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(20),
                            topRight: Radius.circular(20),
                            bottomRight: Radius.circular(20),
                          ),
                          color: AllColors.white,
                        ),
                        width: MediaQuery.of(context).size.width * 0.5,
                        child: (isPDF && isFileExists(filePath))
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(6.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    BlocBuilder<PdfPreviewCubit,
                                        PdfPreviewState>(
                                      builder: (context, state) {
                                        if (state is PdfPreviewDone) {
                                          return SizedBox(
                                              child: Image(
                                            image: MemoryImage(
                                                state.preview.bytes),
                                            height: 150,
                                          ));
                                        } else if (state
                                            is PdfCachedPreviewDone) {
                                          return SizedBox(
                                              child: Image.file(
                                            File(state.cachedPreviewPath),
                                            height: 150,
                                          ));
                                        } else {
                                          return SizedBox(
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(4.0),
                                              child: CircularProgressIndicator(
                                                strokeWidth: 2.5,
                                              ),
                                            ),
                                            width: 24,
                                            height: 24,
                                          );
                                        }
                                      },
                                    ),
                                    Text(
                                      '${widget.metaData['name']}',
                                      style: AllStyles.font15w500white.copyWith(
                                        color: AllColors.darkGray,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 10,
                                      softWrap: true,
                                    ),
                                    Text(
                                      fileInfo,
                                      style: AllStyles.font14w400white.copyWith(
                                        color: AllColors.lightGray2,
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            : Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    child: chatDownloadIcon(
                                      isMe: widget.senderIsMe,
                                      context: context,
                                      state: downloadState,
                                      size: formatFileSize(int.parse(size)),
                                      filename: widget.metaData['name'],
                                      downloadsDir: downloadsDir,
                                    ),
                                    width: 32,
                                    height: 40,
                                  ),
                                  SizedBox(width: 10),
                                  Container(
                                    width:
                                        MediaQuery.of(context).size.width * 0.3,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          '${widget.metaData['name']}',
                                          style: AllStyles.font15w500white
                                              .copyWith(
                                            color: AllColors.darkGray,
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 10,
                                          softWrap: true,
                                        ),
                                        Text(
                                          fileInfo,
                                          style: AllStyles.font14w400white
                                              .copyWith(
                                            color: AllColors.lightGray2,
                                          ),
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
              },
            ),
          );
  }
}
