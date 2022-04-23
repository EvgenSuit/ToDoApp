import 'dart:convert';

import 'package:path_provider/path_provider.dart';
import 'save_widget.dart';
import 'dart:io';

class LoadWidgets {
  List contents = [];
  LoadWidgets();
  LoadWidgets.fromJson(Map<String, dynamic> json) : contents = json['contents'];

  String getFileExtension(String file) {
    String fileExtension = '';
    for (int i = file.length - 4; i < file.length - 1; i++) {
      fileExtension += file[i];
    }
    return fileExtension;
  }

  loadContent(String file, String fileExtension) async {
    if (fileExtension == 'txt') {
      String filePath = '';
      for (int i = 7; i < file.length - 1; i++) {
        filePath += file[i];
      }
      File readableFile = File(filePath);
      //await readableFile.delete();
      String fileContentWithSep = readableFile.readAsStringSync();
      final fileContent = fileContentWithSep.split('[sep]');

      contents.add(fileContent);
    }
  }

  loadWidgets() async {
    /*final files = await SaveTask.listDir();
    for (var file in files) {
      String fileExtension = getFileExtension(file);
      loadContent(file, fileExtension);
    }
    return contents; */
  }
}
