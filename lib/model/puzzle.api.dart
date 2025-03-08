import 'dart:convert';
import 'dart:math';
import 'puzzle.dart';
import 'package:http/http.dart' as http;

class ApiReq{

  static Future<List<Puzzle>> get_puzzles() async{
    var headers = {
       'x-rapidapi-key': "cdac944943msh71d6a625800d2aap131c81jsn8411b40bff0c",
    'x-rapidapi-host': "chess-puzzles.p.rapidapi.com",
    };
    var randomInst = Random();
    var url = "https://chess-puzzles.p.rapidapi.com/";
    var uri  = Uri.parse(url).replace(queryParameters: {
      "themesType":"[\"endgame\",\"\"]",
      "count": "25",
      "rating": (1000-randomInst.nextInt(800)).toString()
    });
    final response = await http.get(uri,headers: headers);
    final return_data = jsonDecode(response.body);
    print(return_data);
    List<Puzzle> l_1 = [];

    for (var i in return_data["puzzles"]){
      l_1.add(
        Puzzle(puzzleId: i["puzzleid"] as String, fen: i["fen"] as String, moves: i["moves"] as List<dynamic>, themes: i["themes"] as List<dynamic>)
      );
    }
    return l_1;
  }
}