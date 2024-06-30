enum ChessPieceType { pawn, rook, knight, bishop, queen , king}



class ChessPiece {
  final ChessPieceType type;
  final bool isWhite;
  Map<ChessPieceType,String> mapData ={
    ChessPieceType.pawn:"pawn",
    ChessPieceType.rook:"rook",
    ChessPieceType.knight:"knight",
    ChessPieceType.bishop:"bishop",
    ChessPieceType.queen:"queen",
    ChessPieceType.king:"king",
  };
  String get imagePath {
   if(!mapData.keys.contains(type)){
     return "";
   }
    String pieceName = mapData[type]!;
    String path="assets/images/";
    if(isWhite){
      path+="white-";
    }else {
      path+="black-";
    }
    return "$path$pieceName.png";
  }


  ChessPiece({
    required this.type,
    required this.isWhite,
});

}