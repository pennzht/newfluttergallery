// Experimental.

import 'package:analyzer/dart/analysis/analysis_context_collection.dart';

void main (){
  final collection = AnalysisContextCollection(
    includedPaths: ['../../lib/demos/material/button_demo.dart'],
  );

  for (final context in collection.contexts) {
    print (context);
  }
}

