import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';

import 'pass.dart';

class SwitchStatementReplacementVisitor extends GeneralizingAstVisitor<void> {
  @override
  void visitSwitchStatement(SwitchStatement statement) {
    for (var subStatement in statement.members) {
      if (subStatement.childEntities.toList()[1].toString() == statement.expression.toString()) {
        print('Statements -> ${subStatement.statements}');

        final effectiveCode = <String>[];

        for (final statement in subStatement.statements) {
          if (statement is BreakStatement) {
            break;
          }

          effectiveCode.add(statement.toString());
        }

        print(effectiveCode);

        replacements.add(
          ReplacementCommand(statement, effectiveCode.join(' ')),
        );
      }
    }
  }
}
