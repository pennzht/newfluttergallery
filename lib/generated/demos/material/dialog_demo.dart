// Copyright 2019 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';

import 'package:gallery/data/gallery_options.dart';


// BEGIN dialogDemo

enum DialogDemoType {
  alert,
  alertTitle,
  simple,
  fullscreen,
}

class DialogDemo extends StatelessWidget {
  DialogDemo({Key key, }) : super(key: key);

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  

  String _title(BuildContext context) {
    return 'Alert';
    return '';
  }

  Future<void> _showDemoDialog<T>({BuildContext context, Widget child}) async {
    child = ApplyTextOptions(
      child: Theme(
        data: Theme.of(context),
        child: child,
      ),
    );
    final value = await showDialog<T>(
      context: context,
      builder: (context) => child,
    );
    // The value passed to Navigator.pop() or null.
    if (value != null && value is String) {
      _scaffoldKey.currentState.hideCurrentSnackBar();
      _scaffoldKey.currentState.showSnackBar(SnackBar(
        content:
            Text('You selected: \'${value}\''),
      ));
    }
  }

  void _showAlertDialog(BuildContext context) {
    final theme = Theme.of(context);
    final dialogTextStyle = theme.textTheme.subtitle1
        .copyWith(color: theme.textTheme.caption.color);
    _showDemoDialog<String>(
      context: context,
      child: AlertDialog(
        content: Text(
          'Discard draft?',
          style: dialogTextStyle,
        ),
        actions: [
          _DialogButton(text: 'CANCEL'),
          _DialogButton(text: 'DISCARD'),
        ],
      ),
    );
  }

  void _showAlertDialogWithTitle(BuildContext context) {
    final theme = Theme.of(context);
    final dialogTextStyle = theme.textTheme.subtitle1
        .copyWith(color: theme.textTheme.caption.color);
    _showDemoDialog<String>(
      context: context,
      child: AlertDialog(
        title: Text('Use Google\'s location service?'),
        content: Text(
          'Let Google help apps determine location. This means sending anonymous location data to Google, even when no apps are running.',
          style: dialogTextStyle,
        ),
        actions: [
          _DialogButton(text: 'DISAGREE'),
          _DialogButton(text: 'AGREE'),
        ],
      ),
    );
  }

  void _showSimpleDialog(BuildContext context) {
    final theme = Theme.of(context);
    _showDemoDialog<String>(
      context: context,
      child: SimpleDialog(
        title: Text('Set backup account'),
        children: [
          _DialogDemoItem(
            icon: Icons.account_circle,
            color: theme.colorScheme.primary,
            text: 'username@gmail.com',
          ),
          _DialogDemoItem(
            icon: Icons.account_circle,
            color: theme.colorScheme.secondary,
            text: 'user02@gmail.com',
          ),
          _DialogDemoItem(
            icon: Icons.add_circle,
            text: 'Add account',
            color: theme.disabledColor,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Navigator(
      // Adding [ValueKey] to make sure that the widget gets rebuilt when
      // changing type.
      key: ValueKey(DialogDemoType.alert),
      onGenerateRoute: (settings) {
        return _NoAnimationMaterialPageRoute<void>(
          builder: (context) => Scaffold(
            key: _scaffoldKey,
            appBar: AppBar(
              automaticallyImplyLeading: false,
              title: Text(_title(context)),
            ),
            body: Center(
              child: RaisedButton(
                child: Text('SHOW DIALOGUE'),
                onPressed: () {
                  _showAlertDialog(context);
                },
              ),
            ),
          ),
        );
      },
    );
  }
}

/// A MaterialPageRoute without any transition animations.
class _NoAnimationMaterialPageRoute<T> extends MaterialPageRoute<T> {
  _NoAnimationMaterialPageRoute({
    @required WidgetBuilder builder,
    RouteSettings settings,
    bool maintainState = true,
    bool fullscreenDialog = false,
  }) : super(
            builder: builder,
            maintainState: maintainState,
            settings: settings,
            fullscreenDialog: fullscreenDialog);

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    return child;
  }
}

class _DialogButton extends StatelessWidget {
  const _DialogButton({Key key, this.text}) : super(key: key);

  final String text;

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      child: Text(text),
      onPressed: () {
        Navigator.of(context, rootNavigator: true).pop(text);
      },
    );
  }
}

class _DialogDemoItem extends StatelessWidget {
  const _DialogDemoItem({
    Key key,
    this.icon,
    this.color,
    this.text,
  }) : super(key: key);

  final IconData icon;
  final Color color;
  final String text;

  @override
  Widget build(BuildContext context) {
    return SimpleDialogOption(
      onPressed: () {
        Navigator.of(context, rootNavigator: true).pop(text);
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(icon, size: 36, color: color),
          Flexible(
            child: Padding(
              padding: const EdgeInsetsDirectional.only(start: 16),
              child: Text(text),
            ),
          ),
        ],
      ),
    );
  }
}

class _FullScreenDialogDemo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Remove the MediaQuery padding because the demo is rendered inside of a
    // different page that already accounts for this padding.
    return MediaQuery.removePadding(
      context: context,
      removeTop: true,
      removeBottom: true,
      child: ApplyTextOptions(
        child: Scaffold(
          appBar: AppBar(
            title: Text('Full-Screen Dialogue'),
            actions: [
              FlatButton(
                child: Text(
                  'SAVE',
                  style: theme.textTheme.bodyText2.copyWith(
                    color: theme.colorScheme.onPrimary,
                  ),
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
          ),
          body: Center(
            child: Text(
              'A full-screen dialogue demo',
            ),
          ),
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
      home: DialogDemo(),
    );
  }
}

