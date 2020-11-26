import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class PlayPage extends StatefulWidget{
  final String songName;
  PlayPage(this.songName);
  @override
  State<StatefulWidget> createState(){
    return PlayPageState(this.songName);
  }
}

class PlayPageState extends State<PlayPage>{
  String songName;
  PlayPageState(this.songName);

  @override
  Widget build(BuildContext context){
    return WillPopScope(
      onWillPop: () {
       moveToLastScreen();
      },
        child: Scaffold(
        appBar: AppBar(title: Text('Reproduciendo'),

        ),
        backgroundColor: Colors.white,
        body: scaffoldBody(),
      ),
    );
  }
  void moveToLastScreen() {
    sendHttpPostRequest();
    Navigator.pop(context);
  }

    void sendHttpPostRequest() {
      //const url = 'https://pianoapp-f3679.firebaseio.com/keys.json';
      const url = 'http://10.0.0.11:5000/stopPlay';
      http.post(url).then((response) {
      });

    }

  Widget scaffoldBody(){
    return SingleChildScrollView(
          child: Center(
        child: Column(
          children: <Widget>[
            Container(
              width: 300,
              height: 400,
              child: Image.asset('images/pianoPlay.jpg'),
            ),
            Text(songName,style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
            Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                      width: 50,
                      height: 50,
                      child: Image.asset('images/circle-cropped-1.png')),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                      width: 50,
                      height: 50,
                      child: Image.asset('images/circle-cropped.png')),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                        width: 50,
                        height: 50,
                        child: Image.asset('images/circle-cropped-2.png')),
                ),

            ]
            )

          ]
        )
      ),
    );
  }
}