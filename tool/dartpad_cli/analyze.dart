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

    walkAst(result.unit);
  }
}

void walkAst(AstNode ast, [int level = 0]) {
  print('${indent * level}|${ast.offset} -> ${ast.end}');
  ast.accept(PrintVisitor());
}

class PrintVisitor extends GeneralizingAstVisitor<void> {
  @override
  void visitNode(AstNode node) {
    print('${node.offset} -> ${node.end}');
    node.visitChildren(PrintVisitor());
  }
}
