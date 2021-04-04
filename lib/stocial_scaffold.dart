
import 'package:flutter/material.dart';

class StocialScaffold extends StatefulWidget{

  final Widget body;
  final String title;

  StocialScaffold({required this.body, this.title = 'Stocial'});

  @override
  State<StatefulWidget> createState() => ScaffoldState();
}

class ScaffoldState extends State<StocialScaffold> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: widget.body,
    );
  }

}