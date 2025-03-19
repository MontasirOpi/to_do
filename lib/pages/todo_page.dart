import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:to_do/pages/widgets/edit_todo_dialog.dart';
import 'package:to_do/pages/widgets/show_add_todo_dailog.dart';

import '../models/todo.dart';
import '../services/csv_service.dart';
import '../services/json_import_service.dart';
import '../widgets/todo_tile.dart';


class TodoPage extends StatefulWidget {
  const TodoPage({super.key});

  @override
  State<TodoPage> createState() => _TodoPageState();
}

class _TodoPageState extends State<TodoPage> {
  final CsvService _csvService = CsvService();
  final JsonImportService _jsonImportService = JsonImportService();
  List<Todo> _todos = [];

  @override
  void initState() {
    super.initState();
    _loadTodos();
  }

  Future<void> _loadTodos() async {
    final todos = await _csvService.readTodos();
    setState(() => _todos = todos);
  }

  Future<void> _addTodo(String title, String description, String status) async {
    final newTodo = Todo(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title,
      description: description,
      createdAt: DateTime.now().millisecondsSinceEpoch,
      status: status,
    );
    setState(() => _todos.add(newTodo));
    await _csvService.writeTodos(_todos);
  }

  Future<void> _deleteTodo(Todo todo) async {
    setState(() => _todos.remove(todo));
    await _csvService.writeTodos(_todos);
  }

  Future<void> _editTodo(Todo todo) async {
    await showDialog(
      context: context,
      builder: (_) => EditTodoDialog(
        todo: todo,
        onSave: (title, desc, status) async {
          setState(() {
            todo.title = title;
            todo.description = desc;
            todo.status = status;
          });
          await _csvService.writeTodos(_todos);
        },
      ),
    );
  }

  Future<void> _importJson() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['json'],
    );
    if (result != null) {
      final file = File(result.files.single.path!);
      final importedTodos = await _jsonImportService.importFromJson(file);
      setState(() => _todos.addAll(importedTodos));
      await _csvService.writeTodos(_todos);
    }
  }

  void _showAddTodoDialog() {
    showDialog(
      context: context,
      builder: (_) => AddTodoDialog(
        onAdd: (title, desc, status) async {
          await _addTodo(title, desc, status);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text('Todo App')),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blue, Colors.purple],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.upload_file),
            onPressed: _importJson,
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF2196F3), // Blue 500
              Color(0xFF64B5F6), // Light Blue 300
              Color(0xFFE3F2FD), // Lightest Blue background
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: ListView(
            children: _todos
                .map(
                  (todo) => TodoTile(
                    todo: todo,
                    onDelete: () => _deleteTodo(todo),
                    onEdit: () => _editTodo(todo),
                  ),
                )
                .toList(),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddTodoDialog,
        child: const Icon(Icons.add),
      ),
    );
  }
}
