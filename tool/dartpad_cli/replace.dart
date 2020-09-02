// Experimental: Replacement.

import 'package:analyzer/dart/analysis/analysis_context_collection.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';
import 'package:analyzer/src/dart/ast/ast.dart';
import 'package:_fe_analyzer_shared/src/scanner/token.dart';

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
    print ('=' * 80);

    result.unit.accept(PrintVisitor());

    print (result.unit.toSource());
  }
}

class ReplacementVisitor extends GeneralizingAstVisitor<void> {
  @override
  void visitNode(AstNode node) {
    if (node is SimpleIdentifierImpl && node.token.lexeme == 'type') {
      print(node.token.toString());
      node.token = StringToken(TokenType.IDENTIFIER, 'type2', 0);
    } else if (node is ...) {
      
    }
    node.visitChildren(ReplacementVisitor());
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
