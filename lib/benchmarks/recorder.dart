// Copyright 2014 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';
import 'dart:html' as html;
import 'dart:ui';

import 'package:meta/meta.dart';

import 'package:flutter/gestures.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

/// A function that performs asynchronous work.
typedef AsyncVoidCallback = Future<void> Function();

/// An [AsyncVoidCallback] that doesn't do anything.
///
/// This is used just so we don't have to deal with null all over the place.
Future<void> _dummyAsyncVoidCallback() async {}

/// Runs the benchmark using the given [recorder].
///
/// Notifies about "set up" and "tear down" events via the [setUpAllDidRun]
/// and [tearDownAllWillRun] callbacks.
@sealed
class Runner {
  /// Creates a runner for the [recorder].
  ///
  /// All arguments must not be null.
  Runner({
    @required this.recorder,
    this.setUpAllDidRun = _dummyAsyncVoidCallback,
    this.tearDownAllWillRun = _dummyAsyncVoidCallback,
  });

  /// The recorder that will run and record the benchmark.
  final Recorder recorder;

  /// Called immediately after [Recorder.setUpAll] future is resolved.
  ///
  /// This is useful, for example, to kick off a profiler or a tracer such that
  /// the "set up" computations are not included in the metrics.
  final AsyncVoidCallback setUpAllDidRun;

  /// Called just before calling [Recorder.tearDownAll].
  ///
  /// This is useful, for example, to stop a profiler or a tracer such that
  /// the "tear down" computations are not included in the metrics.
  final AsyncVoidCallback tearDownAllWillRun;

  /// Runs the benchmark and reports the results.
  Future<void> run() async {
    await recorder.setUpAll();
    await setUpAllDidRun();
    await recorder.run();
    await tearDownAllWillRun();
    await recorder.tearDownAll();
  }
}

/// Base class for benchmark recorders.
///
/// Each benchmark recorder has a [name] and a [run] method at a minimum.
abstract class Recorder {
  Recorder._(this.name, this.isTracingEnabled);

  /// Whether this recorder requires tracing using Chrome's DevTools Protocol's
  /// "Tracing" API.
  final bool isTracingEnabled;

  /// The name of the benchmark.
  ///
  /// The results displayed in the Flutter Dashboard will use this name as a
  /// prefix.
  final String name;

  /// Called once before all runs of this benchmark recorder.
  ///
  /// This is useful for doing one-time setup work that's needed for the
  /// benchmark.
  Future<void> setUpAll() async {}

  /// The implementation of the benchmark that will produce a [Profile].
  Future<void> run();

  /// Called once after all runs of this benchmark recorder.
  ///
  /// This is useful for doing one-time clean up work after the benchmark is
  /// complete.
  Future<void> tearDownAll() async {}
}

/// A (modified) recorder for benchmarking interactions with the framework by creating
/// widgets.
///
/// To implement a benchmark, extend this class and implement [createWidget].
///
/// Example:
///
/// ```
/// class BenchListView extends CustomWidgetRecorder {
///   BenchListView() : super(name: benchmarkName);
///
///   static const String benchmarkName = 'bench_list_view';
///
///   @override
///   Widget createWidget() {
///     return Directionality(
///       textDirection: TextDirection.ltr,
///       child: _TestListViewWidget(),
///     );
///   }
/// }
///
/// class _TestListViewWidget extends StatefulWidget {
///   @override
///   State<StatefulWidget> createState() {
///     return _TestListViewWidgetState();
///   }
/// }
///
/// class _TestListViewWidgetState extends State<_TestListViewWidget> {
///   ScrollController scrollController;
///
///   @override
///   void initState() {
///     super.initState();
///     scrollController = ScrollController();
///     Timer.run(() async {
///       bool forward = true;
///       while (true) {
///         await scrollController.animateTo(
///           forward ? 300 : 0,
///           curve: Curves.linear,
///           duration: const Duration(seconds: 1),
///         );
///         forward = !forward;
///       }
///     });
///   }
///
///   @override
///   Widget build(BuildContext context) {
///     return ListView.builder(
///       controller: scrollController,
///       itemCount: 10000,
///       itemBuilder: (BuildContext context, int index) {
///         return Text('Item #$index');
///       },
///     );
///   }
/// }
/// ```
abstract class CustomizedWidgetRecorder extends Recorder
    implements FrameRecorder {
  CustomizedWidgetRecorder({@required String name}) : super._(name, true);

  /// Creates a widget to be benchmarked.
  ///
  /// The widget must create its own animation to drive the benchmark. The
  /// animation should continue indefinitely. The benchmark harness will stop
  /// pumping frames automatically.
  Widget createWidget();

  @override
  VoidCallback didStop;

  Completer<void> _runCompleter;

  /// Tells whether the recorder should continue. Can be different from
  /// [profile.shouldContinue()].
  bool shouldContinue();

  @override
  @mustCallSuper
  void frameWillDraw() {
    startMeasureFrame();
  }

  @override
  @mustCallSuper
  void frameDidDraw() {
    endMeasureFrame();

    if (shouldContinue()) {
      window.scheduleFrame();
    } else {
      didStop();
      _runCompleter.complete();
    }
  }

  @override
  void _onError(dynamic error, StackTrace stackTrace) {
    _runCompleter.completeError(error, stackTrace);
  }

  @override
  Future<void> run() async {
    _runCompleter = Completer<void>();
    final _RecordingWidgetsBinding binding =
        _RecordingWidgetsBinding.ensureInitialized();
    final Widget widget = createWidget();

    binding._beginRecording(this, widget);

    try {
      await _runCompleter.future;
    } finally {
      _runCompleter = null;
    }
  }
}

