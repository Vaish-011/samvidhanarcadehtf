import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'chess_logic.dart';
import 'chess_board.dart';  // Ensure this path is correct.


class ChessGame extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ChessBoard()..initialize(),
      child: ChessGamePage(),
    );
  }
}

class ChessGamePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chess Game'),
        actions: [
          IconButton(
            icon: Icon(Icons.replay),
            onPressed: () {
              Provider.of<ChessBoard>(context, listen: false).initialize();
            },
          ),
        ],
      ),
      body: Consumer<ChessBoard>(builder: (context, board, child) {
        if (board.winner != null) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _showWinnerDialog(context, board.winner!);
          });
        }

        return Column(
          children: [
            Expanded(child: ChessBoardWidget(board: board)),
            if (board.winner != null)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  '${board.winner} wins!',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ),
          ],
        );
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Provider.of<ChessBoard>(context, listen: false).initialize();
        },
        child: Icon(Icons.refresh),
        tooltip: 'Restart Game',
      ),
    );
  }

  void _showWinnerDialog(BuildContext context, String winner) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Game Over'),
          content: Text('$winner wins!'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Provider.of<ChessBoard>(context, listen: false).initialize();
              },
              child: Text('Restart'),
            ),
          ],
        );
      },
    );
  }
}
