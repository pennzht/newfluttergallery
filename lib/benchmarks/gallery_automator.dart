// Copyright 2020 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:gallery/data/demos.dart';
import 'package:gallery/main.dart';

import 'scroll.dart';

const Duration _initialWaitingDuration = Duration(milliseconds: 1500);

const List<String> _demosWithAnimation = <String>[
  'progress-indicator@material',
  'cupertino-activity-indicator@cupertino',
];

const Duration _defaultWaitingDuration = Duration(seconds: 3);

enum DemoType {
  study,
  animatedWidget,
  unanimatedWidget,
}

DemoType typeOfDemo(String demo) {
  if (demo.contains('@study')) {
    return DemoType.study;
  } else if (_demosWithAnimation.contains(demo)) {
    return DemoType.animatedWidget;
  } else {
    return DemoType.unanimatedWidget;
  }
}

/// A class that automates the gallery.
class GalleryAutomator {
  GalleryAutomator({
    @required this.benchmarkName,
    this.shouldRunPredicate,
    this.testScrollsOnly = false,
    @required this.stopWarmingUpCallback,
  }) : assert(testScrollsOnly || shouldRunPredicate != null);

  /// The name of the current benchmark.
  final String benchmarkName;

  /// A function deciding whether a demo should be run in this benchmark.
  final bool Function(String) shouldRunPredicate;

  /// Whether we only test scrolling in this benchmark.
  final bool testScrollsOnly;

  /// A function to call when warm-up is finished.
  ///
  /// This function is intended to ask `Recorder` to mark the warm-up phase
  /// as over.
  final void Function() stopWarmingUpCallback;

  /// Whether the automation has ended.
  bool finished = false;

  /// A widget controller for automation.
  LiveWidgetController controller;

  /// An iterable that generates all demo names.
  Iterable<String> get demoNames => allGalleryDemoDescriptions();

  /// The gallery widget, with automation.
  Widget createWidget() {
    // There is no `catchError` here, because all errors are caught by
    // the zone set up in `lib/web_benchmarks.dart` in `flutter/flutter`.
    Future<void>.delayed(
      _initialWaitingDuration,
      testScrollsOnly ? automateScrolls : automateDemoGestures,
    );
    return const GalleryApp();
  }

  /// Opens and quits demos that are specified by [shouldRunPredicate], twice.
  Future<void> automateDemoGestures() async {
    await warmUp();

    print('==== List of demos to be run ====');
    for (final demo in demoNames) {
      if (shouldRunPredicate(demo)) {
        print(demo);
      }
    }
    print('==== End of list of demos to be run ====');

    var finishedStudyDemos = false;

    for (final demo in demoNames) {
      print('Doing demo $demo');
      if (!finishedStudyDemos && typeOfDemo(demo) != DemoType.study) {
        finishedStudyDemos = true;

        print('Scrolling... 10');

        await scrollUntilVisible(
          element: find.text('Categories').evaluate().single,
          strict: true,
          animated: false,
        );

        print('Scrolling... 11');
      }

      print('Looking for demoButton...');

      final demoButton =
          find.byKey(ValueKey(demo), skipOffstage: false).evaluate().single;

      print('Scrolling until visible...');

      await scrollUntilVisible(
        element: demoButton,
        animated: false,
      );

      print('Scrolled until visible!');

      // Run demo if it passes `runCriterion`.
      // Note that the above scrolling is required even for demos *not*
      // satisfying `runCriterion`, because we need to scroll
      // through every `Scrollable` to find the `demoButton`.
      if (shouldRunPredicate(demo)) {
        print('Running demo "$demo"');

        for (var i = 0; i < 2; ++i) {
          print('Waiting to tap... 1 ');

          await controller.tap(find.byKey(ValueKey(demo)));

          print('Tapped! 1');

          if (typeOfDemo(demo) == DemoType.animatedWidget) {
            print('Waiting for it to finish...');
            await Future<void>.delayed(_defaultWaitingDuration);
          } else {
            print('Waiting for animation to stop...');
            await animationStops();
          }

          print('Finished!');

          await controller.tap(find.byKey(const ValueKey('Back')));

          print('Tapping back...');

          await animationStops();

          print('Animation stopped!');
        }
      }
    }

    print('All demos finished.');

    // At the end of the test, mark as finished.
    finished = true;
  }

