// Copyright 2019 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/cupertino.dart';


import 'package:gallery/data/gallery_options.dart';

// BEGIN cupertinoAlertDemo

enum AlertDemoType {
  alert,
  alertTitle,
  alertButtons,
  alertButtonsOnly,
  actionSheet,
}

class CupertinoAlertDemo extends StatefulWidget {
  const CupertinoAlertDemo({
    Key key,
    ,
  }) : super(key: key);

  

  @override
  _CupertinoAlertDemoState createState() => _CupertinoAlertDemoState();
}

class _CupertinoAlertDemoState extends State<CupertinoAlertDemo> {
  String lastSelectedValue;

  String _title(BuildContext context) {
    return 'Alert';
    return '';
  }

  void _showDemoDialog({BuildContext context, Widget child}) {
    showCupertinoDialog<String>(
      context: context,
      builder: (context) => ApplyTextOptions(child: child),
    ).then((value) {
      if (value != null) {
        setState(() {
          lastSelectedValue = value;
        });
      }
    });
  }

  void _showDemoActionSheet({BuildContext context, Widget child}) {
    child = ApplyTextOptions(
      child: CupertinoTheme(
        data: CupertinoTheme.of(context),
        child: child,
      ),
    );
    showCupertinoModalPopup<String>(
      context: context,
      builder: (context) => child,
    ).then((value) {
      if (value != null) {
        setState(() {
          lastSelectedValue = value;
        });
      }
    });
  }

  void _onAlertPress(BuildContext context) {
    _showDemoDialog(
      context: context,
      child: CupertinoAlertDialog(
        title: Text('Discard draft?'),
        actions: [
          CupertinoDialogAction(
            child: Text(
              'Discard',
            ),
            isDestructiveAction: true,
            onPressed: () => Navigator.of(context, rootNavigator: true).pop(
              'Discard',
            ),
          ),
          CupertinoDialogAction(
            child: Text(
              'Cancel',
            ),
            isDefaultAction: true,
            onPressed: () => Navigator.of(context, rootNavigator: true).pop(
              'Cancel',
            ),
          ),
        ],
      ),
    );
  }

  void _onAlertWithTitlePress(BuildContext context) {
    _showDemoDialog(
      context: context,
      child: CupertinoAlertDialog(
        title: Text(
          'Allow \'Maps\' to access your location while you are using the app?',
        ),
        content: Text(
          'Your current location will be displayed on the map and used for directions, nearby search results and estimated travel times.',
        ),
        actions: [
          CupertinoDialogAction(
            child: Text(
              'Don\'t allow',
            ),
            onPressed: () => Navigator.of(context, rootNavigator: true).pop(
              'Don\'t allow',
            ),
          ),
          CupertinoDialogAction(
            child: Text(
              'Allow',
            ),
            onPressed: () => Navigator.of(context, rootNavigator: true).pop(
              'Allow',
            ),
          ),
        ],
      ),
    );
  }

  void _onAlertWithButtonsPress(BuildContext context) {
    _showDemoDialog(
      context: context,
      child: CupertinoDessertDialog(
        title: Text(
          'Select Favourite Dessert',
        ),
        content: Text(
          'Please select your favourite type of dessert from the list below. Your selection will be used to customise the suggested list of eateries in your area.',
        ),
      ),
    );
  }

  void _onAlertButtonsOnlyPress(BuildContext context) {
    _showDemoDialog(
      context: context,
      child: const CupertinoDessertDialog(),
    );
  }

  void _onActionSheetPress(BuildContext context) {
    _showDemoActionSheet(
      context: context,
      child: CupertinoActionSheet(
        title: Text(
          'Select Favourite Dessert',
        ),
        message: Text(
          'Please select your favourite type of dessert from the list below. Your selection will be used to customise the suggested list of eateries in your area.',
        ),
        actions: [
          CupertinoActionSheetAction(
            child: Text(
              'Cheesecake',
            ),
            onPressed: () => Navigator.of(context, rootNavigator: true).pop(
              'Cheesecake',
            ),
          ),
          CupertinoActionSheetAction(
            child: Text(
              'Tiramisu',
            ),
            onPressed: () => Navigator.of(context, rootNavigator: true).pop(
              'Tiramisu',
            ),
          ),
          CupertinoActionSheetAction(
            child: Text(
              'Apple Pie',
            ),
            onPressed: () => Navigator.of(context, rootNavigator: true).pop(
              'Apple Pie',
            ),
          ),
        ],
        cancelButton: CupertinoActionSheetAction(
          child: Text(
            'Cancel',
          ),
          isDefaultAction: true,
          onPressed: () => Navigator.of(context, rootNavigator: true).pop(
            'Cancel',
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        automaticallyImplyLeading: false,
        middle: Text(_title(context)),
      ),
      child: Builder(
        builder: (context) {
          return Column(
            children: [
              Expanded(
                child: Center(
                  child: CupertinoButton.filled(
                    child: Text(
                      'Show alert',
                    ),
                    onPressed: () {
                      _onAlertPress(context);
                    },
                  ),
                ),
              ),
              if (lastSelectedValue != null)
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    'You selected: \'${lastSelectedValue}\'',
                    style: CupertinoTheme.of(context).textTheme.textStyle,
                    textAlign: TextAlign.center,
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}

class CupertinoDessertDialog extends StatelessWidget {
  const CupertinoDessertDialog({Key key, this.title, this.content})
      : super(key: key);

  final Widget title;
  final Widget content;

  @override
  Widget build(BuildContext context) {
    return CupertinoAlertDialog(
      title: title,
      content: content,
      actions: [
        CupertinoDialogAction(
          child: Text(
            'Cheesecake',
          ),
          onPressed: () {
            Navigator.of(context, rootNavigator: true).pop(
              'Cheesecake',
            );
          },
        ),
        CupertinoDialogAction(
          child: Text(
            'Tiramisu',
          ),
          onPressed: () {
            Navigator.of(context, rootNavigator: true).pop(
              'Tiramisu',
            );
          },
        ),
        CupertinoDialogAction(
          child: Text(
            'Apple Pie',
          ),
          onPressed: () {
            Navigator.of(context, rootNavigator: true).pop(
              'Apple Pie',
            );
          },
        ),
        CupertinoDialogAction(
          child: Text(
            'Chocolate brownie',
          ),
          onPressed: () {
            Navigator.of(context, rootNavigator: true).pop(
              'Chocolate brownie',
            );
          },
        ),
        CupertinoDialogAction(
          child: Text(
            'Cancel',
          ),
          isDestructiveAction: true,
          onPressed: () {
            Navigator.of(context, rootNavigator: true).pop(
              'Cancel',
            );
          },
        ),
      ],
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
    return CupertinoApp(
      home: CupertinoAlertDemo(),
    );
  }
}

