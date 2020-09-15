// Copyright 2019 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';



enum MenuDemoType {
  contextMenu,
  sectionedMenu,
  simpleMenu,
  checklistMenu,
}

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
        title: Text('Menu'),
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

// BEGIN menuDemoContext

// Pressing the PopupMenuButton on the right of this item shows
// a simple menu with one disabled item. Typically the contents
// of this "contextual menu" would reflect the app's state.
class _ContextMenuDemo extends StatelessWidget {
  const _ContextMenuDemo({Key key, this.showInSnackBar}) : super(key: key);

  final void Function(String value) showInSnackBar;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text('An item with a context menu'),
      trailing: PopupMenuButton<String>(
        padding: EdgeInsets.zero,
        onSelected: (value) => showInSnackBar(
          'Selected: ${value}',
        ),
        itemBuilder: (context) => <PopupMenuItem<String>>[
          PopupMenuItem<String>(
            value: 'Context menu item one',
            child: Text(
              'Context menu item one',
            ),
          ),
          PopupMenuItem<String>(
            enabled: false,
            child: Text(
              'Disabled menu item',
            ),
          ),
          PopupMenuItem<String>(
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

// END

// BEGIN menuDemoSectioned

// Pressing the PopupMenuButton on the right of this item shows
// a menu whose items have text labels and icons and a divider
// That separates the first three items from the last one.
class _SectionedMenuDemo extends StatelessWidget {
  const _SectionedMenuDemo({Key key, this.showInSnackBar}) : super(key: key);

  final void Function(String value) showInSnackBar;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
          'An item with a sectioned menu'),
      trailing: PopupMenuButton<String>(
        padding: EdgeInsets.zero,
        onSelected: (value) => showInSnackBar(
            'Selected: ${value}'),
        itemBuilder: (context) => <PopupMenuEntry<String>>[
          PopupMenuItem<String>(
            value: 'Preview',
            child: ListTile(
              leading: const Icon(Icons.visibility),
              title: Text(
                'Preview',
              ),
            ),
          ),
          PopupMenuItem<String>(
            value: 'Share',
            child: ListTile(
              leading: const Icon(Icons.person_add),
              title: Text(
                'Share',
              ),
            ),
          ),
          PopupMenuItem<String>(
            value: 'Get link',
            child: ListTile(
              leading: const Icon(Icons.link),
              title: Text(
                'Get link',
              ),
            ),
          ),
          const PopupMenuDivider(),
          PopupMenuItem<String>(
            value: 'Remove',
            child: ListTile(
              leading: const Icon(Icons.delete),
              title: Text(
                'Remove',
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// END

// BEGIN menuDemoSimple

// This entire list item is a PopupMenuButton. Tapping anywhere shows
// a menu whose current value is highlighted and aligned over the
// list item's center line.
class _SimpleMenuDemo extends StatefulWidget {
  const _SimpleMenuDemo({Key key, this.showInSnackBar}) : super(key: key);

  final void Function(String value) showInSnackBar;

  @override
  _SimpleMenuDemoState createState() => _SimpleMenuDemoState();
}

class _SimpleMenuDemoState extends State<_SimpleMenuDemo> {
  SimpleValue _simpleValue;

  void showAndSetMenuSelection(BuildContext context, SimpleValue value) {
    setState(() {
      _simpleValue = value;
    });
    widget.showInSnackBar(
      'Selected: ${simpleValueToString(context, value)}',
    );
  }

  String simpleValueToString(BuildContext context, SimpleValue value) => {
        SimpleValue.one: 'Menu item one',
        SimpleValue.two: 'Menu item two',
        SimpleValue.three:
            'Menu item three',
      }[value];

  @override
  void initState() {
    super.initState();
    _simpleValue = SimpleValue.two;
  }

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<SimpleValue>(
      padding: EdgeInsets.zero,
      initialValue: _simpleValue,
      onSelected: (value) => showAndSetMenuSelection(context, value),
      child: ListTile(
        title: Text(
            'An item with a simple menu'),
        subtitle: Text(simpleValueToString(context, _simpleValue)),
      ),
      itemBuilder: (context) => <PopupMenuItem<SimpleValue>>[
        PopupMenuItem<SimpleValue>(
          value: SimpleValue.one,
          child: Text(simpleValueToString(
            context,
            SimpleValue.one,
          )),
        ),
        PopupMenuItem<SimpleValue>(
          value: SimpleValue.two,
          child: Text(simpleValueToString(
            context,
            SimpleValue.two,
          )),
        ),
        PopupMenuItem<SimpleValue>(
          value: SimpleValue.three,
          child: Text(simpleValueToString(
            context,
            SimpleValue.three,
          )),
        ),
      ],
    );
  }
}

// END

// BEGIN menuDemoChecklist

// Pressing the PopupMenuButton on the right of this item shows a menu
// whose items have checked icons that reflect this app's state.
class _ChecklistMenuDemo extends StatefulWidget {
  const _ChecklistMenuDemo({Key key, this.showInSnackBar}) : super(key: key);

  final void Function(String value) showInSnackBar;

  @override
  _ChecklistMenuDemoState createState() => _ChecklistMenuDemoState();
}

class _ChecklistMenuDemoState extends State<_ChecklistMenuDemo> {
  List<CheckedValue> _checkedValues;

  @override
  void initState() {
    super.initState();
    _checkedValues = [CheckedValue.three];
  }

  void showCheckedMenuSelections(BuildContext context, CheckedValue value) {
    if (_checkedValues.contains(value)) {
      setState(() {
        _checkedValues.remove(value);
      });
    } else {
      setState(() {
        _checkedValues.add(value);
      });
    }

    widget.showInSnackBar(
      'Checked: ${_checkedValues.map((value) => checkedValueToString(context, value))}',
    );
  }

  String checkedValueToString(BuildContext context, CheckedValue value) => {
        CheckedValue.one: 'One',
        CheckedValue.two: 'Two',
        CheckedValue.three: 'Three',
        CheckedValue.four: 'Four',
      }[value];

  bool isChecked(CheckedValue value) => _checkedValues.contains(value);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
          'An item with a checklist menu'),
      trailing: PopupMenuButton<CheckedValue>(
        padding: EdgeInsets.zero,
        onSelected: (value) => showCheckedMenuSelections(context, value),
        itemBuilder: (context) => <PopupMenuItem<CheckedValue>>[
          CheckedPopupMenuItem<CheckedValue>(
            value: CheckedValue.one,
            checked: isChecked(CheckedValue.one),
            child: Text(
              checkedValueToString(context, CheckedValue.one),
            ),
          ),
          CheckedPopupMenuItem<CheckedValue>(
            value: CheckedValue.two,
            enabled: false,
            checked: isChecked(CheckedValue.two),
            child: Text(
              checkedValueToString(context, CheckedValue.two),
            ),
          ),
          CheckedPopupMenuItem<CheckedValue>(
            value: CheckedValue.three,
            checked: isChecked(CheckedValue.three),
            child: Text(
              checkedValueToString(context, CheckedValue.three),
            ),
          ),
          CheckedPopupMenuItem<CheckedValue>(
            value: CheckedValue.four,
            checked: isChecked(CheckedValue.four),
            child: Text(
              checkedValueToString(context, CheckedValue.four),
            ),
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
      home: MenuDemo(),
    );
  }
}

