import 'package:flutter/material.dart';
import '../models/todo.dart';

class TodoTile extends StatelessWidget {
  final Todo todo;
  final VoidCallback onDelete;
  final VoidCallback onEdit;

  const TodoTile({
    required this.todo,
    required this.onDelete,
    required this.onEdit,
    super.key,
  });

  // Status chip with color coding
  Widget _buildStatusChip(String status) {
    Color color;
    switch (status) {
      case 'completed':
        color = Colors.green;
        break;
      case 'pending':
        color = Colors.orange;
        break;
      case 'ready':
      default:
        color = Colors.blue;
    }
    return Chip(
      label: Text(
        status.toUpperCase(),
        style: const TextStyle(color: Colors.white, fontSize: 10),
      ),
      backgroundColor: color,
      padding: const EdgeInsets.symmetric(horizontal: 6),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        title: Text(
          todo.title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(todo.description),
            const SizedBox(height: 4),
            _buildStatusChip(todo.status),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.edit, color: Colors.blue),
              onPressed: onEdit,
            ),
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: onDelete,
            ),
          ],
        ),
      ),
    );
  }
}
