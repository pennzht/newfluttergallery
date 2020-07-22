// Copyright 2020 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';

const Duration _animationCheckingInterval = Duration(milliseconds: 50);

const Duration _scrollAnimationLength = Duration(milliseconds: 300);

Offset _absoluteTopLeft(RenderObject renderObject) =>
    (renderObject as RenderBox).localToGlobal(Offset.zero);

Rect _absoluteRect(RenderObject renderObject) =>
    _absoluteTopLeft(renderObject) & renderObject.paintBounds.size;

Size _windowSize(BuildContext context) => MediaQuery.of(context).size;

Rect _windowRect(BuildContext context) => Offset.zero & _windowSize(context);

bool _isSuperset({@required Rect large, @required Rect small}) =>
    large.top <= small.top &&
    large.left <= small.left &&
    large.bottom >= small.bottom &&
    large.right >= small.right;

const _minFreeRoomRequirement = 5.0;

/// Whether [small] is a subset of [large] and has sufficient room
/// inside [large], at the end of [large] specified by [axisDirection].
bool _hasSufficientFreeRoom({
  @required Rect large,
  @required Rect small,
  @required AxisDirection axisDirection,
}) {
  if (!_isSuperset(large: large, small: small)) {
    return false;
  } else {
    bool result;

    switch (axisDirection) {
      case AxisDirection.down:
        result = large.bottom - small.bottom >= _minFreeRoomRequirement;
        break;
      case AxisDirection.right:
        result = large.right - small.right >= _minFreeRoomRequirement;
        break;
      case AxisDirection.left:
        result = small.left - large.left >= _minFreeRoomRequirement;
        break;
      case AxisDirection.up:
        result = small.top - large.top >= _minFreeRoomRequirement;
        break;
    }

    return result;
  }
}

Future<void> previousAnimationStops() async {
  if (!WidgetsBinding.instance.hasScheduledFrame) return;

  final Completer stopped = Completer<void>();

  Timer.periodic(_animationCheckingInterval, (timer) {
    if (!WidgetsBinding.instance.hasScheduledFrame) {
      stopped.complete();
      timer.cancel();
    }
  });

  await stopped.future;
}

Future<void> animationStops() async {
  var waitCount = 0;

  while (WidgetsBinding.instance.hasScheduledFrame) {
    await Future<void>.delayed(_animationCheckingInterval);

    print('        waitCount = $waitCount');

    waitCount ++;
  }
}

Future<void> scrollUntilVisible({
  @required Element element,
  bool strict = false,
  bool animated = true,
}) async {
  final elementRenderObject = element.renderObject;
  final elementRect = _absoluteRect(elementRenderObject);

  final scrollable = Scrollable.of(element);
  final viewport = RenderAbstractViewport.of(elementRenderObject);

  final visibleWindow = _absoluteRect(viewport).intersect(_windowRect(element));

  print('[scrollUntilVisible] computed window');

  // (!!!) This exception is added in order to test if `web_benchmarks_html`
  // can catch an exception with correct stacktrace.
  // Verified: shows stacktrace (js).
  // if (1 + 1 == 2) {
  //   throw Exception('Custom Exception from Gallery.');
  // }

  // If there is free room between this demo button and the end of
  // the scrollable, the next demo button is visible and can be tapped.
  if (!strict &&
      _hasSufficientFreeRoom(
        large: visibleWindow,
        small: elementRect,
        axisDirection: scrollable.axisDirection,
      )) {
    return;
  }

  print('[scrollUntilVisible] scrolling required');

  double pixelsToBeMoved;
  switch (scrollable.axisDirection) {
    /* TODO for the future:
        add support for other directions and other alignment policies. */
    case AxisDirection.down:
      pixelsToBeMoved = elementRect.top - visibleWindow.top;
      break;
    case AxisDirection.right:
      pixelsToBeMoved = elementRect.left - visibleWindow.left;
      break;
    case AxisDirection.left:
      pixelsToBeMoved = visibleWindow.right - elementRect.right;
      break;
    case AxisDirection.up:
      pixelsToBeMoved = visibleWindow.bottom - elementRect.bottom;
      break;
  }

  print('[scrollUntilVisible] computed pixels to scroll');

  final targetPixels = scrollable.position.pixels + pixelsToBeMoved;
  final restrictedTargetPixels = targetPixels
      .clamp(
        scrollable.position.minScrollExtent,
        scrollable.position.maxScrollExtent,
      )
      .toDouble();

  print('[scrollUntilVisible] about to await scrollToPosition');

  await scrollToPosition(
    scrollable: scrollable,
    pixels: restrictedTargetPixels,
    animated: animated,
  );

  print('[scrollUntilVisible] done');
}

Future<void> scrollToExtreme({
  @required ScrollableState scrollable,
  bool toEnd = false,
  bool animated = true,
}) async {
  final targetPixels = toEnd
      ? scrollable.position.maxScrollExtent
      : scrollable.position.minScrollExtent;

  await scrollToPosition(
    scrollable: scrollable,
    pixels: targetPixels,
    animated: animated,
  );
}

Future<void> scrollToPosition({
  @required ScrollableState scrollable,
  @required double pixels,
  bool animated = true,
}) async {
  print('[scrollToPosition] about to start');

  if (animated) {
    print('[scrollToPosition] "animated"');

    await scrollable.position.animateTo(
      pixels,
      duration: _scrollAnimationLength,
      curve: Curves.easeInOut,
    );

    print('[scrollToPosition] "animated" done');
  } else {
    print('[scrollToPosition] "not animated"');

    scrollable.position.jumpTo(pixels);

    print('[scrollToPosition] "not animated" done');
  }
}
