// Experimental: Replacement 2.

import 'dart:io' as io;

import 'package:analyzer/dart/analysis/analysis_context_collection.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';
import 'package:analyzer/src/dart/ast/ast.dart';

//const filePath = '/Users/tianguang/Documents/dev/gallery2/gallery/lib/demos/material/button_demo.dart';
const filePath = '/Users/tianguang/Documents/dev/gallery2/gallery/lib/demos/material/menu_demo.dart';
const indent = '  ';

class ReplacementCommand {
  const ReplacementCommand(this.node, this.target);

  final AstNode node;
  final String target;
}

final replacements = <ReplacementCommand>[];
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

    // result.unit.accept(ReplacementVisitor());
    print ('=' * 80);

    result.unit.accept(PrintVisitor());

    print (result.unit.toSource());
    await io.File('lib/generated/genraw.dart').writeAsString(result.unit.toString());
    await io.File('lib/generated/gensource.dart').writeAsString(result.unit.toSource());
  }

  print(replacements);
  print(enumRepresentations);

  await handleReplacements ();
}

Future<void> handleReplacements () async {
  int comparator(ReplacementCommand a, ReplacementCommand b) {
    return a.node.offset - b.node.offset;
  }

  replacements.sort(comparator);

  var myFile = io.File(filePath);
  var contents = await myFile.readAsString();
  for (var i = replacements.length - 1; i >= 0; i --) {
    var replacement = replacements[i];
    contents = replace(
      contents,
      replacement.node.offset,
      replacement.node.end,
      replacement.target,
    );
  }
  await io.File('lib/generated/gen.dart').writeAsString(contents);
}

String replace(String original, int start, int stop, String substring)
  => '${original.substring(0, start)}$substring${original.substring(stop)}';

ReturnType findAncestor<AncestorType, ReturnType>(AstNode node) {
  var pointer = node;
  while (pointer != null && pointer is! AncestorType) {
    pointer = pointer.parent;
  }
  return pointer as ReturnType;
}

/* More work on the way.
class ReplacementVisitor extends GeneralizingAstVisitor<void> {
  @override
  void visitSwitchStatement(SwitchStatement statement) {
    if (isType (statement.expression)) {
      subtreeReplace (
        statement.parent.childEntities,
        statement,
        PrefixedIdentifierImpl(SimpleIdentifierImpl(SimpleToken())),
      );
    }
  }
} */

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
