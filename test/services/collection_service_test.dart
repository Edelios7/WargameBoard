import 'package:flutter_test/flutter_test.dart';
import 'package:wargameboard/services/collection_service.dart';

void main() {
  const service = CollectionService();

  test('formats a value with the French locale', () {
    final formatted = service.formatValue(1234.5, 'fr');
    expect(formatted, contains('1'));
    expect(formatted, contains('234'));
    expect(formatted, contains('€'));
  });

  test('formats a value with the English locale', () {
    final formatted = service.formatValue(1234.5, 'en');
    expect(formatted, contains('€'));
    expect(formatted, contains('1,234'));
  });

  test('formats zero', () {
    expect(service.formatValue(0, 'fr'), isNotEmpty);
  });
}
