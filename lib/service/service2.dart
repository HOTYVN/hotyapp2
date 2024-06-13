import 'package:flutter/material.dart';
import 'package:hoty/common/footer.dart';
import 'package:hoty/service/service_guide.dart';

class Service2 extends StatelessWidget {
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
            Navigator.pop(context);
          },
        ),
        title: Container(
          //width: 80 * (MediaQuery.of(context).size.width / 360),
          //height: 80 * (MediaQuery.of(context).size.height / 360),
          /*child: Image(image: AssetImage('assets/logo.png')),*/
          child: Text("Real estate counselling request" , style: TextStyle(fontSize: 18,  color: Colors.black, fontWeight: FontWeight.bold,),
          ),
        ),
        //centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: 350 * (MediaQuery.of(context).size.width / 360),
              height: 25 * (MediaQuery.of(context).size.height / 360),
              margin : EdgeInsets.fromLTRB(0 * (MediaQuery.of(context).size.height / 360), 5 * (MediaQuery.of(context).size.height / 360),
                  0 * (MediaQuery.of(context).size.height / 360), 0 * (MediaQuery.of(context).size.height / 360)),
              decoration: BoxDecoration(
                border: Border.all(
                    color: Color.fromRGBO(243, 246, 248, 1)
                ),
                borderRadius: BorderRadius.circular(3 * (MediaQuery.of(context).size.height / 360)),
                color: Color.fromRGBO(255, 255, 255, 1),
              ),
              child: TextField(
                decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                    borderSide: BorderSide(
                      color: Color.fromRGBO(243, 246, 248, 1),
                    ),
                  ),
                  // labelText: 'Search',
                  hintText: 'Name',
                ),
              ),
            ),
            Container(
              width: 350 * (MediaQuery.of(context).size.width / 360),
              height: 25 * (MediaQuery.of(context).size.height / 360),
              margin : EdgeInsets.fromLTRB(0 * (MediaQuery.of(context).size.height / 360), 5 * (MediaQuery.of(context).size.height / 360),
                  0 * (MediaQuery.of(context).size.height / 360), 0 * (MediaQuery.of(context).size.height / 360)),

              child: Row(
                children: [
                  Container(
                    width: 95 * (MediaQuery.of(context).size.width / 360),
                    height: 25 * (MediaQuery.of(context).size.height / 360),
                    decoration: BoxDecoration(
                      border: Border.all(
                          color: Color.fromRGBO(243, 246, 248, 1)
                      ),
                      borderRadius: BorderRadius.circular(3 * (MediaQuery.of(context).size.height / 360)),
                      color: Color.fromRGBO(255, 255, 255, 1),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text("+84", style: TextStyle(fontSize: 16, color: Colors.black),),
                        Icon(Icons.expand_more, color: Colors.black, size: 35,),
                      ],
                    ),
                  ),

                  Container(
                    width: 250 * (MediaQuery.of(context).size.width / 360),
                    height: 25 * (MediaQuery.of(context).size.height / 360),
                    /*padding : EdgeInsets.fromLTRB(10 * (MediaQuery.of(context).size.height / 360), 7 * (MediaQuery.of(context).size.height / 360),
                        3 * (MediaQuery.of(context).size.height / 360), 0 * (MediaQuery.of(context).size.height / 360)),*/
                    decoration: BoxDecoration(
                      border: Border.all(
                          color: Color.fromRGBO(243, 246, 248, 1)
                      ),
                      borderRadius: BorderRadius.circular(3 * (MediaQuery.of(context).size.height / 360)),
                      color: Color.fromRGBO(255, 255, 255, 1),
                    ),
                    child: TextField(
                      decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(5)),
                          borderSide: BorderSide(
                            color: Color.fromRGBO(243, 246, 248, 1),
                          ),
                        ),
                        // labelText: 'Search',
                        hintText: 'Phone number',
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: 350 * (MediaQuery.of(context).size.width / 360),
              height: 25 * (MediaQuery.of(context).size.height / 360),
              margin : EdgeInsets.fromLTRB(0 * (MediaQuery.of(context).size.height / 360), 5 * (MediaQuery.of(context).size.height / 360),
                  0 * (MediaQuery.of(context).size.height / 360), 0 * (MediaQuery.of(context).size.height / 360)),
              decoration: BoxDecoration(
                border: Border.all(
                    color: Color.fromRGBO(243, 246, 248, 1)
                ),
                borderRadius: BorderRadius.circular(3 * (MediaQuery.of(context).size.height / 360)),
                color: Color.fromRGBO(255, 255, 255, 1),
              ),
              child: Row(
                children: [
                  Container(
                    width: 295 * (MediaQuery.of(context).size.width / 360),
                    /*padding : EdgeInsets.fromLTRB(10 * (MediaQuery.of(context).size.height / 360), 0 * (MediaQuery.of(context).size.height / 360),
                        3 * (MediaQuery.of(context).size.height / 360), 0 * (MediaQuery.of(context).size.height / 360)),*/
                    child: TextField(
                      decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(5)),
                          borderSide: BorderSide(
                            color: Color.fromRGBO(255, 255, 255, 1),
                          ),
                        ),
                        // labelText: 'Search',
                        hintText: 'Consultation time',
                      ),
                    ),
                  ),
                  Container(
                    width: 50 * (MediaQuery.of(context).size.width / 360),
                    child: Center(
                      child : Icon(Icons.edit_calendar, size: 20,),
                    )
                  ),
                ],
              ),
            ),
            Container(
              width: 350 * (MediaQuery.of(context).size.width / 360),
              height: 80 * (MediaQuery.of(context).size.height / 360),
              margin : EdgeInsets.fromLTRB(5 * (MediaQuery.of(context).size.height / 360), 5 * (MediaQuery.of(context).size.height / 360),
                  5 * (MediaQuery.of(context).size.height / 360), 0 * (MediaQuery.of(context).size.height / 360)),
              padding : EdgeInsets.fromLTRB(5 * (MediaQuery.of(context).size.height / 360), 5 * (MediaQuery.of(context).size.height / 360),
                  0 * (MediaQuery.of(context).size.height / 360), 0 * (MediaQuery.of(context).size.height / 360)),
              decoration: BoxDecoration(
                border: Border.all(
                    color: Color.fromRGBO(243, 246, 248, 1)
                ),
                borderRadius: BorderRadius.circular(3 * (MediaQuery.of(context).size.height / 360)),
                color: Color.fromRGBO(255, 255, 255, 1),
              ),
              child: TextField(
                maxLines: 5,
                minLines: 5,
                decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                    borderSide: BorderSide(
                      color: Color.fromRGBO(255, 255, 255, 1),
                    ),
                  ),
                  // labelText: 'Search',
                  hintText: 'Please provide the information you need for real estate consultation, such as move-in date, budget, and apartment name. Please be specific to expedite your property search.',
                ),
              ),
            ),
            Container(
              margin : EdgeInsets.fromLTRB(10 * (MediaQuery.of(context).size.width / 360), 5 * (MediaQuery.of(context).size.height / 360),
                  0 * (MediaQuery.of(context).size.width / 360), 5 * (MediaQuery.of(context).size.height / 360)),
              width: 350 * (MediaQuery.of(context).size.width / 360),
              height: 51 * (MediaQuery.of(context).size.height / 360),
              decoration: BoxDecoration(
                border: Border.all(
                    color: Color.fromRGBO(255, 255, 255, 1)
                ),
                borderRadius: BorderRadius.circular(3 * (MediaQuery.of(context).size.height / 360)),
                color: Color.fromRGBO(243, 246, 248, 1),
              ),

              child: Column(
                children: [
                  Container(
                    width: 350 * (MediaQuery.of(context).size.width / 360),
                    height: 15 * (MediaQuery.of(context).size.height / 360),
                    padding: EdgeInsets.fromLTRB(15 * (MediaQuery.of(context).size.width / 360), 5 * (MediaQuery.of(context).size.height / 360),
                        0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360) ),
                    child: Text("Announcement", style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold
                      ),
                    ),
                  ),
                  Container(
                    width: 350 * (MediaQuery.of(context).size.width / 360),
                    height: 35 * (MediaQuery.of(context).size.height / 360),
                    padding: EdgeInsets.fromLTRB(15 * (MediaQuery.of(context).size.width / 360), 5 * (MediaQuery.of(context).size.height / 360),
                        60 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360) ),
                    child: Text("The responsible party will review your application and contact you via the provided mobile number.", style: TextStyle(
                        fontSize: 14,
                    ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: 340 * (MediaQuery.of(context).size.width / 360),
              height: 30 * (MediaQuery.of(context).size.height / 360),
              padding : EdgeInsets.fromLTRB(5 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360),
                  5 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360)),
              margin : EdgeInsets.fromLTRB(0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360),
                  0 * (MediaQuery.of(context).size.width / 360), 5 * (MediaQuery.of(context).size.height / 360)),
              child: Row(
                children: [
                  Container(
                    width: 330 * (MediaQuery.of(context).size.width / 360),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Color.fromRGBO(228, 116, 33, 1),
                          padding: EdgeInsets.symmetric(horizontal: 5 * (MediaQuery.of(context).size.width / 360), vertical: 10 * (MediaQuery.of(context).size.height / 360)),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5 * (MediaQuery.of(context).size.height / 360))
                          )
                      ),
                      /*onPressed: (){
                        Navigator.push(context, MaterialPageRoute(
                          builder: (context) {
                            return Service();
                          },
                        ));
                      },*/
                      onPressed : () => FlutterDialog(context),
                      child:  Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text('Apply', style: TextStyle(fontSize: 20),textAlign: TextAlign.center,),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),

            Container(
              margin: EdgeInsets.fromLTRB(
                0 * (MediaQuery.of(context).size.width / 360),
                40 * (MediaQuery.of(context).size.height / 360),
                0 * (MediaQuery.of(context).size.width / 360),
                0 * (MediaQuery.of(context).size.height / 360),
              ),
            ),
          ],
        ),
      ),
      extendBody: true,
      bottomNavigationBar: Footer(nowPage: ''),
    );
  }

  void FlutterDialog(context) {
    showDialog(
        context: context,
        //barrierDismissible - Dialog를 제외한 다른 화면 터치 불가
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            // RoundedRectangleBorder - Dialog 화면 모서리 둥글게 조절
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0)),
            //Dialog Main Title
            /*title: Column(
              children: <Widget>[
                new Text("Dialog Title"),
              ],
            ),*/
            //
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  "등록이 완료되었습니다.",
                ),
              ],
            ),
            actions: <Widget>[
              TextButton(
                child: new Text("확인"),
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.push(context, MaterialPageRoute(
                    builder: (context) {
                      return Service_guide(table_nm: null,);
                    },
                  ));
                },
              ),
            ],
          );
        });
  }
}