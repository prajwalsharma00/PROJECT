import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'past.dart';
import 'today.dart';
import 'future.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Home(),
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.grey[100],
        appBarTheme: AppBarTheme(
          elevation: 0,
          centerTitle: true,
          backgroundColor: Colors.white,
          titleTextStyle: TextStyle(
            color: Colors.blue[800],
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
          iconTheme: IconThemeData(color: Colors.blue[800]),
        ),
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: Colors.blue[800],
          elevation: 4,
        ),
      ),
    );
  }
}

class Home extends StatefulWidget {
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

  void _refreshTasks() {
    DateTime now = DateTime.now();
    List<Map<String, dynamic>> updatedPresent = [];
    List<Map<String, dynamic>> updatedPast = [];
    List<Map<String, dynamic>> updatedFuture = [];

    for (var task in taskLists['Present']!) {
      if (task['done']) {
        updatedPast.add(task);
      } else {
        updatedPresent.add(task);
      }
    }

    for (var task in taskLists['Future']!) {
      DateTime taskDate = task['date'];
      if (taskDate.isBefore(now) || taskDate.isAtSameMomentAs(now)) {
        updatedPresent.add(task);
      } else {
        updatedFuture.add(task);
      }
    }

    // Calculate statistics
    _completedTasks = taskLists['Past']!.length + updatedPast.length;
    _pendingTasks = updatedPresent.length + updatedFuture.length;

    setState(() {
      taskLists['Present'] = updatedPresent;
      taskLists['Past'] = [...taskLists['Past']!, ...updatedPast];
      taskLists['Future'] = updatedFuture;
    });
  }

  void _addTask(String category, String task, DateTime date, String priority) {
    setState(() {
      String targetCategory = date.isBefore(DateTime.now())
          ? 'Past'
          : date.isAtSameMomentAs(DateTime.now())
          ? 'Present'
          : 'Future';
      taskLists[targetCategory]?.add({
        'task': task,
        'date': date,
        'done': false,
        'priority': priority,
      });
      _pendingTasks++;
    });
  }

  void _showAddTaskDialog() {
    TextEditingController taskController = TextEditingController();
    DateTime selectedDate = DateTime.now();
    String selectedPriority = 'Medium';

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Text(
            'Add New Task',
            style: TextStyle(
              color: Colors.blue[800],
              fontWeight: FontWeight.bold,
            ),
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: taskController,
                  decoration: InputDecoration(
                    hintText: 'Enter task description',
                    border: OutlineInputBorder(),
                    filled: true,
                    fillColor: Colors.grey[100],
                  ),
                  maxLines: 2,
                ),
                SizedBox(height: 16),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey[300]!),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: ListTile(
                    leading: Icon(Icons.calendar_today, color: Colors.blue[800]),
                    title: Text(
                      DateFormat('MMM dd, yyyy').format(selectedDate),
                      style: TextStyle(fontSize: 16),
                    ),
                    trailing: Icon(Icons.arrow_drop_down, color: Colors.blue[800]),
                    onTap: () async {
                      DateTime? picked = await showDatePicker(
                        context: context,
                        initialDate: selectedDate,
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2100),
                        builder: (context, child) {
                          return Theme(
                            data: Theme.of(context).copyWith(
                              colorScheme: ColorScheme.light(
                                primary: Colors.blue[800]!,
                                onPrimary: Colors.white,
                                onSurface: Colors.black,
                              ),
                              textButtonTheme: TextButtonThemeData(
                                style: TextButton.styleFrom(
                                  foregroundColor: Colors.blue[800],
                                ),
                              ),
                            ),
                            child: child!,
                          );
                        },
                      );
                      if (picked != null) {
                        setState(() {
                          selectedDate = picked;
                        });
                      }
                    },
                  ),
                ),
                SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: selectedPriority,
                  decoration: InputDecoration(
                    labelText: 'Priority',
                    border: OutlineInputBorder(),
                    filled: true,
                    fillColor: Colors.grey[100],
                  ),
                  items: ['High', 'Medium', 'Low']
                      .map((priority) => DropdownMenuItem(
                    value: priority,
                    child: Text(priority),
                  ))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedPriority = value!;
                    });
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'Cancel',
                style: TextStyle(color: Colors.grey[600]),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue[800],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: () {
                if (taskController.text.isNotEmpty) {
                  _addTask('Present', taskController.text, selectedDate, selectedPriority);
                }
                Navigator.pop(context);
              },
              child: Text(
                'Add Task',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildStatsCard(String title, int count, Color color) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
            SizedBox(height: 8),
            Text(
              count.toString(),
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Task Dashboard'),
          bottom: TabBar(
            labelColor: Colors.blue[800],
            unselectedLabelColor: Colors.grey[600],
            indicatorColor: Colors.blue[800],
            indicatorWeight: 3,
            tabs: [
              Tab(icon: Icon(Icons.history), text: 'Past'),
              Tab(icon: Icon(Icons.today), text: 'Today'),
              Tab(icon: Icon(Icons.upcoming), text: 'Future'),
            ],
          ),
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildStatsCard('Completed', _completedTasks, Colors.green),
                  _buildStatsCard('Pending', _pendingTasks, Colors.orange),
                ],
              ),
            ),
            Expanded(
              child: TabBarView(
                children: [
                  PastTasks(taskLists['Past']!, _refreshTasks),
                  PresentTasks(taskLists['Present']!, _refreshTasks),
                  FutureTasks(taskLists['Future']!, _refreshTasks),
                ],
              ),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: _showAddTaskDialog,
          child: Icon(Icons.add, size: 30),
          tooltip: 'Add Task',
        ),
      ),
    );
  }
}