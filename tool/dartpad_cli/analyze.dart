// Experimental.

import 'package:analyzer/dart/analysis/analysis_context_collection.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';

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
    print (result);
    print (result.content);
    print (result.content.length);
    print (result.unit);

    result.unit.accept(PrintVisitor());
  }
}

class PrintVisitor extends GeneralizingAstVisitor<void> {
  PrintVisitor([this.level = 0]);

  final int level;

  @override
  void visitNode(AstNode node) {
    final representation = node.length <= 32 ? node.toString() : '...';
    print(
      '${indent * level} | '
      '${node.offset} -> ${node.end} '
      '$representation '
      '<${node.runtimeType}> '
      'of: <${node.parent.runtimeType}>'
    );
    node.visitChildren(PrintVisitor(level + 1));
  }
}
