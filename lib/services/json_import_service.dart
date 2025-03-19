import 'dart:convert';
import 'dart:io';
import '../models/todo.dart';

class JsonImportService {
  Future<List<Todo>> importFromJson(File jsonFile) async {
    final jsonString = await jsonFile.readAsString();
    final List<dynamic> jsonList = json.decode(jsonString);
    return jsonList.map((e) => Todo.fromJson(e)).toList();
  }
}
