import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wargameboard/core/widgets/radar_chart.dart';

void main() {
  testWidgets('renders without throwing for a typical 5-axis profile', (
    tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: RadarChart(
            axes: [
              RadarAxis(label: 'Tir', value: 70),
              RadarAxis(label: 'Corps-à-corps', value: 20),
              RadarAxis(label: 'Résilience', value: 50),
              RadarAxis(label: 'Mobilité', value: 30),
              RadarAxis(label: 'Contrôle', value: 40),
            ],
          ),
        ),
      ),
    );

    expect(tester.takeException(), isNull);
    expect(find.byType(RadarChart), findsOneWidget);
  });

  testWidgets('does not throw with fewer than 3 axes (degenerate case)', (
    tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: RadarChart(
            axes: [RadarAxis(label: 'Tir', value: 50)],
          ),
        ),
      ),
    );

    expect(tester.takeException(), isNull);
  });
}
