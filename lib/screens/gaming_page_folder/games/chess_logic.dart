import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'quiz_screen.dart';
import 'dart:math';




enum ChessPiece {
  empty,
  pawn,
  rook,
  knight,
  bishop,
  queen,
  king,
  wpawn,
  wrook,
  wknight,
  wbishop,
  wqueen,
  wking
}

class ChessBoard extends ChangeNotifier {
  List<List<bool>> restrictedMove = List.generate(boardSize, (i) => List.generate(boardSize, (j) => false));
  static const int boardSize = 8;
  List<List<ChessPiece>> board;
  List<List<bool>> validMoves;
  int selectedPieceX = -1;
  int selectedPieceY = -1;
  bool isWhiteTurn = true;
  String? winner;
  List<ChessPiece> capturedPieces = []; // List to track captured pieces

  ChessBoard()
      : board = List.generate(boardSize, (i) => List.generate(boardSize, (j) => ChessPiece.empty)),
        validMoves = List.generate(boardSize, (i) => List.generate(boardSize, (j) => false)) {
    initialize(); // Call the initialize method to set up the board
  }

  void initialize() {
    isWhiteTurn = true;
    winner = null;
    capturedPieces.clear();
    // Reset the board to empty
    board = List.generate(boardSize, (i) => List.generate(boardSize, (j) => ChessPiece.empty));

    for (int i = 0; i < boardSize; i++) {
      board[1][i] = ChessPiece.pawn;
      board[6][i] = ChessPiece.wpawn;
    }
    board[0][0] = board[0][7] = ChessPiece.rook;
    board[0][1] = board[0][6] = ChessPiece.knight;
    board[0][2] = board[0][5] = ChessPiece.bishop;
    board[0][3] = ChessPiece.queen;
    board[0][4] = ChessPiece.king;
    board[7][0] = board[7][7] = ChessPiece.wrook;
    board[7][1] = board[7][6] = ChessPiece.wknight;
    board[7][2] = board[7][5] = ChessPiece.wbishop;
    board[7][3] = ChessPiece.wqueen;
    board[7][4] = ChessPiece.wking;

    resetValidMoves();
    notifyListeners();
  }

  // Helper functions to determine piece color
  bool isWhitePiece(ChessPiece piece) {
    return piece == ChessPiece.wpawn ||
        piece == ChessPiece.wrook ||
        piece == ChessPiece.wknight ||
        piece == ChessPiece.wbishop ||
        piece == ChessPiece.wqueen ||
        piece == ChessPiece.wking;
  }

  bool isBlackPiece(ChessPiece piece) {
    return piece == ChessPiece.pawn ||
        piece == ChessPiece.rook ||
        piece == ChessPiece.knight ||
        piece == ChessPiece.bishop ||
        piece == ChessPiece.queen ||
        piece == ChessPiece.king;
  }




  void selectPiece(int x, int y) {
    ChessPiece piece = board[y][x];
    if ((isWhiteTurn && isWhitePiece(piece)) || (!isWhiteTurn && isBlackPiece(piece))) {
      selectedPieceX = x;
      selectedPieceY = y;
      resetValidMoves();
      highlightValidMoves(x, y);
      notifyListeners();
    }
  }
  void movePiece(int fromX, int fromY, int toX, int toY) {

    // Check if the move is valid
    if (validMoves[toY][toX]) {
      // Capture opponent's piece if present
      if (board[toY][toX] != ChessPiece.empty && validMoves[toY][toX]) {
        capture(fromX, fromY, toX, toY);

      }
      else{

        // Move the piece
        board[toY][toX] = board[fromY][fromX];
        board[fromY][fromX] = ChessPiece.empty;
      }// Empty the original square
      isWhiteTurn = !isWhiteTurn; // Alternate turns
      resetValidMoves();
      resetRestrictedMoves();
      notifyListeners();
    }
  }

  void capture(int fromX, int fromY, int toX, int toY) {
    // Capture the opponent's piece
    ChessPiece capturedPiece = board[toY][toX];
    capturedPieces.add(capturedPiece);
    if(capturedPiece == ChessPiece.king || capturedPiece == ChessPiece.wking){
      winner = capturedPiece ==ChessPiece.king?"white":"black";
    }
    board[toY][toX] = ChessPiece.empty;// Store captured piece in the list
    board[toY][toX] = board[fromY][fromX]; // Move the piece to the capture position
    board[fromY][fromX] = ChessPiece.empty; // Empty the original square
  }

  void resetValidMoves() {
    validMoves = List.generate(boardSize, (i) => List.generate(boardSize, (j) => false));

  }
  void resetRestrictedMoves(){
    restrictedMove = List.generate(boardSize, (i) => List.generate(boardSize, (j) => false));
  }

  void highlightValidMoves(int x, int y) {
    ChessPiece piece = board[y][x];

    // Reset valid moves and highlight all possible moves
    resetValidMoves();

    switch (piece) {
      case ChessPiece.pawn:
        highlightPawnMoves(x, y, isWhite: false);
        break;
      case ChessPiece.wpawn:
        highlightPawnMoves(x, y, isWhite: true);
        break;
      case ChessPiece.rook:
      case ChessPiece.wrook:
        highlightRookMoves(x, y);
        break;
      case ChessPiece.knight:
      case ChessPiece.wknight:
        highlightKnightMoves(x, y);
        break;
      case ChessPiece.bishop:
      case ChessPiece.wbishop:
        highlightBishopMoves(x, y);
        break;
      case ChessPiece.queen:
      case ChessPiece.wqueen:
        highlightQueenMoves(x, y);
        break;
      case ChessPiece.king:
      case ChessPiece.wking:
        highlightKingMoves(x, y);
        break;
      default:
        break;
    }
  }


