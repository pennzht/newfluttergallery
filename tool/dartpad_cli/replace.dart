// Experimental: Replacement.

import 'pass.dart' as pass;

import 'collect_l10n.dart' show collectL10ns;
import 'replace_widget_type.dart' show WidgetTypeReplacementVisitor;
import 'replace_switch_statement.dart' show SwitchStatementReplacementVisitor;
import 'replace_l10n.dart' show L10nReplacementVisitor;

const galleryPath = '/Users/tianguang/Documents/dev/gallery2/gallery';
const menuDemoPath = '$galleryPath/lib/demos/material/menu_demo.dart';
const buttonDemoPath = '$galleryPath/lib/demos/material/button_demo.dart';
const chipDemoPath = '$galleryPath/lib/demos/material/chip_demo.dart';

const enL10nsPath = '$galleryPath/.dart_tool/flutter_gen/gen_l10n/gallery_localizations_en.dart';

Future<void> main () async {
  final l10ns = await collectL10ns(
    l10nsPath: enL10nsPath,
  );

  await pass.replacePass(
    sourcePath: menuDemoPath,
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
    demoClassName: 'MenuDemo',
  );
}
