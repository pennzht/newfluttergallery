// Experimental: Replacement.

import 'pass.dart' as pass;

//const filePath = '/Users/tianguang/Documents/dev/gallery2/gallery/lib/demos/material/button_demo.dart';
const filePath = '/Users/tianguang/Documents/dev/gallery2/gallery/lib/demos/material/menu_demo.dart';

Future<void> main () async {
  await pass.replacePass(
    sourcePath: filePath,
    outputPath: 'lib/generated/gen.dart',
    visitor: pass.ReplacementVisitor(),
  );
}