  void removeRestrictedMove(int restrictedX, int restrictedY) {
    if (isInBounds(restrictedX, restrictedY)) {
      validMoves[restrictedY][restrictedX] = false; // Remove the highlight
      notifyListeners(); // Notify listeners to update UI
    }
  }


  void highlightPawnMoves(int x, int y, {required bool isWhite}) {
    int direction = isWhite ? -1 : 1;
    ChessPiece enemyPawn = isWhite ? ChessPiece.pawn : ChessPiece.wpawn;

    // Move forward
    if (isInBounds(x, y + direction) && board[y + direction][x] == ChessPiece.empty) {
      validMoves[y + direction][x] = true;
    }

    // Initial double move
    if ((isWhite && y == 6 || !isWhite && y == 1) && board[y + 2 * direction][x] == ChessPiece.empty && board[y + direction][x] == ChessPiece.empty) {
      validMoves[y + 2 * direction][x] = true;
    }

    // Capture diagonally
    if (isInBounds(x - 1, y + direction) && board[y + direction][x - 1] != ChessPiece.empty && board[y + direction][x - 1] == enemyPawn) {
      validMoves[y + direction][x - 1] = true;
    }
    if (isInBounds(x + 1, y + direction) && board[y + direction][x + 1] != ChessPiece.empty && board[y + direction][x + 1] == enemyPawn) {
      validMoves[y + direction][x + 1] = true;
    }
  }

  void highlightRestrictedMoves(int x, int y) {
    // Loop through the board to highlight restricted moves
    for (int i = 0; i < boardSize; i++) {
      for (int j = 0; j < boardSize; j++) {
        if (restrictedMove[i][j]) {
          // Highlight the restricted move, typically this will mark it in red
          validMoves[i][j] = false; // Invalidate the move
          notifyListeners(); // Update the UI
        }
      }
    }
  }


  // Reset valid moves and highlight all possible moves
  //   resetValidMoves();

  void highlightRookMoves(int x, int y) {
    // Vertical and horizontal moves
    highlightDirectionalMoves(x, y, 1, 0);  // down
    highlightDirectionalMoves(x, y, -1, 0); // up
    highlightDirectionalMoves(x, y, 0, 1);  // right
    highlightDirectionalMoves(x, y, 0, -1); // left
  }

  void highlightKnightMoves(int x, int y) {
    List<List<int>> moves = [
      [x + 2, y + 1], [x + 2, y - 1], [x - 2, y + 1], [x - 2, y - 1],
      [x + 1, y + 2], [x + 1, y - 2], [x - 1, y + 2], [x - 1, y - 2]
    ];
    for (var move in moves) {
      int newX = move[0];
      int newY = move[1];
      if (isInBounds(newX, newY) && (board[newY][newX] == ChessPiece.empty || isOpponentPiece(newX, newY))) {
        validMoves[newY][newX] = true;
      }
    }
  }

  void highlightBishopMoves(int x, int y) {
    highlightDirectionalMoves(x, y, 1, 1);   // down-right
    highlightDirectionalMoves(x, y, 1, -1);  // down-left
    highlightDirectionalMoves(x, y, -1, 1);  // up-right
    highlightDirectionalMoves(x, y, -1, -1); // up-left
  }

  void highlightQueenMoves(int x, int y) {
    // Queen combines rook and bishop moves
    highlightRookMoves(x, y);
    highlightBishopMoves(x, y);
  }

  void highlightKingMoves(int x, int y) {
    List<List<int>> moves = [
      [x + 1, y], [x - 1, y], [x, y + 1], [x, y - 1],
      [x + 1, y + 1], [x - 1, y + 1], [x + 1, y - 1], [x - 1, y - 1]
    ];
    for (var move in moves) {
      int newX = move[0];
      int newY = move[1];
      if (isInBounds(newX, newY) && (board[newY][newX] == ChessPiece.empty || isOpponentPiece(newX, newY))) {
        validMoves[newY][newX] = true;
      }
    }
  }

  void highlightDirectionalMoves(int x, int y, int dx, int dy) {
    int newX = x + dx;
    int newY = y + dy;
    while (isInBounds(newX, newY)) {
      if (board[newY][newX] == ChessPiece.empty) {
        validMoves[newY][newX] = true;
      } else if (isOpponentPiece(newX, newY)) {
        validMoves[newY][newX] = true;
        break;
      } else {
        break;
      }
      newX += dx;
      newY += dy;
    }
  }

  bool isInBounds(int x, int y) {
    return x >= 0 && x < boardSize && y >= 0 && y < boardSize;
  }

  bool isOpponentPiece(int x, int y) {
    ChessPiece piece = board[y][x];
    return (isWhiteTurn && isBlackPiece(piece)) || (!isWhiteTurn && isWhitePiece(piece));
  }
  void removeRestrictedMoves() {
    for (int y = 0; y < boardSize; y++) {
      for (int x = 0; x < boardSize; x++) {
        restrictedMove[y][x] = false; // Reset the restricted moves
      }
    }
    notifyListeners(); // Notify listeners to update UI
  }
}
