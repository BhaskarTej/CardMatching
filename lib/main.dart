import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'game_state.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => GameState(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Card Matching Game'),
        ),
        body: const GameBoard(),
      ),
    );
  }
}

class GameBoard extends StatelessWidget {
  const GameBoard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final gameState = Provider.of<GameState>(context);
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4, // 4x4 grid
        mainAxisSpacing: 8,
        crossAxisSpacing: 8,
      ),
      padding: const EdgeInsets.all(16),
      itemCount: gameState.cards.length,
      itemBuilder: (context, index) {
        final card = gameState.cards[index];
        return CardWidget(
          card: card,
          onTap: () => gameState.flipCard(card),
        );
      },
    );
  }
}
import 'package:flutter/material.dart';
import 'card_model.dart';

class GameState extends ChangeNotifier {
  final List<CardModel> cards = [
    // Add pairs of matching cards (e.g., 8 pairs for a 4x4 grid)
    CardModel(front: '🍎', id: 1),
    CardModel(front: '🍎', id: 1),
    CardModel(front: '🍌', id: 2),
    CardModel(front: '🍌', id: 2),
    // Add more pairs as needed
  ]..shuffle(); // Shuffle the cards randomly

  List<CardModel> flippedCards = [];

  void flipCard(CardModel card) {
    if (flippedCards.length < 2 && !card.isFaceUp) {
      card.isFaceUp = true;
      flippedCards.add(card);
      notifyListeners();

      if (flippedCards.length == 2) {
        _checkMatch();
      }
    }
  }

  void _checkMatch() async {
    await Future.delayed(const Duration(seconds: 1));
    if (flippedCards[0].id == flippedCards[1].id) {
      flippedCards.clear(); // Keep them face up
    } else {
      for (var card in flippedCards) {
        card.isFaceUp = false;
      }
      flippedCards.clear(); // Flip them back
    }
    notifyListeners();
  }
}
class CardModel {
  final String front;
  final int id;
  bool isFaceUp;

  CardModel({
    required this.front,
    required this.id,
    this.isFaceUp = false,
  });
}
