import 'package:flutter_test/flutter_test.dart';
import 'package:wargameboard/core/utils/rule_pdf_source.dart';

void main() {
  test('returns null when neither the local file nor the bundled asset exist',
      () async {
    final bytes = await RulePdfSource.resolve('does-not-exist');
    expect(bytes, isNull);
  });

  test(
      'resolves bytes from the local dev file when present '
      '(no-op on checkouts without the git-ignored PDF)', () async {
    final bytes = await RulePdfSource.resolve('warhammer-40000-core-rules');
    if (bytes == null) return;
    expect(bytes.isNotEmpty, isTrue);
  });
}
