import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hoty/common/footer.dart';
import 'package:hoty/main/main_page.dart';
import 'package:http/http.dart' as http;

import '../common/icons/my_icons.dart';
import 'guide/profile_service_guide_detail.dart';

class Profile_service_guide extends StatefulWidget {
  const Profile_service_guide({super.key});

  @override
  State<Profile_service_guide> createState() => _Profile_service_guideState();
}

class _Profile_service_guideState extends State<Profile_service_guide> {

  List<dynamic> getresult = [];
  List<dynamic> result = [];
  // list 호출
  Future<dynamic> getlistdata() async {

    var url = Uri.parse(
      'http://www.hoty.company/mf/guide/list.do',
      //'http://www.hoty.company/mf/guide/list.do',
    );

    print('######');
    try {
      Map data = {
        "board_seq": 27,
        "mysqlpage" : 0,
        "rows" : 20,
      };
      var body = json.encode(data);
      // print(body);
      var response = await http.post(
          url,
          headers: {"Content-Type": "application/json"},
          body: body
      );
      // print('Response status: ${response.statusCode}');
      // print('Response body: ${response.body}');
      if(response.statusCode == 200) {
        var resultstatus = json.decode(response.body)['resultstatus'];

        // print(resultstatus);
        // print(json.decode(response.body)['result']);
        getresult = json.decode(response.body)['result'];

        for(int i=0; i<getresult.length; i++){
          result.add(getresult[i]);
        }

        // print("asdasdasdasdasd");
        print(result);
      }
      print(result.length);
    }
    catch(e){
      print(e);
    }
  }

  @override
  void initState() {
    getlistdata().then((_) {
      setState(() {

      });
    });
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: true,
        /*iconTheme: IconThemeData(
          color: Colors.black,
        ),*/
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
        titleSpacing: 5,
        leadingWidth: 40,
        title: Container(
          //width: 80 * (MediaQuery.of(context).size.width / 360),
          //height: 80 * (MediaQuery.of(context).size.height / 360),
          /*child: Image(image: AssetImage('assets/logo.png')),*/
          alignment: Alignment.centerLeft,
          child: Text("이용방법안내" , style: TextStyle(fontSize: 18,  color: Colors.black, fontWeight: FontWeight.bold,),
            textAlign: TextAlign.left,
          ),
        ),
        //centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            for(var i = 0; i < result.length; i++)
            Container(
              child : Column(
                children: [
                  Container(
                    width: 360 * (MediaQuery.of(context).size.width / 360),
                    // height: 30 * (MediaQuery.of(context).size.height / 360),
                    //color: Colors.deepPurple,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Color.fromRGBO(255, 255, 255, 1),
                          elevation: 0
                        //padding: EdgeInsets.symmetric(horizontal: 20 * (MediaQuery.of(context).size.height / 360), vertical: 10 * (MediaQuery.of(context).size.height / 360)),
                        /*shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5 * (MediaQuery.of(context).size.height / 360))
                    )*/
                      ),
                      onPressed: (){
                        Navigator.push(context, MaterialPageRoute(
                          builder: (context) {
                            return ProfileServiceGuideDetail(article_seq: result[i]["article_seq"], appTitle: result[i]['title']);
                          },
                        ));
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,

                        children: [
                          Container(
                            child: Row(
                              children: [
                                Container(
                                  width: 30 * (MediaQuery.of(context).size.width / 360),
                                  child:Icon(My_icons.my_05, size: 20 * (MediaQuery.of(context).size.width / 360),  color: Color(0xffE47421),),
                                ),
                                Container(
                                  padding: EdgeInsets.symmetric(horizontal: 2 * (MediaQuery.of(context).size.height / 360), vertical: 2 * (MediaQuery.of(context).size.height / 360)),
                                  //color: Colors.red,
                                  child: Text("${result[i]['title']}" ,
                                    style: TextStyle(fontSize: 14 * (MediaQuery.of(context).size.width / 360), color: Colors.black),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(

                            // width: 25 * (MediaQuery.of(context).size.width / 360),
                            child: Icon(Icons.keyboard_arrow_right_rounded, size: 28 * (MediaQuery.of(context).size.width / 360),  color: Color(0xffC4CCD0),),
                            // child : Image(image: AssetImage('assets/prev_icon.png'), width: (25 * (MediaQuery.of(context).size.width / 360))),
                          ),
                        ],
                      ),
                    ),

                  ),
                  Container(
                      width: 330 * (MediaQuery.of(context).size.width / 360),
                      decoration : BoxDecoration (
                          border : Border(
                              bottom: BorderSide(color : Color.fromRGBO(243, 246, 248, 1), width: 1 * (MediaQuery.of(context).size.width / 360),)
                          )
                      )
                  ),
                ],
              )
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
      bottomNavigationBar: Footer(nowPage: 'My_page'),
    );
  }
}