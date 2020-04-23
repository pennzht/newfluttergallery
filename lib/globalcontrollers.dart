/// TODO: Insert copyright notice here.

import 'package:flutter/material.dart';

class GlobalControllers extends InheritedWidget {
  const GlobalControllers({
    Key key,
    @required this.controller,
    @required this.child,
    @required this.openStudy,
  }): super(key: key, child: child);

  final ScrollController controller;
  final List<void Function()> openStudy;
  final Widget child;

  static GlobalControllers of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<GlobalControllers>();
  }

  @override
  bool updateShouldNotify(GlobalControllers old)
      => old.controller != controller;
}

