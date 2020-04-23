// Copyright 2019 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart' show timeDilation;
import 'package:flutter_localized_locales/flutter_localized_locales.dart';
import 'package:gallery/globalcontrollers.dart';
import 'package:gallery/routes.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gallery/constants.dart';
import 'package:gallery/data/gallery_options.dart';
import 'package:gallery/l10n/gallery_localizations.dart';
import 'package:gallery/pages/backdrop.dart';
import 'package:gallery/pages/splash.dart';
import 'package:gallery/themes/gallery_theme_data.dart';

void main() {
  GoogleFonts.config.allowHttp = false;
  runApp(GalleryApp(controller: ScrollController(debugLabel: 'controller from main')));
}

class GalleryApp extends StatelessWidget {
  GalleryApp({@required this.controller, @required this.openStudy});

  final ScrollController controller;
  final List<void Function()> openStudy;

  @override
  Widget build(BuildContext context) {
    return ModelBinding(
      initialModel: GalleryOptions(
        themeMode: ThemeMode.system,
        textScaleFactor: systemTextScaleFactorOption,
        customTextDirection: CustomTextDirection.localeBased,
        locale: null,
        timeDilation: timeDilation,
        platform: defaultTargetPlatform,
      ),
      child: Builder(
        builder: (context) {
          return GlobalControllers(
            controller: controller,
            openStudy: openStudy,
            child: MaterialApp(
              title: 'Gallery',
              debugShowCheckedModeBanner: false,
              themeMode: GalleryOptions.of(context).themeMode,
              theme: GalleryThemeData.lightThemeData.copyWith(
                platform: GalleryOptions.of(context).platform,
              ),
              darkTheme: GalleryThemeData.darkThemeData.copyWith(
                platform: GalleryOptions.of(context).platform,
              ),
              localizationsDelegates: const [
                ...GalleryLocalizations.localizationsDelegates,
                LocaleNamesLocalizationsDelegate()
              ],
              supportedLocales: GalleryLocalizations.supportedLocales,
              locale: GalleryOptions.of(context).locale,
              localeResolutionCallback: (locale, supportedLocales) {
                deviceLocale = locale;
                return locale;
              },
              onGenerateRoute: RouteConfiguration.onGenerateRoute,
            )
          );
        },
      ),
    );
  }
}

class RootPage extends StatelessWidget {
  const RootPage({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const ApplyTextOptions(
      child: SplashPage(
        child: Backdrop(),
      ),
    );
  }
}
