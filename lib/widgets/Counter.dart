// ignore_for_file: prefer_const_constructors
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Counter extends StatefulWidget {
  final String title;
  final int countkey;
  final int startingCount;

  const Counter(
      {Key? key,
      required this.title,
      required this.countkey,
      required this.startingCount});

  @override
  State<Counter> createState() => _CounterState();
}

class _CounterState extends State<Counter> {
  int _counter = 0;

  Future<void> _increment() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _counter++;
      prefs.setInt(widget.countkey.toString(), _counter.toInt());
    });
  }

  Future<void> _deincrement() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _counter--;
      prefs.setInt(widget.countkey.toString(), _counter.toInt());
    });
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      print('GETTING:  ${widget.countkey.toString()}: ${prefs.getInt(widget.countkey.toString())}');
      _counter = prefs.getInt(widget.countkey.toString()) ?? 0;
    });
  }

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.blue,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          SizedBox(
            width: 10,
          ),
          Text(
            "${widget.title}: ",
            style: TextStyle(
              fontSize: 30,
              color: Colors.white,
            ),
          ),
          Text(
            _counter.toString(),
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 30,
              color: Colors.white,
            ),
          ),
          SizedBox(
            width: 10,
          ),
          ElevatedButton(
              onPressed: () {
                setState(() {
                  _increment();
                });
              },
              child: Text('+')),
          SizedBox(
            width: 20,
          ),
          ElevatedButton(
              onPressed: () {
                setState(() {
                  _deincrement();
                });
              },
              child: Text('-'))
        ],
      ),
    );
  }
}
