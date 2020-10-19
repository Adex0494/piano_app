import 'package:flutter/material.dart';

import '../widgets/menu_option.dart';
import 'piano_page.dart';
import 'reproduction_page.dart';
import 'statistics.dart';

class MenuPage extends StatefulWidget {
  @override
  _MenuPageState createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(title: Text('Pianist Bot', style: TextStyle(color:Colors.white)),leading: null,),
      body: menuScaffoldBody(),
    );
  }

    Widget menuScaffoldBody() {
      return Column(
        children: <Widget>[
        MenuOption(0,4,0, 'Teclado',navigateToPianoPage,'images/piano.png'),   
        MenuOption(0,4,0, 'Biblioteca Musical',navigateToReproductionPage,'images/playButton.png'),
        MenuOption(0,4,2, 'Estadística',navigateToControlPanelPage,'images/controlPanel.png'),
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

    void navigateToControlPanelPage() {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return ControlPanelPage();
    }));
  }
}