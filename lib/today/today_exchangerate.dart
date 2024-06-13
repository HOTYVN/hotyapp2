import 'package:flutter/material.dart';
import 'package:hoty/common/footer.dart';
import 'package:hoty/main/main_page.dart';


class TodayExchangerate extends StatelessWidget {
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
        titleSpacing: -8.0,
        title: Container(
          /*width: 80 * (MediaQuery.of(context).size.width / 360),
          height: 80 * (MediaQuery.of(context).size.height / 360),
          child: Image(image: AssetImage('assets/logo.png')),*/
          child: Text("Exchange Rate" , style: TextStyle(fontSize: 16,  color: Colors.black, fontWeight: FontWeight.bold,)
          ),
        ),
        //centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              margin : EdgeInsets.fromLTRB(15 * (MediaQuery.of(context).size.width / 360), 5 * (MediaQuery.of(context).size.height / 360),
                  15 * (MediaQuery.of(context).size.width / 360), 5 * (MediaQuery.of(context).size.height / 360)),
              width: 350 * (MediaQuery.of(context).size.width / 360),
              height: 25 * (MediaQuery.of(context).size.height / 360),
              decoration: BoxDecoration (
                  border : Border(
                      bottom: BorderSide(color: Color.fromRGBO(243, 246, 248, 1), width : 2 * (MediaQuery.of(context).size.width / 360))
                  )
              ),
              child: Row(
                children: [
                  Container( //
                    width: 210 * (MediaQuery.of(context).size.width / 360),
                    child: Text("Today Exchange Rate", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
                  ),
                  Container(
                    child: Text("2023/06/20 00:00", style: TextStyle(color: Color.fromRGBO(196,204,208,1), fontSize: 14),),
                    
                  ),
                ],
              ),
            ),
            Container(
              child: Column(
                children: [
                  Container(
                    margin : EdgeInsets.fromLTRB(15 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360),
                        15 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360)),
                    width: 350 * (MediaQuery.of(context).size.width / 360),
                    height: 20 * (MediaQuery.of(context).size.height / 360),
                    child: Text("Hello, this is Hoty a living assistant in Ho Chi Minh City. Today's exchange rate is"),
                  ),
                  Container(
                    margin : EdgeInsets.fromLTRB(15 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360),
                        15 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360)),
                    width: 350 * (MediaQuery.of(context).size.width / 360),
                    height: 15 * (MediaQuery.of(context).size.height / 360),
                    child: Text("1 USD = 23.600 VND", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
                  ),
                  Container(
                    margin : EdgeInsets.fromLTRB(15 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360),
                        15 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360)),
                    width: 350 * (MediaQuery.of(context).size.width / 360),
                    height: 10 * (MediaQuery.of(context).size.height / 360),
                    child: Text("Thank you."),
                  ),
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
      bottomNavigationBar: Footer(nowPage: 'Today_page'),
    );
  }
}