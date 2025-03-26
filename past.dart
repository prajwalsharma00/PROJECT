import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class PastTasks extends StatelessWidget {
  final List<Map<String, dynamic>> pastTasks;
  final VoidCallback refreshTasks;

  PastTasks(this.pastTasks, this.refreshTasks);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemCount: pastTasks.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(pastTasks[index]['task']),
          subtitle: Text(DateFormat.yMMMd().format(pastTasks[index]['date'])),
        );
      },
    );
  }
}
