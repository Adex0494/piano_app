import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'dart:convert';

import '../main.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

class PianoPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return PianoPageState();
  }
}

class PianoPageState extends State<PianoPage> {
  String finger = '1';
  bool switchIsOn = false;
  int octaveOrder = 1;
  String record ='';
  String selectedKey='';
  TextEditingController timePressed = TextEditingController();
  TextEditingController delay = TextEditingController();
  TextEditingController songName = TextEditingController();
  OverlayState overlayState;
  OverlayEntry overlayEntry;
  bool overlayEntryIsOn = false;

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
    ]);
  }

  @override
  dispose() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    super.dispose();
  }

  void moveToLastScreen() {
    if (overlayEntryIsOn) {
      overlayEntry.remove();
    }
    PianoApp.stopwatch.stop();
    debugPrint(PianoApp.stopwatch.elapsedMilliseconds.toString());
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final PreferredSizeWidget appBar = AppBar(
      title: Text('Piano', style: TextStyle(color: Colors.white)),
      actions: [
        Center(
            child: Text(
          'Modo grabación',
          style: TextStyle(color: Colors.white, fontSize: 16),
        )),
        Switch(
          activeColor: Colors.white,
          activeTrackColor: Colors.white,
          inactiveThumbColor: Colors.grey,
          inactiveTrackColor: Colors.grey.withOpacity(0.5),
          value: switchIsOn,
          onChanged: (value) {
            setState(() {
              switchIsOn = value;
            });
          },
        )
      ],
    );
    double totalAvailableHeight = mediaQuery.size.height -
        appBar.preferredSize.height -
        mediaQuery.padding.top;

    void sendHttpPostRequest(String keyName) {
      //const url = 'https://pianoapp-f3679.firebaseio.com/keys.json';
      const url = 'http://192.168.0.9:3000/key';
      http.post(url,
          body: json.encode({'keyPressed': keyName}),
          headers: {'Content-type': 'application/json'}).then((response) {
      });

      // var client = http.Client();
      // var url='http://192.168.0.11:3000/switchLed';
      // client.post(url,body:json.encode({'status': true}),
      //  headers: {'Content-type':'application/json'}).then(
      //    (response){
      //      print('status: true');
      //    }
      //  );
    }

    String secondsToMiliseconds(double seconds){
      return (seconds*1000).toInt().toString();
    }

    Widget fingerRadio(String text) {
      return Container(
          child: Column(
        children: [
          Container(
            height: 19,
            width: 24,
            child: Radio(
                activeColor: Colors.black,
                value: text,
                groupValue: finger,
                onChanged: (String value) {
                  setState(() {
                    finger = value;
                  });
                }),
          ),
          Text(text, style: Theme.of(context).textTheme.headline1),
        ],
      ));
    }

    Widget timeTextField(String theText, Function function, TextEditingController theController) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
              child: Text(
            theText,
            style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          )),
          Container(
            height: mediaQuery.size.width * 0.05,
            width: mediaQuery.size.width * 0.1,
            child: TextFormField(
              controller: theController,
              //style: subtitleStyle,
              //controller: usernameController,
              cursorColor: Colors.black,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                  icon: Icon(
                    Icons.timer,
                    color: Colors.black,
                  ),
                  //labelText: theText,
                  // labelStyle: TextStyle(
                  //     fontSize: 10,
                  //     fontWeight: FontWeight.bold,
                  //     color: Colors.black),
                  enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.black)),
                  focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.black))),
              // enabledBorder: OutlineInputBorder(
              //   borderSide: BorderSide(color: Colors.redAccent),
              //   borderRadius: BorderRadius.circular(5.0),
              // )

              onChanged: (value) {
                //when Usuario text changes...
              },
            ),
          ),
        ],
      );
    }

  void _showAlertDialog(String title, String message) {
    AlertDialog alertDialog = AlertDialog(
      title: Text(title),
      content: Text(message),
    );
    showDialog(context: context, builder: (_) => alertDialog);
  }

    Widget overlayWidget(String text) {
    TextStyle subtitleStyle = Theme.of(context).textTheme.subtitle;
    return Card(
      elevation: 15.0,
      child: Column(
        children: <Widget>[
          SizedBox(
              width: 225,
              height: 75,
              child: Padding(
                  padding: EdgeInsets.all(7.0),
                  child: TextFormField(
                    style: subtitleStyle,
                    controller: songName,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                        labelText: '$text',
                        labelStyle: subtitleStyle,
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.black),
                            borderRadius: BorderRadius.circular(5.0))),
                    onChanged: (value) {
                      //When Name Text has changed...
                    },
                  ))),
          Row(
            children: <Widget>[
              Padding(
                  padding: EdgeInsets.all(3.0),
                  child: RaisedButton(
                    elevation: 3.0,
                    color: Colors.black,
                    child: Text(
                      'Registrar',
                      style: TextStyle(color: Colors.white),
                      //textScaleFactor: 1.5,
                    ),
                    onPressed: () {
                      debugPrint(record);
                      //When the Registrar button is pressed...
                      overlayEntry.remove();
                      overlayEntryIsOn = false;
                    },
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5.0)),
                  )),
              Padding(
                  padding: EdgeInsets.all(3.0),
                  child: RaisedButton(
                    elevation: 3.0,
                    color: Colors.grey,
                    child: Text(
                      'Cancelar',
                      style: TextStyle(color: Colors.white),
                      //textScaleFactor: 1.5,
                    ),
                    onPressed: () {
                      //When the Cancelar button is pressed...
                      overlayEntry.remove();
                      overlayEntryIsOn = false;
                    },
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5.0)),
                  ))
            ],
          ),
        ],
      ),
    );
  }

    showOverlay(BuildContext context) {
    songName.text = '';
    overlayState = Overlay.of(context);
    overlayEntry = OverlayEntry(
        builder: (context) => Positioned(
            top: (MediaQuery.of(context).size.height / 5.0),
            right: (MediaQuery.of(context).size.width / 2.0) - 112.5,
            child: overlayWidget('Nombre de la canción')));
    overlayState.insert(overlayEntry);
    overlayEntryIsOn = true;
  }

    Widget topBar() {
      return Container(
        color: Colors.white,
        height: totalAvailableHeight * 0.3,
        width: mediaQuery.size.width,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Dedos
            Expanded(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Center(
                        child: Text(
                      'Dedos',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    )),
                  ),
                  Padding(
                    padding: EdgeInsets.all(8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        fingerRadio('1'),
                        fingerRadio('2'),
                        fingerRadio('3'),
                        fingerRadio('4'),
                        fingerRadio('5'),
                      ],
                    ),
                  )
                ],
              ),
            ),

            //Tiempo presionado
            Expanded(
                child: Center(
                    child: timeTextField('Tiempo presionado (s)', () {}, timePressed))),

            //Tiempo Delay
            //Tiempo presionado
            Expanded(
                child: Center(child: timeTextField('Tiempo delay (s)', () {},delay))),

            //Salvar
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Container(
                    width: mediaQuery.size.width / 5.5,
                    height: totalAvailableHeight * 0.08,
                    child: RaisedButton(
                      onPressed: () {
                        if (!(timePressed.text=='' || delay.text=='' || selectedKey==''))
                        {
                          debugPrint('klk');
                          record = record + selectedKey + finger + secondsToMiliseconds(double.parse(timePressed.text)) + secondsToMiliseconds(double.parse(delay.text)); 
                          setState(() {
                            finger ='1';
                            selectedKey = '';
                            timePressed.text='';
                            delay.text = '';
                          });
                        }
                        else _showAlertDialog('Error', 'Asegúrese de usar números válidos y de presionar la tecla deseada');
                      },
                      color: Colors.white,
                      elevation: 7,
                      child: Text('Guardar',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          )),
                    ),
                  ),
                  Container(
                    // width: ,
                    height: totalAvailableHeight * 0.08,
                    width: mediaQuery.size.width / 5.5,
                    child: RaisedButton(
                      onPressed: () {
                       showOverlay(context);
                      },
                      color: Colors.white,
                      elevation: 7,
                      child: Text('Guardar todo',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          )),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      );
    }

    Widget pianoButtonWithSuperKey(String theText) {
      return Stack(overflow: Overflow.visible, children: <Widget>[
        Padding(
            padding: const EdgeInsets.only(bottom: 0.5, top: 0.5),
            child: Container(
              decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: selectedKey==theText+'n'? 7:5,
                      blurRadius: 7,
                      offset: Offset(0, 3), // changes position of shadow
                    ),
                  ],
                  color: selectedKey==theText+'n' && switchIsOn? Colors.orange: Colors.white,
                  border: Border.all(color: Colors.black, width:selectedKey==theText+'n'? 2:1),
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(7),
                      bottomRight: Radius.circular(7))),
              width: mediaQuery.size.width * 0.1, // 200.0,
              height: totalAvailableHeight * 0.65,
              child: GestureDetector(
                onTapDown: (_) {
                  setState(() {
                    selectedKey=theText+'n';
                  });
                    //sendHttpPostRequest(theText+'s1');

                },
                onTapUp: (_){
                  if(!switchIsOn)
                    //sendHttpPostRequest(theText+'s0');
                    setState(() {
                      selectedKey='';
                    });
                    
                },
              ),
            )),
        Positioned(
            top: 2.0,
            left: -mediaQuery.size.width * 0.025,
            child: Container(
                decoration: BoxDecoration(
                    color: selectedKey== theText+'s' && switchIsOn ? Colors.orange: Colors.black,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: selectedKey== theText+'s'?4:2,
                        blurRadius: 3,
                        offset: Offset(0, 3), // changes position of shadow
                      ),
                    ],
                    border: Border.all(color: switchIsOn? Colors.black: Colors.grey, width:selectedKey== theText+'s'? 1:0.5),
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(5),
                        bottomRight: Radius.circular(5))),
                width: mediaQuery.size.width * 0.05,
                height: totalAvailableHeight * 0.4,
                              child: GestureDetector(
                onTapDown: (_) {
                  setState(() {
                    selectedKey=theText+'s';
                  });
                  //if(!switchIsOn)
                    //sendHttpPostRequest(theText+'s1');
                },
                onTapUp: (_){
                  if(!switchIsOn)
                    setState(() {
                    selectedKey='';
                  });
                    //sendHttpPostRequest(theText+'s0');
                },
              ),)),
        Positioned(
            bottom: 5,
            //top: 2.0,
            left: mediaQuery.size.width * 0.038,
            child: Container(
                //alignment: Alignment.center,
                //width: mediaQuery.size.width * 0.05,
                //height: totalAvailableHeight * 0.5,
                child: Text(
              theText,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            )))
      ]);
    }

    Widget pianoButton(String theText) {
      return Stack(overflow: Overflow.visible, children: <Widget>[
        Padding(
            padding: const EdgeInsets.only(bottom: 0.5, top: 0.5),
            child: Container(
              //color: Colors.white,
              decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: selectedKey==theText+'n'? 7:5,
                      blurRadius: 7,
                      offset: Offset(0, 3), // changes position of shadow
                    ),
                  ],
                  color: selectedKey==theText+'n' && switchIsOn? Colors.orange: Colors.white,
                  border: Border.all(color: Colors.black, width:selectedKey==theText+'n'? 2:1),
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(7),
                      bottomRight: Radius.circular(7))),
              width: mediaQuery.size.width * 0.1, // 200.0,
              height: totalAvailableHeight * 0.65,
              child: GestureDetector(
                onTapDown: (_) {
                  setState(() {
                    selectedKey=theText+'n';
                  });
                  //if(!switchIsOn)
                    //sendHttpPostRequest(theText+'n1');
                },
                onTapUp: (_){
                  if(!switchIsOn)
                    setState(() {
                    selectedKey='';
                  });
                    //sendHttpPostRequest(theText+'n0');
                },
              ),
            )),
        Positioned(
            bottom: 5,
            //top: 2.0,
            left: mediaQuery.size.width * 0.038,
            child: Container(
                //alignment: Alignment.center,
                //width: mediaQuery.size.width * 0.05,
                //height: totalAvailableHeight * 0.5,
                child: Text(
              theText,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            )))
      ]);
    }

    if (!PianoApp.stopwatch.isRunning) {
      debugPrint(PianoApp.stopwatch.elapsedMilliseconds.toString());
      PianoApp.stopwatch.start();
    }
    
    Widget firstOctave(){
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
        pianoButton('C1'),
        pianoButtonWithSuperKey('D1'),
        pianoButtonWithSuperKey('E1'),
        pianoButton('F1'),
        pianoButtonWithSuperKey('G1'),
        pianoButtonWithSuperKey('A1'),
        pianoButtonWithSuperKey('B1'),
        pianoButton('C2'),
      ],);
    }

    Widget secondOctave(){
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          pianoButton('C2'),
          pianoButtonWithSuperKey('D2'),
          pianoButtonWithSuperKey('E2'),
          pianoButton('F2'),
          pianoButtonWithSuperKey('G2'),
          pianoButtonWithSuperKey('A2'),
          pianoButtonWithSuperKey('B2'),
          pianoButton('C3'),
                   
        ],
      );
    }

    Widget thirdOctave(){
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          pianoButton('C3'),
          pianoButtonWithSuperKey('D3'),
          pianoButtonWithSuperKey('E3'),
          pianoButton('F3'),
          pianoButtonWithSuperKey('G3'),
          pianoButtonWithSuperKey('A3'),
          pianoButtonWithSuperKey('B3'),
          pianoButton('C4'),
        ],
      );
    }

    Widget fourthOctave(){
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          pianoButton('C4'),
          pianoButtonWithSuperKey('D4'),
          pianoButtonWithSuperKey('E4'),
          pianoButton('F4'),
          pianoButtonWithSuperKey('G4'),
          pianoButtonWithSuperKey('A4'),
          pianoButtonWithSuperKey('B4'),
          pianoButton('C5'),
        ],
      );
    }

    Widget fifthOctave(){
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          pianoButton('C5'),
          pianoButtonWithSuperKey('D5'),
          pianoButtonWithSuperKey('E5'),
          pianoButton('F5'),
          pianoButtonWithSuperKey('G5'),
          pianoButtonWithSuperKey('A5'),
          pianoButtonWithSuperKey('B5'),
          pianoButton('C6'),
        ],
      );
    }

    Widget selectOctave(){
      switch (octaveOrder){
        case 1: return firstOctave();
        case 2: return secondOctave();
        case 3: return thirdOctave();
        case 4: return fourthOctave();
        case 5: return fifthOctave();
      }
    }

    Widget recordingBody() {
      return Column(
        children: [
          topBar(),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Padding(
                padding: EdgeInsets.only(top: 7.0),
                child: Row(
                  children: <Widget>[
                    pianoButton('C1'),
                    pianoButtonWithSuperKey('D1'),
                    pianoButtonWithSuperKey('E1'),
                    pianoButton('F1'),
                    pianoButtonWithSuperKey('G1'),
                    pianoButtonWithSuperKey('A1'),
                    pianoButtonWithSuperKey('B1'),
                    pianoButton('C2'),
                    pianoButtonWithSuperKey('D2'),
                    pianoButtonWithSuperKey('E2'),
                    pianoButton('F2'),
                    pianoButtonWithSuperKey('G2'),
                    pianoButtonWithSuperKey('A2'),
                    pianoButtonWithSuperKey('B2'),
                    pianoButton('C3'),
                    pianoButtonWithSuperKey('D3'),
                    pianoButtonWithSuperKey('E3'),
                    pianoButton('F3'),
                    pianoButtonWithSuperKey('G3'),
                    pianoButtonWithSuperKey('A3'),
                    pianoButtonWithSuperKey('B3'),
                    pianoButton('C4'),
                    pianoButtonWithSuperKey('D4'),
                    pianoButtonWithSuperKey('E4'),
                    pianoButton('F4'),
                    pianoButtonWithSuperKey('G4'),
                    pianoButtonWithSuperKey('A4'),
                    pianoButtonWithSuperKey('B4'),
                    pianoButton('C5'),
                    pianoButtonWithSuperKey('D5'),
                    pianoButtonWithSuperKey('E5'),
                    pianoButton('F5'),
                    pianoButtonWithSuperKey('G5'),
                    pianoButtonWithSuperKey('A5'),
                    pianoButtonWithSuperKey('B5'),
                    pianoButton('C6'),
                  ],
                )),
          ),
        ],
      );
    }

    Widget liveBody() {
      return Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
             IconButton(icon: Icon(Icons.arrow_back),onPressed: (){if(octaveOrder>1)setState(() {
                octaveOrder--;
             });},),
             selectOctave(),
              IconButton(icon: Icon(Icons.arrow_forward),onPressed: (){if(octaveOrder<5)setState(() {
                octaveOrder++;
             });}),
          ],
        )
      );
    }

    Widget getScaffoldBody() {
      if (!switchIsOn)
        return liveBody();
      else
        return recordingBody();
    }

    return WillPopScope(
        onWillPop: () {
          moveToLastScreen();
        },
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: appBar,
          body: getScaffoldBody(),
        ));
  }
}

