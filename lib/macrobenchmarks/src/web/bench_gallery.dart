// Copyright 2014 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';

import 'package:flutter/material.dart';

import 'package:gallery/main.dart';

import 'recorder.dart';
import 'test_data.dart';

/// Creates an infinite list of Material cards and scrolls it.
class Galleries extends WidgetRecorder {
  // WidgetRecorder.

  Galleries({@required this.controller, @required this.openStudy}) : super(name: benchmarkName);

  static const String benchmarkName = 'galleries';
  final ScrollController controller;
  final List<void Function()> openStudy;

  @override
  Widget createWidget() => GalleryApp(controller: controller, openStudy: openStudy);
}
