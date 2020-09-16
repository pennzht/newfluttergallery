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
    if (! file.contains('data_table_demo.dart')) {
      continue;
    }

    final parts = path.split(file);
    final directoryName = parts[parts.length - 2];

    final targetPath = '$galleryPath/lib/generated/demos/$directoryName/${path.basename(file)}';
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

  final append = pass.demoNames.isNotEmpty
      ? pass.boilerplate(
        generateAppClassName(sourcePath),
        generateClassName(sourcePath, pass.demoNames),
      )
      : '';

  await pass.appendPass(
    sourcePath: '$galleryPath/lib/generated/gen3.dart',
    outputPath: targetPath,
    append: append,
  );
}

String generateAppClassName(String sourcePath) {
  final parts = path.split(sourcePath);
  final demoDirectory = parts[parts.length - 2];
  if (demoDirectory == 'cupertino') {
    return 'CupertinoApp';
  } else {
    return 'MaterialApp';
  }
}

String generateClassName(String sourcePath, List<String> demoNames) {
  final exactClassName = _exactClassName(sourcePath);
  if (demoNames.contains(exactClassName)) {
    return exactClassName;
  } else {
    return demoNames[0];
  }
}

String _exactClassName(String sourcePath) {
  final basename = path.basenameWithoutExtension(sourcePath);
  final parts = basename.split('_');
  final capitalizedParts = parts.map((word) => '${word[0].toUpperCase()}${word.substring(1)}').toList();
  final className = capitalizedParts.join();
  return className;
}
