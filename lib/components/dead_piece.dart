import 'package:chess/components/piece.dart';
import 'package:flutter/material.dart';
class DeadPiece extends StatelessWidget {
  final ChessPiece chessPiece;
  const DeadPiece({super.key,required this.chessPiece});

  @override
  Widget build(BuildContext context) {
    return Image.asset(chessPiece.imagePath);
  }
}
