import 'package:chess/components/dead_piece.dart';
import 'package:chess/components/piece.dart';
import 'package:chess/components/square.dart';
import 'package:chess/helper/helper_function.dart';
import 'package:flutter/material.dart';

class GameBoard extends StatefulWidget {
  const GameBoard({super.key});

  @override
  State<GameBoard> createState() => _GameBoardState();
}

class _GameBoardState extends State<GameBoard> {
  List<List<ChessPiece?>> board = [];

  ChessPiece? selectedPiece;
  int selectedRow = -1;
  int selectedCol = -1;

  List<List<int>> validMoves = [];
  List<ChessPiece> whitePiecesTaken = [];
  List<ChessPiece> blackPiecesTaken = [];
  bool isWhiteTurn = true;

  bool checkStatus = false;

  List<int> whiteKingPosition = [7, 4];
  List<int> blackKingPosition = [0, 4];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initBoard();
  }

  void pieceSelected(int row, int col) {
    setState(() {
      if (selectedPiece == null && board[row][col] != null) {
        if (board[row][col]!.isWhite == isWhiteTurn) {
          selectedRow = row;
          selectedCol = col;
          selectedPiece = board[row][col];
        }
      } else if (board[row][col] != null &&
          board[row][col]!.isWhite == selectedPiece?.isWhite) {
        selectedRow = row;
        selectedCol = col;
        selectedPiece = board[row][col];
      } else if (selectedPiece != null &&
          validMoves.any((element) => element[0] == row && element[1] == col)) {
        movePiece(row, col);
      }

      validMoves = calculateRealValidMoves(
          selectedRow, selectedCol, selectedPiece, true);
    });
  }

  bool isCheckMate(bool isWhiteKing) {
    if (!isKingInCheck(isWhiteKing)) {
      return false;
    }

    for (int i = 0; i < 8; i++) {
      for (int j = 0; j < 8; j++) {
        if (board[i][j] == null || board[i][j]!.isWhite != isWhiteKing) {
          continue;
        }

        List<List<int>> pieceValidMoves =
            calculateRealValidMoves(i, j, board[i][j], true);

        if (pieceValidMoves.isNotEmpty) {
          return false;
        }
      }
    }

    return true;
  }

  List<List<int>> calculateRawValidMoves(int row, int col, ChessPiece? piece) {
    List<List<int>> candidatesMoves = [];

    if (piece == null) {
      return [];
    }
    int direction = piece!.isWhite ? -1 : 1;
    switch (piece.type) {
      case ChessPieceType.pawn:
        if (isInBoard(row + direction, col) &&
            board[row + direction][col] == null) {
          candidatesMoves.add([row + direction, col]);
        }

        if ((row == 1 && !piece.isWhite) || (row == 6 && piece.isWhite)) {
          if (isInBoard(row + 2 * direction, col) &&
              board[row + 2 * direction][col] == null) {
            candidatesMoves.add([row + 2 * direction, col]);
          }
        }

        if (isInBoard(row + direction, col - 1) &&
            board[row + direction][col - 1] != null &&
            board[row + direction][col - 1]!.isWhite != piece.isWhite) {
          candidatesMoves.add([row + direction, col - 1]);
        }

        if (isInBoard(row + direction, col + 1) &&
            board[row + direction][col + 1] != null &&
            board[row + direction][col + 1]!.isWhite != piece.isWhite) {
          candidatesMoves.add([row + direction, col + 1]);
        }

        break;
      case ChessPieceType.rook:
        var directions = [
          [-1, 0], // up
          [1, 0], // down
          [0, -1], // left
          [0, 1], // right
        ];

        for (var direction in directions) {
          var i = 1;

          while (true) {
            var newRow = row + i * direction[0];
            var newCol = col + i * direction[1];

            if (!isInBoard(newRow, newCol)) {
              break;
            }

            if (board[newRow][newCol] != null) {
              if (board[newRow][newCol]!.isWhite != piece.isWhite) {
                candidatesMoves.add([newRow, newCol]);
              }
              break;
            }
            candidatesMoves.add([newRow, newCol]);
            i++;
          }
        }

        break;
      case ChessPieceType.knight:
        var knightMoves = [
          [-2, -1],
          [-2, 1],
          [-1, -2],
          [-1, 2],
          [1, -2],
          [1, 2],
          [2, -1],
          [2, 1],
        ];

        for (var move in knightMoves) {
          var newRow = row + move[0];
          var newCol = col + move[1];

          if (!isInBoard(newRow, newCol)) {
            continue;
          }
          if (board[newRow][newCol] != null) {
            if (board[newRow][newCol]!.isWhite != piece.isWhite) {
              candidatesMoves.add([newRow, newCol]);
            }
            continue;
          }
          candidatesMoves.add([newRow, newCol]);
        }
        break;
      case ChessPieceType.bishop:
        var directions = [
          [-1, -1], // up
          [-1, 1], // down
          [1, -1], // left
          [1, 1], // right
        ];
        for (var direction in directions) {
          var i = 1;

          while (true) {
            var newRow = row + i * direction[0];
            var newCol = col + i * direction[1];

            if (!isInBoard(newRow, newCol)) {
              break;
            }

            if (board[newRow][newCol] != null) {
              if (board[newRow][newCol]!.isWhite != piece.isWhite) {
                candidatesMoves.add([newRow, newCol]);
              }
              break;
            }
            candidatesMoves.add([newRow, newCol]);
            i++;
          }
        }
        break;
      case ChessPieceType.queen:
        var directions = [
          [-1, 0], // up
          [1, 0], // down
          [0, -1], // left
          [0, 1], // right
          [-1, -1], // right
          [-1, 1], // right
          [1, -1], // right
          [1, 1], // right
        ];
        for (var direction in directions) {
          var i = 1;

          while (true) {
            var newRow = row + i * direction[0];
            var newCol = col + i * direction[1];

            if (!isInBoard(newRow, newCol)) {
              break;
            }

            if (board[newRow][newCol] != null) {
              if (board[newRow][newCol]!.isWhite != piece.isWhite) {
                candidatesMoves.add([newRow, newCol]);
              }
              break;
            }
            candidatesMoves.add([newRow, newCol]);
            i++;
          }
        }
        break;
      case ChessPieceType.king:
        var directions = [
          [-1, 0], // up
          [1, 0], // down
          [0, -1], // left
          [0, 1], // right
          [-1, -1], // right
          [-1, 1], // right
          [1, -1], // right
          [1, 1], // right
        ];
        for (var direction in directions) {
          var newRow = row + direction[0];
          var newCol = col + direction[1];

          if (!isInBoard(newRow, newCol)) {
            continue;
          }

          if (board[newRow][newCol] != null) {
            if (board[newRow][newCol]!.isWhite != piece.isWhite) {
              candidatesMoves.add([newRow, newCol]);
            }
            continue;
          }
          candidatesMoves.add([newRow, newCol]);
        }
        break;
      default:
    }

    return candidatesMoves;
  }

  List<List<int>> calculateRealValidMoves(
      int row, int col, ChessPiece? piece, bool checkSimulation) {
    List<List<int>> realValidMovies = [];
    List<List<int>> candidateMoves = calculateRawValidMoves(row, col, piece);

    if (checkSimulation) {
      for (var move in candidateMoves) {
        int endRow = move[0];
        int endCol = move[1];

        if (simulatedMoveIsSafe(piece!, row, col, endRow, endCol)) {
          realValidMovies.add(move);
        }
      }
    } else {
      realValidMovies = candidateMoves;
    }

    return realValidMovies;
  }

  bool simulatedMoveIsSafe(
      ChessPiece piece, int startRow, int startCol, int endRow, int endCol) {
    ChessPiece? originalDestinationPosition = board[endRow][endCol];

    List<int>? originalKingPosition;

    if (piece.type == ChessPieceType.king) {
      originalKingPosition =
          piece.isWhite ? whiteKingPosition : blackKingPosition;
      if (piece.isWhite) {
        whiteKingPosition = [endRow, endCol];
      } else {
        blackKingPosition = [endRow, endCol];
      }
    }

    board[endRow][endCol] = piece;
    board[startRow][startCol] = null;

    bool kingInCheck = isKingInCheck(piece.isWhite);

    board[startRow][startCol] = piece;
    board[endRow][endCol] = originalDestinationPosition;

    if (piece.type == ChessPieceType.king) {
      if (piece.isWhite) {
        whiteKingPosition = originalKingPosition!;
      } else {
        blackKingPosition = originalKingPosition!;
      }
    }
    return !kingInCheck;
  }

  void initBoard() {
    List<List<ChessPiece?>> newBoard =
        List.generate(8, (index) => List.generate(8, (index) => null));
    for (String key in boardPiece.keys) {
      List<String> listIndex = key.split("||");
      for (String k in listIndex) {
        newBoard[int.parse(k) ~/ 10][int.parse(k) % 10] =
            boardPiece[boardPiece.keys.firstWhere((key) => key.contains(k))];
      }
    }
    board = newBoard;
  }

  void movePiece(int newRow, int newCol) {
    if (board[newRow][newCol] != null) {
      var capturedPiece = board[newRow][newCol];
      if (capturedPiece!.isWhite) {
        whitePiecesTaken.add(capturedPiece);
      } else {
        blackPiecesTaken.add(capturedPiece);
      }
    }

    if (selectedPiece!.type == ChessPieceType.king) {
      if (selectedPiece!.isWhite) {
        whiteKingPosition = [newRow, newCol];
      } else {
        blackKingPosition = [newRow, newCol];
      }
    }

    board[newRow][newCol] = selectedPiece;
    board[selectedRow][selectedCol] = null;

    if (isKingInCheck(!isWhiteTurn)) {
      checkStatus = true;
    } else {
      checkStatus = false;
    }

    setState(() {
      selectedCol = -1;
      selectedRow = -1;
      selectedPiece = null;
      validMoves = [];
      isWhiteTurn = !isWhiteTurn;
    });

    if (isCheckMate(isWhiteTurn)) {
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
                title: const Text("Check Mate!"),
                actions: [
                  TextButton(
                      onPressed: resetBoard, child: const Text("Play Again"))
                ],
              ));
    }
  }

  void resetBoard() {
    Navigator.pop(context);
    initBoard();
    setState(() {
      selectedCol = -1;
      selectedRow = -1;
      selectedPiece = null;
      validMoves = [];
      isWhiteTurn = true;
      whitePiecesTaken = [];
      blackPiecesTaken = [];
      checkStatus = false;
      whiteKingPosition = [7, 4];
      blackKingPosition = [0, 4];
    });
  }

  bool isKingInCheck(bool isWhiteKing) {
    List<int> kingPosition =
        isWhiteKing ? whiteKingPosition : blackKingPosition;

    for (int i = 0; i < 8; i++) {
      for (int j = 0; j < 8; j++) {
        if (board[i][j] == null || board[i][j]!.isWhite == isWhiteKing) {
          continue;
        }
        List<List<int>> pieceValidMoves =
            calculateRealValidMoves(i, j, board[i][j], false);

        if (pieceValidMoves.any((move) =>
            move[0] == kingPosition[0] && move[1] == kingPosition[1])) {
          return true;
        }
      }
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Center(
            child: Container(
              constraints: const BoxConstraints(
                maxWidth: 660,
              ),
              child: Column(
                 children: [
                  SizedBox(
                    height: 80,
                    child: GridView.builder(
                        itemCount: whitePiecesTaken.length,
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 8),
                        itemBuilder: (context, index) {
                          return DeadPiece(
                            chessPiece: whitePiecesTaken[index],
                          );
                        }),
                  ),
                  Text(checkStatus ? "check!" : ""),
                  Expanded(
                    flex: 2,
                    child: GridView.builder(
                        itemCount: 8 * 8,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 8,
                            childAspectRatio: 1,
                        ),
                        itemBuilder: (context, index) {
                          int row = index ~/ 8;
                          int col = index % 8;
                          bool isSelected = selectedRow == row && selectedCol == col;
                          bool isValidMove = false;
                          for (var pos in validMoves) {
                            if (pos[0] == row && pos[1] == col) {
                              isValidMove = true;
                            }
                          }
                          return Square(
                            isWhite: isWhite(index),
                            chessPiece: board[row][col],
                            isSelected: isSelected,
                            isValidMove: isValidMove,
                            onTap: () => pieceSelected(row, col),
                              isKingInCheck: board[row][col]!= null ? isKingInCheck( board[row][col]!.isWhite): false
                          );
                        }),
                  ),
                  SizedBox(
                    height: 80,
                    child: GridView.builder(
                        itemCount: blackPiecesTaken.length,
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 8),
                        itemBuilder: (context, index) {
                          return DeadPiece(
                            chessPiece: blackPiecesTaken[index],
                          );
                        }),
                  ),
                ],
              ),
            ),
          );
        }
      ),
    );
  }
}
