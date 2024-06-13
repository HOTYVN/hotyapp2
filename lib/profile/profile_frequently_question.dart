import 'package:flutter/material.dart';
import 'package:hoty/common/footer.dart';
import 'package:hoty/main/main_page.dart';

class ProfileFrequentlyQuestion extends StatelessWidget {
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
        titleSpacing: 5,
        leadingWidth: 40,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_rounded),
          iconSize: 12 * (MediaQuery.of(context).size.height / 360),
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
        title: Container(
          //width: 80 * (MediaQuery.of(context).size.width / 360),
          //height: 80 * (MediaQuery.of(context).size.height / 360),
          /*child: Image(image: AssetImage('assets/logo.png')),*/
          child: Text("Frequently Question" , style: TextStyle(fontSize: 18,  color: Colors.black, fontWeight: FontWeight.bold,),
          ),
        ),
        //centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            TextButton(
              onPressed: (){
                Navigator.push(context, MaterialPageRoute(
                  builder: (context) {
                    return ProfileFrequentlyQuestion();
                  },
                ));
              },
              //width: 360 * (MediaQuery.of(context).size.width / 360),
              //height: 20 * (MediaQuery.of(context).size.height / 360),
              //padding: EdgeInsets.fromLTRB(10 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360),
              //    0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360) ),
              child: Row(
                children: [
                  Container(
                    padding: EdgeInsets.fromLTRB(5 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360),
                        0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360) ),
                    width: 30 * (MediaQuery.of(context).size.width / 360),
                    child : Image(image: AssetImage('assets/question_mark.png'), width: (30 * (MediaQuery.of(context).size.width / 360))),
                  ),
                  Container(
                    padding: EdgeInsets.fromLTRB(5 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360),
                        15 * (MediaQuery.of(context).size.width / 360) , 0 ),
                    width: 280 * (MediaQuery.of(context).size.width / 360),
                    child: Text("What is partial approval?",
                      style: TextStyle(
                        fontSize: 16 * (MediaQuery.of(context).size.width / 360),
                        color: Colors.black,
                        height: 0.6 * (MediaQuery.of(context).size.height / 360),
                      ),
                    ),
                  ),
                  Container(
                    width: 25 * (MediaQuery.of(context).size.width / 360),
                    child : Image(image: AssetImage('assets/down_icon.png'), width: (25 * (MediaQuery.of(context).size.width / 360))),
                  ),
                ],
              ),
            ),
            Container(
                decoration : BoxDecoration (
                    border : Border(
                        bottom: BorderSide(color : Color.fromRGBO(243, 246, 248, 1), width: 1 * (MediaQuery.of(context).size.width / 360),)
                    )
                )
            ),
            TextButton(
              onPressed: (){
                Navigator.push(context, MaterialPageRoute(
                  builder: (context) {
                    return ProfileFrequentlyQuestion();
                  },
                ));
              },
              //width: 360 * (MediaQuery.of(context).size.width / 360),
              //height: 20 * (MediaQuery.of(context).size.height / 360),
              //padding: EdgeInsets.fromLTRB(10 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360),
              //    0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360) ),
              child: Row(
                children: [
                  Container(
                    padding: EdgeInsets.fromLTRB(5 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360),
                        0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360) ),
                    width: 30 * (MediaQuery.of(context).size.width / 360),
                    child : Image(image: AssetImage('assets/question_mark.png'), width: (30 * (MediaQuery.of(context).size.width / 360))),
                  ),
                  Container(
                    padding: EdgeInsets.fromLTRB(5 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360),
                        15 * (MediaQuery.of(context).size.width / 360) , 0 ),
                    width: 280 * (MediaQuery.of(context).size.width / 360),
                    child: Text("Was the evaluation rejected hidden?",
                      style: TextStyle(
                        fontSize: 16 * (MediaQuery.of(context).size.width / 360),
                        color: Colors.black,
                        height: 0.6 * (MediaQuery.of(context).size.height / 360),
                      ),
                    ),
                  ),
                  Container(
                    width: 25 * (MediaQuery.of(context).size.width / 360),
                    child : Image(image: AssetImage('assets/down_icon.png'), width: (25 * (MediaQuery.of(context).size.width / 360))),
                  ),
                ],
              ),
            ),
            Container(
                decoration : BoxDecoration (
                    border : Border(
                        bottom: BorderSide(color : Color.fromRGBO(243, 246, 248, 1), width: 1 * (MediaQuery.of(context).size.width / 360),)
                    )
                )
            ),
            TextButton(
              onPressed: (){
                Navigator.push(context, MaterialPageRoute(
                  builder: (context) {
                    return ProfileFrequentlyQuestion();
                  },
                ));
              },
              //width: 360 * (MediaQuery.of(context).size.width / 360),
              //height: 20 * (MediaQuery.of(context).size.height / 360),
              //padding: EdgeInsets.fromLTRB(10 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360),
              //    0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360) ),
              child: Row(
                children: [
                  Container(
                    padding: EdgeInsets.fromLTRB(5 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360),
                        0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360) ),
                    width: 30 * (MediaQuery.of(context).size.width / 360),
                    child : Image(image: AssetImage('assets/question_mark.png'), width: (30 * (MediaQuery.of(context).size.width / 360))),
                  ),
                  Container(
                    padding: EdgeInsets.fromLTRB(5 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360),
                        15 * (MediaQuery.of(context).size.width / 360) , 0 ),
                    width: 280 * (MediaQuery.of(context).size.width / 360),
                    child: Text("Is it possible to edit a rejected/hidden evaluation?",
                      style: TextStyle(
                        fontSize: 16 * (MediaQuery.of(context).size.width / 360),
                        color: Colors.black,
                        height: 0.6 * (MediaQuery.of(context).size.height / 360),
                      ),
                    ),
                  ),
                  Container(
                    width: 25 * (MediaQuery.of(context).size.width / 360),
                    child : Image(image: AssetImage('assets/down_icon.png'), width: (25 * (MediaQuery.of(context).size.width / 360))),
                  ),
                ],
              ),
            ),
            Container(
                decoration : BoxDecoration (
                    border : Border(
                        bottom: BorderSide(color : Color.fromRGBO(243, 246, 248, 1), width: 1 * (MediaQuery.of(context).size.width / 360),)
                    )
                )
            ),
            TextButton(
              onPressed: (){
                Navigator.push(context, MaterialPageRoute(
                  builder: (context) {
                    return ProfileFrequentlyQuestion();
                  },
                ));
              },
              //width: 360 * (MediaQuery.of(context).size.width / 360),
              //height: 20 * (MediaQuery.of(context).size.height / 360),
              //padding: EdgeInsets.fromLTRB(10 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360),
              //    0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360) ),
              child: Row(
                children: [
                  Container(
                    padding: EdgeInsets.fromLTRB(5 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360),
                        0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360) ),
                    width: 30 * (MediaQuery.of(context).size.width / 360),
                    child : Image(image: AssetImage('assets/question_mark.png'), width: (30 * (MediaQuery.of(context).size.width / 360))),
                  ),
                  Container(
                    padding: EdgeInsets.fromLTRB(5 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360),
                        15 * (MediaQuery.of(context).size.width / 360) , 0 ),
                    width: 280 * (MediaQuery.of(context).size.width / 360),
                    child: Text("If I edit my evaluation, can I still receive unaccrued points?",
                      style: TextStyle(
                        fontSize: 16 * (MediaQuery.of(context).size.width / 360),
                        color: Colors.black,
                        height: 0.6 * (MediaQuery.of(context).size.height / 360),
                      ),
                    ),
                  ),
                  Container(
                    width: 25 * (MediaQuery.of(context).size.width / 360),
                    child : Image(image: AssetImage('assets/down_icon.png'), width: (25 * (MediaQuery.of(context).size.width / 360))),
                  ),
                ],
              ),
            ),
            Container(
                decoration : BoxDecoration (
                    border : Border(
                        bottom: BorderSide(color : Color.fromRGBO(243, 246, 248, 1), width: 1 * (MediaQuery.of(context).size.width / 360),)
                    )
                )
            ),
            TextButton(
              onPressed: (){
                Navigator.push(context, MaterialPageRoute(
                  builder: (context) {
                    return ProfileFrequentlyQuestion();
                  },
                ));
              },
              //width: 360 * (MediaQuery.of(context).size.width / 360),
              //height: 20 * (MediaQuery.of(context).size.height / 360),
              //padding: EdgeInsets.fromLTRB(10 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360),
              //    0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360) ),
              child: Row(
                children: [
                  Container(
                    padding: EdgeInsets.fromLTRB(5 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360),
                        0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360) ),
                    width: 30 * (MediaQuery.of(context).size.width / 360),
                    child : Image(image: AssetImage('assets/question_mark.png'), width: (30 * (MediaQuery.of(context).size.width / 360))),
                  ),
                  Container(
                    padding: EdgeInsets.fromLTRB(5 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360),
                        15 * (MediaQuery.of(context).size.width / 360) , 0 ),
                    width: 280 * (MediaQuery.of(context).size.width / 360),
                    child: Text("Want to delete your review?",
                      style: TextStyle(
                        fontSize: 16 * (MediaQuery.of(context).size.width / 360),
                        color: Colors.black,
                        height: 0.6 * (MediaQuery.of(context).size.height / 360),
                      ),
                    ),
                  ),
                  Container(
                    width: 25 * (MediaQuery.of(context).size.width / 360),
                    child : Image(image: AssetImage('assets/down_icon.png'), width: (25 * (MediaQuery.of(context).size.width / 360))),
                  ),
                ],
              ),
            ),
            Container(
                decoration : BoxDecoration (
                    border : Border(
                        bottom: BorderSide(color : Color.fromRGBO(243, 246, 248, 1), width: 1 * (MediaQuery.of(context).size.width / 360),)
                    )
                )
            ),
            TextButton(
              onPressed: (){
                Navigator.push(context, MaterialPageRoute(
                  builder: (context) {
                    return ProfileFrequentlyQuestion();
                  },
                ));
              },
              //width: 360 * (MediaQuery.of(context).size.width / 360),
              //height: 20 * (MediaQuery.of(context).size.height / 360),
              //padding: EdgeInsets.fromLTRB(10 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360),
              //    0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360) ),
              child: Row(
                children: [
                  Container(
                    padding: EdgeInsets.fromLTRB(5 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360),
                        0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360) ),
                    width: 30 * (MediaQuery.of(context).size.width / 360),
                    child : Image(image: AssetImage('assets/question_mark.png'), width: (30 * (MediaQuery.of(context).size.width / 360))),
                  ),
                  Container(
                    padding: EdgeInsets.fromLTRB(5 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360),
                        15 * (MediaQuery.of(context).size.width / 360) , 0 ),
                    width: 280 * (MediaQuery.of(context).size.width / 360),
                    child: Text("The evaluation has been approved, but points are not accumulated?",
                      style: TextStyle(
                        fontSize: 16 * (MediaQuery.of(context).size.width / 360),
                        color: Colors.black,
                        height: 0.6 * (MediaQuery.of(context).size.height / 360),
                      ),
                    ),
                  ),
                  Container(
                    width: 25 * (MediaQuery.of(context).size.width / 360),
                    child : Image(image: AssetImage('assets/down_icon.png'), width: (25 * (MediaQuery.of(context).size.width / 360))),
                  ),
                ],
              ),
            ),
            Container(
                decoration : BoxDecoration (
                    border : Border(
                        bottom: BorderSide(color : Color.fromRGBO(243, 246, 248, 1), width: 1 * (MediaQuery.of(context).size.width / 360),)
                    )
                )
            ),
            TextButton(
              onPressed: (){
                Navigator.push(context, MaterialPageRoute(
                  builder: (context) {
                    return ProfileFrequentlyQuestion();
                  },
                ));
              },
              //width: 360 * (MediaQuery.of(context).size.width / 360),
              //height: 20 * (MediaQuery.of(context).size.height / 360),
              //padding: EdgeInsets.fromLTRB(10 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360),
              //    0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360) ),
              child: Row(
                children: [
                  Container(
                    padding: EdgeInsets.fromLTRB(5 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360),
                        0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360) ),
                    width: 30 * (MediaQuery.of(context).size.width / 360),
                    child : Image(image: AssetImage('assets/question_mark.png'), width: (30 * (MediaQuery.of(context).size.width / 360))),
                  ),
                  Container(
                    padding: EdgeInsets.fromLTRB(5 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360),
                        15 * (MediaQuery.of(context).size.width / 360) , 0 ),
                    width: 280 * (MediaQuery.of(context).size.width / 360),
                    child: Text("The evaluation is not approved and points are not accumulated?",
                      style: TextStyle(
                        fontSize: 16 * (MediaQuery.of(context).size.width / 360),
                        color: Colors.black,
                        height: 0.6 * (MediaQuery.of(context).size.height / 360),
                      ),
                    ),
                  ),
                  Container(
                    width: 25 * (MediaQuery.of(context).size.width / 360),
                    child : Image(image: AssetImage('assets/down_icon.png'), width: (25 * (MediaQuery.of(context).size.width / 360))),
                  ),
                ],
              ),
            ),
            Container(
                decoration : BoxDecoration (
                    border : Border(
                        bottom: BorderSide(color : Color.fromRGBO(243, 246, 248, 1), width: 1 * (MediaQuery.of(context).size.width / 360),)
                    )
                )
            ),
            TextButton(
              onPressed: (){
                Navigator.push(context, MaterialPageRoute(
                  builder: (context) {
                    return ProfileFrequentlyQuestion();
                  },
                ));
              },
              //width: 360 * (MediaQuery.of(context).size.width / 360),
              //height: 20 * (MediaQuery.of(context).size.height / 360),
              //padding: EdgeInsets.fromLTRB(10 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360),
              //    0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360) ),
              child: Row(
                children: [
                  Container(
                    padding: EdgeInsets.fromLTRB(5 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360),
                        0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360) ),
                    width: 30 * (MediaQuery.of(context).size.width / 360),
                    child : Image(image: AssetImage('assets/question_mark.png'), width: (30 * (MediaQuery.of(context).size.width / 360))),
                  ),
                  Container(
                    padding: EdgeInsets.fromLTRB(5 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360),
                        15 * (MediaQuery.of(context).size.width / 360) , 0 ),
                    width: 280 * (MediaQuery.of(context).size.width / 360),
                    child: Text("The evaluation is not approved and points are not accumulated?",
                      style: TextStyle(
                        fontSize: 16 * (MediaQuery.of(context).size.width / 360),
                        color: Colors.black,
                        height: 0.6 * (MediaQuery.of(context).size.height / 360),
                      ),
                    ),
                  ),
                  Container(
                    width: 25 * (MediaQuery.of(context).size.width / 360),
                    child : Image(image: AssetImage('assets/down_icon.png'), width: (25 * (MediaQuery.of(context).size.width / 360))),
                  ),
                ],
              ),
            ),
            Container(
                decoration : BoxDecoration (
                    border : Border(
                        bottom: BorderSide(color : Color.fromRGBO(243, 246, 248, 1), width: 1 * (MediaQuery.of(context).size.width / 360),)
                    )
                )
            ),
          ],
        ),
      ),
      extendBody: true,
bottomNavigationBar: Footer(nowPage: 'My_page'),
    );
  }
}