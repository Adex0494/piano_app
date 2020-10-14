import 'package:flutter/material.dart';

class MenuOption extends StatelessWidget {
  final double topAndSidePadding;
  final double bottomPadding;
  final String text;
  final Function function;
  final String imageDir;

  MenuOption(this.topAndSidePadding,this.bottomPadding,this.text,this.function,this.imageDir);

  @override
  Widget build(BuildContext context) {
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
                      width: 140,
                      height: 140,
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
}