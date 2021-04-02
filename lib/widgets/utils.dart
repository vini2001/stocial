import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class StocialLoading extends StatelessWidget {

  final String? label;
  const StocialLoading({this.label});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(),
          if(label != null) Divider(color: Colors.transparent),
          if(label != null) Text('Carregando...')
        ],
      ),
    );
  }
}