
class Puzzle{
  String puzzleId = "";
  String fen = "";
  List<dynamic> moves = <dynamic>[];
  List<dynamic> themes = <dynamic>[];

  Puzzle({required this.puzzleId,required this.fen,required this.moves,required this.themes});
  
  @override
  String toString(){
    return "Puzzle {puzzleId: $puzzleId,fen: $fen, moves, $moves,themes: $themes}";
  }

  Map<String,dynamic> fenConv(){
    Map<String,dynamic> return_map = {"Black":" ","White":"","toMove":"","castling":"","enpassant":"","moves":moves};
    int count = 1;
    List black_plist = [];List white_plist = [];
    for(var i in this.fen.split("/")){
      int chr_start = 97;
      String dummy = "";
      for (var j in i.split("")){
        print(return_map["Black"]!=null);
        if(j==" "){
          break;
        }else if("12345678".contains(j)){
          chr_start+=int.parse(j);
          continue;
        }else if(j=="p"){
          black_plist.add(String.fromCharCode(chr_start)+count.toString());
        }else if(j=="P"){
          white_plist.add(String.fromCharCode(chr_start)+count.toString());
        }else if(j.codeUnits[0]>=97&&j.codeUnits[0]<=122){
          black_plist.add(j.toLowerCase()+String.fromCharCode(chr_start)+count.toString());
        }else{
          black_plist.add(j.toLowerCase()+String.fromCharCode(chr_start)+count.toString());
        }
        chr_start++;
        }
        
    count++;
    }
    return_map["Black"] = black_plist.join(" ");
    return_map["White"] = white_plist.join(" ");
    return_map["toMove"] = (fen.split(" ")[1]);
    return_map["castling"] = (fen.split(" ")[2]);
    return_map["enpassant"] = (fen.split(" ")[3]);
    return return_map;
  }
}