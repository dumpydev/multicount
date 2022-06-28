// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables
import 'package:flutter/material.dart';
import 'package:simplemulticounter/widgets/Counter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int amount = 0;
  List<Counter> dynamicList = [];

  Future<void> _save() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      prefs.setInt('amount', amount);
    });
  }
  Future<void> _reset() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      print(dynamicList.length);
      for(int i = 0; i < dynamicList.length + 500; i++) {
        prefs.setInt('$i', 0);
        print('SET Counter $i to 0');
        print('GETTING:  Counter $i: ${prefs.getInt(i.toString())}');
      }
      amount = 0;
      prefs.setInt('amount', 0);
      dynamicList = [];
    });
  }
  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      amount = prefs.getInt('amount') ?? 0;
      for (int i = 0; i < amount + 1; i++) {
        dynamicList.add(Counter(
          title: 'Counter $i',
          countkey: i,
          startingCount: 0,
        ));
      }
    });


  }
  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: TextButton(
            onPressed: () {
              setState(() {
                _reset();
              });
            },
            child:
                Text('Simple Counters', style: TextStyle(color: Colors.white)),
          ),
        ),
        body: Center(
          child: Column(
            children: <Widget>[
              Expanded(
                child: ListView.builder(
                  itemCount: dynamicList.length,
                  itemBuilder: (context, index) {
                    return dynamicList[index];
                  },
                ),
              ),
            ],
          ),
        ),
        floatingActionButton: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            FloatingActionButton(
              onPressed: () {
                setState(() {
                  _reset();
                });
              },
              child: Icon(Icons.delete),
            ),
            SizedBox(
              height: 10,
            ),
            FloatingActionButton(
              onPressed: () {
                setState(() {
                  amount--;
                  dynamicList.removeLast();
                  _save();
                });
              },
              child: Icon(Icons.remove),
            ),
            SizedBox(
              height: 10,
            ),
            FloatingActionButton(
              onPressed: () {
                setState(() {
                  amount++;
                  dynamicList.add(Counter(
                    title: "Counter ${dynamicList.length + 1}",
                    countkey: dynamicList.length + 1,
                    startingCount: 0,
                  ));
                  print(amount);
                  _save();
                });
              },
              child: Icon(Icons.add),
            ),
          ],
        ));
  }
}
