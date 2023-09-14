import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

class FileService {
  Future<String> saveFile(String url, String fileName) async {
    String directory = (await getApplicationDocumentsDirectory()).path;
    File file = new File('$directory/${fileName}');
    var request = await http.get(Uri.parse(url));
    var bytes = await request.bodyBytes;
    await file.writeAsBytes(bytes);
    if (!kReleaseMode) {
      print(file.path);
    }
    return file.path;
  }

  Future<void> removeFile(String filePath) async {
    File file = new File(filePath);
    try {
      await file.delete();
    } catch (e) {
      print(e);
    }
  }
}
