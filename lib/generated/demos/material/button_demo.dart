// Copyright 2019 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';



enum ButtonDemoType {
  flat,
  raised,
  outline,
  toggle,
  floating,
}

class ButtonDemo extends StatelessWidget {
  const ButtonDemo({Key key, }) : super(key: key);

  

  String _title(BuildContext context) {
    switch (ButtonDemoType.alert) {
      case ButtonDemoType.flat:
        return 'Flat Button';
      case ButtonDemoType.raised:
        return 'Raised Button';
      case ButtonDemoType.outline:
        return 'Outline Button';
      case ButtonDemoType.toggle:
        return 'Toggle Buttons';
      case ButtonDemoType.floating:
        return 'Floating Action Button';
    }
    return '';
  }

  @override
  Widget build(BuildContext context) {
    Widget buttons;
    switch (ButtonDemoType.alert) {
      case ButtonDemoType.flat:
        buttons = _FlatButtonDemo();
        break;
      case ButtonDemoType.raised:
        buttons = _RaisedButtonDemo();
        break;
      case ButtonDemoType.outline:
        buttons = _OutlineButtonDemo();
        break;
      case ButtonDemoType.toggle:
        buttons = _ToggleButtonsDemo();
        break;
      case ButtonDemoType.floating:
        buttons = _FloatingActionButtonDemo();
        break;
    }

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(_title(context)),
      ),
      body: buttons,
    );
  }
}

// BEGIN buttonDemoFlat

class _FlatButtonDemo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FlatButton(
            child: Text('BUTTON'),
            onPressed: () {},
          ),
          const SizedBox(height: 12),
          FlatButton.icon(
            icon: const Icon(Icons.add, size: 18),
            label: Text('BUTTON'),
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}

// END

// BEGIN buttonDemoRaised

class _RaisedButtonDemo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          RaisedButton(
            child: Text('BUTTON'),
            onPressed: () {},
          ),
          const SizedBox(height: 12),
          RaisedButton.icon(
            icon: const Icon(Icons.add, size: 18),
            label: Text('BUTTON'),
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}

// END

// BEGIN buttonDemoOutline

class _OutlineButtonDemo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          OutlineButton(
            // TODO: Should update to OutlineButton follow material spec.
            highlightedBorderColor:
                Theme.of(context).colorScheme.onSurface.withOpacity(0.12),
            child: Text('BUTTON'),
            onPressed: () {},
          ),
          const SizedBox(height: 12),
          OutlineButton.icon(
            // TODO: Should update to OutlineButton follow material spec.
            highlightedBorderColor:
                Theme.of(context).colorScheme.onSurface.withOpacity(0.12),
            icon: const Icon(Icons.add, size: 18),
            label: Text('BUTTON'),
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}

// END

// BEGIN buttonDemoToggle

class _ToggleButtonsDemo extends StatefulWidget {
  @override
  _ToggleButtonsDemoState createState() => _ToggleButtonsDemoState();
}

class _ToggleButtonsDemoState extends State<_ToggleButtonsDemo> {
  final isSelected = <bool>[false, false, false];

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ToggleButtons(
        children: const [
          Icon(Icons.ac_unit),
          Icon(Icons.call),
          Icon(Icons.cake),
        ],
        onPressed: (index) {
          setState(() {
            isSelected[index] = !isSelected[index];
          });
        },
        isSelected: isSelected,
      ),
    );
  }
}

// END

// BEGIN buttonDemoFloating

class _FloatingActionButtonDemo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FloatingActionButton(
            child: const Icon(Icons.add),
            onPressed: () {},
            tooltip: 'Create',
          ),
          const SizedBox(height: 20),
          FloatingActionButton.extended(
            icon: const Icon(Icons.add),
            label: Text('Create'),
            onPressed: () {},
          ),
        ],
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
      home: ButtonDemo(),
    );
  }
}

