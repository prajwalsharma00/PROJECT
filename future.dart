  import 'package:flutter/material.dart';
  import 'package:intl/intl.dart';

  class FutureTasks extends StatelessWidget {
    final List<Map<String, dynamic>> futureTasks;
    final VoidCallback refreshTasks;

    FutureTasks(this.futureTasks, this.refreshTasks);

    @override
    Widget build(BuildContext context) {
      return ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: futureTasks.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(futureTasks[index]['task']),
            subtitle: Text(DateFormat.yMMMd().format(futureTasks[index]['date'])),
          );
        },
      );
    }
  }
