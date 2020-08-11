// Experimental: Replacement.

import 'package:analyzer/dart/analysis/analysis_context_collection.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';
import 'package:analyzer/src/dart/ast/ast.dart';

const filePath = '/Users/tianguang/Documents/dev/gallery2/gallery/lib/demos/material/button_demo.dart';
const indent = '  ';

Future<void> main () async {
  final collection = AnalysisContextCollection(
    includedPaths: [filePath],
  );

  for (final context in collection.contexts) {
    print (context);
    final result = await context.currentSession.getResolvedUnit(
      filePath,
    );

    result.unit.accept(ReplacementVisitor());
  }
}

class ReplacementVisitor extends GeneralizingAstVisitor<void> {
  @override
  void visitNode(AstNode node) {
    if (node is SimpleIdentifierImpl) {
      print (node.toString());
    }
    node.visitChildren(ReplacementVisitor());
  }
}