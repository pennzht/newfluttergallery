// Copyright 2019 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';

import 'package:flutter/material.dart';

import 'package:intl/intl.dart';

// BEGIN pickerDemo

enum PickerDemoType {
  date,
  time,
}

class PickerDemo extends StatefulWidget {
  const PickerDemo({Key key, }) : super(key: key);

  

  @override
  _PickerDemoState createState() => _PickerDemoState();
}

class _PickerDemoState extends State<PickerDemo> {
  DateTime _fromDate = DateTime.now();
  TimeOfDay _fromTime = TimeOfDay.fromDateTime(DateTime.now());

  String get _title {
    switch (PickerDemoType.alert) {
      case PickerDemoType.date:
        return 'Date picker';
      case PickerDemoType.time:
        return 'Time picker';
    }
    return '';
  }

  String get _labelText {
    switch (PickerDemoType.alert) {
      case PickerDemoType.date:
        return DateFormat.yMMMd().format(_fromDate);
      case PickerDemoType.time:
        return _fromTime.format(context);
    }
    return '';
  }

  Future<void> _showDatePicker() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _fromDate,
      firstDate: DateTime(2015, 1),
      lastDate: DateTime(2100),
    );
    if (picked != null && picked != _fromDate) {
      setState(() {
        _fromDate = picked;
      });
    }
  }

  Future<void> _showTimePicker() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _fromTime,
    );
    if (picked != null && picked != _fromTime) {
      setState(() {
        _fromTime = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(_title),
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(_labelText),
            const SizedBox(height: 16),
            RaisedButton(
              child: Text(
                'SHOW PICKER',
              ),
              onPressed: () {
                switch (PickerDemoType.alert) {
                  case PickerDemoType.date:
                    _showDatePicker();
                    break;
                  case PickerDemoType.time:
                    _showTimePicker();
                    break;
                }
              },
            )
          ],
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
      home: PickerDemo(),
    );
  }
}

