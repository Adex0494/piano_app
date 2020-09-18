import 'package:flutter/material.dart';
class PianoPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState(){
    return PianoPageState();
  }
} 

class PianoPageState extends State<PianoPage> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
            backgroundColor: Colors.grey,
            body: Padding(
                padding: EdgeInsets.only(top: 20.0),
                child: Row(children: <Widget>[
                  Expanded(
                      child: Column(
                    //crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      PianoButtonWithSuperKey(
                          onMainKeyPress: () {}, onSuperKeyPress: () {}),
                      PianoButton(onKeyPress: () {}),
                      PianoButtonWithSuperKey(
                          onMainKeyPress: () {}, onSuperKeyPress: () {}),
                      PianoButtonWithSuperKey(
                          onMainKeyPress: () {}, onSuperKeyPress: () {}),
                      PianoButton(onKeyPress: () {}),
                      PianoButtonWithSuperKey(
                          onMainKeyPress: () {}, onSuperKeyPress: () {}),
                      PianoButtonWithSuperKey(
                          onMainKeyPress: () {}, onSuperKeyPress: () {}),
                      PianoButtonWithSuperKey(
                          onMainKeyPress: () {}, onSuperKeyPress: () {}),
                      PianoButton(onKeyPress: () {}),
                      PianoButtonWithSuperKey(
                          onMainKeyPress: () {}, onSuperKeyPress: () {}),
                      PianoButtonWithSuperKey(
                          onMainKeyPress: () {}, onSuperKeyPress: () {}),
                      PianoButton(onKeyPress: () {}),
                      PianoButtonWithSuperKey(
                          onMainKeyPress: () {}, onSuperKeyPress: () {}),
                      PianoButtonWithSuperKey(
                          onMainKeyPress: () {}, onSuperKeyPress: () {}),
                      PianoButtonWithSuperKey(
                          onMainKeyPress: () {}, onSuperKeyPress: () {}),
                      PianoButton(onKeyPress: () {}),
                      PianoButtonWithSuperKey(
                          onMainKeyPress: () {}, onSuperKeyPress: () {}),
                      PianoButtonWithSuperKey(
                          onMainKeyPress: () {}, onSuperKeyPress: () {}),
                    ],
                  )),
                  Expanded(
                      child: Column(
                    //crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      PianoButton(onKeyPress: () {}),
                      PianoButton(onKeyPress: () {}),
                      PianoButtonWithSuperKey(
                          onMainKeyPress: () {}, onSuperKeyPress: () {}),
                      PianoButtonWithSuperKey(
                          onMainKeyPress: () {}, onSuperKeyPress: () {}),
                      PianoButtonWithSuperKey(
                          onMainKeyPress: () {}, onSuperKeyPress: () {}),
                      PianoButton(onKeyPress: () {}),
                      PianoButtonWithSuperKey(
                          onMainKeyPress: () {}, onSuperKeyPress: () {}),
                      PianoButtonWithSuperKey(
                          onMainKeyPress: () {}, onSuperKeyPress: () {}),
                      PianoButton(onKeyPress: () {}),
                      PianoButtonWithSuperKey(
                          onMainKeyPress: () {}, onSuperKeyPress: () {}),
                      PianoButtonWithSuperKey(
                          onMainKeyPress: () {}, onSuperKeyPress: () {}),
                      PianoButtonWithSuperKey(
                          onMainKeyPress: () {}, onSuperKeyPress: () {}),
                      PianoButton(onKeyPress: () {}),
                      PianoButtonWithSuperKey(
                          onMainKeyPress: () {}, onSuperKeyPress: () {}),
                      PianoButtonWithSuperKey(
                          onMainKeyPress: () {}, onSuperKeyPress: () {}),
                      PianoButton(onKeyPress: () {}),
                      PianoButtonWithSuperKey(
                          onMainKeyPress: () {}, onSuperKeyPress: () {}),
                      PianoButtonWithSuperKey(
                          onMainKeyPress: () {}, onSuperKeyPress: () {}),
                    ],
                  ))
                ]))));
  }
}

class PianoButtonWithSuperKey extends StatelessWidget {
  final Function onMainKeyPress;
  final Function onSuperKeyPress;

  const PianoButtonWithSuperKey(
      {Key key, @required this.onMainKeyPress, @required this.onSuperKeyPress})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Expanded(
        flex: 1,
        child: Stack(overflow: Overflow.visible, children: <Widget>[
          Padding(
              padding: const EdgeInsets.only(bottom: 0.5, top: 0.5),
              child: Container(
                width: double.infinity, // 200.0,
                height: double.infinity,
                child: RaisedButton(
                  onPressed: onMainKeyPress,
                ),
              )),
          Positioned(
              top: -9.0,
              child: Container(
                  width: 115.0,
                  height: 17.0,
                  child: RaisedButton(
                    color: Colors.black,
                    onPressed: onSuperKeyPress,
                  )))
        ]));
  }
}

class PianoButton extends StatelessWidget {
  final Function onKeyPress;

  const PianoButton({Key key, @required this.onKeyPress}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Expanded(
        flex: 1,
        child: Padding(
            padding: const EdgeInsets.only(bottom: 0.5, top: 0.5),
            child: Container(
                width: double.infinity, //200.0,
                height: double.infinity,
                child: RaisedButton(
                  onPressed: onKeyPress,
                ))));
  }
}
