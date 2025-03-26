import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class PresentTasks extends StatelessWidget {
  final List<Map<String, dynamic>> presentTasks;
  final VoidCallback refreshTasks;

  PresentTasks(this.presentTasks, this.refreshTasks);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemCount: presentTasks.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(presentTasks[index]['task']),
          subtitle: Text(DateFormat.yMMMd().format(presentTasks[index]['date'])),
          trailing: IconButton(
            icon: Icon(Icons.check, color: Colors.green),
            onPressed: refreshTasks,
          ),
        );
      },
    );
  }
}
