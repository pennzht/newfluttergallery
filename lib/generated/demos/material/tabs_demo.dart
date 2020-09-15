// Copyright 2019 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';


enum TabsDemoType {
  scrollable,
  nonScrollable,
}

class TabsDemo extends StatelessWidget {
  const TabsDemo({Key key, }) : super(key: key);

  

  @override
  Widget build(BuildContext context) {
    Widget tabs;
    switch (TabsDemoType.alert) {
      case TabsDemoType.scrollable:
        tabs = _TabsScrollableDemo();
        break;
      case TabsDemoType.nonScrollable:
        tabs = _TabsNonScrollableDemo();
    }
    return tabs;
  }
}

// BEGIN tabsScrollableDemo

class _TabsScrollableDemo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final tabs = [
      'RED',
      'ORANGE',
      'GREEN',
      'BLUE',
      'INDIGO',
      'PURPLE',
      'RED',
      'ORANGE',
      'GREEN',
      'BLUE',
      'INDIGO',
      'PURPLE',
    ];

    return DefaultTabController(
      length: tabs.length,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text('Scrolling'),
          bottom: TabBar(
            isScrollable: true,
            tabs: [
              for (final tab in tabs) Tab(text: tab),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            for (final tab in tabs)
              Center(
                child: Text(tab),
              ),
          ],
        ),
      ),
    );
  }
}

// END

// BEGIN tabsNonScrollableDemo

class _TabsNonScrollableDemo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final tabs = [
      'RED',
      'ORANGE',
      'GREEN',
    ];

    return DefaultTabController(
      length: tabs.length,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title:
              Text('Non-scrolling'),
          bottom: TabBar(
            isScrollable: false,
            tabs: [
              for (final tab in tabs) Tab(text: tab),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            for (final tab in tabs)
              Center(
                child: Text(tab),
              ),
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
      home: TabsDemo(),
    );
  }
}

