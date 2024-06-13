import 'dart:convert';
import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_ip_address/get_ip_address.dart';
import 'package:hoty/common/dialog/commonAlert.dart';
import 'package:hoty/common/footer.dart';
import 'package:hoty/community/dailytalk/community_dailyTalk_view.dart';
import 'package:hoty/community/privatelesson/lesson_view.dart';
import 'package:hoty/community/usedtrade/trade_view.dart';
import 'package:hoty/kin/kin_comment_list.dart';
import 'package:hoty/kin/kin_view.dart';
import 'package:hoty/kin/kin_view2.dart';
import 'package:hoty/kin/kinlist.dart';
import 'package:hoty/kin/providers/main_category_provider.dart';
import 'package:hoty/kin/model/mainCategoryVO.dart';
import 'package:hoty/main/main_page.dart';

import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:dio/dio.dart';
import "package:http_parser/http_parser.dart";


class CommentModify extends StatefulWidget {
  final int article_seq;
  final int comment_seq;
  final dynamic table_nm;
  final dynamic main_catcode;

  const CommentModify({Key? key,
    required this.article_seq,
    required this.comment_seq,
    required this.table_nm,
    required this.main_catcode,
  }) : super(key:key);

  @override
  State<CommentModify> createState() => _CommentModifyState();
}

class _CommentModifyState extends State<CommentModify> {

  final _formKey = GlobalKey<FormState>();

  List<mainCategoryVO> mainCategory = [];

  var cms_menu_seq = 22;

  bool isLoading = true;
  MainCategoryProvider mainCategoryProvider = MainCategoryProvider();
  String? _selectedValue ;
  String? _selectRadioValue ;
  String? writeApi_result ;
  int? point;
  String? member_id = "";

  final ImagePicker _picker = ImagePicker();

  List<XFile> _pickedImgs = [];
  List<dynamic> filelist = [];
  List<dynamic> deletefile = [];

  bool _isChecked = false;

  int click_check = 1;

  bool _visibility1 = true;
  bool _visibility2 = false;

  Map view = {};

  Future _pickImg(ImageSource imageSource) async {

    if(imageSource == ImageSource.camera) {
      final XFile? images = await _picker.pickImage(source: imageSource);
      if(_pickedImgs.length >= 1) {
        if (images != null) {
          setState(() {
            _pickedImgs.removeLast();
          });
        }
      }
      if (images != null) {
        setState(() {
          _pickedImgs.add(images);
          if(filelist.length > 0) {
            filelist.removeLast();
          }
        });
      }
    }

    if(imageSource == ImageSource.gallery) {
      final XFile? images = await _picker.pickImage(source: imageSource);

      if(_pickedImgs.length >= 1) {
        if (images != null) {
          setState(() {
            _pickedImgs.removeLast();
          });
        }
      }
      if (images != null) {
        setState(() {
          _pickedImgs.add(images);
          if(filelist.length > 0) {
            filelist.removeLast();
          }
        });
      }

    }
  }

  Future initmainCategory() async {
    mainCategory = await mainCategoryProvider.getCategory();
  }


  static final storage = FlutterSecureStorage();
  Future initgetpointview() async {
    member_id = (await storage.read(key:'memberId')) ?? "";
    point = await mainCategoryProvider.getpointview(member_id);
  }

  /*Future initview() async {
    view = await mainCategoryProvider.getview(widget.article_seq, widget.table_nm);
  }*/

  Future initview() async {
    view = await mainCategoryProvider.getCommentview(widget.comment_seq, widget.table_nm);
  }

  final _titleController = TextEditingController();
  final _contsController = TextEditingController();
  final _tagsController = TextEditingController();
  final _pointController = TextEditingController();

  late FocusNode contsNode;

  @override
  void initState() {
    super.initState();

    contsNode = FocusNode();

    initview().then((_) {
      setState(() {

        //_titleController.text = view["data"]["title"];
        _contsController.text = view["data"]["conts"];
        //_tagsController.text = view["data"]["tag_names"];
        //_pointController.text = view["data"]["etc01"];

       // _selectedValue = view["data"]["main_category"];

        if(view["files"] != "") {
          _visibility1 = false;
          _visibility2 = true;
        }

        filelist = view["files"];
      });
    });

    initmainCategory().then((_) {
      setState(() {

      });
    });
    initgetpointview().then((_) {
      setState(() {

      });
    });

    /*_selectRadioValue = cat02list.first.idx;*/
  }

  @override
  void dispose() {
    contsNode.dispose();
    super.dispose();
  }

  Future<bool> _onBackKey() async {
    final value = await showDialog(context: context,
        barrierColor: Color(0xffE47421).withOpacity(0.4),
        builder: (BuildContext context) {
          return MediaQuery(
            data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
            child: writeback(context, ''),
          );
        }
    );

    if(value == true) {
      print(value);
      Navigator.pop(context);
    }

    return value;
  }

