// Experimental: Replacement.

import 'pass.dart' as pass;

//const filePath = '/Users/tianguang/Documents/dev/gallery2/gallery/lib/demos/material/button_demo.dart';
const galleryPath = '/Users/tianguang/Documents/dev/gallery2/gallery';
const filePath = '$galleryPath/lib/demos/material/menu_demo.dart';

Future<void> main () async {
  await pass.replacePass(
    sourcePath: filePath,
    outputPath: '$galleryPath/lib/generated/gen.dart',
    visitor: pass.WidgetTypeReplacementVisitor(),
  );

  await pass.replacePass(
    sourcePath: '$galleryPath/lib/generated/gen.dart',
    outputPath: '$galleryPath/lib/generated/gen2.dart',
    visitor: pass.SwitchStatementReplacementVisitor(),
  );
}
