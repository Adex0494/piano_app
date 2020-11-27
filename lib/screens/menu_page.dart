import 'package:flutter/material.dart';

import '../widgets/menu_option.dart';
import 'piano_page.dart';
import 'reproduction_page.dart';
import 'statistics.dart';
import '../main.dart';
import 'dart:async';

class MenuPage extends StatefulWidget {
  final int userId;
  final Function saveTime;
  MenuPage(this.userId, this.saveTime);
  @override
  _MenuPageState createState() => _MenuPageState(this.userId, this.saveTime);
}

class _MenuPageState extends State<MenuPage> {
  final int userId;
  final Function saveTime;
  _MenuPageState(this.userId, this.saveTime);

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
            title: Text('Pianist Bot', style: TextStyle(color: Colors.white)),
            leading: Icon(
              Icons.circle,
              color: PianoApp.connected ? Colors.green : Colors.grey,
            ),
          ),
          body: menuScaffoldBody(),
        ));
  }

  Widget menuScaffoldBody() {
    return Column(
      children: <Widget>[
        MenuOption(0, 4, 0, 'Teclado', navigateToPianoPage, 'images/piano.png'),
        MenuOption(0, 4, 0, 'Biblioteca Musical', navigateToReproductionPage,
            'images/playButton.png'),
        MenuOption(0, 4, 2, 'Estadística', navigateToStatisticsPage,
            'images/controlPanel.png'),
      ],
    );
  }

  void navigateToPianoPage() {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return PianoPage();
    }));
  }

  void navigateToReproductionPage() {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return ReproductionPage();
    }));
  }

  void navigateToStatisticsPage() {
    debugPrint('$userId');
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return StatisticsPage(userId, saveTime);
    }));
  }

  void moveToLastScreen() {
    debugPrint('Moving to last Screen');
    Navigator.pop(context, true);
  }
}
