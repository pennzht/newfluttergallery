// Copyright 2014 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';

import 'package:flutter/material.dart';

import 'package:gallery/main.dart';

import 'recorder.dart';
import 'test_data.dart';

/// Creates an infinite list of Material cards and scrolls it.
class Directed extends WidgetRecorder {
  Directed() : super(name: benchmarkName);

  static const String benchmarkName = 'directed';

  @override
  Widget createWidget() => const MaterialApp(
        title: 'Infinite Card Scroll Benchmark',
        home: _DirectedCards(),
      );
}

class _DirectedCards extends StatefulWidget {
  const _DirectedCards({Key key}) : super(key: key);

  @override
  State<_DirectedCards> createState() => _DirectedCardsState();
}

class _DirectedCardsState extends State<_DirectedCards> {
  ScrollController scrollController;

  double offset;
  static const double distance = 1000;
  static const Duration stepDuration = Duration(seconds: 1);

  @override
  void initState() {
    super.initState();

    scrollController = ScrollController();
    offset = 0;

    // Without the timer the animation doesn't begin.
    Timer.run(() async {
      while (true) {
        await scrollController.animateTo(
          offset + distance,
          curve: Curves.linear,
          duration: stepDuration,
        );
        offset += distance;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return GalleryApp();
  }
}
