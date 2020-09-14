// Copyright 2019 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';

enum SimpleValue {
  one,
  two,
  three,
}

enum CheckedValue {
  one,
  two,
  three,
  four,
}

class MenuDemo extends StatefulWidget {
  const MenuDemo({Key key, }) : super(key: key);

  @override
  _MenuDemoState createState() => _MenuDemoState();
}

class _MenuDemoState extends State<MenuDemo> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  void showInSnackBar(String value) {
    _scaffoldKey.currentState.hideCurrentSnackBar();
    _scaffoldKey.currentState.showSnackBar(SnackBar(
      content: Text(value),
    ));
  }

  @override
  Widget build(BuildContext context) {
    Widget demo;
    demo = _ContextMenuDemo(showInSnackBar: showInSnackBar);

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: const Text('Menu'),
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Center(
          child: demo,
        ),
      ),
    );
  }
}

// Pressing the PopupMenuButton on the right of this item shows
// a simple menu with one disabled item. Typically the contents
// of this "contextual menu" would reflect the app's state.
class _ContextMenuDemo extends StatelessWidget {
  const _ContextMenuDemo({Key key, this.showInSnackBar}) : super(key: key);

  final void Function(String value) showInSnackBar;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: const Text('An item with a context menu'),
      trailing: PopupMenuButton<String>(
        padding: EdgeInsets.zero,
        onSelected: (value) => showInSnackBar(
          'Selected: $value',
        ),
        itemBuilder: (context) => <PopupMenuItem<String>>[
          const PopupMenuItem<String>(
            value: 'Context menu item one',
            child: Text(
              'Context menu item one',
            ),
          ),
          const PopupMenuItem<String>(
            enabled: false,
            child: Text(
              'Disabled menu item',
            ),
          ),
          const PopupMenuItem<String>(
            value:
                'Context menu item three',
            child: Text(
              'Context menu item three',
            ),
          ),
        ],
      ),
    );
  }
}
