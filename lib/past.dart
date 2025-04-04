import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class PastTasks extends StatelessWidget {
  final List<Map<String, dynamic>> pastTasks;
  final VoidCallback refreshTasks;
  final Function(int, Map<String, dynamic>) onEdit;
  final Function(int) onDelete;

  PastTasks(this.pastTasks, this.refreshTasks,
      {required this.onEdit, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    if (pastTasks.isEmpty) {
      return Center(child: Text('No past tasks.'));
    }
    return ListView.builder(
      padding: EdgeInsets.all(16),
      itemCount: pastTasks.length,
      itemBuilder: (context, index) {
        final task = pastTasks[index];
        return Card(
          child: ListTile(
            leading: Checkbox(
              value: task['done'],
              activeColor: Colors.green,
              onChanged: null, // Disabled in Past view
            ),
            title: Text(task['task'],
                style: TextStyle(
                  decoration:
                  task['done'] ? TextDecoration.lineThrough : null,
                )),
            subtitle: Text(
              '${DateFormat('MMM dd, hh:mm a').format(task['date'])}\nPriority: ${task['priority']}\nStatus: ${task['done'] ? 'Completed' : 'Incomplete'}',
            ),
            isThreeLine: true,
            trailing: Wrap(
              spacing: 8,
              children: [
                IconButton(
                    icon: Icon(Icons.edit, color: Colors.blue[800]),
                    onPressed: () => onEdit(index, task)),
                IconButton(
                    icon: Icon(Icons.delete, color: Colors.red[600]),
                    onPressed: () => onDelete(index)),
              ],
            ),
          ),
        );
      },
    );
  }
}