import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';

import 'pass.dart';

class L10nReplacementVisitor extends GeneralizingAstVisitor<void> {
  const L10nReplacementVisitor({this.l10ns});

  final Map<String, L10nPattern> l10ns;

  // TODO: edit.

  @override
  void visitPropertyAccess(PropertyAccess node) {
    if (node.realTarget.toString() == 'GalleryLocalizations.of(context)') {
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
  }

  @override
  void visitMethodInvocation(MethodInvocation node) {
    if (node.realTarget.toString() == 'GalleryLocalizations.of(context)') {
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
}
