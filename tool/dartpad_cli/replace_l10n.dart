import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';

import 'pass.dart';

const l10nVariables = ['GalleryLocalizations.of(context)', 'localizations'];

class L10nReplacementVisitor extends GeneralizingAstVisitor<void> {
  const L10nReplacementVisitor({this.l10ns});

  final Map<String, L10nPattern> l10ns;

  // TODO: edit.

  @override
  void visitPropertyAccess(PropertyAccess node) {
    if (l10nVariables.contains(node.realTarget.toString())) {
      //print('PropertyAccess => target: ${node.realTarget}, property: ${node
      //    .propertyName}');

      final name = node.propertyName.toString();

      replacements.add(
        ReplacementCommand(
          node,
          l10ns[name].replace([]),
        ),
      );
    }

    node.visitChildren(this);
  }

  @override
  void visitPrefixedIdentifier(PrefixedIdentifier node) {
    print('prefix: ${node.prefix.toString()}');

    if (l10nVariables.contains(node.prefix.toString())) {
      //print('PropertyAccess => target: ${node.realTarget}, property: ${node
      //    .propertyName}');

      final name = node.identifier.toString();

      replacements.add(
        ReplacementCommand(
          node,
          l10ns[name].replace([]),
        ),
      );
    } else {
      node.visitChildren(this);
    }
  }

  @override
  void visitMethodInvocation(MethodInvocation node) {
    if (l10nVariables.contains(node.realTarget.toString())) {
      final name = node.methodName.toString();
      final arguments = node.argumentList.arguments.map(
            (argument) => argument.toString(),
      ).toList();

      replacements.add(
        ReplacementCommand(
          node,
          l10ns[name].replace(arguments),
        ),
      );
    }

    node.visitChildren(this);
  }

  @override
  void visitAssignmentExpression(AssignmentExpression node) {
    if (node.leftHandSide.toString() == 'localizations') {
      final statement = findAncestor<VariableDeclarationStatement, AstNode>(node);
      assert (statement != null);

      replacements.add(
        ReplacementCommand(
          statement,
          '',
        ),
      );
    }

    node.visitChildren(this);
  }

  @override
  void visitVariableDeclaration(VariableDeclaration node) {
    if (node.name.toString() == 'localizations') {
      final statement = findAncestor<VariableDeclarationStatement, AstNode>(node);
      assert (statement != null);

      replacements.add(
        ReplacementCommand(
          statement,
          '',
        ),
      );
    }

    node.visitChildren(this);
  }

  /// Removes the localization import directive.
  @override
  void visitImportDirective(ImportDirective node) {
    if (node.selectedUriContent.contains('gallery_localizations')) {
      replacements.add(
        ReplacementCommand(node, ''),
      );
    }
  }

  /// Collects demo names.
  @override
  void visitClassDeclaration(ClassDeclaration node) {
    if (node.name.toString().endsWith('Demo')) {
      demoNames.add(node.name.toString());
    }

    node.visitChildren(this);
  }
}
