import 'dart:io';

import 'package:csv/csv.dart';
import 'package:file_manager/file_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pull/const.dart';
//
//Show Device File Exporer to select destination for exporting file
//
class FileSaveLocationView extends StatefulWidget {
  const FileSaveLocationView({Key? key, required this.employeeData}) : super(key: key);

  final List<List<dynamic>> employeeData;
  @override
  State<FileSaveLocationView> createState() => _FileSaveLocationViewState();
}

class _FileSaveLocationViewState extends State<FileSaveLocationView> {
  final FileManagerController controller = FileManagerController();
  String selectedPath = '';

  //export file with selected location
  exploreFile() async {
    String dir = selectedPath +
        "/${DateTime.now().microsecondsSinceEpoch.toString()}.csv";

    String file = "$dir";

    File f = await File(file).create(recursive: true);

    String csv = ListToCsvConverter().convert(widget.employeeData, eol: '\n');

    await f.writeAsString(csv).then((value) {
      showToast('CSV file exported !');
      Navigator.pop(context);
    }).catchError((e) {
      showToast(errorTxt);
    });
  }

  @override
  Widget build(BuildContext context) {
    return ControlBackButton(
      controller: controller,
      child: Scaffold(
        appBar: appBar(context),
        body: WillPopScope(
          onWillPop: () async {
            Navigator.pop(context);
            return true;
          },
          child: FileManager(
            controller: controller,
            builder: (context, snapshot) {
              final List<FileSystemEntity> entities = snapshot;
              return ListView.builder(
                padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 10.h),
                itemCount: entities.length,
                physics: BouncingScrollPhysics(),
                itemBuilder: (context, index) {
                  FileSystemEntity entity = entities[index];
                  return Container(
                    margin: EdgeInsets.only(bottom: 10.h),
                    decoration: BoxDecoration(
                        color: colorThree,
                        borderRadius: BorderRadius.circular(10.r)),
                    child: ListTile(
                      leading: FileManager.isFile(entity)
                          ? Icon(
                              Icons.feed_outlined,
                              size: 20.sp,
                              color: whiteColor,
                            )
                          : Icon(
                              Icons.folder,
                              size: 20.sp,
                              color: whiteColor,
                            ),
                      title: Text(
                        FileManager.basename(
                          entity,
                          showFileExtension: true,
                        ),
                        style: GoogleFonts.poppins(
                            textStyle: TextStyle(
                                fontSize: 15.sp,
                                fontWeight: FontWeight.w600,
                                color: whiteColor)),
                      ),
                      subtitle: subtitle(entity),
                      trailing: GestureDetector(
                        onTap: () {
                          //select final destination by clicking on any folder
                          setState(() {
                            selectedPath =
                                selectedPath == entity.path ? '' : entity.path;
                          });
                        },
                        child: Container(
                          height: 30.h,
                          width: 30.w,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: selectedPath == entity.path
                                  ? Colors.green
                                  : Colors.red),
                          child: Center(
                            child: Icon(
                              Icons.done,
                              size: 20.sp,
                              color: selectedPath == entity.path
                                  ? blackColor
                                  : whiteColor,
                            ),
                          ),
                        ),
                      ),
                      onTap: () async {
                        if (FileManager.isDirectory(entity)) {
                          // open the folder
                          controller.openDirectory(entity);
                        }
                      },
                    ),
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }

  AppBar appBar(BuildContext context) {
    return AppBar(
      actions: [
        TextButton(
            onPressed: () => createFolder(context),
            child: Text(
              'Create Folder',
              style: GoogleFonts.poppins(
                  textStyle:
                      TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w500)),
            )),
        SizedBox(
          width: 10.w,
        )
      ],
      title: ValueListenableBuilder<String>(
        valueListenable: controller.titleNotifier,
        builder: (context, title, _) => Text(
          title == '0' ? '' : title,
          style: GoogleFonts.poppins(
              textStyle: TextStyle(
                  fontSize: 14.sp,
                  color: whiteColor,
                  fontWeight: FontWeight.w600)),
        ),
      ),
      leading: TextButton(
        onPressed: () {
          exploreFile();
          // Navigator.pop(context, selectedPath);
        },
        child: Text(
          'Done',
          style: GoogleFonts.poppins(
              textStyle:
                  TextStyle(fontWeight: FontWeight.w600, fontSize: 15.sp)),
        ),
      ),
    );
  }

  Widget subtitle(FileSystemEntity entity) {
    return FutureBuilder<FileStat>(
      future: entity.stat(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          if (entity is File) {
            int size = snapshot.data!.size;

            return Text(
              "${FileManager.formatBytes(size)}",
              style: GoogleFonts.poppins(
                  textStyle: TextStyle(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w400,
                      color: whiteColor)),
            );
          }
          return Text(
            "${snapshot.data!.modified}".substring(0, 10),
            style: GoogleFonts.poppins(
                textStyle: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w400,
                    color: whiteColor)),
          );
        } else {
          return Text("");
        }
      },
    );
  }

  createFolder(BuildContext context) async {
    showDialog(
      context: context,
      builder: (context) {
        TextEditingController folderName = TextEditingController();
        return Dialog(
          child: Container(
            padding: EdgeInsets.all(10),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  title: TextField(
                    controller: folderName,
                  ),
                ),
                ElevatedButton(
                  onPressed: () async {
                    try {
                      // Create Folder
                      await FileManager.createFolder(
                          controller.getCurrentPath, folderName.text);
                      // Open Created Folder
                      controller.setCurrentPath =
                          controller.getCurrentPath + "/" + folderName.text;
                    } catch (e) {}

                    Navigator.pop(context);
                  },
                  child: Text('Create Folder'),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
