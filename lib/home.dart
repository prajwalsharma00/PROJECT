import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'past.dart';
import 'today.dart';
import 'future.dart';

class Home extends StatefulWidget {
  final VoidCallback toggleTheme;
  Home({required this.toggleTheme});
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Map<String, List<Map<String, dynamic>>> taskLists = {
    'Past': [],
    'Present': [],
    'Future': []
  };

  int _completedTasks = 0;
  int _pendingTasks = 0;

  @override
  void initState() {
    super.initState();
    _loadInitialTasks();
  }

  void _loadInitialTasks() {
    taskLists['Present']!.add({
      'task': 'Grocery Shopping',
      'date': DateTime.now(),
      'done': false,
      'priority': 'High',
      'subtasks': [
        {'title': 'Buy milk', 'done': false},
        {'title': 'Buy bread', 'done': true},
      ]
    });
    taskLists['Future']!.add({
      'task': 'Book Doctor Appointment',
      'date': DateTime.now().add(Duration(days: 3)),
      'done': false,
      'priority': 'Medium',
      'subtasks': []
    });
    taskLists['Past']!.add({
      'task': 'Pay Bills',
      'date': DateTime.now().subtract(Duration(days: 2)),
      'done': true,
      'priority': 'High',
      'subtasks': []
    });
    _calculateStats();
  }

  void _calculateStats() {
    _completedTasks = taskLists['Past']!.where((task) => task['done'] == true).length;
    _pendingTasks = taskLists['Present']!.where((task) => task['done'] == false).length +
        taskLists['Future']!.length;
  }

  void _refreshTasks() {
    DateTime now = DateTime.now();
    DateTime todayStart = DateTime(now.year, now.month, now.day);
    DateTime todayEnd = todayStart.add(Duration(days: 1));

    List<Map<String, dynamic>> updatedPast = [];
    List<Map<String, dynamic>> updatedPresent = [];
    List<Map<String, dynamic>> updatedFuture = [];

    for (var list in [taskLists['Past'], taskLists['Present'], taskLists['Future']]) {
      for (var task in list!) {
        DateTime taskDate = task['date'];
        if (task['done']) {
          updatedPast.add(task);
        } else if (taskDate.isBefore(todayStart)) {
          updatedPast.add(task);
        } else if (taskDate.isAfter(todayEnd)) {
          updatedFuture.add(task);
        } else {
          updatedPresent.add(task);
        }
      }
    }

    setState(() {
      taskLists['Past'] = updatedPast;
      taskLists['Present'] = updatedPresent;
      taskLists['Future'] = updatedFuture;
      _calculateStats();
    });
  }

  void _addTask(String task, DateTime date, String priority, List<Map<String, dynamic>> subtasks) {
    DateTime now = DateTime.now();
    DateTime todayStart = DateTime(now.year, now.month, now.day);
    DateTime todayEnd = todayStart.add(Duration(days: 1));

    String category;
    if (date.isBefore(todayStart)) {
      category = 'Past';
    } else if (date.isAfter(todayEnd)) {
      category = 'Future';
    } else {
      category = 'Present';
    }

    setState(() {
      taskLists[category]!.add({
        'task': task,
        'date': date,
        'done': false,
        'priority': priority,
        'subtasks': subtasks,
      });
      _calculateStats();
    });
  }

  void _updateTaskStatus(String category, int index, bool newValue) {
    setState(() {
      taskLists[category]![index]['done'] = newValue;
      _refreshTasks();
    });
  }

  void _showAddTaskDialog() {
    TextEditingController taskController = TextEditingController();
    TextEditingController subtaskController = TextEditingController();
    DateTime selectedDate = DateTime.now();
    String selectedPriority = 'Medium';
    List<Map<String, dynamic>> subtasks = [];

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Add New Task'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: taskController,
                decoration: InputDecoration(hintText: 'Enter task title'),
              ),
              SizedBox(height: 8),
              TextField(
                controller: subtaskController,
                decoration: InputDecoration(
                  hintText: 'Enter a subtask and press Add',
                  suffixIcon: IconButton(
                    icon: Icon(Icons.add),
                    onPressed: () {
                      if (subtaskController.text.isNotEmpty) {
                        setState(() {
                          subtasks.add({
                            'title': subtaskController.text,
                            'done': false,
                          });
                          subtaskController.clear();
                        });
                      }
                    },
                  ),
                ),
              ),
              SizedBox(height: 8),
              Wrap(
                spacing: 6,
                children: subtasks.map((sub) => Chip(label: Text(sub['title']))).toList(),
              ),
              SizedBox(height: 8),
              ListTile(
                title: Text(DateFormat('MMM dd, hh:mm a').format(selectedDate)),
                trailing: Icon(Icons.calendar_today),
                onTap: () async {
                  DateTime? picked = await showDatePicker(
                    context: context,
                    initialDate: selectedDate,
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2100),
                  );
                  if (picked != null) {
                    TimeOfDay? pickedTime = await showTimePicker(
                      context: context,
                      initialTime: TimeOfDay.fromDateTime(selectedDate),
                    );
                    if (pickedTime != null) {
                      setState(() {
                        selectedDate = DateTime(
                          picked.year,
                          picked.month,
                          picked.day,
                          pickedTime.hour,
                          pickedTime.minute,
                        );
                      });
                    }
                  }
                },
              ),
              DropdownButtonFormField<String>(
                value: selectedPriority,
                decoration: InputDecoration(labelText: 'Priority'),
                items: ['High', 'Medium', 'Low']
                    .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                    .toList(),
                onChanged: (val) => selectedPriority = val!,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (taskController.text.isNotEmpty) {
                _addTask(taskController.text, selectedDate, selectedPriority, subtasks);
                Navigator.pop(context);
              }
            },
            child: Text('Add'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    void _deleteTask(String category, int index) {
      setState(() {
        taskLists[category]!.removeAt(index);
        _calculateStats();
      });
    }

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Task Dashboard'),
          actions: [
            IconButton(
              icon: Icon(Icons.brightness_6),
              onPressed: widget.toggleTheme,
            ),
          ],
          bottom: TabBar(
            tabs: [
              Tab(icon: Icon(Icons.history), text: 'Past'),
              Tab(icon: Icon(Icons.today), text: 'Today'),
              Tab(icon: Icon(Icons.upcoming), text: 'Future'),
            ],
          ),
        ),
        body: TabBarView(
          children: [

            PastTasks(taskLists['Past']!, _refreshTasks,
                onEdit: (i, task) => {},
                onDelete: (i) => _deleteTask('Past', i)),
            TodayTasks(taskLists['Present']!, _refreshTasks,
                onStatusChange: _updateTaskStatus,
                onEdit: (i, task) => {},
                onDelete: (i) => _deleteTask('Present', i)),
            FutureTasks(taskLists['Future']!, _refreshTasks,
                onStatusChange: _updateTaskStatus,
                onEdit: (i, task) => {},
                onDelete: (i) => _deleteTask('Future', i)),
          ],
        ),

        floatingActionButton: FloatingActionButton(
          onPressed: _showAddTaskDialog,
          child: Icon(Icons.add),
        ),
      ),
    );
  }
}