  @override
  Widget build(BuildContext context) {

    return
      GestureDetector(
        onTap : () => FocusManager.instance.primaryFocus?.unfocus(),
        child : Scaffold(
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
              actions: [
                GestureDetector(
                  onTap: (){
                    FlutterDialog(context);
                  },
                  child : Container(
                    //width: 70 * (MediaQuery.of(context).size.width / 360),
                      margin : EdgeInsets.fromLTRB(0 * (MediaQuery.of(context).size.width / 360), 5 * (MediaQuery.of(context).size.height / 360),
                          10 * (MediaQuery.of(context).size.width / 360), 3 * (MediaQuery.of(context).size.height / 360)),
                      padding : EdgeInsets.fromLTRB(7 * (MediaQuery.of(context).size.width / 360), 3 * (MediaQuery.of(context).size.height / 360),
                          7 * (MediaQuery.of(context).size.width / 360), 3 * (MediaQuery.of(context).size.height / 360)),
                      child:Row(
                        children: [
                          /*Icon(Icons.listflutter, size: 12 * (MediaQuery.of(context).size.height / 360),  color: Color(0xffC4CCD0),),*/
                          //Image(image: AssetImage("assets/ink_pen.png"), width : 15 * (MediaQuery.of(context).size.width / 360)),
                          Text('  수정',
                            style: TextStyle(
                              fontSize: 16 * (MediaQuery.of(context).size.width / 360),
                              color: Color(0xff151515),
                              fontWeight: FontWeight.w600,
                              fontFamily: 'NanumSquareR',
                            ),
                          ),
                        ],
                      )
                  ),
                )
            ]
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      conts(context),
                    ],
                  ),
                ),
              ],
            ),
          ),
          bottomNavigationBar: Footer(nowPage: '',),
        )
    );
  }

  Container apply(BuildContext context) {
    return Container(
      width: 340 * (MediaQuery.of(context).size.width / 360),
      height: 30 * (MediaQuery.of(context).size.height / 360),
      padding : EdgeInsets.fromLTRB(15 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360),
          15 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360)),
      margin : EdgeInsets.fromLTRB(0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360),
          0 * (MediaQuery.of(context).size.width / 360), 5 * (MediaQuery.of(context).size.height / 360)),
      child: Row(
        children: [
          Container(
            width: 330 * (MediaQuery.of(context).size.width / 360),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: click_check == 0
                      ? Color.fromRGBO(255, 243, 234, 1)
                      : Color.fromRGBO(228, 116, 33, 1),
                  padding: EdgeInsets.symmetric(horizontal: 5 * (MediaQuery.of(context).size.width / 360), vertical: 7 * (MediaQuery.of(context).size.height / 360)),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5 * (MediaQuery.of(context).size.height / 360))
                  )
              ),
              onPressed : () {
                if(_formKey.currentState!.validate()) {
                  if(click_check == 1) {
                    setState(() {
                      click_check = 0;
                    });
                    FlutterDialog(context);
                  }
                }
              },
              child:  Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text('작성하기', style: TextStyle(fontSize: 9 * (MediaQuery.of(context).size.height / 360), color: click_check == 0 ? Color(0xffE47421) : Colors.white),textAlign: TextAlign.center,),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Container hide_identity(BuildContext context) {
    return Container(
      width: 360 * (MediaQuery.of(context).size.width / 360),
      height: 30 * (MediaQuery.of(context).size.height / 360),
      margin : EdgeInsets.fromLTRB(15 * (MediaQuery.of(context).size.width / 360), 5 * (MediaQuery.of(context).size.height / 360),
          15 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360)),
      child: Row(
        children: [
          Container(
              width: 295 * (MediaQuery.of(context).size.width / 360),
              child : Text("닉네임 비공개" ,style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14 * (MediaQuery.of(context).size.width / 360)),)
          ),
          Container(
              width : 35 * (MediaQuery.of(context).size.width / 360),
              height : 25 * (MediaQuery.of(context).size.height / 360),
              child : FittedBox(
                fit: BoxFit.contain,
                child : CupertinoSwitch(
                  value: _isChecked,
                  activeColor: CupertinoColors.activeBlue,
                  onChanged: (bool? value) {
                    _isChecked = value!;
                    setState(() {
                    });
                  },
                ),
              )
          ),
        ],
      ),
    );
  }

  Container point_input(BuildContext context) {
    return Container(
            width: 360 * (MediaQuery.of(context).size.width / 360),
            height: 65 * (MediaQuery.of(context).size.height / 360),
            padding: EdgeInsets.fromLTRB(15 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360),
                15 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360) ),
            child: Column(
              children: [
                Container(
                  height: 55 * (MediaQuery.of(context).size.height / 360),
                  child: Column(
                    children: [
                      Container(
                        height: 50 * (MediaQuery.of(context).size.height / 360),
                        margin : EdgeInsets.fromLTRB(0 * (MediaQuery.of(context).size.width / 360), 5 * (MediaQuery.of(context).size.height / 360),
                            0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360) ),
                        decoration: BoxDecoration(
                          color: Color.fromRGBO(243, 246, 248, 1),
                          borderRadius: BorderRadius.circular(2 * (MediaQuery.of(context).size.height / 360)),
                        ),
                        child: Column(
                          children: [
                            Container(
                              height: 15 * (MediaQuery.of(context).size.height / 360),
                              margin : EdgeInsets.fromLTRB(0 * (MediaQuery.of(context).size.width / 360), 5 * (MediaQuery.of(context).size.height / 360),
                                  0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360) ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text("보유포인트:", style: TextStyle(fontSize: 16),),
                                  Text(" ${point} P", style: TextStyle(color: Color.fromRGBO(228, 116, 33, 1), fontSize: 16),),
                                ],
                              ),
                            ),
                            Container(
                              width: 290 * (MediaQuery.of(context).size.width / 360),
                              height: 20 * (MediaQuery.of(context).size.height / 360),
                              margin : EdgeInsets.fromLTRB(0 * (MediaQuery.of(context).size.width / 360), 5 * (MediaQuery.of(context).size.height / 360),
                                  0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360) ),
                              decoration: BoxDecoration(
                                color: Color.fromRGBO(255, 255, 255, 1),
                                borderRadius: BorderRadius.circular(2 * (MediaQuery.of(context).size.height / 360)),
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    width: 250 * (MediaQuery.of(context).size.width / 360),
                                    margin : EdgeInsets.fromLTRB(15 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360),
                                        0 * (MediaQuery.of(context).size.width / 360), 2 * (MediaQuery.of(context).size.height / 360) ),
                                    child : TextFormField(
                                      controller: _pointController,
                                      keyboardType: TextInputType.number,
                                      inputFormatters: <TextInputFormatter>[
                                        FilteringTextInputFormatter.digitsOnly,
                                      ],
                                      onChanged: (value) {
                                        setState(() {
                                          if(point! < int.parse(value)) {
                                            _pointController.text = "0";
                                            showDialog(context: context,
                                                barrierColor: Color(0xffE47421).withOpacity(0.4),
                                                barrierDismissible: false,
                                                builder: (BuildContext context) {
                                                  return MediaQuery(
                                                    data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
                                                    child: textalert(context,'보유하고 있는 포인트보다 많은 포인트를 설정할 수 없습니다.'),
                                                  );
                                                }
                                            );
                                          }});
                                      },
                                      decoration: InputDecoration(
                                        border: InputBorder.none,
                                        // labelText: 'Search',
                                        hintText: '채택자에게 지급 할 포인트를 입력하세요.',
                                        hintStyle: TextStyle(color:Color(0xffC4CCD0), fontSize: 16),
                                      ),
                                      autovalidateMode: AutovalidateMode.onUserInteraction,
                                      validator: (value) {
                                        value = value?.trim();
                                        if(value == null || value.isEmpty) {
                                          return "포인트는 필수 입력값입니다.";
                                        }
                                        return null;
                                      },
                                    ),
                                  ),
                                  Container(
                                    width: 15 * (MediaQuery.of(context).size.width / 360),
                                    margin : EdgeInsets.fromLTRB(0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360),
                                        5 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360) ),
                                    child : Text("P")
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
  }

  Container tags(BuildContext context) {
    return Container(
            width: 360 * (MediaQuery.of(context).size.width / 360),
            height: 25 * (MediaQuery.of(context).size.height / 360),
            margin : EdgeInsets.fromLTRB(15 * (MediaQuery.of(context).size.width / 360), 5 * (MediaQuery.of(context).size.height / 360),
                15 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360)),
            decoration: BoxDecoration(
              border: Border.all(
                  color: Color.fromRGBO(243, 246, 248, 1)
              ),
              borderRadius: BorderRadius.circular(3 * (MediaQuery.of(context).size.height / 360)),
              color: Color.fromRGBO(255, 255, 255, 1),
            ),
            child: TextField(
              controller: _tagsController,
              decoration: InputDecoration(
                border: InputBorder.none,
                contentPadding : EdgeInsets.fromLTRB(15 * (MediaQuery.of(context).size.width / 360), 5 * (MediaQuery.of(context).size.height / 360), 0, 0),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(5)),
                  borderSide: BorderSide(
                    color: Color.fromRGBO(255, 255, 255, 1),
                  ),
                ),
                // labelText: 'Search',
                hintText: '#태그 입력 (최대 10)',
                hintStyle: TextStyle(color:Color(0xffC4CCD0),),
              ),
              onTap: () {
                if(_tagsController.text == "") {
                  _tagsController.text = "#";
                }
              },
              onChanged: (text) {
                setState(() {
                  if(text.substring(text.length - 1, text.length) == "#") {
                    _tagsController.text = _tagsController.text.substring(0 , text.length - 1) + " #";
                  }

                  if(text.split("#").length > 10) {
                    _tagsController.text = _tagsController.text.substring(0, _tagsController.text.length - 1);
                    showDialog(context: context,
                        barrierColor: Color(0xffE47421).withOpacity(0.4),
                        builder: (BuildContext context) {
                          return MediaQuery(
                            data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
                            child: textalert(context,'태그를 10개 이상 설정할수 없습니다.'),
                          );
                        }
                    );
                  }

                });

              },
            ),
          );
  }

  Container upload(BuildContext context) {
    List<Widget> _boxContents = [


      Container(),
      Container(),
      Container(),
      Container(),
      Container(),
      Container(),
      _pickedImgs.length <= 6
          ? Container()
          : FittedBox(
        child: Container(
          padding: EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.6),
            shape: BoxShape.circle,
          ),
          child: Text('+${(_pickedImgs.length - 6).toString()}',
            style: Theme.of(context).textTheme.subtitle2?.copyWith(fontWeight: FontWeight.w800),
          ),
        ),
      ),
    ];

    return Container(
      child: Column(
        children: <Widget>[
          Visibility(visible: _visibility1,child:
          Container(
            width: 360 * (MediaQuery.of(context).size.width / 360),
            height: 65 * (MediaQuery.of(context).size.height / 360),
            margin : EdgeInsets.fromLTRB(10 * (MediaQuery.of(context).size.width / 360), 5 * (MediaQuery.of(context).size.height / 360),
                10 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360)),
            child: TextButton(
                onPressed: () {
                  showDialog(context: context,
                      builder: (BuildContext context) {
                        return imagealert(context);
                      }
                  );
                  setState(() {
                    _visibility1 = false;
                    _visibility2 = true;
                  });
                },
                child : DottedBorder(
                  color: Color.fromRGBO(228, 116, 33, 1),//color of dotted/dash line
                  strokeWidth: 1, //thickness of dash/dots
                  dashPattern: [5,1],
                  //strokeCap: StrokeCap.round,
                  radius: Radius.circular(3),
                  borderType: BorderType.RRect,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 350 * (MediaQuery.of(context).size.width / 360),
                        height: 35 * (MediaQuery.of(context).size.height / 360),
                        margin : EdgeInsets.fromLTRB(0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360),
                            0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              height: 15 * (MediaQuery.of(context).size.height / 360),
                              child: Image(image: AssetImage("assets/upload_photo.png"), width: 30 * (MediaQuery.of(context).size.width / 360),),
                            ),
                            Container(
                              height: 10 * (MediaQuery.of(context).size.height / 360),
                              margin : EdgeInsets.fromLTRB(0 * (MediaQuery.of(context).size.width / 360), 3 * (MediaQuery.of(context).size.height / 360),
                                  0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360)),
                              child: Text("사진 업로드", style: TextStyle(fontSize: 16, color: Color.fromRGBO(228, 116, 33, 1), fontWeight: FontWeight.w700),),
                            ),
                          ],
                        ),
                      ),
                      Container(
                          // height: 20 * (MediaQuery.of(context).size.height / 360),
                          child : Text("5MB를 초과하지 않는 파일을\n첨부해주세요.", style: TextStyle(fontSize: 14, color: Color(0xff151515), fontWeight: FontWeight.w400), textAlign: TextAlign.center, )
                      ),
                    ],
                  ),
                )
            ),
          ),
          ),
          Visibility(visible: _visibility2,child:
          Container(
              height: 110 * (MediaQuery.of(context).size.height / 360),
              margin : EdgeInsets.fromLTRB(15 * (MediaQuery.of(context).size.width / 360), 5 * (MediaQuery.of(context).size.height / 360),
                  15 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360)),
              child : GridView.count(
                padding: EdgeInsets.all(2),
                physics: NeverScrollableScrollPhysics(),
                crossAxisCount: 3,
                mainAxisSpacing: 5,
                crossAxisSpacing: 5,
                children: List.generate(6, (index) =>
                    DottedBorder(
                        color: Color(0xffE47421),
                        dashPattern: [5,3],
                        borderType: BorderType.RRect,
                        radius: Radius.circular(10),
                        child: Stack(
                          alignment: Alignment.topRight,
                          children: [
                            if(index < filelist.length )
                              Container(
                                decoration:
                                BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    image: DecorationImage(image : NetworkImage("http://www.hoty.company/upload/KIN/${filelist[index]["yyyy"]}/${filelist[index]["mm"]}/${filelist[index]["uuid"]}"), fit: BoxFit.cover)
                                ),
                              ),
                            if(index < filelist.length )
                              Container (
                                  margin: EdgeInsets.fromLTRB(0 * (MediaQuery.of(context).size.width / 360), 4  * (MediaQuery.of(context).size.height / 360), 7 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360)),
                                  decoration: BoxDecoration(
                                    color: Color(0xffffffff),
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  //삭제버튼
                                  child : IconButton(
                                      padding: EdgeInsets.zero,
                                      constraints: BoxConstraints(),
                                      icon: Icon(Icons.close, color: Color(0xffC4CCD0), size : 15),
                                      onPressed: () {
                                        setState(() {
                                          /*print("####################### 조건 ####################");
                                      print(_pickedImgs.length);
                                      print(filelist.length);
                                      print(5 - (_pickedImgs.length)  - (filelist.length));
                                      print(index);*/
                                          deletefile.add(filelist[index]["uuid"]);
                                          filelist.remove(filelist[index]);
                                        });
                                      }
                                  )
                              ),
                            if(index > filelist.length - 1 && (index - (filelist.length - 1 )) <= (_pickedImgs.length ))
                              Container(
                                  decoration: index > filelist.length - 1 && (index - (filelist.length - 1 )) <= (_pickedImgs.length )
                                      ? BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    image: DecorationImage(fit: BoxFit.cover,image: FileImage(File(_pickedImgs[index - filelist.length].path))),
                                  )
                                      : null,
                                  //child: Text("asd ${index} || ${_pickedImgs.length }"),
                                  child : index == (((_pickedImgs.length) + (filelist.length))) ? Center(
                                      child:
                                      TextButton(
                                          onPressed: () {
                                            showDialog(context: context,
                                                builder: (BuildContext context) {
                                                  return imagealert(context);
                                                }
                                            );
                                          },
                                          child:  Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Container(
                                                height: 15 * (MediaQuery.of(context).size.height / 360),
                                                child: Image(image: AssetImage("assets/upload_photo.png"), width: 30 * (MediaQuery.of(context).size.width / 360),),
                                              ),
                                              Container(
                                                height: 10 * (MediaQuery.of(context).size.height / 360),
                                                margin : EdgeInsets.fromLTRB(0 * (MediaQuery.of(context).size.width / 360), 3 * (MediaQuery.of(context).size.height / 360),
                                                    0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360)),
                                                child: Text("사진 업로드", style: TextStyle(fontSize: 16, color: Color.fromRGBO(228, 116, 33, 1), fontWeight: FontWeight.w700),),
                                              ),
                                            ],
                                          )
                                      )
                                  ) : null
                              ),
                            if(index == (((_pickedImgs.length) + (filelist.length))))
                              Container(
                                //child: Text("asd ${index} || ${_pickedImgs.length }"),
                                  child : Center(
                                      child:
                                      TextButton(
                                          onPressed: () {
                                            showDialog(context: context,
                                                builder: (BuildContext context) {
                                                  return imagealert(context);
                                                }
                                            );
                                          },
                                          child:  Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Container(
                                                height: 15 * (MediaQuery.of(context).size.height / 360),
                                                child: Image(image: AssetImage("assets/upload_photo.png"), width: 30 * (MediaQuery.of(context).size.width / 360),),
                                              ),
                                              Container(
                                                height: 10 * (MediaQuery.of(context).size.height / 360),
                                                margin : EdgeInsets.fromLTRB(0 * (MediaQuery.of(context).size.width / 360), 3 * (MediaQuery.of(context).size.height / 360),
                                                    0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360)),
                                                child: Text("사진 업로드", style: TextStyle(fontSize: 16, color: Color.fromRGBO(228, 116, 33, 1), fontWeight: FontWeight.w700),),
                                              ),
                                            ],
                                          )
                                      )
                                  )
                              ),
                            if(index > filelist.length - 1 && (index - (filelist.length - 1 )) <= (_pickedImgs.length ))
                              Container (
                                  margin: EdgeInsets.fromLTRB(0 * (MediaQuery.of(context).size.width / 360), 4  * (MediaQuery.of(context).size.height / 360), 7 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360)),
                                  decoration: BoxDecoration(
                                    color: Color(0xffffffff),
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  //삭제버튼
                                  child : IconButton(
                                      padding: EdgeInsets.zero,
                                      constraints: BoxConstraints(),
                                      icon: Icon(Icons.close, color: Color(0xffC4CCD0), size : 15),
                                      onPressed: () {
                                        setState(() {
                                          _pickedImgs.remove(_pickedImgs[index - (filelist.length)]);
                                        });
                                      }
                                  )
                              )
                          ],
                          //child : Center(child: _boxContents[index])
                        )
                    )
                ).toList(),
              )
          ),
          )
        ],
      ),
    );

  }

  Container conts(BuildContext context) {
    return Container(
            margin : EdgeInsets.fromLTRB(15 * (MediaQuery.of(context).size.width / 360), 10 * (MediaQuery.of(context).size.height / 360),
                15 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360)),
            width: 360 * (MediaQuery.of(context).size.width / 360),
            /*height: 70 * (MediaQuery.of(context).size.height / 360),*/
            decoration: BoxDecoration(
              border: Border.all(
                  color: Color.fromRGBO(243, 246, 248, 1)
              ),
              borderRadius: BorderRadius.circular(3 * (MediaQuery.of(context).size.height / 360)),
              color: Color.fromRGBO(255, 255, 255, 1),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width : 360 * (MediaQuery.of(context).size.width / 360),
                  height : 40 * (MediaQuery.of(context).size.height / 360),
                  child : TextFormField(
                    controller: _contsController,
                    focusNode: contsNode,
                    maxLines: 3,
                    minLines: 1,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      contentPadding : EdgeInsets.fromLTRB(15 * (MediaQuery.of(context).size.width / 360), 5 * (MediaQuery.of(context).size.height / 360), 0, 0),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(5)),
                        borderSide: BorderSide(
                          color: Color.fromRGBO(255, 255, 255, 1),
                        ),
                      ),
                      // labelText: 'Search',
                    ),
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (value) {
                      value = value?.trim();
                      if(value == null || value.isEmpty) {
                        contsNode.requestFocus();
                        return "질문 내용은 필수 입력값입니다.";
                      }
                      return null;
                    },
                    style: TextStyle(fontFamily: ''),
                  ),
                ),
                if(filelist.length > 0 && _pickedImgs.length <= 0)
                  Container(
                      width: 60 * (MediaQuery.of(context).size.width / 360),
                      height: 30 * (MediaQuery.of(context).size.height / 360),
                      margin : EdgeInsets.fromLTRB(15 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360),
                          0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360)),
                      child : DottedBorder(
                          color: Color(0xffE47421),
                          dashPattern: [5,3],
                          borderType: BorderType.RRect,
                          radius: Radius.circular(10),
                          child: Stack(
                            alignment: Alignment.topRight,
                            children: [
                              Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8),
                                      image: DecorationImage(image : NetworkImage("http://www.hoty.company/upload/${widget.table_nm}/${filelist[0]["yyyy"]}/${filelist[0]["mm"]}/${filelist[0]["uuid"]}"), fit: BoxFit.cover)
                                  ),
                                  child :  null
                              ),
                              Container (
                                  margin: EdgeInsets.fromLTRB(0 * (MediaQuery.of(context).size.width / 360), 1 * (MediaQuery.of(context).size.height / 360), 2 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360)),
                                  decoration: BoxDecoration(
                                    color: Color(0xffffffff),
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  //삭제버튼
                                  child : IconButton(
                                      padding: EdgeInsets.zero,
                                      constraints: BoxConstraints(),
                                      icon: Icon(Icons.close, color: Color(0xffC4CCD0), size : 15),
                                      onPressed: () {
                                        setState(() {
                                          filelist.removeLast();
                                        });
                                      }
                                  )
                              )
                            ],
                            //child : Center(child: _boxContents[index])
                          )
                      )
                  ),
                if(_pickedImgs.length > 0)
                  Container(
                      width: 60 * (MediaQuery.of(context).size.width / 360),
                      height: 30 * (MediaQuery.of(context).size.height / 360),
                      margin : EdgeInsets.fromLTRB(15 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360),
                          0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360)),
                      child : DottedBorder(
                          color: Color(0xffE47421),
                          dashPattern: [5,3],
                          borderType: BorderType.RRect,
                          radius: Radius.circular(10),
                          child: Stack(
                            alignment: Alignment.topRight,
                            children: [
                              if(_pickedImgs.length > 0)
                              Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8),
                                      image: DecorationImage(fit: BoxFit.cover,image: FileImage(File("${_pickedImgs[0].path}")))
                                  ),
                                  child :  null
                              ),
                              if(_pickedImgs.length > 0)
                              Container (
                                  margin: EdgeInsets.fromLTRB(0 * (MediaQuery.of(context).size.width / 360), 1 * (MediaQuery.of(context).size.height / 360), 2 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360)),
                                  decoration: BoxDecoration(
                                    color: Color(0xffffffff),
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  //삭제버튼
                                  child : IconButton(
                                      padding: EdgeInsets.zero,
                                      constraints: BoxConstraints(),
                                      icon: Icon(Icons.close, color: Color(0xffC4CCD0), size : 15),
                                      onPressed: () {
                                        setState(() {
                                          _pickedImgs.removeLast();
                                        });
                                      }
                                  )
                              )
                            ],
                            //child : Center(child: _boxContents[index])
                          )
                      )
                  ),
                  Container(
                    margin : EdgeInsets.fromLTRB(0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360),
                        0 * (MediaQuery.of(context).size.width / 360), 5 * (MediaQuery.of(context).size.height / 360)),
                    child : Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        GestureDetector(
                            onTap : () {
                              _pickImg(ImageSource.gallery);
                            },
                            child : Container(
                                padding : EdgeInsets.fromLTRB(8 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360),
                                    8 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360)),
                                child : Image(image: AssetImage("assets/add_a_gallary.png"), color:Color(0xffC4CCD0), width : 18 * (MediaQuery.of(context).size.width / 360))
                            )
                        ),
                        GestureDetector(
                            onTap : () {
                              _pickImg(ImageSource.camera);
                            },
                            child : Container(
                                padding : EdgeInsets.fromLTRB(0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360),
                                    8 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360)),
                                child : Image(image: AssetImage("assets/add_a_photo.png"), color:Color(0xffC4CCD0), width : 20 * (MediaQuery.of(context).size.width / 360))
                            )
                        ),
                      ],
                    )
                )
              ],
            )
          );
  }

  Container title(BuildContext context) {
    return Container(
            margin : EdgeInsets.fromLTRB(15 * (MediaQuery.of(context).size.width / 360), 5 * (MediaQuery.of(context).size.height / 360),
                15 * (MediaQuery.of(context).size.width / 360), 5 * (MediaQuery.of(context).size.height / 360)),
            width: 360 * (MediaQuery.of(context).size.width / 360),
            height: 25 * (MediaQuery.of(context).size.height / 360),
            decoration: BoxDecoration(
              border: Border.all(
                  color: Color.fromRGBO(243, 246, 248, 1)
              ),
              borderRadius: BorderRadius.circular(3 * (MediaQuery.of(context).size.height / 360)),
              color: Color.fromRGBO(255, 255, 255, 1),
            ),
            child: TextFormField(
              controller: _titleController,
              decoration: InputDecoration(
                border: InputBorder.none,
                contentPadding : EdgeInsets.fromLTRB(15 * (MediaQuery.of(context).size.width / 360), 5 * (MediaQuery.of(context).size.height / 360), 0, 0),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(5)),
                  borderSide: BorderSide(
                    color: Color.fromRGBO(255, 255, 255, 1),
                  ),
                ),
                // labelText: 'Search',
                hintText: '제목',
                hintStyle: TextStyle(color:Color(0xffC4CCD0),),
              ),
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: (value) {
                value = value?.trim();
                if(value == null || value.isEmpty) {
                  return "제목은 필수 입력값입니다.";
                }
                return null;
              },
              style: TextStyle(fontFamily: ''),
            ),
          );
  }

  Container maincategory(BuildContext context) {
    return Container(
            width : 360 * (MediaQuery.of(context).size.width / 360),
            height : 20 * (MediaQuery.of(context).size.height / 360),
            margin : EdgeInsets.fromLTRB(15 * (MediaQuery.of(context).size.width / 360), 5 * (MediaQuery.of(context).size.height / 360),
                15 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360)),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(3 * (MediaQuery.of(context).size.height / 360)),
              border: Border.all(
                  color: Color.fromRGBO(243, 246, 248, 1)
              ),
            ),
            child: DropdownButtonFormField(
              icon: const Icon(Icons.keyboard_arrow_down_rounded),
              isExpanded: true,
              hint: Text("카테고리를 선택해주세요.", style: TextStyle(fontSize: 15, color: Color(0xffC4CCD0)),),
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(3)),
                  borderSide: BorderSide(
                    color:Color(0xffF3F6F8),
                  ),
                ),
                contentPadding: EdgeInsets.only(left: 15),
              ),
              items: mainCategory.map((mainCategoryVO item) => DropdownMenuItem(value: item.idx,child: Text(item.name),),)
                  .toList(),
              onChanged: (String? value) => setState(() {
                this._selectedValue = value;
              }),
              value : _selectedValue,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: (value) {
                value = value?.trim();
                if(value == null || value.isEmpty) {
                  return "카테고리를 필수 선택값입니다.";
                }
                return null;
              },
            ),
          );
  }

  Future<void> FlutterDialog(context) async {


      final List<MultipartFile> _files =
      _pickedImgs.map(
              (img) => MultipartFile.fromFileSync(
              img.path, contentType: new MediaType("image", "jpg"))
      ).toList();

      var ipAddress = IpAddress(type: RequestType.json);
      dynamic data = await ipAddress.getIpAddress();

      // Create storage
      final storage = FlutterSecureStorage();
      String? reg_id = await storage.read(key: "memberId");
      String? nickname = await storage.read(key: "memberNick");
      String? reg_nm = await storage.read(key: "memberNick");

      if(_tagsController.text != null && _tagsController.text != "") {
        if (_tagsController.text.substring( _tagsController.text.length - 1, _tagsController.text.length) == "#") {
          _tagsController.text = _tagsController.text.substring(0, _tagsController.text.length - 1);
        }
      }

      FormData _formData = FormData.fromMap(
          {
            "filelist" : filelist.length,
            "attach" : _files,
            "delattach" : deletefile,
            "article_seq" : widget.article_seq,
            "cms_menu_seq" : cms_menu_seq.toString(),
            "comment_seq" : widget.comment_seq,
            "conts": _contsController.text,
            "main_category": _selectedValue,
            "session_ip": data["ip"].toString(),
            "session_member_id": reg_id,
            "session_member_nm": reg_nm,
            "table_nm": widget.table_nm,
          }
      );

      Dio dio = Dio();

      dio.options.contentType = "multipart/form-data";

      final res = await dio.post(
          "http://www.hoty.company/mf/comment/modify.do", data: _formData)
          .then((res) {
        return res.data;
      });

      print("결과입니다.");
      print(res);

      /*Future initWrite(rst) async {
      writeApi_result = await mainCategoryProvider.writeApi(rst);
    }*/

      /*if(writeApi_result == "success")*/
      if (res["result"] != null && res["resultstatus"] == "N") {

        if(widget.table_nm == "DAILY_TALK") {
          Navigator.pop(context);
          Navigator.pop(context);
          Navigator.push(context, MaterialPageRoute(
            builder: (context) {
              return CommunityDailyTalkView(article_seq: widget.article_seq, table_nm: widget.table_nm, main_catcode: "B06", params: {});
            },
          ));
        } else if (widget.table_nm == "PERSONAL_LESSON") {
          Navigator.pop(context);
          Navigator.pop(context);
          Navigator.push(context, MaterialPageRoute(
            builder: (context) {
              return LessonView(article_seq: widget.article_seq, table_nm: widget.table_nm,  params: {}, checkList : []);
            },
          ));
        } else if (widget.table_nm == "USED_TRNSC") {
          Navigator.pop(context);
          Navigator.pop(context);
          Navigator.push(context, MaterialPageRoute(
            builder: (context) {
              return TradeView(article_seq: widget.article_seq, table_nm: widget.table_nm, params: {}, checkList : []);
            },
          ));
        }


      }
    }





  AlertDialog imagealert(BuildContext context) {
    return AlertDialog(
      // RoundedRectangleBorder - Dialog 화면 모서리 둥글게 조절
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0)),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
              margin: EdgeInsets.fromLTRB(0 * (MediaQuery.of(context).size.height / 360) , 0 * (MediaQuery.of(context).size.height / 360), 0, 0 * (MediaQuery.of(context).size.height / 360)),
              child : Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(
                    style: TextButton.styleFrom(
                        backgroundColor: Color(0xffFFFFFF),
                        padding: EdgeInsets.symmetric(horizontal: 3 * (MediaQuery.of(context).size.width / 360), vertical: 5 * (MediaQuery.of(context).size.height / 360)),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(3 * (MediaQuery.of(context).size.height / 360))
                        ),
                        side: BorderSide(width:1, color:Color(0xffE47421)), //border width and color
                        elevation: 0
                    ),
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 20 * (MediaQuery.of(context).size.width / 360), vertical: 3 * (MediaQuery.of(context).size.height / 360)),
                      child : Text("카메라", style: TextStyle(color: Color(0xffE47421)),),
                    ),
                    onPressed: () {
                     _pickImg(ImageSource.camera);
                      Navigator.pop(context);

                    },
                  ),
                  SizedBox(width: 7 * (MediaQuery.of(context).size.width / 360)),
                  TextButton(
                    style: TextButton.styleFrom(
                        backgroundColor: Color(0xffFFFFFF),
                        padding: EdgeInsets.symmetric(horizontal: 3 * (MediaQuery.of(context).size.width / 360), vertical: 5 * (MediaQuery.of(context).size.height / 360)),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(3 * (MediaQuery.of(context).size.height / 360))
                        ),
                        side: BorderSide(width:1, color:Color(0xffE47421)), //border width and color
                        elevation: 0
                    ),
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 20 * (MediaQuery.of(context).size.width / 360), vertical: 3 * (MediaQuery.of(context).size.height / 360)),
                      child : Text("갤러리", style: TextStyle(color: Color(0xffE47421)),),
                    ),
                    onPressed: () {
                      _pickImg(ImageSource.gallery);
                      Navigator.pop(context);
                    },
                  ),
                ],
              )
          )
        ],
      ),
    );
  }
}