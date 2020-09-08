// Experimental: Replacement.

import 'pass.dart' as pass;

const galleryPath = '/Users/tianguang/Documents/dev/gallery2/gallery';
const menuDemoPath = '$galleryPath/lib/demos/material/menu_demo.dart';
const buttonDemoPath = '$galleryPath/lib/demos/material/button_demo.dart';

Future<void> main () async {
  await pass.replacePass(
    sourcePath: menuDemoPath,
    outputPath: '$galleryPath/lib/generated/gen.dart',
    visitor: pass.WidgetTypeReplacementVisitor(),
    printTree: true,
  );

  await pass.replacePass(
    sourcePath: '$galleryPath/lib/generated/gen.dart',
    outputPath: '$galleryPath/lib/generated/gen2.dart',
    visitor: pass.SwitchStatementReplacementVisitor(),
  );
}
