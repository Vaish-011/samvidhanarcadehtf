import 'package:flutter/material.dart';
import 'chess_logic.dart';
import 'quiz_screen.dart';
import 'dart:math';

class ChessBoardWidget extends StatelessWidget {
  final ChessBoard board;

  const ChessBoardWidget({Key? key, required this.board}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: ChessBoard.boardSize,
      ),
      itemCount: ChessBoard.boardSize * ChessBoard.boardSize,
      itemBuilder: (context, index) {
        int x = index % ChessBoard.boardSize;
        int y = index ~/ ChessBoard.boardSize;

        ChessPiece piece = board.board[y][x];

        return GestureDetector(
          onTap: () {
            if (piece != ChessPiece.empty) {
              board.selectPiece(x, y);

              // Show quiz dialog when a piece is selected
              showDialog(
                context: context,
                builder: (context) {
                  return QuizScreen(
                    onCorrectAnswer: () {
                      if (board.validMoves[y][x] && piece != ChessPiece.empty) {
                        board.capture(board.selectedPieceX!, board.selectedPieceY!, x, y);
                      } else {
                        board.movePiece(board.selectedPieceX!, board.selectedPieceY!, x, y);
                      }
                      // Handle correct answer
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Great job! Continue your game.')),
                      );
                    },
                    onIncorrectAnswer: () {
                      board.highlightRestrictedMoves(x, y);
                      disableRandomValidMove(board);
                      board.restrictedMove[y][x] = true; // Mark the grid at (x, y) as restricted
                      board.notifyListeners(); // Trigger a UI update
                    },
                  );
                },
              );
            } else if (board.selectedPieceX != null && board.selectedPieceY != null) {
              // A piece is already selected, check if the tap is on a valid move
              if (board.validMoves[y][x]) {
                board.movePiece(board.selectedPieceX!, board.selectedPieceY!, x, y);
              }
            }
          },
          child: Container(
            color: (board.selectedPieceX == x && board.selectedPieceY == y)
                ? Colors.yellow
                : board.restrictedMove[y][x]
                ? Colors.red
                : board.validMoves[y][x]
                ? Colors.green
                : (x + y) % 2 == 0
                ? Colors.white
                : Colors.black,
            child: piece != ChessPiece.empty
                ? Image.asset(
              'assets/chess/${piece.toString().split('.').last}.png',
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) {
                return Container(); // Handle image loading error
              },
            )
                : null,
          ),
        );
      },
    );
  }
}

void disableRandomValidMove(ChessBoard board) {
  List<Point<int>> validMovePoints = [];

  // Collect valid moves
  for (int y = 0; y < ChessBoard.boardSize; y++) {
    for (int x = 0; x < ChessBoard.boardSize; x++) {
      if (board.validMoves[y][x]) {
        validMovePoints.add(Point(x, y));
      }
    }
  }

  // Randomly disable one valid move if there are any
  if (validMovePoints.isNotEmpty) {
    Point<int> randomMove = validMovePoints[Random().nextInt(validMovePoints.length)];
    board.validMoves[randomMove.y][randomMove.x] = false;
    // Mark this move as restricted
    board.restrictedMove[randomMove.y][randomMove.x] = true;
    board.notifyListeners(); // Notify listeners about the change
  }
}
