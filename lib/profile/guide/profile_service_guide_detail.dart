import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hoty/common/footer.dart';
import 'package:hoty/main/main_page.dart';
import 'package:hoty/profile/service/profile_service_detail.dart';
import 'package:http/http.dart' as http;

class ProfileServiceGuideDetail extends StatefulWidget{
  final int article_seq;
  final String appTitle;

  const ProfileServiceGuideDetail({super.key, required this.article_seq, required this.appTitle});

  @override
  State<ProfileServiceGuideDetail> createState() => _ProfileServiceGuideDetailState();
}

class _ProfileServiceGuideDetailState extends State<ProfileServiceGuideDetail> {

  Map<dynamic, dynamic> result = {};
  // list 호출
  Future<dynamic> getlistdata() async {

    var url = Uri.parse(
      'http://www.hoty.company/mf/guide/view.do',
      //'http://www.hoty.company/mf/guide/view.do',
    );

    print('######');
    try {
      Map data = {
        "article_seq" : widget.article_seq,
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
        result = json.decode(response.body)['result'];

        // print("asdasdasdasdasd");
        print(result["conts"]);
      }
    }
    catch(e){
      print(e);
    }
  }

  String HtmlConts = '';

  @override
  void initState() {


    super.initState();
    getlistdata().then((_) {
      setState(() {
        if(result["conts"] != null) {
          HtmlConts = result["conts"];
          print(HtmlConts);
        }
      });
    });

  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap : () => FocusManager.instance.primaryFocus?.unfocus(),
        child : Scaffold(
        appBar: AppBar(
          titleSpacing: 5,
          leadingWidth: 40,
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
          title: Container(
            //width: 80 * (MediaQuery.of(context).size.width / 360),
            //height: 80 * (MediaQuery.of(context).size.height / 360),
            /*child: Image(image: AssetImage('assets/logo.png')),*/
            alignment: Alignment.centerLeft,
            child: Text(widget.appTitle , style: TextStyle(fontSize: 18,  color: Colors.black, fontWeight: FontWeight.bold,),
              textAlign: TextAlign.left,
            ),
          ),
          //centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                width: 360 * (MediaQuery.of(context).size.width / 360),
                child: Html(data: HtmlConts),
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
      )
    );
  }
}