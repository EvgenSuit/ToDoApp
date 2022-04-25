import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'dart:convert';

class SaveTask {
  SaveTask({this.taskTitle, this.taskText});
  String? taskTitle;
  String? taskText;
  String separationToken = '[sep]';

  Map<String, dynamic> toJson() => {
        'contents': [taskTitle, taskText]
      };

  static listDir() async {
    List<String> fileNames = [];
    Directory appDocumentsDirectory = await getApplicationDocumentsDirectory();
    await for (var entity in appDocumentsDirectory.list()) {
      fileNames.add(entity.toString());
    }
    print('All trhe files: $fileNames');
    return fileNames;
  }

  getFilePath() async {
    Directory appDocumentsDirectory = await getApplicationDocumentsDirectory();
    String appDocPath = appDocumentsDirectory.path;
    String filePath = '$appDocPath/$taskTitle.txt';

    return filePath;
  }

  void saveFile() async {
    //File file = File(await getFilePath());
    //file.writeAsString('$taskTitle$separationToken$taskText');
  }

  readFile() async {
    File file = File(await getFilePath());
    String fileContent = file.readAsStringSync();
    return fileContent;
  }
}
