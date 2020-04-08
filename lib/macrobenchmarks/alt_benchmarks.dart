// Copyright 2014 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

/* This file contains benchmark tests that are used in
   flutter_driver tests. */

import 'dart:async';
import 'dart:convert' show json;
import 'dart:html' as html;

import 'src/web/bench_text_layout.dart';
import 'src/web/bench_text_out_of_picture_bounds.dart';

import 'src/web/bench_build_material_checkbox.dart';
import 'src/web/bench_card_infinite_scroll.dart';
import 'src/web/bench_draw_rect.dart';
import 'src/web/bench_dynamic_clip_on_static_picture.dart';
import 'src/web/bench_simple_lazy_text_scroll.dart';
import 'src/web/bench_text_out_of_picture_bounds.dart';
import 'src/web/bench_experimental.dart';
import 'src/web/bench_gallery.dart';
import 'src/web/bench_directed.dart';
import 'src/web/recorder.dart';

typedef RecorderFactory = Recorder Function();

const bool isCanvasKit = bool.fromEnvironment('FLUTTER_WEB_USE_SKIA', defaultValue: false);

final RecorderFactory benchmark = () => Galleries();

Future<void> main() async {
  print('Debug: running alt_benchmarks.dart');

  await _runBenchmark(benchmark);
  // html.window.location.reload();
}

Future<void> _runBenchmark(RecorderFactory benchmark) async {

  print('Debug: alt_benchmarks.dart -> _runBenchmark');
  final RecorderFactory recorderFactory = benchmark;

  final Recorder recorder = recorderFactory();

  try {
    final Profile profile = await recorder.run();
    print('profile = $profile');
    print('profile.toJson() = ${profile.toJson()}');
    print('profile.scoreData = ${profile.scoreData}');
    print('profile.scoreData[...]/a = ${profile.scoreData["drawFrameDuration"].allValues}');
    print('profile.scoreData[...]/m = ${profile.scoreData["drawFrameDuration"].measuredValues}');
  } catch (error, stackTrace) {
    print('error: $error, stackTrace: $stackTrace');
    await html.HttpRequest.request(
      '/on-error',
      method: 'POST',
      mimeType: 'application/json',
      sendData: json.encode(<String, dynamic>{
        'error': '$error',
        'stackTrace': '$stackTrace',
      }),
    );
  }
}
