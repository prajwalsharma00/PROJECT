import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class FutureTasks extends StatelessWidget {
  final List<Map<String, dynamic>> futureTasks;
  final VoidCallback refreshTasks;
  final Function(String, int, bool) onStatusChange;
  final Function(int, Map<String, dynamic>) onEdit;
  final Function(int) onDelete;

  FutureTasks(this.futureTasks, this.refreshTasks,
      {required this.onStatusChange,
        required this.onEdit,
        required this.onDelete});

  @override
  Widget build(BuildContext context) {
    if (futureTasks.isEmpty) {
      return Center(child: Text('No future tasks.'));
    }
    return ListView.builder(
      padding: EdgeInsets.all(16),
      itemCount: futureTasks.length,
      itemBuilder: (context, index) {
        final task = futureTasks[index];
        return Card(
          child: ListTile(
            leading: Checkbox(
              value: task['done'],
              activeColor: Colors.green,
              onChanged: (val) => onStatusChange('Future', index, val!),
            ),
            title: Text(task['task']),
            subtitle: Text(
              '${DateFormat('MMM dd, hh:mm a').format(task['date'])}\nPriority: ${task['priority']}',
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