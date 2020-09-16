import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';

import 'pass.dart';

Future<Map<String, L10nPattern>> collectL10ns({String l10nsPath}) async {
  final answer = <String, L10nPattern> {};

  final result = await getResolvedUnit(l10nsPath);

  result.unit.accept(
    L10nCollectorVisitor(
      locale: 'GalleryLocalizationsEn',
      collection: answer,
    ),
  );

  // result.unit.accept(PrintVisitor());

  print ('=' * 80);
  print ('# answer =');
  for (final key in answer.keys) {
    print ('$key => ${answer[key]}');
  }
  print ('=' * 80);

  return answer;

  // TODO: add processing.
}

class L10nCollectorVisitor extends GeneralizingAstVisitor<void> {
  const L10nCollectorVisitor({this.locale, this.collection, this.collectInside = false});

  final String locale;
  final Map<String, L10nPattern> collection;

  final bool collectInside;

  @override
  void visitClassDeclaration(ClassDeclaration node) {
    node.visitChildren(
      L10nCollectorVisitor(locale: locale, collection: collection, collectInside: true),
    );
  }

  @override
  void visitMethodDeclaration(MethodDeclaration node) {
    if (!collectInside) return;

    if (node.returnType.toString() != 'String') return;

    print ('returnType -> ${node.returnType}');
    print ('parameters -> ${node.parameters}');
    print ('body -> ${node.body}');

    final name = node.name.toString();

    AstNode functionBody;

    if (node.body is ExpressionFunctionBody) {
      functionBody = (node.body as ExpressionFunctionBody).expression;
    } else if (node.body is BlockFunctionBody) {
      functionBody = ((node.body as BlockFunctionBody).block.statements.first
      as ReturnStatement).expression;
    } else {
      throw Exception('Unexpected function body: '
          'Function body must be either an `ExpressionFunctionBody` or '
          'an `BlockFunctionBody`');
    }

    print (functionBody);

    final parameters = node
        ?.parameters?.parameters
        ?.map((element) => element.identifier.toString())
        ?.toList() ?? <String>[];

    collection[name] = L10nPattern.generate(parameters, functionBody);
  }
}
