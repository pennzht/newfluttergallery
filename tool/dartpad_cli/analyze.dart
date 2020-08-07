// Experimental.

import 'package:analyzer/dart/analysis/analysis_context_collection.dart';

const filePath = '/Users/tianguang/Documents/dev/gallery2/gallery/lib/demos/material/button_demo.dart';

Future<void> main () async {
  final collection = AnalysisContextCollection(
    includedPaths: [filePath],
  );

  for (final context in collection.contexts) {
    print (context);
    final result = await context.currentSession.getResolvedUnit(
      filePath,
    );
    print (result);
    print (result.content);
    print (result.content.length);
  }
}

