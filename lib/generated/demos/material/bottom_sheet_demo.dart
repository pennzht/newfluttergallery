// Copyright 2019 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';



enum BottomSheetDemoType {
  persistent,
  modal,
}

class BottomSheetDemo extends StatelessWidget {
  const BottomSheetDemo({Key key, }) : super(key: key);

  

  String _title(BuildContext context) {
    return 'Persistent bottom sheet';
    return '';
  }

  Widget _bottomSheetDemo(BuildContext context) {
    return _PersistentBottomSheetDemo();
  }

  @override
  Widget build(BuildContext context) {
    // We wrap the demo in a [Navigator] to make sure that the modal bottom
    // sheets gets dismissed when changing demo.
    return Navigator(
      // Adding [ValueKey] to make sure that the widget gets rebuilt when
      // changing type.
      key: ValueKey(BottomSheetDemoType.persistent),
      onGenerateRoute: (settings) {
        return MaterialPageRoute<void>(
          builder: (context) => Scaffold(
            appBar: AppBar(
              automaticallyImplyLeading: false,
              title: Text(_title(context)),
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () {},
              backgroundColor: Theme.of(context).colorScheme.secondary,
              child: Icon(
                Icons.add,
                semanticLabel:
                    'Add',
              ),
            ),
            body: _bottomSheetDemo(context),
          ),
        );
      },
    );
  }
}

// BEGIN bottomSheetDemoModal#1 bottomSheetDemoPersistent#1

class _BottomSheetContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300,
      child: Column(
        children: [
          Container(
            height: 70,
            child: Center(
              child: Text(
                'Header',
                textAlign: TextAlign.center,
              ),
            ),
          ),
          const Divider(thickness: 1),
          Expanded(
            child: ListView.builder(
              itemCount: 21,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text('Item ${index}'),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

// END bottomSheetDemoModal#1 bottomSheetDemoPersistent#1

// BEGIN bottomSheetDemoModal#2

class _ModalBottomSheetDemo extends StatelessWidget {
  void _showModalBottomSheet(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      builder: (context) {
        return _BottomSheetContent();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: RaisedButton(
        onPressed: () {
          _showModalBottomSheet(context);
        },
        child: Text('SHOW BOTTOM SHEET'),
      ),
    );
  }
}

// END

// BEGIN bottomSheetDemoPersistent#2

class _PersistentBottomSheetDemo extends StatefulWidget {
  @override
  _PersistentBottomSheetDemoState createState() =>
      _PersistentBottomSheetDemoState();
}

class _PersistentBottomSheetDemoState
    extends State<_PersistentBottomSheetDemo> {
  VoidCallback _showBottomSheetCallback;

  @override
  void initState() {
    super.initState();
    _showBottomSheetCallback = _showPersistentBottomSheet;
  }

  void _showPersistentBottomSheet() {
    setState(() {
      // Disable the show bottom sheet button.
      _showBottomSheetCallback = null;
    });

    Scaffold.of(context)
        .showBottomSheet<void>(
          (context) {
            return _BottomSheetContent();
          },
          elevation: 25,
        )
        .closed
        .whenComplete(() {
          if (mounted) {
            setState(() {
              // Re-enable the bottom sheet button.
              _showBottomSheetCallback = _showPersistentBottomSheet;
            });
          }
        });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: RaisedButton(
        onPressed: _showBottomSheetCallback,
        child: Text('SHOW BOTTOM SHEET'),
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
      home: BottomSheetDemo(),
    );
  }
}

