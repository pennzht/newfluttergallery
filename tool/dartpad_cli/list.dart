import 'dart:io';

import 'pass.dart' as pass;

import 'package:path/path.dart' as path;

import 'collect_l10n.dart' show collectL10ns;
import 'replace_widget_type.dart' show WidgetTypeReplacementVisitor;
import 'replace_switch_statement.dart' show SwitchStatementReplacementVisitor;
import 'replace_l10n.dart' show L10nReplacementVisitor;

const galleryPath = '/Users/tianguang/Documents/dev/gallery2/gallery';
const menuDemoPath = '$galleryPath/lib/demos/material/menu_demo.dart';
const buttonDemoPath = '$galleryPath/lib/demos/material/button_demo.dart';
const chipDemoPath = '$galleryPath/lib/demos/material/chip_demo.dart';

const enL10nsPath = '$galleryPath/.dart_tool/flutter_gen/gen_l10n/gallery_localizations_en.dart';

Future<void> main() async {
  final l10ns = await collectL10ns(
    l10nsPath: enL10nsPath,
  );

  final libPath = Directory('lib/demos');
  final list = await libPath.list(recursive: true).toList();

  final files = <String>[];

  for (final item in list) {
    if (item is File) {
      files.add(item.absolute.path);
    }
  }

  for (final file in files) {
    final targetPath = '$galleryPath/lib/generated/demos/${path.dirname(file)}/${path.basename(file)}';
    await replace(file, targetPath, l10ns);
  }
}

// Experimental: Replacement.

Future<void> replace (String sourcePath, String targetPath, Map<String, pass.L10nPattern> l10ns) async {
  print('replacing $sourcePath -> $targetPath');

  await pass.replacePass(
    sourcePath: sourcePath,
    outputPath: '$galleryPath/lib/generated/gen1.dart',
    visitor: WidgetTypeReplacementVisitor(),
    printTree: false,
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
    outputPath: targetPath,
    demoClassName: generateClassName(sourcePath),
  );
}

String generateClassName(String sourcePath) {
  final basename = path.basename(sourcePath);
  final parts = basename.split('_');
  final capitalizedParts = parts.map((word) => '${word[0].toUpperCase()}${word.substring(1)}').toList();
  final className = capitalizedParts.join();
  return className;
}

