import 'dart:io';
import 'package:csv/csv.dart';
import 'package:path_provider/path_provider.dart';
import '../models/todo.dart';

class CsvService {
  static const String _fileName = 'todos.csv';

  // Get local file path inside app directory
  Future<File> _getLocalFile() async {
    final directory = await getApplicationDocumentsDirectory();
    return File('${directory.path}/$_fileName');
  }

  // Write todos to CSV
  Future<void> writeTodos(List<Todo> todos) async {
    final file = await _getLocalFile();
    final rows = [
      ['id', 'title', 'description', 'created_at', 'status'],
      ...todos.map((todo) => [
            todo.id,
            todo.title,
            todo.description,
            todo.createdAt,
            todo.status,
          ])
    ];
    final csv = const ListToCsvConverter().convert(rows);
    await file.writeAsString(csv);
  }

  // Read todos from CSV
  Future<List<Todo>> readTodos() async {
    try {
      final file = await _getLocalFile();
      if (!await file.exists()) return [];

      final csvString = await file.readAsString();
      final rows = const CsvToListConverter().convert(csvString);

      // Remove header row
      rows.removeAt(0);

      return rows.map((row) {
        return Todo(
          id: row[0].toString(),
          title: row[1].toString(),
          description: row[2].toString(),
          createdAt: int.tryParse(row[3].toString()) ?? DateTime.now().millisecondsSinceEpoch,
          status: row[4].toString(),
        );
      }).toList();
    } catch (e) {
      return [];
    }
  }
}
