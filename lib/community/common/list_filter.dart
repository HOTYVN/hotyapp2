import 'dart:collection';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hoty/common/footer.dart';
import 'package:http/http.dart' as http;

import '../privatelesson/lesson_list.dart';
import '../usedtrade/trade_list.dart';

class Cm_Filter extends StatefulWidget {
  final String subtitle;
  final List<String> getcheckList;
  const Cm_Filter({Key? key,
    required this.subtitle,
    required this.getcheckList,
  }) : super(key:key);

  @override
  _Cm_Filter createState() => _Cm_Filter();
}


class _Cm_Filter extends State<Cm_Filter> {

  List<String> allcheckList = [];
  List<String> checkList = [];
  List<String> main_category = [];
  List<String> sub_category = [];


  List<String> checkList2 = [];

  List<dynamic> getresult = [];
  List<dynamic> result = [];
  Map<String, dynamic> catcode = {};
  List<dynamic> cattitle = []; // 카테고리타이틀
  List<dynamic> catname = []; // 세부카테고리



  Future<dynamic> getcodedata() async {

    var url = Uri.parse(
      'http://www.hoty.company/mf/common/commonCode.do',
    );
    try {
      Map data = {
        // "pidx": widget.subtitle,
      };
      var body = json.encode(data);
      var response = await http.post(
          url,
          headers: {"Content-Type": "application/json"},
          body: body
      );
      // print('Response status: ${response.statusCode}');
      // print('Response body: ${response.body}');
      if(response.statusCode == 200) {
        checkList.addAll(widget.getcheckList);
        var resultstatus = json.decode(response.body)['resultstatus'];
        var catlist = json.decode(response.body)['result'];

        result = json.decode(response.body)['result'];

        // print(result);


        for(int i=0; i<result.length; i++){
          if(result[i]['pidx'] == widget.subtitle){
            cattitle.add(result[i]);
          }
        }

        cattitle.forEach((element) {
          result.forEach((value) {
            if(value['pidx'] == element['idx']){
              catname.add(value);
            }
          });
          // print(element['idx']);
        });

        // print("asdasdasdasdasd");
        // print(result.length);
      }
      // print(result.length);
    }
    catch(e){
      print(e);
    }
  }



