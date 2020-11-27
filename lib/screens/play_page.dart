import 'dart:async';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../main.dart';

class PlayPage extends StatefulWidget {
  final String songName;
  PlayPage(this.songName);
  @override
  State<StatefulWidget> createState() {
    return PlayPageState(this.songName);
  }
}

class PlayPageState extends State<PlayPage> {
  String songName;
  PlayPageState(this.songName);

  bool connected = false;
  Timer timer;

  void askForConnection() {
    //debugPrint(PianoApp.connected.toString());
    if (PianoApp.connected != connected)
      setState(() {
        connected = PianoApp.connected;
      });
  }

  @override
  initState() {
    const oneSec = const Duration(milliseconds: 3000);
    timer = new Timer.periodic(oneSec, (Timer t) => askForConnection());
    super.initState();
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        moveToLastScreen();
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('Reproduciendo'),
          leading: Icon(
            Icons.circle,
            color: PianoApp.connected ? Colors.green : Colors.grey,
          ),
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
    String url = PianoApp.urlBase + '/stopPlay';
    http.post(url).then((response) {});
  }

  Widget scaffoldBody() {
    return SingleChildScrollView(
      child: Center(
          child: Column(children: <Widget>[
        Container(
          width: 300,
          height: 400,
          child: Image.asset('images/pianoPlay.jpg'),
        ),
        Text(
          songName,
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        // Row(
        //     mainAxisAlignment: MainAxisAlignment.center,
        //     children: <Widget>[
        //     Padding(
        //       padding: const EdgeInsets.all(8.0),
        //       child: Container(
        //           width: 50,
        //           height: 50,
        //           child: Image.asset('images/circle-cropped-1.png')),
        //     ),
        //     Padding(
        //       padding: const EdgeInsets.all(8.0),
        //       child: Container(
        //           width: 50,
        //           height: 50,
        //           child: Image.asset('images/circle-cropped.png')),
        //     ),
        //     Padding(
        //       padding: const EdgeInsets.all(8.0),
        //       child: Container(
        //             width: 50,
        //             height: 50,
        //             child: Image.asset('images/circle-cropped-2.png')),
        //     ),

        // ]
        // )
      ])),
    );
  }
}
