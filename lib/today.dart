import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TodayTasks extends StatelessWidget {
  final List<Map<String, dynamic>> todayTasks;
  final VoidCallback refreshTasks;
  final Function(String, int, bool) onStatusChange;
  final Function(int, Map<String, dynamic>) onEdit;
  final Function(int) onDelete;

  TodayTasks(this.todayTasks, this.refreshTasks,
      {required this.onStatusChange,
        required this.onEdit,
        required this.onDelete});

  @override
  Widget build(BuildContext context) {
    if (todayTasks.isEmpty) {
      return Center(child: Text('No tasks for today.'));
    }
    return ListView.builder(
      padding: EdgeInsets.all(16),
      itemCount: todayTasks.length,
      itemBuilder: (context, index) {
        final task = todayTasks[index];
        return Card(
          child: ListTile(
            leading: Checkbox(
              value: task['done'],
              activeColor: Colors.green,
              onChanged: (val) => onStatusChange('Present', index, val!),
            ),
            title: Text(task['task'],
                style: TextStyle(
                  decoration: task['done'] ? TextDecoration.lineThrough : null,
                )),
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