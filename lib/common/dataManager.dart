import 'dart:convert';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';

class DataManager {
  static final DataManager _instance = DataManager._internal();

  factory DataManager() {
    return _instance;
  }

  DataManager._internal();

  Future<File> _getLocalFile() async {
    final directory = await getApplicationDocumentsDirectory();
    return File('${directory.path}/data.json');
  }

  Future<void> saveData(Map<String, dynamic> data) async {
    final file = await _getLocalFile();
    final jsonData = jsonEncode(data);
    print("jsonData");
    print(jsonData);
    await file.writeAsString(jsonData);
  }

  Future<Map<String, dynamic>> loadData() async {
    try {
      final file = await _getLocalFile();
      if (file.existsSync()) {
        final jsonData = await file.readAsString();
        print("jsonData2");
        print(jsonData);
        return jsonDecode(jsonData);
      } else {
        return {};
      }
    } catch (e) {
      print('Error loading data: $e');
      return {};
    }
  }

  Future<void> deleteData() async {
    final file = await _getLocalFile();
    if (file.existsSync()) {
      await file.delete();
    }
  }
}