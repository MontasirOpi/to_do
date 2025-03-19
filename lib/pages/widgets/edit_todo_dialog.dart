import 'package:flutter/material.dart';
import '../../models/todo.dart';


class EditTodoDialog extends StatefulWidget {
  final Todo todo;
  final Function(String title, String desc, String status) onSave;

  const EditTodoDialog({super.key, required this.todo, required this.onSave});

  @override
  State<EditTodoDialog> createState() => _EditTodoDialogState();
}

class _EditTodoDialogState extends State<EditTodoDialog> {
  late TextEditingController titleController;
  late TextEditingController descController;
  late String statusValue;

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController(text: widget.todo.title);
    descController = TextEditingController(text: widget.todo.description);
    statusValue = widget.todo.status;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Edit Todo'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: titleController,
            decoration: const InputDecoration(labelText: 'Title'),
          ),
          TextField(
            controller: descController,
            decoration: const InputDecoration(labelText: 'Description'),
          ),
          const SizedBox(height: 10),
          DropdownButtonFormField<String>(
            value: statusValue,
            items: const [
              DropdownMenuItem(value: 'ready', child: Text('Ready')),
              DropdownMenuItem(value: 'pending', child: Text('Pending')),
              DropdownMenuItem(value: 'completed', child: Text('Completed')),
            ],
            onChanged: (val) {
              if (val != null) {
                setState(() {
                  statusValue = val;
                });
              }
            },
            decoration: const InputDecoration(labelText: 'Status'),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            if (titleController.text.isNotEmpty) {
              widget.onSave(
                titleController.text,
                descController.text,
                statusValue,
              );
              Navigator.pop(context);
            }
          },
          child: const Text('Save'),
        ),
      ],
    );
  }
}
