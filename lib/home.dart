
import 'package:cryptochess/main.dart';
import 'package:flutter/material.dart';
import 'package:cryptochess/model/puzzle.api.dart';
import 'package:cryptochess/model/puzzle.dart';


List<Puzzle> puzzle_values = [];
bool _isLoading = true;

void main(){
  
  runApp(HomePage());
}

class HomePage extends StatefulWidget {
  HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    ApiReq.get_puzzles().then((onValue){
      puzzle_values = onValue;
      setState(() {
        isLoading_ = false;
      }); 
    });
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: !isLoading_?HomepageScaffold():Center(child: Container(child: CircularProgressIndicator(backgroundColor: Colors.transparent, strokeWidth: 10.0, color: Colors.white)))
    );
  }
}

class HomepageScaffold extends StatefulWidget {
  HomepageScaffold({super.key});

  @override
  State<HomepageScaffold> createState() => _HomepageScaffoldState();
}

class _HomepageScaffoldState extends State<HomepageScaffold> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: Color.fromRGBO(0,0,0, 1),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [          
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 30.0,top: 100.0),
                child: Text("CRYPTOCHESS",style: TextStyle(
                  fontFamily: "Rubrik",
                  fontSize: 32.0,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,),
              ),
              Padding(padding: EdgeInsets.only(bottom: 100.0,left: 130.0),
              child: Text("BY OSPC",style: TextStyle(
                fontSize: 16.0,
                color: Colors.white
              ),)),
            ],
          ),
          Center(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 10),
              width: MediaQuery.of(context).size.width,
              child: ElevatedButton(onPressed: () async{
                Navigator.push(context, MaterialPageRoute(builder: (context)=>GamePage(time_elapsed: 1500,puz_value: puzzle_values,points: 0)));
              }, child: Text("START",style: TextStyle(
                fontFamily: "Rubrik",
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                  side: BorderSide(
                    width: 3,
                    color: Colors.white,
                  )
                )
              ),),
            ),
          )
        ],), 
      ),
    );
  }
}