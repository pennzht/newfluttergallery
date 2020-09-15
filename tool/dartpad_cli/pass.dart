// Experimental: A pass of replacement.

import 'dart:io' as io;

import 'package:analyzer/dart/analysis/analysis_context_collection.dart';
import 'package:analyzer/dart/analysis/results.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';

const indent = '  ';

String boilerplate (String appClassName, String demoClassName) =>
'''// The following code allows the demo to be run
// as a standalone app.

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return $appClassName(
      home: $demoClassName(),
    );
  }
}

''';

class ReplacementCommand {
  const ReplacementCommand(this.node, this.target);

  final AstNode node;
  final String target;

  @override
  String toString() {
    return 'ReplacementCommand ($node, $target)';
  }
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

Future<ResolvedUnitResult> getResolvedUnit(String sourcePath) async {

  final collection = AnalysisContextCollection(
    includedPaths: [sourcePath],
  );

  final context = collection.contexts.single;

  final result = context.currentSession.getResolvedUnit(sourcePath);

  return result;
}

Future<void> replacePass ({
  String sourcePath,
  String outputPath,
  AstVisitor<void> visitor,
  bool printTree = false,
}) async {
  replacements.clear();

  final sourceContents = await io.File(sourcePath).readAsString();

  final result = await getResolvedUnit(sourcePath);

  result.unit.accept(visitor);
  if (printTree) {print ('=' * 80);}

  if (printTree) {
    result.unit.accept(PrintVisitor());
    print (result.unit.toSource());
  }

  print (replacements);
  print (enumRepresentations);

  final outputContents = await handleReplacements (sourceContents);

  await io.File(outputPath).writeAsString(outputContents);
}

Future<void> appendPass({
  String sourcePath,
  String outputPath,
  String appClassName,
  String demoClassName,
}) async {
  final sourceContents = await io.File(sourcePath).readAsString();
  await io.File(outputPath).writeAsString(sourceContents + boilerplate(appClassName, demoClassName));
}

Future<String> handleReplacements (String sourceContents) async {
  print(replacements);

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

class L10nPattern {
  const L10nPattern._(this.parameterIndices, this.body);

  factory L10nPattern.generate(List<String> parameters, AstNode body) {
    assert (body is StringLiteral || body is StringInterpolation);

    final parameterIndices = Map<String, int>.fromIterables(
      parameters.asMap().values,
      parameters.asMap().keys,
    );

    return L10nPattern._(parameterIndices, body);
  }

  final Map<String, int> parameterIndices;

  int get parameterCount => parameterIndices.length;

  final AstNode body; // must be either `SimpleStringLiteral` or `StringInterpolation`

  @override
  String toString (){
    return 'L10nPattern._($parameterIndices, $body)';
  }

  String replace(List<String> parameters) {
    assert (parameters.length == parameterCount);

    if (body is SimpleStringLiteral) {
      return body.toString();
    } else {
      final children = (body as StringInterpolation).elements;
      final replaced = <String>[];

      for (final child in children) {
        if (child is InterpolationString) {
          replaced.add(child.toString());
        } else if (child is InterpolationExpression) {
          final index = parameterIndices[child.expression.toString()];
          final replacedString = parameters[index];
          final codeForInterpolation =
              '${child.leftBracket}$replacedString${child.rightBracket}';
          replaced.add(codeForInterpolation);
        } else {
          throw Exception('Unexpected interpolation element; '
              'every element should be either an `InterpolationString` or '
              'an `InterpolationExpression`');
        }
      }

      return replaced.join();
    }
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