  /// Scrolls various parts of the gallery.
  Future<void> automateScrolls() async {
    await warmUp();

    print('Running scrolling test.');

    final selectedDemos = firstDemosOfCategories(demoNames);

    var scrolled = false;

    // For each category
    for (final demo in selectedDemos) {
      print('Doing demo: $demo');
      // Scroll to that category
      if (!scrolled && categoryOf(demo) != 'study') {
        scrolled = true;
        print('Waiting to scroll... 1');
        await scrollUntilVisible(
          element: find.text('Categories').evaluate().single,
          strict: true,
        );
        print('Scrolled!');
      } else if (scrolled && categoryOf(demo) == 'study') {
        scrolled = false;
        final pageScrollable =
            Scrollable.of(find.text('Categories').evaluate().single);
        print('Waiting to scroll... 2');
        await scrollToExtreme(scrollable: pageScrollable, toEnd: false);
        print('Scrolled!');
      }

      print('Looking for demoButton');
      // Scroll that scrollable
      final demoButton =
          find.byKey(ValueKey(demo), skipOffstage: false).evaluate().single;
      print('Found demoButton!');
      final scrollable = Scrollable.of(demoButton);
      print('Found scrollable!');

      for (var i = 0; i < 2; ++i) {
        print('Scrolling to extreme... 1');
        await scrollToExtreme(scrollable: scrollable, toEnd: true);
        print('Scrolling to extreme... 2');
        await scrollToExtreme(scrollable: scrollable, toEnd: false);
        print('Scrolling to extreme... 3');
      }
    }

    print('Scrolling test finished.');
    finished = true;
  }

  /// Warm up the animation.
  Future<void> warmUp() async {
    print('Warming up.');

    // Let animation stop.
    await animationStops();

    print('Animation stopped.');

    // Set controller.
    controller = LiveWidgetController(WidgetsBinding.instance);

    print('Found controller');

    // Find first demo of each category.
    final candidateDemos = firstDemosOfCategories(demoNames);

    print('Found candidatedemo');

    // Find first demo that is not being tested here.
    // We open this demo as a way to warm up the engine, so we need to use an
    // untested demo to avoid biasing the benchmarks.
    String firstUntestedDemo;
    for (final demo in candidateDemos) {
      if (testScrollsOnly || !shouldRunPredicate(demo)) {
        firstUntestedDemo = demo;
        break;
      }
    }
    assert(firstUntestedDemo != null);

    // Open and close the demo twice to warm up.
    for (var i = 0; i < 2; ++i) {
      await controller.tap(find.byKey(ValueKey(firstUntestedDemo)));

      if (typeOfDemo(firstUntestedDemo) == DemoType.animatedWidget) {
        await Future<void>.delayed(_defaultWaitingDuration);
      } else {
        await animationStops();
      }

      await controller.tap(find.byKey(const ValueKey('Back')));

      await animationStops();
    }

    // When warm-up finishes, inform the recorder.
    stopWarmingUpCallback();

    print('Warm-up finished.');
  }

  /// A function to find the category of a demo.
  String categoryOf(String demo) {
    final atSymbolIndex = demo.lastIndexOf('@');
    if (atSymbolIndex < 0) {
      return '';
    } else {
      return demo.substring(atSymbolIndex + 1);
    }
  }

  /// A function to find the first demo of each category.
  List<String> firstDemosOfCategories(Iterable<String> demoList) {
    // Select the first demo from each category.
    final coveredCategories = <String>{};
    final selectedDemos = <String>[];

    for (final demo in demoList) {
      final category = categoryOf(demo);
      if (!coveredCategories.contains(category)) {
        coveredCategories.add(category);
        selectedDemos.add(demo);
      }
    }

    return selectedDemos;
  }
}
