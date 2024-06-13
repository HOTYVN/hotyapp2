import 'package:flutter/material.dart';

import 'main/main_page.dart';

class TemplatePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: true,
        /*iconTheme: IconThemeData(
            color: Colors.black
        ),*/
        leading: IconButton(
          icon: Icon(Icons.arrow_back_rounded),
          iconSize: 25,
          color: Colors.black,
          alignment: Alignment.centerLeft,
          // padding: EdgeInsets.zero,
          visualDensity: VisualDensity(horizontal: -2.0, vertical: -2.0),
          onPressed: (){
            if (Navigator.canPop(context)) {
              Navigator.of(context).pop();
            } else {
              Navigator.push(context, MaterialPageRoute(
                builder: (context) {
                  return MainPage();
                },
              ));
            }
          },
        ),
        title: GestureDetector(
          onTap: (){
            Navigator.push(context, MaterialPageRoute(
              builder: (context) {
                return MainPage();
              },
            ));
          },
          child: Container(
            width: 80 * (MediaQuery.of(context).size.width / 350),
            height: 80 * (MediaQuery.of(context).size.height / 360),
            child: Image(image: AssetImage('assets/logo.png')),
          ),
        ),
        centerTitle: true,
      ),
      body: Container(
        child: Text("여기만 수정하시면됨."),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(40),
                topRight: Radius.circular(40)
            )
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(

              margin: EdgeInsets.fromLTRB(0, 0, 15 * (MediaQuery.of(context).size.height / 360), 0),
              padding: EdgeInsets.symmetric(horizontal: 3 * (MediaQuery.of(context).size.height / 360), vertical: 0),
              width: 40 * (MediaQuery.of(context).size.width / 360),
              height: 40 * (MediaQuery.of(context).size.height / 360),
              child: Image(image: AssetImage('assets/home.png')),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(0, 0, 15 * (MediaQuery.of(context).size.height / 360), 0),
              padding: EdgeInsets.symmetric(horizontal: 3 * (MediaQuery.of(context).size.height / 360), vertical: 0),
              width: 40 * (MediaQuery.of(context).size.width / 360),
              height: 40 * (MediaQuery.of(context).size.height / 360),
              child: Image(image: AssetImage('assets/reader.png')),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(0, 0, 15 * (MediaQuery.of(context).size.height / 360), 0),
              padding: EdgeInsets.symmetric(horizontal: 3 * (MediaQuery.of(context).size.height / 360), vertical: 0),
              width: 60 * (MediaQuery.of(context).size.width / 360),
              height: 40 * (MediaQuery.of(context).size.height / 360),
              child: Image(image: AssetImage('assets/wltlrin.png')),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(0, 0, 15  * (MediaQuery.of(context).size.height / 360), 0),
              padding: EdgeInsets.symmetric(horizontal: 3 * (MediaQuery.of(context).size.height / 360), vertical: 0),
              width: 40 * (MediaQuery.of(context).size.width / 360),
              height: 40 * (MediaQuery.of(context).size.height / 360),
              child: Image(image: AssetImage('assets/search.png')),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
              padding: EdgeInsets.symmetric(horizontal: 3 * (MediaQuery.of(context).size.height / 360), vertical: 0),
              width: 40 * (MediaQuery.of(context).size.width / 360),
              height: 40 * (MediaQuery.of(context).size.height / 360),
              child: Image(image: AssetImage('assets/person.png')),
            ),
          ],
        ),
      ),
    );
  }
}