import 'dart:io';
import 'dart:math';
import 'dart:ui' as ui;
import 'package:cryptochess/dummy_route.dart';
import 'package:cryptochess/model/puzzle.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chess_board/flutter_chess_board.dart';
import 'package:cryptochess/model/puzzle.api.dart';
import "package:cryptochess/encryption.dart";
import 'dart:async';
import 'package:chess/chess.dart' as chess;



List<String> encryption_algorithms = ["caesar","atbash","rot13","Vigenère","Affine"];
bool isLoading_ = true;
List<Puzzle> puzzle_values = [];
Map<String,dynamic> ui_params = {};
int points = 0;
class GamePage extends StatefulWidget {
  int time_elapsed = 0;
  int points = 0;
  List<Puzzle> puz_value = [];
  GamePage({super.key,required int this.time_elapsed,required this.puz_value, required this.points}){
    puzzle_values = this.puz_value;
  }

  @override
  State<GamePage> createState() => _GamePageState(time_elapsed: this.time_elapsed, points: this.points);
}

class _GamePageState extends State<GamePage> {
  int time_elapsed;
  int points;
  _GamePageState({required int this.time_elapsed, required int this.points});
  @override
  void initState(){
    // TODO: implement initState
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: isLoading_?Center(child: Container(child: CircularProgressIndicator(backgroundColor: Colors.transparent, strokeWidth: 10.0, color: Colors.white))):GamePageScaffold(time_elapsed: time_elapsed,points: points,)
    );
  }
}

class GamePageScaffold extends StatefulWidget {
  int time_elapsed = 0;
  int points = 0;
  GamePageScaffold({super.key,required this.time_elapsed, required this.points});
  @override
  State<GamePageScaffold> createState() => _GamePageScaffoldState(time_elapsed: this.time_elapsed,points: this.points);
}

class _GamePageScaffoldState extends State<GamePageScaffold> {
  ChessBoardController _boardController = ChessBoardController();
  Map<String,String> curr_puzzle = <String,String>{};
  bool listen_event = true;
  int time_elapsed = 0;
  int points = 0;
  Timer? _timer;
  Map<String,dynamic> cha = {};
  String given_answer = "";
  String showMoves = "";
  bool submit_color = false;
  _GamePageScaffoldState({required this.time_elapsed,required this.points});
  void _startTimer(){
    const elapse_duration = Duration(seconds: 1);
    _timer = Timer.periodic(
      elapse_duration, (Timer timer){
        if(time_elapsed==0){
          _timer!.cancel();
          Navigator.push(context, MaterialPageRoute(builder: (context)=>SamplePage(points:points)));
        }else{
          setState(() {
          time_elapsed--;
          });
        }
      });
  }
  Map<String,dynamic> pGen(){
    Random rand_inst = Random();
    int puzzle_index = rand_inst.nextInt(24); int enc_algo = rand_inst.nextInt(4);
    Map<String,dynamic> return_puzzle = puzzle_values[puzzle_index].fenConv();
    return_puzzle["fen_value"] = puzzle_values[puzzle_index].fen;
    switch (enc_algo){
      case 0:
        return_puzzle["Black"] = caesarCypher(return_puzzle["Black"]);
        return_puzzle["White"] = caesarCypher(return_puzzle["White"]);
        return_puzzle["enc"] = "caesar";
      case 1:
        return_puzzle["Black"] = Atbash(return_puzzle["Black"]);
        return_puzzle["White"] = Atbash(return_puzzle["White"]);
        return_puzzle["enc"] = "atbash";
      case 2:
        return_puzzle["Black"] = rot13(return_puzzle["Black"]);
        return_puzzle["White"] = rot13(return_puzzle["White"]);
        return_puzzle["enc"] = "rot13";
      case 3:
        return_puzzle["Black"] = Vigenere(return_puzzle["Black"]);
        return_puzzle["White"] = Vigenere(return_puzzle["White"]);
        return_puzzle["enc"] = "Vigenère";
      case 4:
        return_puzzle["Black"] = Affine(return_puzzle["Black"]);
        return_puzzle["White"] = Affine(return_puzzle["White"]);
        return_puzzle["enc"] = "Affine";
    }
    print("${return_puzzle}");
    return return_puzzle; 
  }
  Map<String,dynamic> correct_answer(String? correct_enc){
    Random random_inst = Random();
    Map<String,dynamic> return_map = <String,dynamic>{"c_op_pos":0,"dummy_algo":"","crt_algo":correct_enc};
    return_map["c_op_pos"] = random_inst.nextInt(2);
    int enc_index = encryption_algorithms.indexOf(correct_enc!);
    print("${encryption_algorithms} found at ${correct_enc} in index ${enc_index}");
    List filt_enc_algo = encryption_algorithms.sublist(0,enc_index)+encryption_algorithms.sublist(enc_index+1);
    return_map["dummy_algo"] = filt_enc_algo[random_inst.nextInt(filt_enc_algo.length)];
    print("return_map : ${return_map}");
    return return_map;
  }

