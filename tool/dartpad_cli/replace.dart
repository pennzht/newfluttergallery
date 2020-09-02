// Experimental: Replacement.

import 'dart:io' as io;

import 'package:analyzer/dart/analysis/analysis_context_collection.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';
import 'package:analyzer/src/dart/ast/ast.dart';

const filePath = '/Users/tianguang/Documents/dev/gallery2/gallery/lib/demos/material/button_demo.dart';
//const filePath = '/Users/tianguang/Documents/dev/gallery2/gallery/lib/demos/material/menu_demo.dart';
const indent = '  ';

final replacements = <AstNode>[];
final enumRepresentations = <String>[];
String enumName;

// Keep any of the following:
// SimpleIdentifierImpl of FieldFormalParameterImpl
// DeclaredSimpleIdentifier of VariableDeclarationImpl

// Replace any of the following:
// SimpleIdentifierImpl of PrefixedIdentifierImpl
// SimpleIdentifierImpl of SwitchStatementImpl

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

  print(replacements);
  print(enumRepresentations);

  await handleReplacements ();
}

Future<void> handleReplacements () async {
  var myFile = io.File(filePath);
  var contents = await myFile.readAsString();
  for (var i = replacements.length - 1; i >= 0; i --) {
    var replacement = replacements[i];
    contents = replace(
      contents,
      replacement.offset,
      replacement.end,
      '$enumName.${enumRepresentations[0]}',
    );
  }
  await io.File('lib/generated/gen.dart').writeAsString(contents);
}

String replace(String original, int start, int stop, String substring)
  => '${original.substring(0, start)}$substring${original.substring(stop)}';

class ReplacementVisitor extends GeneralizingAstVisitor<void> {
  @override
  void visitNode(AstNode node) {
    // replace "type" identifiers.
    if (node is SimpleIdentifierImpl &&
        node.token.lexeme == 'type' &&
        node.parent is! FieldFormalParameterImpl &&
        node.parent is! VariableDeclarationImpl) {
      print ('node: $node\ntoken: ${node.token.toString()}\nrange: ${node.offset} -> ${node.end}');
      replacements.add(node);
    } else if (node is EnumConstantDeclarationImpl && node.parent is EnumDeclarationImpl &&
        (node.parent as EnumDeclarationImpl).name.name.endsWith('Type')
    ) {
      enumRepresentations.add(node.name.name);
      enumName = (node.parent as EnumDeclarationImpl).name.name;
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