// class PianoButtonWithSuperKey extends StatelessWidget {
//   final Function onMainKeyPress;
//   final Function onSuperKeyPress;

//   const PianoButtonWithSuperKey(
//       {Key key, @required this.onMainKeyPress, @required this.onSuperKeyPress})
//       : super(key: key);
//   @override
//   Widget build(BuildContext context) {
//     return Stack(overflow: Overflow.visible, children: <Widget>[
//           Padding(
//               padding: const EdgeInsets.only(bottom: 0.5, top: 0.5),
//               child: Container(
//                 width: double.infinity, // 200.0,
//                 height: double.infinity,
//                 child: RaisedButton(
//                   onPressed: onMainKeyPress,
//                 ),
//               )),
//           Positioned(
//               top: -9.0,
//               child: Container(
//                   width: 115.0,
//                   height: 17.0,
//                   child: RaisedButton(
//                     color: Colors.black,
//                     onPressed: onSuperKeyPress,
//                   )))
//         ]);
//   }
// }

// class PianoButton extends StatelessWidget {
//   final Function onKeyPress;

//   const PianoButton({Key key, @required this.onKeyPress}) : super(key: key);
//   @override
//   Widget build(BuildContext context) {
//     return Expanded(
//         flex: 1,
//         child: Padding(
//             padding: const EdgeInsets.only(bottom: 0.5, top: 0.5),
//             child: Container(
//                 width: double.infinity, //200.0,
//                 height: double.infinity,
//                 child: RaisedButton(
//                   onPressed: onKeyPress,
//                 ))));
//   }
// }
