import 'package:chess/components/piece.dart';
import 'package:chess/values/colors.dart';
import 'package:flutter/material.dart';
class Square extends StatelessWidget {
  final bool isWhite;
  final ChessPiece? chessPiece;
  final bool isSelected;
  final bool isValidMove;
  final Function()? onTap;
  final bool isKingInCheck;
  const Square({required this.isWhite,this.chessPiece,required this.isSelected,required this.isValidMove,required this.onTap,required this.isKingInCheck,super.key});

  @override
  Widget build(BuildContext context) {
    Color? squareColor;
     if(isKingInCheck && chessPiece?.type == ChessPieceType.king) {
    squareColor = Colors.red;
    }
    else if(isSelected){
      squareColor = Colors.green;
    }else if(isValidMove) {
      squareColor = Colors.green[200];
    }
    else{
      squareColor=  isWhite ? foregroundColor: backgroundColor;
    }

    return GestureDetector(
      onTap: onTap,
      child: Container(
        color: squareColor,
        child: chessPiece !=null ? Image.asset(chessPiece!.imagePath):null,
      ),
    );
  }
}
