
import 'package:flutter/material.dart';

class StocialScaffold extends StatefulWidget{

  final Widget body;
  final String title;
  Widget? sideWidget;

  StocialScaffold({required this.body, this.title = 'Stocial', this.sideWidget});

  @override
  State<StatefulWidget> createState() => ScaffoldState();
}

class ScaffoldState extends State<StocialScaffold> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Stack(
          children: [
            Container(
              alignment: Alignment.center,
              width: double.infinity,
              child: Text(widget.title),
            ),
            if(widget.sideWidget != null) widget.sideWidget!
          ],
        ),
      ),
      body: widget.body,
    );
  }

}