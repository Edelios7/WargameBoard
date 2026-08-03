import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wargameboard/core/theme/block_overrides.dart';

void main() {
  tearDown(() => BlockOverrides.clearAll());

  group('BlockOverrides', () {
    test('forId returns null when nothing is set for that id', () {
      expect(BlockOverrides.forId('unknown.id'), isNull);
    });

    test('setImage stores an image-only override', () {
      final file = File('some/path.png');
      BlockOverrides.setImage('block.a', file);

      final override = BlockOverrides.forId('block.a');
      expect(override, isNotNull);
      expect(override!.image, file);
      expect(override.color, isNull);
    });

    test('setColor stores a color-only override', () {
      BlockOverrides.setColor('block.b', Colors.red);

      final override = BlockOverrides.forId('block.b');
      expect(override, isNotNull);
      expect(override!.color, Colors.red);
      expect(override.image, isNull);
    });

    test('setColor after setImage replaces the previous override', () {
      BlockOverrides.setImage('block.c', File('a.png'));
      BlockOverrides.setColor('block.c', Colors.blue);

      final override = BlockOverrides.forId('block.c');
      expect(override!.image, isNull);
      expect(override.color, Colors.blue);
    });

    test('clear removes the override for that id only', () {
      BlockOverrides.setColor('block.d', Colors.green);
      BlockOverrides.setColor('block.e', Colors.yellow);

      BlockOverrides.clear('block.d');

      expect(BlockOverrides.forId('block.d'), isNull);
      expect(BlockOverrides.forId('block.e'), isNotNull);
    });

    test('clearAll removes every override', () {
      BlockOverrides.setColor('block.f', Colors.green);
      BlockOverrides.setColor('block.g', Colors.yellow);

      BlockOverrides.clearAll();

      expect(BlockOverrides.forId('block.f'), isNull);
      expect(BlockOverrides.forId('block.g'), isNull);
    });
  });
}
