// Experimental.

import 'package:analyzer/dart/analysis/analysis_context_collection.dart';
import 'package:analyzer/dart/analysis/results.dart';

Future<void> main () async {
  final collection = AnalysisContextCollection(
    includedPaths: ['/Users/tianguang/Documents/dev/gallery2/gallery/tool/dartpad_cli/analyze.dart'],
  );

  for (final context in collection.contexts) {
    print (context);
    final result = await context.currentSession.getResolvedUnit(
      '/Users/tianguang/Documents/dev/gallery2/gallery/tool/dartpad_cli/analyze.dart',
    );
    print (result);
    print (result.content.length);
  }
}

