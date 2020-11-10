import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import '../main.dart';
import 'package:flutter/services.dart';

class PianoPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return PianoPageState();
  }
}

class PianoPageState extends State<PianoPage> {
  String finger = '1';
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
    PianoApp.stopwatch.stop();
    debugPrint(PianoApp.stopwatch.elapsedMilliseconds.toString());
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final PreferredSizeWidget appBar =
        AppBar(title: Text('Piano', style: TextStyle(color: Colors.white)));
    double totalAvailableHeight = mediaQuery.size.height -
        appBar.preferredSize.height -
        mediaQuery.padding.top;

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

    Widget timeTextField(String theText,Function function) {
      return Column(
        children: [
        //   Padding(
        //     padding: const EdgeInsets.all(8.0),
        //     child: Center(
        //         child: RaisedButton(
        //           elevation: 5,
        //           onPressed: function,
        //             child: Text(
        //       theText,
        //       style: TextStyle(
        //         fontSize: 16,
        //         fontWeight: FontWeight.bold,
        //       ),
        //     ))
        //     ),
        //   ),
          TextFormField(
            //style: subtitleStyle,
            //controller: usernameController,
            cursorColor: Colors.black,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
                icon: Icon(
                  Icons.timer,
                  color: Colors.black,
                ),
                labelText: theText,
                labelStyle: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: Colors.black
                      ), 
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
        ],
      );
    }

