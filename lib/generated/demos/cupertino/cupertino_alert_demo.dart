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
        title: Text(GalleryLocalizations.of(context).dialogDiscardTitle),
        actions: [
          CupertinoDialogAction(
            child: Text(
              GalleryLocalizations.of(context).cupertinoAlertDiscard,
            ),
            isDestructiveAction: true,
            onPressed: () => Navigator.of(context, rootNavigator: true).pop(
              GalleryLocalizations.of(context).cupertinoAlertDiscard,
            ),
          ),
          CupertinoDialogAction(
            child: Text(
              GalleryLocalizations.of(context).cupertinoAlertCancel,
            ),
            isDefaultAction: true,
            onPressed: () => Navigator.of(context, rootNavigator: true).pop(
              GalleryLocalizations.of(context).cupertinoAlertCancel,
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
          GalleryLocalizations.of(context).cupertinoAlertLocationTitle,
        ),
        content: Text(
          GalleryLocalizations.of(context).cupertinoAlertLocationDescription,
        ),
        actions: [
          CupertinoDialogAction(
            child: Text(
              GalleryLocalizations.of(context).cupertinoAlertDontAllow,
            ),
            onPressed: () => Navigator.of(context, rootNavigator: true).pop(
              GalleryLocalizations.of(context).cupertinoAlertDontAllow,
            ),
          ),
          CupertinoDialogAction(
            child: Text(
              GalleryLocalizations.of(context).cupertinoAlertAllow,
            ),
            onPressed: () => Navigator.of(context, rootNavigator: true).pop(
              GalleryLocalizations.of(context).cupertinoAlertAllow,
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
          GalleryLocalizations.of(context).cupertinoAlertFavoriteDessert,
        ),
        content: Text(
          GalleryLocalizations.of(context).cupertinoAlertDessertDescription,
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
          GalleryLocalizations.of(context).cupertinoAlertFavoriteDessert,
        ),
        message: Text(
          GalleryLocalizations.of(context).cupertinoAlertDessertDescription,
        ),
        actions: [
          CupertinoActionSheetAction(
            child: Text(
              GalleryLocalizations.of(context).cupertinoAlertCheesecake,
            ),
            onPressed: () => Navigator.of(context, rootNavigator: true).pop(
              GalleryLocalizations.of(context).cupertinoAlertCheesecake,
            ),
          ),
          CupertinoActionSheetAction(
            child: Text(
              GalleryLocalizations.of(context).cupertinoAlertTiramisu,
            ),
            onPressed: () => Navigator.of(context, rootNavigator: true).pop(
              GalleryLocalizations.of(context).cupertinoAlertTiramisu,
            ),
          ),
          CupertinoActionSheetAction(
            child: Text(
              GalleryLocalizations.of(context).cupertinoAlertApplePie,
            ),
            onPressed: () => Navigator.of(context, rootNavigator: true).pop(
              GalleryLocalizations.of(context).cupertinoAlertApplePie,
            ),
          ),
        ],
        cancelButton: CupertinoActionSheetAction(
          child: Text(
            GalleryLocalizations.of(context).cupertinoAlertCancel,
          ),
          isDefaultAction: true,
          onPressed: () => Navigator.of(context, rootNavigator: true).pop(
            GalleryLocalizations.of(context).cupertinoAlertCancel,
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
              GalleryLocalizations.of(context).cupertinoAlertCheesecake,
            );
          },
        ),
        CupertinoDialogAction(
          child: Text(
            'Tiramisu',
          ),
          onPressed: () {
            Navigator.of(context, rootNavigator: true).pop(
              GalleryLocalizations.of(context).cupertinoAlertTiramisu,
            );
          },
        ),
        CupertinoDialogAction(
          child: Text(
            'Apple Pie',
          ),
          onPressed: () {
            Navigator.of(context, rootNavigator: true).pop(
              GalleryLocalizations.of(context).cupertinoAlertApplePie,
            );
          },
        ),
        CupertinoDialogAction(
          child: Text(
            'Chocolate brownie',
          ),
          onPressed: () {
            Navigator.of(context, rootNavigator: true).pop(
              GalleryLocalizations.of(context).cupertinoAlertChocolateBrownie,
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
              GalleryLocalizations.of(context).cupertinoAlertCancel,
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
    return MaterialApp(
      home: CupertinoAlertDemo(),
    );
  }
}

