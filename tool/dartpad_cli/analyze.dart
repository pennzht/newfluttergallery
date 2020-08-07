// Experimental.

import 'package:analyzer/dart/analysis/analysis_context_collection.dart';

Future<void> main () async {
  final collection = AnalysisContextCollection(
    includedPaths: ['/Users/tianguang/Documents/dev/gallery2/gallery/lib'],
  );

  for (final context in collection.contexts) {
    print (context);
    final result = await context.currentSession.getResolvedUnit(
      '/Users/tianguang/Documents/dev/gallery2/gallery/lib/demos/material/buttom_demo.dart',
    );
    print (result);
  }
}