    Widget topBar() {
      return Container(
        height: totalAvailableHeight * 0.3,
        width: mediaQuery.size.width,
        child: Row(
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
              child: timeTextField('Tiempo presionado (s)',(){})
            ),

            //Tiempo Delay
            //Tiempo presionado
            Expanded( 
              child: timeTextField('Tiempo delay (s)',(){})
            ),

            //Salvar
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Container(
                    height: totalAvailableHeight * 0.08,
                    width: mediaQuery.size.width/5.5,
                    child: RaisedButton(
                      onPressed: null,
                      color: Colors.white,
                      elevation: 7,
                      child: Text('Grabar',style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        )),
                    ),
                  ),
                  Container(
                    width: mediaQuery.size.width/5.5,
                    height: totalAvailableHeight * 0.08,
                    child: RaisedButton(
                      onPressed: null,
                      color: Colors.white,
                      elevation: 7,
                      child: Text('Guardar',style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        )),
                    ),
                  ),
                  Container(
                   // width: ,
                   height: totalAvailableHeight * 0.08,
                   width: mediaQuery.size.width/5.5,
                    child: RaisedButton(
                      onPressed: null,
                      color: Colors.white,
                      elevation: 7,
                      child: Text('Guardar todo',style: TextStyle(
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

    Widget pianoButtonWithSuperKey(
        Function onMainKeyPress, Function onSuperKeyPress, String theText) {
      return Stack(overflow: Overflow.visible, children: <Widget>[
        Padding(
            padding: const EdgeInsets.only(bottom: 0.5, top: 0.5),
            child: Container(
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.black, width: 1.5),
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(7),
                      bottomRight: Radius.circular(7))),
              width: mediaQuery.size.width * 0.1, // 200.0,
              height: totalAvailableHeight * 0.65,
              child: RaisedButton(
                onPressed: onMainKeyPress,
              ),
            )),
        Positioned(
            top: 2.0,
            left: -mediaQuery.size.width * 0.025,
            child: Container(
                width: mediaQuery.size.width * 0.05,
                height: totalAvailableHeight * 0.4,
                child: RaisedButton(
                  color: Colors.black,
                  onPressed: onSuperKeyPress,
                ))),
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

    Widget pianoButton(Function onKeyPress, String theText) {
      return Stack(overflow: Overflow.visible, children: <Widget>[
        Padding(
            padding: const EdgeInsets.only(bottom: 0.5, top: 0.5),
            child: Container(
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.black, width: 1.5),
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(7),
                      bottomRight: Radius.circular(7))),
              width: mediaQuery.size.width * 0.1, // 200.0,
              height: totalAvailableHeight * 0.65,
              child: RaisedButton(
                onPressed: onKeyPress,
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

    return WillPopScope(
      onWillPop: () {
        moveToLastScreen();
      },
      child: Scaffold(
          backgroundColor: Colors.grey,
          appBar: appBar,
          body: Column(
            children: [
              topBar(),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Padding(
                    padding: EdgeInsets.only(top: 7.0),
                    child: Row(
                      children: <Widget>[
                        pianoButton(() {}, 'C1'),
                        pianoButtonWithSuperKey(() {}, () {}, 'D1'),
                        pianoButtonWithSuperKey(() {}, () {}, 'E1'),
                        pianoButton(() {}, 'F1'),
                        pianoButtonWithSuperKey(() {}, () {}, 'G1'),
                        pianoButtonWithSuperKey(() {}, () {}, 'A1'),
                        pianoButtonWithSuperKey(() {}, () {}, 'B1'),
                        pianoButton(() {}, 'C2'),
                        pianoButtonWithSuperKey(() {}, () {}, 'D2'),
                        pianoButtonWithSuperKey(() {}, () {}, 'E2'),
                        pianoButton(() {}, 'F2'),
                        pianoButtonWithSuperKey(() {}, () {}, 'G2'),
                        pianoButtonWithSuperKey(() {}, () {}, 'A2'),
                        pianoButtonWithSuperKey(() {}, () {}, 'B2'),
                        pianoButton(() {}, 'C3'),
                        pianoButtonWithSuperKey(() {}, () {}, 'D3'),
                        pianoButtonWithSuperKey(() {}, () {}, 'E3'),
                        pianoButton(() {}, 'F3'),
                        pianoButtonWithSuperKey(() {}, () {}, 'G3'),
                        pianoButtonWithSuperKey(() {}, () {}, 'A3'),
                        pianoButtonWithSuperKey(() {}, () {}, 'B3'),
                        pianoButton(() {}, 'C4'),
                        pianoButtonWithSuperKey(() {}, () {}, 'D4'),
                        pianoButtonWithSuperKey(() {}, () {}, 'E4'),
                        pianoButton(() {}, 'F4'),
                        pianoButtonWithSuperKey(() {}, () {}, 'G4'),
                        pianoButtonWithSuperKey(() {}, () {}, 'A4'),
                        pianoButtonWithSuperKey(() {}, () {}, 'B4'),
                        pianoButton(() {}, 'C5'),
                        pianoButtonWithSuperKey(() {}, () {}, 'D5'),
                        pianoButtonWithSuperKey(() {}, () {}, 'E5'),
                        pianoButton(() {}, 'F5'),
                        pianoButtonWithSuperKey(() {}, () {}, 'G5'),
                        pianoButtonWithSuperKey(() {}, () {}, 'A5'),
                        pianoButtonWithSuperKey(() {}, () {}, 'B5'),
                        pianoButton(() {}, 'C6'),

                        //pianoButton(() {}),
                      ],
                      // Expanded(
                      //     child: Column(
                      //   //crossAxisAlignment: CrossAxisAlignment.stretch,
                      //   children: <Widget>[
                      //     PianoButton(onKeyPress: () {}),
                      //     PianoButton(onKeyPress: () {}),
                      //     PianoButtonWithSuperKey(
                      //         onMainKeyPress: () {}, onSuperKeyPress: () {}),
                      //     PianoButtonWithSuperKey(
                      //         onMainKeyPress: () {}, onSuperKeyPress: () {}),
                      //     PianoButtonWithSuperKey(
                      //         onMainKeyPress: () {}, onSuperKeyPress: () {}),
                      //     PianoButton(onKeyPress: () {}),
                      //     PianoButtonWithSuperKey(
                      //         onMainKeyPress: () {}, onSuperKeyPress: () {}),
                      //     PianoButtonWithSuperKey(
                      //         onMainKeyPress: () {}, onSuperKeyPress: () {}),
                      //     PianoButton(onKeyPress: () {}),
                      //     PianoButtonWithSuperKey(
                      //         onMainKeyPress: () {}, onSuperKeyPress: () {}),
                      //     PianoButtonWithSuperKey(
                      //         onMainKeyPress: () {}, onSuperKeyPress: () {}),
                      //     PianoButtonWithSuperKey(
                      //         onMainKeyPress: () {}, onSuperKeyPress: () {}),
                      //     PianoButton(onKeyPress: () {}),
                      //     PianoButtonWithSuperKey(
                      //         onMainKeyPress: () {}, onSuperKeyPress: () {}),
                      //     PianoButtonWithSuperKey(
                      //         onMainKeyPress: () {}, onSuperKeyPress: () {}),
                      //     PianoButton(onKeyPress: () {}),
                      //     PianoButtonWithSuperKey(
                      //         onMainKeyPress: () {}, onSuperKeyPress: () {}),
                      //     PianoButtonWithSuperKey(
                      //         onMainKeyPress: () {}, onSuperKeyPress: () {}),
                      //   ],
                      // ))
                    )),
              ),
            ],
          )),
    );
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
