

import 'package:chess/components/piece.dart';

bool isWhite(int index){
  int x = index ~/ 8; // row
  int y = index % 8;
  return (x + y)% 2 ==0 ;
}

Map<String,ChessPiece> boardPiece = {
  "00||07" : ChessPiece(
     isWhite: false,
     type: ChessPieceType.rook
  ),
  "01||06" : ChessPiece(
      isWhite: false,
      type: ChessPieceType.knight
  ),
  "02||05" : ChessPiece(
      isWhite: false,
      type: ChessPieceType.bishop
  ),
  "03" : ChessPiece(
      isWhite: false,
      type: ChessPieceType.queen
  ),
  "04" : ChessPiece(
      isWhite: false,
      type: ChessPieceType.king
  ),
  "74" : ChessPiece(
      isWhite: true,
      type: ChessPieceType.king
  ),
  "73" : ChessPiece(
      isWhite: true,
      type: ChessPieceType.queen
  ),
  "72||75" : ChessPiece(
      isWhite: true,
      type: ChessPieceType.bishop
  ),
  "71||76" : ChessPiece(
      isWhite: true,
      type: ChessPieceType.knight
  ),
  "70||77" : ChessPiece(
      isWhite: true,
      type: ChessPieceType.rook
  ),
  /////////////////////row 1 ///////////////
  "10||11||12||13||14||15||16||17" : ChessPiece(
      isWhite: false,
      type: ChessPieceType.pawn
  ),

  "60||61||62||63||64||65||66||67" : ChessPiece(
      isWhite: true,
      type: ChessPieceType.pawn
  ),

};


bool isInBoard(int row, int col){
  return row >=0 && row <8 && col >=0 && col <8;
}
