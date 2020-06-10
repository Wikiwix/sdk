// Copyright (c) 2020, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:io';

import 'package:path/path.dart' as path;
import 'package:test/test.dart';

import 'package:vm/snapshot/instruction_sizes.dart' as instruction_sizes;

void main() async {
  if (!Platform.executable.contains('dart-sdk')) {
    // If we are not running from the prebuilt SDK then this test does nothing.
    return;
  }

  final sdkBin = path.dirname(Platform.executable);
  final dart2native =
      path.join(sdkBin, Platform.isWindows ? 'dart2native.bat' : 'dart2native');

  if (!File(dart2native).existsSync()) {
    throw 'Failed to locate dart2native in the SDK';
  }

  group('instruction-sizes', () {
    test('basic-parsing', () async {
      await withTempDir('basic-parsing', (dir) async {
        final inputDart = path.join(dir, 'input.dart');
        final outputBinary = path.join(dir, 'output.exe');
        final sizesJson = path.join(dir, 'sizes.json');

        // Create test input.
        await File(inputDart).writeAsString("""
@pragma('vm:never-inline')
dynamic makeSomeClosures() {
  return [
    () => true,
    () => false,
    () => 11,
  ];
}

class A {
  @pragma('vm:never-inline')
  dynamic tornOff() {
    return true;
  }
}

class B {
  @pragma('vm:never-inline')
  dynamic tornOff() {
    return false;
  }
}

class C {
  static dynamic tornOff() async {
    return true;
  }
}

@pragma('vm:never-inline')
Function tearOff(dynamic o) {
  return o.tornOff;
}

void main(List<String> args) {
  for (var cl in makeSomeClosures()) {
    print(cl());
  }
  print(tearOff(args.isEmpty ? A() : B()));
  print(C.tornOff);
}
""");

        // Compile input.dart to native and output instruction sizes.
        final result = await Process.run(dart2native, [
          '-o',
          outputBinary,
          '--extra-gen-snapshot-options=--print_instructions_sizes_to=$sizesJson',
          inputDart,
        ]);

        expect(result.exitCode, equals(0),
            reason: 'Compilation completed successfully');
        expect(File(outputBinary).existsSync(), isTrue,
            reason: 'Output binary exists');
        expect(File(sizesJson).existsSync(), isTrue,
            reason: 'Instruction sizes output exists');

        final symbols = await instruction_sizes.load(File(sizesJson));
        expect(symbols, isNotNull,
            reason: 'Sizes file was successfully parsed');
        expect(symbols.length, greaterThan(0),
            reason: 'Sizes file is non-empty');

        // Check for duplicated symbols (using both raw and scrubbed names).
        // Maps below contain mappings library-uri -> class-name -> names.
        final symbolRawNames = <String, Map<String, Set<String>>>{};
        final symbolScrubbedNames = <String, Map<String, Set<String>>>{};

        Set<String> getSetOfNames(Map<String, Map<String, Set<String>>> map,
            String libraryUri, String className) {
          // For file uris make sure to canonicalize the path. This prevents
          // issues with mismatching case on Windows which has case insensitive
          // file system.
          if (libraryUri != null) {
            final uri = Uri.parse(libraryUri);
            if (uri.scheme == 'file') {
              libraryUri =
                  Uri.file(path.canonicalize(uri.toFilePath())).toString();
            }
          }
          return map
              .putIfAbsent(libraryUri ?? '', () => {})
              .putIfAbsent(className ?? '', () => {});
        }

        for (var sym in symbols) {
          expect(
              getSetOfNames(symbolRawNames, sym.libraryUri, sym.className)
                  .add(sym.name.raw),
              isTrue,
              reason:
                  'All symbols should have unique names (within libraries): ${sym.name.raw}');
          expect(
              getSetOfNames(symbolScrubbedNames, sym.libraryUri, sym.className)
                  .add(sym.name.scrubbed),
              isTrue,
              reason: 'Scrubbing the name should not make it non-unique');
        }

        // Check for expected names which should appear in the output.
        final inputDartSymbolNames = symbolScrubbedNames[
            Uri.file(path.canonicalize(inputDart)).toString()];
        expect(inputDartSymbolNames, isNotNull,
            reason: 'Symbols from input.dart are included into sizes output');

        expect(inputDartSymbolNames[''], isNotNull,
            reason: 'Should include top-level members from input.dart');
        expect(inputDartSymbolNames[''], contains('makeSomeClosures'));
        final closures = inputDartSymbolNames[''].where(
            (name) => name.startsWith('makeSomeClosures.<anonymous closure'));
        expect(closures.length, 3,
            reason: 'There are three closures inside makeSomeClosure');

        expect(inputDartSymbolNames['A'], isNotNull,
            reason: 'Should include class A members from input.dart');
        expect(inputDartSymbolNames['A'], contains('tornOff'));
        expect(inputDartSymbolNames['A'], contains('[tear-off] tornOff'));
        expect(inputDartSymbolNames['A'],
            contains('[tear-off-extractor] get:tornOff'));

        expect(inputDartSymbolNames['B'], isNotNull,
            reason: 'Should include class B members from input.dart');
        expect(inputDartSymbolNames['B'], contains('tornOff'));
        expect(inputDartSymbolNames['B'], contains('[tear-off] tornOff'));
        expect(inputDartSymbolNames['B'],
            contains('[tear-off-extractor] get:tornOff'));

        // Presence of async modifier should not cause tear-off name to end
        // with {body}.
        expect(inputDartSymbolNames['C'], contains('[tear-off] tornOff'));

        // Check that output does not contain '[unknown stub]'
        expect(symbolRawNames[''][''], isNot(contains('[unknown stub]')),
            reason: 'All stubs must be named');
      });
    });
  });
}

Future withTempDir(String prefix, Future fun(String dir)) async {
  final tempDir =
      Directory.systemTemp.createTempSync('instruction-sizes-test-${prefix}');
  try {
    await fun(tempDir.path);
  } finally {
    tempDir.deleteSync(recursive: true);
  }
}
