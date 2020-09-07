// Experimental: A pass of replacement.

import 'dart:io' as io;

import 'package:analyzer/dart/analysis/analysis_context_collection.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';
import 'package:analyzer/src/dart/ast/ast.dart';

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

Future<void> replacePass ({String sourcePath, String outputPath, AstVisitor<void> visitor}) async {
  replacements.clear();
  enumRepresentations.clear();

  final sourceContents = await io.File(sourcePath).readAsString();

  final collection = AnalysisContextCollection(
    includedPaths: [sourcePath],
  );

  for (final context in collection.contexts) {
    print (context);
    final result = await context.currentSession.getResolvedUnit(
      sourcePath,
    );

    result.unit.accept(visitor);
    print ('=' * 80);

    result.unit.accept(PrintVisitor());

    print (result.unit.toSource());
  }

  print(replacements);
  print(enumRepresentations);

  final outputContents = await handleReplacements (sourceContents);

  await io.File(outputPath).writeAsString(outputContents);
}

Future<String> handleReplacements (String sourceContents) async {
  int comparator(ReplacementCommand a, ReplacementCommand b) {
    return a.node.offset - b.node.offset;
  }

  replacements.sort(comparator);

  var contents = sourceContents;
  for (var i = replacements.length - 1; i >= 0; i --) {
    var replacement = replacements[i];
    contents = replaceOnce(
      contents,
      replacement.node.offset,
      replacement.node.end,
      replacement.target,
    );
  }

  return contents;
}

String replaceOnce(String original, int start, int stop, String substring)
    => '${original.substring(0, start)}$substring${original.substring(stop)}';

ReturnType findAncestor<AncestorType, ReturnType>(AstNode node) {
  var pointer = node;
  while (pointer != null && pointer is! AncestorType) {
    pointer = pointer.parent;
  }
  return pointer as ReturnType;
}

class ReplacementVisitor extends GeneralizingAstVisitor<void> {
  @override
  void visitNode(AstNode node) {
    // replace "type" identifiers.
    if (node is SimpleIdentifierImpl &&
        node.token.lexeme == 'type' &&
        node.parent is! FieldFormalParameter &&
        node.parent is! VariableDeclaration) {
      AstNode replacingNode;
      if (node.parent is PrefixedIdentifier) {
        replacingNode = node.parent;
      } else {
        replacingNode = node;
      }
      print ('node: $replacingNode\ntoken: ${replacingNode.toString()}\nrange: ${replacingNode.offset} -> ${replacingNode.end}');
      replacements.add(ReplacementCommand(replacingNode, '$enumName.${enumRepresentations[0]}'));
    } else if (node is EnumConstantDeclaration && node.parent is EnumDeclaration &&
        (node.parent as EnumDeclaration).name.name.endsWith('Type')
    ) {
      enumRepresentations.add(node.name.name);
      enumName = (node.parent as EnumDeclaration).name.name;
    } else if (node is SimpleIdentifier &&
        node.token.lexeme == 'type' &&
        node.parent is FieldFormalParameter) {
      replacements.add(ReplacementCommand(node.parent, ''));
      // print ((node.parent as FieldFormalParameter).childEntities);
    } else if (node is SimpleIdentifier &&
        node.token.lexeme == 'type' &&
        node.parent is VariableDeclaration) {
      replacements.add(ReplacementCommand(findAncestor<ClassMember, AstNode>(node), ''));
      print ((node.parent as VariableDeclaration).childEntities);
    } else if (node is SwitchStatement) {
      print(node);
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
