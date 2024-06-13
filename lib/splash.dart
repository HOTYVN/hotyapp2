import 'dart:async';

import 'package:flutter/material.dart';
import 'package:gif/gif.dart';
// import 'package:video_player/video_player.dart';
import 'dart:convert';
import 'main.dart';

class VideoApp extends StatefulWidget {
  const VideoApp({super.key});

  @override
  _VideoAppState createState() => _VideoAppState();
}

class _VideoAppState extends State<VideoApp> {
  // late VideoPlayerController _controller;
  // late GifController _controller1;
  @override
  void initState() {
    super.initState();
   /* _controller = VideoPlayerController.asset("assets/test1.mp4")
      ..initialize().then((_) {
        // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
        setState(() {
          _controller.play();
        });
      });*/
  }

  @override
  Widget build(BuildContext context) {
    final String imageLogoName = 'assets/images/public/PurpleLogo.svg';

    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;


    return WillPopScope(
      onWillPop: () async => false,
      child: MediaQuery(
        data: MediaQuery.of(context).copyWith(textScaleFactor:1.0),
        child: Container(
          height : MediaQuery.of(context).size.height,
          color: Colors.white,
          child:  Gif(
            // controller: _controller1,
            image: AssetImage("assets/hoty_splash3.gif"),
            autostart: Autostart.once,
            onFetchCompleted: () {
              Timer(Duration(milliseconds: 2550), () {
                runApp(const MyApp());
              });
              // runApp(const MyApp());
            }
          ),

        ),
      ),
    );
  }


  /*@override
  Widget build(BuildContext context) {
    return MaterialApp(
      // title: 'Video Demo',
      home: Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: _controller.value.isInitialized
              ? AspectRatio(
            aspectRatio: _controller.value.aspectRatio,
            child: VideoPlayer(_controller),
          )
              : Container(),
        ),
   *//*     floatingActionButton: FloatingActionButton(
          onPressed: () {
            setState(() {
              _controller.value.isPlaying
                  ? _controller.pause()
                  : _controller.play();
            });
          },
          child: Icon(
            _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
          ),
        ),*//*
      ),
    );
  }
*/
 /* @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }*/
}