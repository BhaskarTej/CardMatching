import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Card Model to represent each card's state.
class CardModel {
  final String front; // The emoji or text displayed on the front.
  final int id; // Identifier to track matching pairs.
  bool isFaceUp; // State to check if the card is face-up or face-down.

  CardModel({
    required this.front,
    required this.id,
    this.isFaceUp = false,
  });
}

// GameState class to manage the game logic and state using Provider.
class GameState extends ChangeNotifier {
  final List<CardModel> cards = [
    CardModel(front: '🍎', id: 1),
    CardModel(front: '🍎', id: 1),
    CardModel(front: '🍌', id: 2),
    CardModel(front: '🍌', id: 2),
    CardModel(front: '🍇', id: 3),
    CardModel(front: '🍇', id: 3),
    CardModel(front: '🍉', id: 4),
    CardModel(front: '🍉', id: 4),
    CardModel(front: '🥑', id: 5),
    CardModel(front: '🥑', id: 5),
    CardModel(front: '🍒', id: 6),
    CardModel(front: '🍒', id: 6),
    CardModel(front: '🍍', id: 7),
    CardModel(front: '🍍', id: 7),
    CardModel(front: '🍓', id: 8),
    CardModel(front: '🍓', id: 8),
  ]..shuffle(); // Shuffle the cards randomly.

  List<CardModel> flippedCards = [];

  // Logic to flip a card.
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

  // Check if two flipped cards match.
  void _checkMatch() async {
    await Future.delayed(const Duration(seconds: 1));
    if (flippedCards[0].id == flippedCards[1].id) {
      flippedCards.clear(); // Keep them face-up if they match.
    } else {
      for (var card in flippedCards) {
        card.isFaceUp = false; // Flip back if they don't match.
      }
      flippedCards.clear();
    }
    notifyListeners();
  }
}

// Main function to start the Flutter app.
void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => GameState(),
      child: const MyApp(),
    ),
  );
}

// Root widget of the app.
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Card Matching Game'),
          backgroundColor: Colors.teal,
        ),
        body: const GameBoard(),
      ),
    );
  }
}

// Widget for the game board using GridView.
class GameBoard extends StatelessWidget {
  const GameBoard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final gameState = Provider.of<GameState>(context);
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4, // 4x4 grid.
        mainAxisSpacing: 8,
        crossAxisSpacing: 8,
      ),
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

// Widget to represent a single card with flip animation.
class CardWidget extends StatelessWidget {
  final CardModel card;
  final VoidCallback onTap;

  const CardWidget({
    Key? key,
    required this.card,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
        decoration: BoxDecoration(
          color: Colors.blueAccent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: card.isFaceUp
            ? Center(
                child: Text(
                  card.front,
                  style: const TextStyle(fontSize: 32),
                ),
              )
            : const Center(
                child: Icon(
                  Icons.question_mark,
                  size: 32,
                  color: Colors.white,
                ),
              ),
      ),
    );
  }
}
