// Copyright 2014 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';

import 'package:flutter/material.dart';

import 'recorder.dart';
import 'test_data.dart';

/// Creates an infinite list of Material cards and scrolls it.
class Experimental extends WidgetRecorder {
  // WidgetRecorder.

  Experimental() : super(name: benchmarkName);

  static const String benchmarkName = 'experimental';

  @override
  Widget createWidget() => const MaterialApp(
        title: 'Infinite Card Scroll Benchmark',
        home: _ExperimentalCards(),
      );
}

class _ExperimentalCards extends StatefulWidget {
  const _ExperimentalCards({Key key}) : super(key: key);

  @override
  State<_ExperimentalCards> createState() => _ExperimentalCardsState();
}

class _ExperimentalCardsState extends State<_ExperimentalCards> {
  ScrollController scrollController;

  double offset;
  static const double distance = 1000;
  static const Duration stepDuration = Duration(seconds: 1);

  @override
  void initState() {
    print('You are watching Experimental.');

    super.initState();

    scrollController = ScrollController();
    offset = 0;

    return;
    // Without the timer the animation doesn't begin.
    Timer.run(() async {
      while (true) {
        await scrollController.animateTo(
          offset + distance,
          curve: Curves.linear,
          duration: stepDuration,
        );
        offset += distance;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return CounterApp();

    return ListView.builder(
      controller: scrollController,
      itemBuilder: (BuildContext context, int index) {
        return SizedBox(
          height: 100.0,
          child: Card(
            elevation: 16.0,
            child: Text(
              lipsum[index % lipsum.length],
              textAlign: TextAlign.center,
            ),
          ),
        );
      },
    );
  }
}






/// Counterapp.
///
///
class CounterApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      showPerformanceOverlay: true,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  @override
  void initState(){
    super.initState();

  }

  void _scheduleTick(){
    WidgetsBinding.instance.scheduleFrameCallback(
            (timeStamp) {
          print('Debug: _MyHomePageState scheduled a new frame at $timeStamp');
          _tick();
        }
    );
  }

  void _tick(){
    _scheduleTick();
  }

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headline4,
              key: ValueKey('counter'),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: Icon(Icons.add),
        key: ValueKey('increment'),
      ),
    );
  }
}