/// Implemented by recorders that use [_RecordingWidgetsBinding] to receive
/// frame life-cycle calls.
abstract class FrameRecorder {
  /// Called by the recorder when it stops recording and doesn't need to collect
  /// any more data.
  set didStop(VoidCallback cb);

  /// Called just before calling [SchedulerBinding.handleDrawFrame].
  void frameWillDraw();

  /// Called immediately after calling [SchedulerBinding.handleDrawFrame].
  void frameDidDraw();

  /// Reports an error.
  ///
  /// The implementation is expected to halt benchmark execution as soon as possible.
  void _onError(dynamic error, StackTrace stackTrace);
}

/// A variant of [WidgetsBinding] that collaborates with a [Recorder] to decide
/// when to stop pumping frames.
///
/// A normal [WidgetsBinding] typically always pumps frames whenever a widget
/// instructs it to do so by calling [scheduleFrame] (transitively via
/// `setState`). This binding will stop pumping new frames as soon as benchmark
/// parameters are satisfactory (e.g. when the metric noise levels become low
/// enough).
class _RecordingWidgetsBinding extends BindingBase
    with
        GestureBinding,
        SchedulerBinding,
        ServicesBinding,
        PaintingBinding,
        SemanticsBinding,
        RendererBinding,
        WidgetsBinding {
  /// Makes an instance of [_RecordingWidgetsBinding] the current binding.
  static _RecordingWidgetsBinding ensureInitialized() {
    if (WidgetsBinding.instance == null) {
      _RecordingWidgetsBinding();
    }
    return WidgetsBinding.instance as _RecordingWidgetsBinding;
  }

  FrameRecorder _recorder;
  bool _hasErrored = false;

  /// To short-circuit all frame lifecycle methods when the benchmark has
  /// stopped collecting data.
  bool _benchmarkStopped = false;

  void _beginRecording(FrameRecorder recorder, Widget widget) {
    if (_recorder != null) {
      throw Exception(
        'Cannot call _RecordingWidgetsBinding._beginRecording more than once',
      );
    }
    final FlutterExceptionHandler originalOnError = FlutterError.onError;

    recorder.didStop = () {
      _benchmarkStopped = true;
    };

    // Fail hard and fast on errors. Benchmarks should not have any errors.
    FlutterError.onError = (FlutterErrorDetails details) {
      _haltBenchmarkWithError(details.exception, details.stack);
      originalOnError(details);
    };
    _recorder = recorder;
    runApp(widget);
  }

  void _haltBenchmarkWithError(dynamic error, StackTrace stackTrace) {
    if (_hasErrored) {
      return;
    }
    _recorder._onError(error, stackTrace);
    _hasErrored = true;
  }

  @override
  void handleBeginFrame(Duration rawTimeStamp) {
    // Don't keep on truckin' if there's an error or the benchmark has stopped.
    if (_hasErrored || _benchmarkStopped) {
      return;
    }
    try {
      super.handleBeginFrame(rawTimeStamp);
    } catch (error, stackTrace) {
      _haltBenchmarkWithError(error, stackTrace);
      rethrow;
    }
  }

  @override
  void scheduleFrame() {
    // Don't keep on truckin' if there's an error or the benchmark has stopped.
    if (_hasErrored || _benchmarkStopped) {
      return;
    }
    super.scheduleFrame();
  }

  @override
  void handleDrawFrame() {
    // Don't keep on truckin' if there's an error or the benchmark has stopped.
    if (_hasErrored || _benchmarkStopped) {
      return;
    }
    try {
      _recorder.frameWillDraw();
      super.handleDrawFrame();
      _recorder.frameDidDraw();
    } catch (error, stackTrace) {
      _haltBenchmarkWithError(error, stackTrace);
      rethrow;
    }
  }
}

int _currentFrameNumber = 1;

/// Adds a marker indication the beginning of frame rendering.
///
/// This adds an event to the performance trace used to find measured frames in
/// Chrome tracing data. The tracing data contains all frames, but some
/// benchmarks are only interested in a subset of frames. For example,
/// [WidgetBuildRecorder] only measures frames that build widgets, and ignores
/// frames that clear the screen.
void startMeasureFrame() {
  html.window.performance.mark('measured_frame_start#$_currentFrameNumber');
}

/// Signals the end of a measured frame.
///
/// See [startMeasureFrame] for details on what this instrumentation is used
/// for.
void endMeasureFrame() {
  html.window.performance.mark('measured_frame_end#$_currentFrameNumber');
  html.window.performance.measure(
    'measured_frame',
    'measured_frame_start#$_currentFrameNumber',
    'measured_frame_end#$_currentFrameNumber',
  );
  _currentFrameNumber += 1;
}
