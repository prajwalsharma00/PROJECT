import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text('Subtract Two Numbers')),
        body: SubtractTwoNumbers(),
      ),
    );
  }
}

class SubtractTwoNumbers extends StatefulWidget {
  @override
  _SubtractTwoNumbersState createState() => _SubtractTwoNumbersState();
}

class _SubtractTwoNumbersState extends State<SubtractTwoNumbers> {
  final TextEditingController num1Controller = TextEditingController();
  final TextEditingController num2Controller = TextEditingController();
  double result = 0;

  void subtractNumbers() {
    setState(() {
      double num1 = double.parse(num1Controller.text);
      double num2 = double.parse(num2Controller.text);
      result = num1 - num2;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(160.0),
      child: Column(
        children: <Widget>[
          TextField(
            controller: num1Controller,
            decoration: InputDecoration(labelText: 'First Number'),
            keyboardType: TextInputType.number,
          ),
          TextField(
            controller: num2Controller,
            decoration: InputDecoration(labelText: 'Second Number'),
            keyboardType: TextInputType.number,
          ),
          SizedBox(height: 40),
          ElevatedButton(
            onPressed: subtractNumbers,
            child: Text('Subtract'),
          ),
          SizedBox(height: 12 ),
          Text('Result: $result'),
        ],
      ),
    );
  }
}
