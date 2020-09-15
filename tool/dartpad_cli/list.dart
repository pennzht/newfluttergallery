import 'dart:io';

Future<void> main() async {
  final libPath = Directory('lib/demos');
  final list = await libPath.list(recursive: true).toList();
  for (final item in list) {
    if (item is File) {
      print(item.absolute);
    }
  }
}

