// Copyright 2019 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/cupertino.dart';



// BEGIN cupertinoSliderDemo

class CupertinoSliderDemo extends StatefulWidget {
  const CupertinoSliderDemo();

  @override
  _CupertinoSliderDemoState createState() => _CupertinoSliderDemoState();
}

class _CupertinoSliderDemoState extends State<CupertinoSliderDemo> {
  double _value = 25.0;
  double _discreteValue = 20.0;

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        automaticallyImplyLeading: false,
        middle: Text('Slider'),
      ),
      child: DefaultTextStyle(
        style: CupertinoTheme.of(context).textTheme.textStyle,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    width: double.infinity,
                    child: CupertinoSlider(
                      value: _value,
                      min: 0.0,
                      max: 100.0,
                      onChanged: (value) {
                        setState(() {
                          _value = value;
                        });
                      },
                    ),
                  ),
                  MergeSemantics(
                    child: Text(
                      'Continuous: ${_value.toStringAsFixed(1)}',
                    ),
                  ),
                ],
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    width: double.infinity,
                    child: CupertinoSlider(
                      value: _discreteValue,
                      min: 0.0,
                      max: 100.0,
                      divisions: 5,
                      onChanged: (value) {
                        setState(() {
                          _discreteValue = value;
                        });
                      },
                    ),
                  ),
                  MergeSemantics(
                    child: Text(
                      'Discrete: ${_discreteValue.toStringAsFixed(1)}',
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// END
// The following code allows the demo to be run
// as a standalone app.

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: CupertinoSliderDemo(),
    );
  }
}

