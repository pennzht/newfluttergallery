// Copyright 2019 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:animations/animations.dart';


// BEGIN sharedXAxisTransitionDemo

class SharedXAxisTransitionDemo extends StatefulWidget {
  const SharedXAxisTransitionDemo();
  @override
  _SharedXAxisTransitionDemoState createState() =>
      _SharedXAxisTransitionDemoState();
}

class _SharedXAxisTransitionDemoState extends State<SharedXAxisTransitionDemo> {
  bool _isLoggedIn = false;

  void _toggleLoginStatus() {
    setState(() {
      _isLoggedIn = !_isLoggedIn;
    });
  }

  @override
  Widget build(BuildContext context) {
    

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Column(
          children: [
            Text('Shared x-axis'),
            Text(
              '(${'Next and Back Buttons'})',
              style: Theme.of(context)
                  .textTheme
                  .subtitle2
                  .copyWith(color: Colors.white),
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageTransitionSwitcher(
                duration: const Duration(milliseconds: 300),
                reverse: !_isLoggedIn,
                transitionBuilder: (
                  child,
                  animation,
                  secondaryAnimation,
                ) {
                  return SharedAxisTransition(
                    child: child,
                    animation: animation,
                    secondaryAnimation: secondaryAnimation,
                    transitionType: SharedAxisTransitionType.horizontal,
                  );
                },
                child: _isLoggedIn ? const _CoursePage() : const _SignInPage(),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  FlatButton(
                    onPressed: _isLoggedIn ? _toggleLoginStatus : null,
                    child: Text('BACK'),
                  ),
                  RaisedButton(
                    onPressed: _isLoggedIn ? null : _toggleLoginStatus,
                    child: Text('NEXT'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CoursePage extends StatelessWidget {
  const _CoursePage();

  @override
  Widget build(BuildContext context) {
    

    return ListView(
      children: [
        const SizedBox(height: 16),
        Text(
          'Streamline your courses',
          style: Theme.of(context).textTheme.headline5,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 10),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Text(
            'Bundled categories appear as groups in your feed. You can always change this later.',
            style: const TextStyle(
              fontSize: 12,
              color: Colors.grey,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        _CourseSwitch(
            course: 'Arts and crafts'),
        _CourseSwitch(course: 'Business'),
        _CourseSwitch(
            course: 'Illustration'),
        _CourseSwitch(course: 'Design'),
        _CourseSwitch(course: 'Culinary'),
      ],
    );
  }
}

class _CourseSwitch extends StatefulWidget {
  const _CourseSwitch({
    this.course,
  });

  final String course;

  @override
  _CourseSwitchState createState() => _CourseSwitchState();
}

class _CourseSwitchState extends State<_CourseSwitch> {
  bool _isCourseBundled = true;

  @override
  Widget build(BuildContext context) {
    
    final subtitle = _isCourseBundled
        ? 'Bundled'
        : 'Shown individually';

    return SwitchListTile(
      title: Text(widget.course),
      subtitle: Text(subtitle),
      value: _isCourseBundled,
      onChanged: (newValue) {
        setState(() {
          _isCourseBundled = newValue;
        });
      },
    );
  }
}

class _SignInPage extends StatelessWidget {
  const _SignInPage();

  @override
  Widget build(BuildContext context) {
    

    return LayoutBuilder(
      builder: (context, constraints) {
        final maxHeight = constraints.maxHeight;
        final spacing = SizedBox(height: maxHeight / 25);

        return Column(
          children: [
            SizedBox(height: maxHeight / 10),
            Image.asset(
              'placeholders/avatar_logo.png',
              package: 'flutter_gallery_assets',
              width: 80,
            ),
            spacing,
            Text(
              'Hi David Park',
              style: Theme.of(context).textTheme.headline5,
            ),
            spacing,
            Text(
              'Sign in with your account',
              style: const TextStyle(
                fontSize: 12,
                color: Colors.grey,
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsetsDirectional.only(
                    top: 40,
                    start: 15,
                    end: 15,
                    bottom: 10,
                  ),
                  child: TextField(
                    decoration: InputDecoration(
                      suffixIcon: const Icon(
                        Icons.visibility,
                        size: 20,
                        color: Colors.black54,
                      ),
                      isDense: true,
                      labelText:
                          'Email or phone number',
                      border: const OutlineInputBorder(),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsetsDirectional.only(start: 10),
                  child: FlatButton(
                    onPressed: () {},
                    child: Text(
                      'FORGOT EMAIL?',
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsetsDirectional.only(start: 10),
                  child: FlatButton(
                    onPressed: () {},
                    child: Text(
                      'CREATE ACCOUNT',
                    ),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}

// END sharedXAxisTransitionDemo
// The following code allows the demo to be run
// as a standalone app.

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SharedXAxisTransitionDemo(),
    );
  }
}

