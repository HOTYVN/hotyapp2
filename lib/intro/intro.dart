import 'package:flutter/material.dart';
import 'package:hoty/intro/intro_one.dart';
import 'package:hoty/intro/intro_two.dart';
import 'package:hoty/intro/intro_three.dart';
import 'package:hoty/intro/intro_four.dart';

class Intro extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return PageView(
      children: [
        IntroOne(),
        IntroTwo(),
        IntroThree(),
        IntroFour()
      ],
    );
  }
}