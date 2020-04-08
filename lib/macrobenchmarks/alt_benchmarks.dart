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

/// Whether we fell back to manual mode.
///
/// This happens when you run benchmarks using plain `flutter run` rather than
/// devicelab test harness. The test harness spins up a special server that
/// provides API for automatically picking the next benchmark to run.
bool isInManualMode = false;

Future<void> main() async {

  /*

  // Check if the benchmark server wants us to run a specific benchmark.
  final html.HttpRequest request = await requestXhr(
    '/next-benchmark',
    method: 'POST',
    mimeType: 'application/json',
    sendData: json.encode(benchmarks.keys.toList()),
  );

  // 404 is expected in the following cases:
  // - The benchmark is ran using plain `flutter run`, which does not provide "next-benchmark" handler.
  // - We ran all benchmarks and the benchmark is telling us there are no more benchmarks to run.
  if (request.status == 404) {
    _fallbackToManual('The server did not tell us which benchmark to run next.');
    return;
  }

  final String benchmarkName = request.responseText;

   */

  final String benchmarkName = 'bench_card_infinite_scroll';


  print('running benchmark $benchmarkName');

  await _runBenchmark(benchmarkName);
  // html.window.location.reload();
}

Future<void> _runBenchmark(String benchmarkName) async {

  print('running benchmark $benchmarkName >>>');
  final RecorderFactory recorderFactory = benchmarks[benchmarkName];

  if (recorderFactory == null) {
    print('recorderFactory is null');
    _fallbackToManual('Benchmark $benchmarkName not found.');
    return;
  }
  print('recorderFactory is not null');

  final Recorder recorder = recorderFactory();

  try {
    print('isInManualMode = $isInManualMode');
    final Profile profile = await recorder.run();
    print('profile = $profile');
    print('profile.toJson() = ${profile.toJson()}');
    print('profile.scoreData = ${profile.scoreData}');
    print('profile.scoreData[...]/a = ${profile.scoreData["drawFrameDuration"].allValues}');
    print('profile.scoreData[...]/m = ${profile.scoreData["drawFrameDuration"].measuredValues}');
    /*
    if (!isInManualMode) {
      final html.HttpRequest request = await html.HttpRequest.request(
        '/profile-data',
        method: 'POST',
        mimeType: 'application/json',
        sendData: json.encode(profile.toJson()),
      );
      if (request.status != 200) {
        throw Exception(
          'Failed to report profile data to benchmark server. '
          'The server responded with status code ${request.status}.'
        );
      }
    } else {
      print(profile);
    }

     */
  } catch (error, stackTrace) {
    print('error: $error, stackTrace: $stackTrace');
    if (isInManualMode) {
      rethrow;
    }
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

void _fallbackToManual(String error) {
  isInManualMode = true;
  html.document.body.appendHtml('''
    <div id="manual-panel">
      <h3>$error</h3>

      <p>Choose one of the following benchmarks:</p>

      <!-- Absolutely position it so it receives the clicks and not the glasspane -->
      <ul style="position: absolute">
        ${
          benchmarks.keys
            .map((String name) => '<li><button id="$name">$name</button></li>')
            .join('\n')
        }
      </ul>
    </div>
  ''', validator: html.NodeValidatorBuilder()..allowHtml5()..allowInlineStyles());

  for (final String benchmarkName in benchmarks.keys) {
    final html.Element button = html.document.querySelector('#$benchmarkName');
    button.addEventListener('click', (_) {
      final html.Element manualPanel = html.document.querySelector('#manual-panel');
      manualPanel?.remove();
      _runBenchmark(benchmarkName);
    });
  }
}

Future<html.HttpRequest> requestXhr(
  String url, {
  String method,
  bool withCredentials,
  String responseType,
  String mimeType,
  Map<String, String> requestHeaders,
  dynamic sendData,
}) {
  final Completer<html.HttpRequest> completer = Completer<html.HttpRequest>();
  final html.HttpRequest xhr = html.HttpRequest();

  method ??= 'GET';
  xhr.open(method, url, async: true);

  if (withCredentials != null) {
    xhr.withCredentials = withCredentials;
  }

  if (responseType != null) {
    xhr.responseType = responseType;
  }

  if (mimeType != null) {
    xhr.overrideMimeType(mimeType);
  }

  if (requestHeaders != null) {
    requestHeaders.forEach((String header, String value) {
      xhr.setRequestHeader(header, value);
    });
  }

  xhr.onLoad.listen((html.ProgressEvent e) {
    completer.complete(xhr);
  });

  xhr.onError.listen(completer.completeError);

  if (sendData != null) {
    xhr.send(sendData);
  } else {
    xhr.send();
  }

  return completer.future;
}
