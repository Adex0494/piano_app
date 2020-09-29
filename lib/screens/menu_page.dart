import 'package:flutter/material.dart';
import 'piano_page.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class MenuPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return MenuState();
  }
}

class MenuState extends State<MenuPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('Pianist Bot')),
      backgroundColor: Colors.black,
      body: scaffoldBody(),
    );
  }

  Widget scaffoldBody() {
    return Column(
      children: <Widget>[
        menuOption('images/teclado.png', 'Teclado',4.0,0,navigateToPianoPage),
        menuOption('images/biblioteca musical.png', 'Biblioteca Musical',4.0,0,navigateToPianoPage),
        menuOption('images/panel de control.png', 'Panel de Control',4.0,4.0,navigateToPianoPage)
      ],
    );
  }

  Widget menuOption (String imageDir, String text, double topAndSidePadding,double bottomPadding,Function function){
    return 
        Expanded(
            
            child: Center(
                child: Padding(
                    padding: EdgeInsets.only(top:topAndSidePadding,bottom: bottomPadding,left: topAndSidePadding,right: topAndSidePadding),
                    child: Container(
                        
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(color: Colors.black, width: 1),
                            borderRadius: BorderRadius.circular(5)),
                        width: double.infinity,
                        height: double.infinity,
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Container(
                                width: 100.0,
                                height: 100.0,
                                child: FlatButton(
                                    onPressed: function,
                                    child: Image.asset(imageDir)),
                              ),
                              (Text(
                                text,
                                style: TextStyle(
                                    color: Colors.black, fontSize: 16.0),
                              ))
                            ])))));
  }

  void navigateToPianoPage() {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return PianoPage();
    }));
  }

  void post(){
    var client = http.Client();
    try{
      var url = 'http://192.168.1.5:300/switchLed';
      client.post(url,body: json.encode({'status':true}),headers: {'Content-type':'application/json'}).then((response){
        print('status: ${true.toString()}');
      });
    }
    finally{
      client.close();
    }

  }
}
