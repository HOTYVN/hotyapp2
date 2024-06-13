import 'dart:collection';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hoty/common/footer.dart';
import 'package:hoty/counseling/counseling_write.dart';
import 'package:hoty/main/main_page.dart';
import 'package:http/http.dart' as http;
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';


class CounselingFilter extends StatefulWidget {
  final String subtitle;
  final List<String> getcheckList;
  final String table_nm;
  final List<String> interiorList;

  const CounselingFilter({Key? key,
    required this.subtitle,
    required this.getcheckList,
    required this.table_nm,
    required this.interiorList,
  }) : super(key:key);

  @override
  _CounselingFilter createState() => _CounselingFilter();
}


class _CounselingFilter extends State<CounselingFilter> {



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
    print(widget.interiorList);
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
        titleSpacing: 0,
        leadingWidth: 40,
        backgroundColor: Colors.white,
        elevation: 0.5,
        automaticallyImplyLeading: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_rounded),
          iconSize: 12 * (MediaQuery.of(context).size.height / 360),
          color: Colors.black,
          // alignment: Alignment.centerLeft,
          // padding: EdgeInsets.zero,
          visualDensity: VisualDensity(horizontal: -2.0, vertical: -3.0),
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
        title: Text("체크리스트",
          style: TextStyle(
            fontSize: 17 * (MediaQuery.of(context).size.width / 360),
            color: Colors.black,
            fontFamily: 'NanumSquareB',
          ),
        ),
        shape: Border(
          bottom: BorderSide(
            color: Color(0xffF3F6F8),
            width: 1 * (MediaQuery.of(context).size.width / 360),
          ),
        ),
        /*centerTitle: true,*/
        /*actions: [
          IconButton(icon: Icon(Icons.close_rounded),color: Colors.black,alignment: Alignment.centerRight,iconSize: 26,
            onPressed: (){
              Navigator.pop(context);
            },
          ),
        ],*/
      ),
      body: SingleChildScrollView(
        child: makefilter('${widget.subtitle}',context,result),
      ),
      bottomNavigationBar:
      Container(
        width: 340 * (MediaQuery.of(context).size.width / 360),
        height: 30 * (MediaQuery.of(context).size.height / 360),
        margin: EdgeInsets.fromLTRB(10 * (MediaQuery.of(context).size.width / 360), 5 * (MediaQuery.of(context).size.height / 360),
            10 * (MediaQuery.of(context).size.width / 360), 5 * (MediaQuery.of(context).size.height / 360)) ,
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 0 * (MediaQuery.of(context).size.height / 360), vertical: 0 * (MediaQuery.of(context).size.height / 360)),
              width: (MediaQuery.of(context).size.width),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: Color.fromRGBO(228, 116, 33, 1),
                    padding: EdgeInsets.symmetric(horizontal: 10 * (MediaQuery.of(context).size.height / 360), vertical: 8 * (MediaQuery.of(context).size.height / 360)),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5 * (MediaQuery.of(context).size.height / 360))
                    )
                ),
                onPressed: (){
                  List<String> check_list = [];
                  for(var i = 0 ; i < cattitle.length; i++) {
                    for(var j = 0; j < checkList.length; j++) {
                      if(checkList[j].contains(cattitle[i]["idx"])) {
                        check_list.add("true");
                      }
                    }
                  }

                  var check_cnt = 0;
                  for(var i = 0; i < check_list.length; i++) {
                    if(check_list[i] == "true") {
                      check_cnt = check_cnt + 1;
                    }
                  }

                  if(checkList.length > 0 && check_cnt >= cattitle.length) {
                    Navigator.pop(context);
                    Navigator.push(context, MaterialPageRoute(
                      builder: (context) {
                        return searchlist();
                      },
                    ));
                  } else {
                    showDialog(context: context,
                        builder: (BuildContext context) {
                          return checkListAlert(context);
                        }
                    );

                  }
                },
                child: Text('다음으로', style: TextStyle(fontSize: 18 * (MediaQuery.of(context).size.width / 360), color: Colors.white, fontWeight: FontWeight.bold),),
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
                        if(cattitle[i]['idx'] == 'I206')
                        Container(
                            width: 175 * (MediaQuery.of(context).size.width / 360),
                            /*height: 15 * (MediaQuery.of(context).size.height / 360),*/
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
                          if(catname[m2]['pidx'] == cattitle[i]['idx'])
                            Container(
                                width: 175 * (MediaQuery.of(context).size.width / 360),
                                /*height: 15 * (MediaQuery.of(context).size.height / 360),*/
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
            checkList.remove(catname[m2]['idx']);
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
    return CounselingWrite(checkList: checkList, table_nm: widget.table_nm, interiorList: widget.interiorList,);
  }

  AlertDialog checkListAlert(BuildContext context) {
    return AlertDialog(
      // RoundedRectangleBorder - Dialog 화면 모서리 둥글게 조절
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0)),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            "체크리스트를 항목 별 1개 이상은 선택해야합니다.",
          ),
        ],
      ),
      actions: <Widget>[
        TextButton(
          child: new Text("확인"),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ],
    );
  }
}