  @override
  void initState() {
    super.initState();
    getcodedata().then((_) {
      setState(() {
      });
    });

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leadingWidth: 27,
        backgroundColor: Colors.white,
        elevation: 0.5,
        automaticallyImplyLeading: true,

        title: Text("필터",
          style: TextStyle(
            fontSize: 20 * (MediaQuery.of(context).size.width / 360),
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        shape: Border(
          bottom: BorderSide(
            color: Color(0xffF3F6F8),
            width: 1 * (MediaQuery.of(context).size.width / 360),
          ),
        ),
        actions: [
          IconButton(icon: Icon(Icons.close_rounded),color: Colors.black,alignment: Alignment.centerRight,iconSize: 26,
            onPressed: (){
              Navigator.pop(context);
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: makefilter('${widget.subtitle}',context,result),
      ),
      bottomNavigationBar:
      Container(
        width: 340 * (MediaQuery.of(context).size.width / 360),
        height: 60 * (MediaQuery.of(context).size.height / 360),
        margin: EdgeInsets.fromLTRB(10 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360),
            10 * (MediaQuery.of(context).size.width / 360), 5 * (MediaQuery.of(context).size.height / 360)) ,
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 0 * (MediaQuery.of(context).size.height / 360), vertical: 0 * (MediaQuery.of(context).size.height / 360)),
              width: (MediaQuery.of(context).size.width),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    elevation: 0,
                    backgroundColor: Color.fromRGBO(228, 116, 33, 1),
                    padding: EdgeInsets.symmetric(horizontal: 10 * (MediaQuery.of(context).size.height / 360), vertical: 9 * (MediaQuery.of(context).size.height / 360)),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5 * (MediaQuery.of(context).size.height / 360))
                    )
                ),
                onPressed: (){
                  Navigator.pop(context);
                  Navigator.push(context, MaterialPageRoute(
                      builder: (context) {
                        return searchlist();
                      },
                  ));
                },
                child: Text('적용하기', style: TextStyle(fontSize: 18 * (MediaQuery.of(context).size.width / 360), color: Colors.white),),
              ),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(0, 3  * (MediaQuery.of(context).size.height / 360), 0, 0 * (MediaQuery.of(context).size.height / 360)) ,
              padding: EdgeInsets.symmetric(horizontal: 0 * (MediaQuery.of(context).size.height / 360), vertical: 0 * (MediaQuery.of(context).size.height / 360)),
              width: (MediaQuery.of(context).size.width),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    elevation: 0,
                    backgroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(horizontal: 10 * (MediaQuery.of(context).size.height / 360), vertical: 9 * (MediaQuery.of(context).size.height / 360)),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5 * (MediaQuery.of(context).size.height / 360)),
                      side : BorderSide(color: Color(0xffE47421), width: 2 * (MediaQuery.of(context).size.width / 360)),

                    )
                ),
                onPressed: (){
                  setState(() {
                    checkList.clear();
                    allcheckList.clear();
                  });
                  /*Navigator.push(context, MaterialPageRoute(
                                builder: (context) {
                                  return TradeList(checkList: checkList,);
                                },
                              ));*/
                },
                child: Text('모든 필터 지우기', style: TextStyle(fontSize: 18 * (MediaQuery.of(context).size.width / 360), color: Color(0xffE47421)),),
              ),
            ),
          ],
        ),
      ),

    );
  }

  Widget makefilter(subtitle,context, result){

    return
      Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              child: Column(
                children: [
                  filterinfo(subtitle,context,result), //필터


                ],
              ),
            ),


          ]
      );
  }

  Column filterinfo(String subtitle,context,result){
    // print(checkList);
    // List<dynamic> category = getresult;

    return
      Column(
        children: [
          for(var i=0; i< cattitle.length; i++)
            if(cattitle[i]['idx'] != 'E2')
            Container(
              // height: 60 * (MediaQuery.of(context).size.height / 360),
              child: Column(
                children: [
                  Container(
                    // alignment: Alignment.centerLeft,
                    width: 360 * (MediaQuery.of(context).size.width / 360),
                    // height: 20 * (MediaQuery.of(context).size.height / 360),
                    margin: EdgeInsets.fromLTRB(10 * (MediaQuery.of(context).size.width / 360), 15 * (MediaQuery.of(context).size.height / 360), 0, 0),
                    child: Text(cattitle[i]['name'],
                      style: TextStyle(
                        // color: Colors.black87,
                        fontWeight: FontWeight.bold,
                        fontSize: 16 * (MediaQuery.of(context).size.width / 360),
                        fontFamily: 'NanumSquareR',
                      ),
                    ),
                  ),
                  Container(
                    width: 350 * (MediaQuery.of(context).size.width / 360),
                    margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
                    // height: 50 * (MediaQuery.of(context).size.height / 360),
                    child: Wrap(
                      children: [
                    /*    Container(
                          width: 175 * (MediaQuery.of(context).size.width / 360),
                          height: 15 * (MediaQuery.of(context).size.height / 360),
                          child: CheckboxListTile(

                            contentPadding: EdgeInsets.zero,
                            controlAffinity: ListTileControlAffinity.leading,
                            side: BorderSide(
                              color: Colors.grey,
                              width: 2,
                            ),
                            title: Text('All'),
                            dense : true,
                            value: allcheckList.contains(cattitle[i]['idx']),
                            checkColor: Colors.white,
                            activeColor: Color(0xffE47421),
                            materialTapTargetSize: MaterialTapTargetSize.padded,
                            onChanged: (val) {
                              _allSelected(val!,cattitle[i]['idx']);
                            },

                          ),
                        ),*/
                        Container(
                          width: 175 * (MediaQuery.of(context).size.width / 360),
                          height: 15 * (MediaQuery.of(context).size.height / 360),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Container( child: Checkbox(
                                  side: BorderSide(
                                    color: Colors.grey,
                                    width: 2,
                                  ),
                                  value: allcheckList.contains(cattitle[i]['idx']),
                                  activeColor: Color(0xffE47421),
                                  checkColor: Colors.white,
                                  onChanged: (val) {
                                    _allSelected(val!,cattitle[i]['idx']);
                                  },
                                ),),
                                Container(
                                  child: Text(
                                    "전체",
                                    style: TextStyle(
                                      fontFamily: 'NanumSquareR',
                                      fontSize: 14 * (MediaQuery.of(context).size.width / 360),
                                    ),
                                  ),
                                ),
                              ]
                              ,)
                        ),

                        for(int m2=0; m2<catname.length; m2++)
                          if(catname[m2]['pidx'] == cattitle[i]['idx'] )
                        Container(
                            width: 175 * (MediaQuery.of(context).size.width / 360),
                            height: 15 * (MediaQuery.of(context).size.height / 360),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Container( child: Checkbox(
                                  side: BorderSide(
                                    color: Colors.grey,
                                    width: 2,
                                  ),
                                  value: checkList.contains(catname[m2]['idx']),
                                  activeColor: Color(0xffE47421),
                                  checkColor: Colors.white,
                                  onChanged: (val) {
                                    _onSelected(val!, catname[m2]['idx']);
                                  },
                                ),),
                                Container(
                                  constraints: BoxConstraints(maxWidth : 130 * (MediaQuery.of(context).size.width / 360)),
                                  child: Text(
                                    "${catname[m2]['name']}",
                                    style: TextStyle(
                                      overflow: TextOverflow.clip,
                                      fontFamily: 'NanumSquareR',
                                      fontSize: 14 * (MediaQuery.of(context).size.width / 360),
                                    ),
                                  ),
                                ),
                              ]
                              ,)
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
        ],
      )
    ;
  }

  void _allSelected(bool selected, String dataName) {
    allcheckList.clear();
    if (selected == true) {
      setState(() {
        allcheckList.add(dataName);
        for(var m2=0; m2<catname.length; m2++) {
          if(catname[m2]['pidx'] == dataName){
            checkList.add(catname[m2]['idx']);
          }
        }
      });
    } else {
      setState(() {
        allcheckList.remove(dataName);
        for(var m2=0; m2<catname.length; m2++) {
          if(catname[m2]['pidx'] == dataName){
            checkList.removeWhere((item) => item == catname[m2]['idx']);   //.remove(catname[m2]['idx']);
          }
        }
      });
    }
  }

  void _onSelected(bool selected, String dataName) {
    if (selected == true) {
      setState(() {
        checkList.add(dataName);
      });
    } else {
      setState(() {
        checkList.remove(dataName);
      });
    }
  }

  Widget searchlist() {

    var table_nm = widget.subtitle;
    var returnurl = '';
    if(table_nm == 'USED_TRNSC') {
      return TradeList(checkList: checkList);
    }
    if(table_nm == 'PERSONAL_LESSON') {
      return LessonList(checkList: checkList);
    }
      return TradeList(checkList: checkList);
  }

}

