// Experimental: Replacement.

import 'dart:io';
import 'pass.dart' as pass;

import 'collect_l10n.dart' show collectL10ns;
import 'replace_widget_type.dart' show WidgetTypeReplacementVisitor;
import 'replace_switch_statement.dart' show SwitchStatementReplacementVisitor;
import 'replace_l10n.dart' show L10nReplacementVisitor;

String get galleryPath => Directory.current.absolute.path;
String get menuDemoPath => '$galleryPath/lib/demos/material/menu_demo.dart';
String get buttonDemoPath => '$galleryPath/lib/demos/material/button_demo.dart';
String get chipDemoPath => '$galleryPath/lib/demos/material/chip_demo.dart';
String get cardsDemoPath => '$galleryPath/lib/demos/material/cards_demo.dart';
String get cupertinoActivityDemoPath => '$galleryPath/lib/demos/cupertino/cupertino_activity_indicator_demo.dart';
String get cupertinoSegmentedDemoPath => '$galleryPath/lib/demos/cupertino/cupertino_segmented_control_demo.dart';
String get enL10nsPath => '$galleryPath/.dart_tool/flutter_gen/gen_l10n/gallery_localizations_en.dart';

Future<void> main () async {
  final l10ns = await collectL10ns(
    l10nsPath: enL10nsPath,
  );

  await pass.replacePass(
    sourcePath: cardsDemoPath,
    outputPath: '$galleryPath/lib/generated/gen1.dart',
    visitor: WidgetTypeReplacementVisitor(),
    printTree: true,
  );

  await pass.replacePass(
    sourcePath: '$galleryPath/lib/generated/gen1.dart',
    outputPath: '$galleryPath/lib/generated/gen2.dart',
    visitor: SwitchStatementReplacementVisitor(),
  );

  await pass.replacePass(
    sourcePath: '$galleryPath/lib/generated/gen2.dart',
    outputPath: '$galleryPath/lib/generated/gen3.dart',
    visitor: L10nReplacementVisitor(l10ns: l10ns),
  );

  await pass.appendPass(
    sourcePath: '$galleryPath/lib/generated/gen3.dart',
    outputPath: '$galleryPath/lib/generated/gen4.dart',
    append: pass.boilerplate('MaterialApp', 'CardsDemo'),
  );
}
