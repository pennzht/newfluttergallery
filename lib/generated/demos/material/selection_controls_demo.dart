// Copyright 2019 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';



enum SelectionControlsDemoType {
  checkbox,
  radio,
  switches,
}

class SelectionControlsDemo extends StatelessWidget {
  const SelectionControlsDemo({Key key, }) : super(key: key);

  

  String _title(BuildContext context) {
    return 'Tick box';
    return '';
  }

  @override
  Widget build(BuildContext context) {
    Widget controls;
    controls = _CheckboxDemo();

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(_title(context)),
      ),
      body: controls,
    );
  }
}

// BEGIN selectionControlsDemoCheckbox

class _CheckboxDemo extends StatefulWidget {
  @override
  _CheckboxDemoState createState() => _CheckboxDemoState();
}

class _CheckboxDemoState extends State<_CheckboxDemo> {
  bool checkboxValueA = true;
  bool checkboxValueB = false;
  bool checkboxValueC;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Checkbox(
            value: checkboxValueA,
            onChanged: (value) {
              setState(() {
                checkboxValueA = value;
              });
            },
          ),
          Checkbox(
            value: checkboxValueB,
            onChanged: (value) {
              setState(() {
                checkboxValueB = value;
              });
            },
          ),
          Checkbox(
            value: checkboxValueC,
            tristate: true,
            onChanged: (value) {
              setState(() {
                checkboxValueC = value;
              });
            },
          ),
        ],
      ),
    );
  }
}

// END

// BEGIN selectionControlsDemoRadio

class _RadioDemo extends StatefulWidget {
  @override
  _RadioDemoState createState() => _RadioDemoState();
}

class _RadioDemoState extends State<_RadioDemo> {
  int radioValue = 0;

  void handleRadioValueChanged(int value) {
    setState(() {
      radioValue = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (int index = 0; index < 3; ++index)
            Radio<int>(
              value: index,
              groupValue: radioValue,
              onChanged: handleRadioValueChanged,
            ),
        ],
      ),
    );
  }
}

// END

// BEGIN selectionControlsDemoSwitches

class _SwitchDemo extends StatefulWidget {
  @override
  _SwitchDemoState createState() => _SwitchDemoState();
}

class _SwitchDemoState extends State<_SwitchDemo> {
  bool switchValue = false;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Semantics(
        container: true,
        label:
            'Switch',
        child: Switch(
          value: switchValue,
          onChanged: (value) {
            setState(() {
              switchValue = value;
            });
          },
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
      home: SelectionControlsDemo(),
    );
  }
}

