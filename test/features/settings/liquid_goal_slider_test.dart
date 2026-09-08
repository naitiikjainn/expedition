import 'package:expedition/features/settings/presentation/widgets/liquid_goal_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('LiquidGoalSlider displays initial displayValue and updates with valueFormatter while dragging', (tester) async {
    double updatedValue = 10000;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: LiquidGoalSlider(
            icon: Icons.directions_walk_rounded,
            iconColor: Colors.green,
            label: 'Daily Steps Goal',
            value: 10000,
            displayValue: '10,000 steps',
            valueFormatter: (val) => '${val.round()} steps',
            min: 1000,
            max: 30000,
            divisions: 58,
            onChanged: (val) {
              updatedValue = val;
            },
          ),
        ),
      ),
    );

    expect(find.text('10000 steps'), findsOneWidget);

    // Find the slider widget and drag it to the right
    final sliderFinder = find.byType(Slider);
    expect(sliderFinder, findsOneWidget);

    final center = tester.getCenter(sliderFinder);
    final gesture = await tester.startGesture(center);
    await gesture.moveBy(const Offset(100, 0));
    await tester.pump();

    // After moving, the text should update dynamically from valueFormatter, not staying static '10,000 steps'
    expect(find.text('10,000 steps'), findsNothing);

    await gesture.up();
    await tester.pumpAndSettle();

    expect(updatedValue, isNot(10000));
  });
}
