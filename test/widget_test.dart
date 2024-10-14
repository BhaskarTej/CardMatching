import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:card_matching_game/main.dart'; // Ensure this matches your project structure

void main() {
  testWidgets('Card flip test', (WidgetTester tester) async {
    // Build the app and trigger a frame.
    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (context) => GameState(),
        child: const MyApp(),
      ),
    );

    // Verify that the cards are initially face down (using question marks).
    expect(find.byIcon(Icons.question_mark), findsNWidgets(16));

    // Tap the first card and trigger a frame.
    await tester.tap(find.byType(CardWidget).first);
    await tester.pump(); // Rebuild the widget tree after the tap.

    // Verify that the first card is now face up (displaying an emoji).
    expect(find.byIcon(Icons.question_mark), findsNWidgets(15));
    expect(find.text('🍎'), findsOneWidget); // Example front emoji.

    // Tap a second card and trigger a frame.
    await tester.tap(find.byType(CardWidget).at(1));
    await tester.pumpAndSettle(); // Wait for animations to complete.

    // Verify if both cards are either face up or flipped back after delay.
    expect(find.byIcon(Icons.question_mark), findsNWidgets(14)); // Or 16 if no match.

    // Add logic to check if the cards are matching or not, based on your game's logic.
  });
}
