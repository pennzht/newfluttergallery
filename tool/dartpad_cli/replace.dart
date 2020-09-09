// Experimental: Replacement.

import 'pass.dart' as pass;

const galleryPath = '/Users/tianguang/Documents/dev/gallery2/gallery';
const menuDemoPath = '$galleryPath/lib/demos/material/menu_demo.dart';
const buttonDemoPath = '$galleryPath/lib/demos/material/button_demo.dart';
const chipDemoPath = '$galleryPath/lib/demos/material/chip_demo.dart';

Future<void> main () async {
  await pass.replacePass(
    sourcePath: buttonDemoPath,
    outputPath: '$galleryPath/lib/generated/gen1.dart',
    visitor: pass.WidgetTypeReplacementVisitor(),
    printTree: true,
  );

  await pass.replacePass(
    sourcePath: '$galleryPath/lib/generated/gen1.dart',
    outputPath: '$galleryPath/lib/generated/gen2.dart',
    visitor: pass.SwitchStatementReplacementVisitor(),
  );

  await pass.replacePass(
    sourcePath: '$galleryPath/lib/generated/gen2.dart',
    outputPath: '$galleryPath/lib/generated/gen3.dart',
    visitor: pass.LocalizationsReplacementVisitor(),
  );
}
