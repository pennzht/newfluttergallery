// Copyright 2019 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';


enum ChipDemoType {
  action,
  choice,
  filter,
  input,
}

class ChipDemo extends StatelessWidget {
  const ChipDemo({Key key, }) : super(key: key);

  

  String _title(BuildContext context) {
    return 'Action chip';
    return '';
  }

  @override
  Widget build(BuildContext context) {
    Widget buttons;
    buttons = _ActionChipDemo();

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(_title(context)),
      ),
      body: buttons,
    );
  }
}

// BEGIN chipDemoAction

class _ActionChipDemo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: ActionChip(
        onPressed: () {},
        avatar: const Icon(
          Icons.brightness_5,
          color: Colors.black54,
        ),
        label: Text('Turn on lights'),
      ),
    );
  }
}

// END

// BEGIN chipDemoChoice

class _ChoiceChipDemo extends StatefulWidget {
  @override
  _ChoiceChipDemoState createState() => _ChoiceChipDemoState();
}

class _ChoiceChipDemoState extends State<_ChoiceChipDemo> {
  int indexSelected = -1;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Wrap(
        children: [
          ChoiceChip(
            label: Text('Small'),
            selected: indexSelected == 0,
            onSelected: (value) {
              setState(() {
                indexSelected = value ? 0 : -1;
              });
            },
          ),
          const SizedBox(width: 8),
          ChoiceChip(
            label: Text('Medium'),
            selected: indexSelected == 1,
            onSelected: (value) {
              setState(() {
                indexSelected = value ? 1 : -1;
              });
            },
          ),
          const SizedBox(width: 8),
          ChoiceChip(
            label: Text('Large'),
            selected: indexSelected == 2,
            onSelected: (value) {
              setState(() {
                indexSelected = value ? 2 : -1;
              });
            },
          ),
        ],
      ),
    );
  }
}

// END

// BEGIN chipDemoFilter

class _FilterChipDemo extends StatefulWidget {
  @override
  _FilterChipDemoState createState() => _FilterChipDemoState();
}

class _FilterChipDemoState extends State<_FilterChipDemo> {
  bool isSelectedElevator = false;
  bool isSelectedWasher = false;
  bool isSelectedFireplace = false;

  @override
  Widget build(BuildContext context) {
    final chips = [
      FilterChip(
        label: Text('Lift'),
        selected: isSelectedElevator,
        onSelected: (value) {
          setState(() {
            isSelectedElevator = !isSelectedElevator;
          });
        },
      ),
      FilterChip(
        label: Text('Washing machine'),
        selected: isSelectedWasher,
        onSelected: (value) {
          setState(() {
            isSelectedWasher = !isSelectedWasher;
          });
        },
      ),
      FilterChip(
        label: Text('Fireplace'),
        selected: isSelectedFireplace,
        onSelected: (value) {
          setState(() {
            isSelectedFireplace = !isSelectedFireplace;
          });
        },
      ),
    ];

    return Center(
      child: Wrap(
        children: [
          for (final chip in chips)
            Padding(
              padding: const EdgeInsets.all(4),
              child: chip,
            )
        ],
      ),
    );
  }
}

// END

// BEGIN chipDemoInput

class _InputChipDemo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: InputChip(
        onPressed: () {},
        onDeleted: () {},
        avatar: const Icon(
          Icons.directions_bike,
          size: 20,
          color: Colors.black54,
        ),
        deleteIconColor: Colors.black54,
        label: Text('Cycling'),
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
      home: ChipDemo(),
    );
  }
}