  String secTOMin(int sec){
    
    int min = (sec/60).toInt();
    int ret_sec = sec-min*60;
    return "${min}:${ret_sec}";
  }
  List<String> solutionMovesUCI = []; // Store API result moves (UCI)
List<String> solutionMovesSAN = []; // Converted SAN moves
int moveIndex = 0; // Track progress in the solution

chess.Chess game = chess.Chess(); // Internal chess engine
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    cha = pGen();
    ui_params = correct_answer(cha["enc"]);
    _startTimer();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(  
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: Column(
          children: [
            Text("Time : ${time_elapsed}",
            style: TextStyle(color: Colors.white,
              fontFamily: "Rubrik",fontSize: 10),
              textAlign: ui.TextAlign.center,),
              Text("Points : ${points}",
            style: TextStyle(color: Colors.white,
              fontFamily: "Rubrik",fontSize: 10),
              textAlign: ui.TextAlign.center,),
          ],
        ),
        title: Center(
          child: Text("CRYPTOCHESS",
          style: TextStyle(color: Colors.white,
          fontFamily: "Rubrik"),
          textAlign: ui.TextAlign.center,),
        ),
      ),
      body: Container(
        color: Colors.black,
        height: double.infinity,
        width: double.infinity,
        child: ListView(
          scrollDirection: Axis.vertical,
          children: [
            Center(
              child: Container(
                padding: const EdgeInsets.all(8.0),
                child: Stack(
                        children: [
              // Chessboard
              Padding(
                padding: EdgeInsets.all(20),
                child: Container(
                  width: 200,
                  height: 200,
                  child: ChessBoard(
                    controller: _boardController,
                    boardColor: BoardColor.brown,
                    boardOrientation: PlayerColor.white,
                  ),
                ),
              ),
              
              for (int i = 0; i < 8; i++)
                Positioned(
                  left: 0,
                  top: 15 + (i * 26.5),
                  child: Text(
                    '${8 - i}',
                    style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold,fontFamily: "Rubik",color:Colors.white),
                  ),
                ),
              for (int i = 0; i < 8; i++)
                Positioned(
                  left: 25 + (i * 27), 
                  bottom: 0,
                  child: Text(
                    String.fromCharCode(97 + i),
                    style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold,fontFamily: "Rubik",color: Colors.white),
                  ),
                ),
                        ],
                      ),
              
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text('Black peices :\n${cha["Black"]}',style: TextStyle(color: Colors.white,letterSpacing: 2,fontWeight: FontWeight.bold),),),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text('White peices :\n${cha["White"]}',style: TextStyle(color: Colors.white,letterSpacing: 2,fontWeight: FontWeight.bold,),),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text('TO MOVE : ${cha["toMove"]}',style: TextStyle(color: Colors.white,letterSpacing: 2,fontWeight: FontWeight.bold,),),
            ),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Center(child: Text("CHOOSE THE CORRECT ALGORITHM",style: TextStyle(fontFamily: "Rubrik",color: Colors.white,),),)
            ),
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                ElevatedButton(style: ElevatedButton.styleFrom(
                  disabledBackgroundColor: ui_params["c_op_pos"] == 1?Colors.grey.withOpacity(0.5):ui.Color.fromRGBO(6,185,129,1),
                  disabledForegroundColor: Colors.black,
                ),onPressed:listen_event? 
                () {
                      if (ui_params["c_op_pos"] == 0) {
                        
      _boardController.loadFen(cha["fen_value"]!);
      print("enters_1");
      setState(() {
        points+=2;
        listen_event = false;
        List<String> l_1 = [];        
        for(int i=1;i<cha["moves"].length;i+=2){
          l_1.add(cha["moves"][i]);
        }
        showMoves = l_1.join(" ");
      });
    } else {
      Navigator.of(context).push(MaterialPageRoute(builder: (context) => GamePage(time_elapsed: time_elapsed, puz_value: puzzle_values, points: points),));
    }
                }:null, child: Text("${(ui_params["c_op_pos"]==0)?ui_params['crt_algo']:ui_params["dummy_algo"]}")),
                ElevatedButton(onPressed: listen_event? 
                () {
                      if (ui_params["c_op_pos"] == 1) {
                        points+=2;
      _boardController.loadFen(cha["fen_value"]!);
      print("enters_1");
      setState(() {
        listen_event = false;
        List<String> l_1 = [];        
        for(int i=1;i<cha["moves"].length;i+=2){
          l_1.add(cha["moves"][i]);
        }
        showMoves = l_1.join(" ");
      });
    } else {
      Navigator.of(context).push(MaterialPageRoute(builder: (context) => GamePage(time_elapsed: time_elapsed, puz_value: puzzle_values, points: points),));
    }
                }:null, child: Text("${(ui_params["c_op_pos"]==1)?ui_params['crt_algo']:ui_params["dummy_algo"]}"),
                style: ElevatedButton.styleFrom(
                  disabledBackgroundColor: ui_params["c_op_pos"] == 0?Colors.grey.withOpacity(0.5):ui.Color.fromRGBO(6,185,129,1),
                  disabledForegroundColor: Colors.black,
                ))
              ],),
            ),
            Container(
              padding: const EdgeInsets.all(8.0),
              width: double.infinity,
              height: 100,
              child: Text('COMPUTER MOVES :\n${showMoves}',style: TextStyle(color: Colors.white,letterSpacing: 2,fontWeight: FontWeight.bold,fontFamily: "Rubik"),),
            ),
            Padding(padding: EdgeInsets.all(8),
              child: Text("YOUR ANSWER",style: TextStyle(
                color: Colors.white,
                fontFamily: "Rubik",
              ),),

            ),
            Container(
              width: MediaQuery.of(context).size.width-30,
              padding: EdgeInsets.symmetric(horizontal: 15,vertical: 10),
              child: TextField(
                readOnly: listen_event,
                style: TextStyle(color: Colors.white, fontFamily: "Rubik"),
                decoration: InputDecoration(
                  fillColor: ui.Color.fromRGBO(32,32,32,1),
                  border: OutlineInputBorder(borderSide: BorderSide(color: Colors.white,width: 2))
                ),
                onChanged: (onValue){
                  given_answer = onValue;
                },
              ),
            ),
            Center(
              child: Container(
                width: 100,
                child: ElevatedButton(onPressed: !listen_event?(){
                  String extracted_correct_answer = "";
                  for(int i=0;i<cha["moves"].length;i+=2){
                    extracted_correct_answer+=cha["moves"][i]+" ";
                  }
                  extracted_correct_answer = extracted_correct_answer.trim();
                  if(extracted_correct_answer==given_answer){
                    setState(() {
                        submit_color = true;
                        points+=40;
                    });
                  }
                  sleep(Duration(milliseconds: 500));
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => GamePage(time_elapsed: time_elapsed, puz_value: puzzle_values, points: points),));
                }:null
                , child: Text("SUBMIT",),style: ElevatedButton.styleFrom(
                  disabledBackgroundColor: Colors.grey.withOpacity(0.5),
                  disabledForegroundColor: Colors.black,
                  backgroundColor: !submit_color?Colors.white:ui.Color.fromRGBO(6,185,129,1)
                ),),
              ),
            )
          ],
        ),
      ),     
    );
  }

}
