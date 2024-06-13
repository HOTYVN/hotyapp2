import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:hoty/common/footer.dart';
import 'package:hoty/main/main_page.dart';
import 'package:http/http.dart' as http;

class ProfileCustomerServiceDetail2 extends StatefulWidget {
  final int cms_menu_seq;
  final String title;

  const ProfileCustomerServiceDetail2({super.key, required int this.cms_menu_seq, required String this.title});

  @override
  State<ProfileCustomerServiceDetail2> createState() => _ProfileCustomerServiceDetail2();
}

class _ProfileCustomerServiceDetail2 extends State<ProfileCustomerServiceDetail2> {
  List<dynamic> list = [];

  Map result = {};
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getBoardList();
      setState(() {

      });
    });

  }

  void getBoardList() async {
    var url = Uri.parse(
      'http://www.hoty.company/mf/member/getMemberServiceGuide2.do',
      //'http://www.hoty.company/mf/member/getMemberServiceGuide2.do',
    );

    try {

      Map data = {
        "cms_menu_seq": widget.cms_menu_seq,
      };

      var body = json.encode(data);
      var response = await http.post(
          url,
          headers: {"Content-Type": "application/json"},
          body: body
      );

      print('get data');
      if(json.decode(response.body)['state'] == 200) {
        print(json.decode(response.body));
        setState(() {
          result = json.decode(response.body)['result']['view'];
        });
      }

    }catch(e) {
      print(e);
    }

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 5,
        leadingWidth: 40,
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: true,
        /*iconTheme: IconThemeData(
            color: Colors.black
        ),*/
        leading: IconButton(
          icon: Icon(Icons.arrow_back_rounded),
          iconSize: 12 * (MediaQuery.of(context).size.height / 360),
          color: Colors.black,
          alignment: Alignment.centerLeft,
          // padding: EdgeInsets.zero,
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
          child: Text(widget.title , style: TextStyle(fontSize: 18,  color: Colors.black, fontWeight: FontWeight.bold,),
          ),
        ),
        //centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Row(
          children: [
            Container(
                width: 360 * (MediaQuery.of(context).size.width / 360),
                padding : EdgeInsets.fromLTRB(15 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360),
                    15 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360)),
                child : Html(data: result['CONTS'] ?? '',)
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
        )
      ),
      //extendBody: true,
      bottomNavigationBar: Footer(nowPage: 'My_page'),
    );
  }
}