import 'dart:async';

import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int counter = 0;
  StreamController<int> counterController = StreamController<int>();
  StreamController<List<int>> newController = StreamController<List<int>>();
  late Stream mySteam;
  StreamTransformer<int, dynamic> myTransformer =
      new StreamTransformer.fromHandlers(handleData: ((data, sink) {
    if (data.isOdd) {
      sink.add(data);
    }
  }));
  subscription() {
    final subs = mySteam.listen((data) {
      print(data);
    });
    Timer(Duration(seconds: 10), (() {
      subs.pause();
    }));
    mySteam.map((event) => event.toString()).listen((event) {
      print(event);
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    mySteam = counterController.stream.asBroadcastStream();
    subscription();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Stream'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            StreamBuilder(
                stream: mySteam.transform(myTransformer),
                builder: ((context, snapshot) {
                  if (snapshot.hasData) {
                    return Text(snapshot.data.toString());
                  } else {
                    return Text('0');
                  }
                })),
            StreamBuilder(
                stream: mySteam,
                builder: ((context, snapshot) {
                  if (snapshot.hasData) {
                    return Text(snapshot.data.toString());
                  } else {
                    return Text('0');
                  }
                })),
            StreamBuilder(
                stream: newController.stream,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Expanded(
                      child: ListView.builder(
                          itemCount: snapshot.data!.length,
                          itemBuilder: ((context, index) {
                            return ListTile(
                              title: Text(snapshot.data![index].toString()),
                            );
                          })),
                    );
                  } else {
                    return Text('No Data');
                  }
                })
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          counter++;
          counterController.sink.add(counter);
          List<int> sampleData = [1, 2, 5, 6, 10];
          newController.sink.add(sampleData);
        },
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
