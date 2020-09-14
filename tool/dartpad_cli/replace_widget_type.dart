import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';

import 'pass.dart';

class WidgetTypeReplacementVisitor extends GeneralizingAstVisitor<void> {
  @override
  void visitNode(AstNode node) {
    // replace "type" identifiers.
    if (node is SimpleIdentifier &&
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
    node.visitChildren(this);
  }
}
