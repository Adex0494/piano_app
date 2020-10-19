import 'package:flutter/material.dart';

class MenuOption extends StatelessWidget {
  final double topPadding;
  final double sidePadding;
  final double bottomPadding;
  final String text;
  final Function function;
  final String imageDir;

  MenuOption(this.topPadding, this.sidePadding, this.bottomPadding, this.text,
      this.function, this.imageDir);

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: Center(
            child: Padding(
                padding: EdgeInsets.only(
                    top: topPadding,
                    bottom: bottomPadding,
                    left: sidePadding,
                    right: sidePadding),
                child: Container(
                  width: double.infinity,
                  //height: 140,
                  child: Card(
                      //color: Colors.white,
                      elevation: 7,
                      //shadowColor: Colors.black,
                      // alignment: Alignment.center,
                      // decoration: BoxDecoration(
                      //     color: Colors.white,
                      //     border: Border.all(color: Colors.black, width: 1),
                      //     borderRadius: BorderRadius.circular(5)),
                      // width: 140,
                      // height: 140,
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            FlatButton(
                                onPressed: function,
                                child: Column(
                                  children: [
                                    Container(width: double.infinity,height: 100, child: Image.asset(imageDir)),
                                    Text(
                                      text,
                                      style: TextStyle(
                                          color: Colors.black, fontSize: 16.0),
                                    )
                                  ],
                                )),
                          ])),
                ))));
  }
}
