import 'package:flutter/material.dart';

class AddTodoDialog extends StatefulWidget {
  final Function(String title, String desc, String status) onAdd;

  const AddTodoDialog({super.key, required this.onAdd});

  @override
  State<AddTodoDialog> createState() => _AddTodoDialogState();
}

class _AddTodoDialogState extends State<AddTodoDialog> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descController = TextEditingController();
  String statusValue = 'ready';

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add Todo'),
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
              widget.onAdd(
                titleController.text,
                descController.text,
                statusValue,
              );
              Navigator.pop(context);
            }
          },
          child: const Text('Add'),
        ),
      ],
    );
  }
}
