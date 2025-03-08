import 'package:cryptochess/home.dart';
import 'package:cryptochess/main.dart';
import 'package:flutter/material.dart';

class SamplePage extends StatelessWidget {
  int points = 0;
  SamplePage({super.key, required this.points});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: 
          Container(
            padding: EdgeInsets.symmetric(vertical: 40,horizontal: 10),
            child: Column(
              children: [
                Text("${"You expected a normal chess game, but it was me, Dio!".toUpperCase()}",style: TextStyle(
                  fontFamily: "Rubrik",
                  color: Colors.white,
                  fontSize: 16
                ),),
                Image.network("https://i.imgflip.com/9lcgoo.jpg",width: 200, height: 200,),
                Text("${"YOU SCORED : ${points}".toUpperCase()}",style: TextStyle(
                  fontFamily: "Rubrik",
                  color: Colors.white,
                  fontSize: 16
                ),),
            
            Container(
                padding: EdgeInsets.symmetric(horizontal: 10),
                width: MediaQuery.of(context).size.width,
                child: ElevatedButton(onPressed: () async{
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>HomePage()));
                }, child: Text("HOMEPAGE",style: TextStyle(
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
              ],
            ),
          ),
        )
      )
    );
  }
}