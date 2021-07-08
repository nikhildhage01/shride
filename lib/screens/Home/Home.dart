
// @dart=2.9

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:shride/screens/Home/mainDrawer.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {






  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar:  AppBar(
          elevation: 0.0,
          title: Text('Shride',
            style: TextStyle(
              fontSize: 22,
              fontFamily: 'NotoSansJP',
            ),
          ),
        ),
        drawer: MainDrawer(),


        );
  }
}
