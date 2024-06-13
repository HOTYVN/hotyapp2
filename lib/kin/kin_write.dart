import 'dart:convert';
import 'dart:async';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_ip_address/get_ip_address.dart';
import 'package:hoty/common/footer.dart';
import 'package:hoty/kin/kin_view.dart';
import 'package:hoty/kin/kinlist.dart';
import 'package:hoty/kin/providers/main_category_provider.dart';
import 'package:hoty/kin/model/mainCategoryVO.dart';

import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:dio/dio.dart';
import "package:http_parser/http_parser.dart";

import '../common/dialog/commonAlert.dart';
import '../main/main_page.dart';

class KinWrite extends StatefulWidget {
  @override
  State<KinWrite> createState() => _KinWriteState();
}

class _KinWriteState extends State<KinWrite> {

  final _formKey = GlobalKey<FormState>();

  List<mainCategoryVO> mainCategory = [];

  bool isLoading = true;
  MainCategoryProvider mainCategoryProvider = MainCategoryProvider();
  String? _selectedValue ;
  String? _selectRadioValue ;
  String? writeApi_result ;
  int? point = 0;
  String? member_id = "";
  final ImagePicker _picker = ImagePicker();
  List<XFile> _pickedImgs = [];
  bool _isChecked = false;

  int click_check = 1;

  bool _visibility1 = true;
  bool _visibility2 = false;

  late FocusNode maincategoryNode;
  late FocusNode titleNode;
  late FocusNode contsNode;
  late FocusNode pointNode;


  Future _pickImg(ImageSource imageSource) async {

    if(imageSource == ImageSource.camera) {
      final XFile? images = await _picker.pickImage(source: imageSource);
      if(_pickedImgs.length + 1 <= 6) {
        if (images != null) {
          setState(() {
            _pickedImgs.add(images);
          });
        }
      } else {
        showDialog(context: context,
            barrierColor: Color(0xffE47421).withOpacity(0.4),
            builder: (BuildContext context) {
              return MediaQuery(
                data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
                child: textalert(context,'이미지를 6개를 초과해서 선택하실수 없습니다.'),
              );
            }
        );
      }
    }

    if(imageSource == ImageSource.gallery) {
      List<XFile?> images = await _picker.pickMultiImage();

      if(images.length + _pickedImgs.length <= 6) {
        setState(() {
          _pickedImgs.addAll(images as Iterable<XFile>);
        });
      } else {
        showDialog(context: context,
            barrierColor: Color(0xffE47421).withOpacity(0.4),
            builder: (BuildContext context) {
              return MediaQuery(
                data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
                child: textalert(context,'이미지를 6개를 초과해서 선택하실수 없습니다.'),
              );
            }
        );
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



  final _titleController = TextEditingController();
  final _contsController = TextEditingController();
  final _tagsController = TextEditingController();
  final _pointController = TextEditingController();


  @override
  void initState() {
    super.initState();
    titleNode = FocusNode();
    contsNode = FocusNode();
    maincategoryNode = FocusNode();
    pointNode = FocusNode();

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
    titleNode.dispose();
    contsNode.dispose();
    maincategoryNode.dispose();
    pointNode.dispose();
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
      WillPopScope(
        onWillPop: () {
        return _onBackKey();

      },
      child: GestureDetector(
        onTap : () => FocusManager.instance.primaryFocus?.unfocus(),
        child : Scaffold(
          appBar: AppBar(
            titleSpacing: 0,
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
         /*   title: GestureDetector(
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
            ),*/
            centerTitle: true,
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      maincategory(context),
                      title(context),
                      conts(context),
                      upload(context),
                      tags(context),
                      point_input(context),
                      hide_identity(context),
                    ],
                  ),
                ),
              ],
            ),
          ),
          bottomNavigationBar: apply(context),
        )
      ),
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
            //height: 28 * (MediaQuery.of(context).size.height / 360),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                  elevation: 0,
                  backgroundColor: click_check == 0
                      ? Color.fromRGBO(255, 243, 234, 1)
                      : Color.fromRGBO(228, 116, 33, 1),
                  padding: EdgeInsets.symmetric(horizontal: 5 * (MediaQuery.of(context).size.width / 360), vertical: 9 * (MediaQuery.of(context).size.height / 360)),
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
                 Container(
                   child :  Text('저장하기', style: TextStyle(fontSize: 16 * (MediaQuery.of(context).size.width / 360), color: click_check == 0 ? Color(0xffE47421) : Colors.white, fontWeight: FontWeight.w600),textAlign: TextAlign.center,),
                 )
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
              width: 290 * (MediaQuery.of(context).size.width / 360),
              child : Text("닉네임 비공개" ,style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14 * (MediaQuery.of(context).size.width / 360)),)
          ),
          Container(
              width : 40 * (MediaQuery.of(context).size.width / 360),
              height : 25 * (MediaQuery.of(context).size.height / 360),
              child : FittedBox(
                fit: BoxFit.contain,
                child : CupertinoSwitch(
                  value: _isChecked,
                  activeColor: Color(0xffE47421),
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
            height: 70 * (MediaQuery.of(context).size.height / 360),
            padding: EdgeInsets.fromLTRB(15 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360),
                15 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360) ),
            child: Column(
              children: [
                Container(
                  height: 65 * (MediaQuery.of(context).size.height / 360),
                  child: Column(
                    children: [
                      Container(
                        height: 60 * (MediaQuery.of(context).size.height / 360),
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
                                  Text(" ${point} P", style: TextStyle(color: Color.fromRGBO(228, 116, 33, 1), fontSize: 14 * (MediaQuery.of(context).size.width / 360), fontWeight: FontWeight.w600),),
                                ],
                              ),
                            ),
                            Container(
                              width: 290 * (MediaQuery.of(context).size.width / 360),
                              //height: 20 * (MediaQuery.of(context).size.height / 360),
                              padding : EdgeInsets.fromLTRB(0 * (MediaQuery.of(context).size.width / 360), 2 * (MediaQuery.of(context).size.height / 360),
                                  0 * (MediaQuery.of(context).size.width / 360), 2 * (MediaQuery.of(context).size.height / 360)),
                              margin : EdgeInsets.fromLTRB(0 * (MediaQuery.of(context).size.width / 360), 5 * (MediaQuery.of(context).size.height / 360),
                                  0 * (MediaQuery.of(context).size.width / 360), 5 * (MediaQuery.of(context).size.height / 360) ),
                              decoration: BoxDecoration(
                                color: Color.fromRGBO(255, 255, 255, 1),
                                borderRadius: BorderRadius.circular(2 * (MediaQuery.of(context).size.height / 360)),
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    width: 250 * (MediaQuery.of(context).size.width / 360),
                                    margin : EdgeInsets.fromLTRB(15 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360),
                                        0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360) ),
                                    child : TextFormField(
                                      controller: _pointController,
                                      keyboardType: TextInputType.number,
                                      focusNode: pointNode,
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
                                          if(_titleController.text != null && _titleController.text != '' && _contsController.text != null && _contsController.text != '') {
                                            pointNode.requestFocus();
                                          }
                                          return "포인트는 필수 입력값입니다.";
                                        }
                                        return null;
                                      },
                                      style: TextStyle(fontFamily: ''),
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
            //height: 25 * (MediaQuery.of(context).size.height / 360),
            padding : EdgeInsets.fromLTRB(0 * (MediaQuery.of(context).size.width / 360), 2 * (MediaQuery.of(context).size.height / 360),
                0 * (MediaQuery.of(context).size.width / 360), 2 * (MediaQuery.of(context).size.height / 360)),
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
                contentPadding : EdgeInsets.fromLTRB(15 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360), 0, 0),
                // labelText: 'Search',
                hintText: '#태그 입력 (최대 10)',
                hintStyle: TextStyle(color:Color(0xffC4CCD0),),
              ),
              style: TextStyle(fontFamily: ''),
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
            height: 70 * (MediaQuery.of(context).size.height / 360),
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
                          // height: 25 * (MediaQuery.of(context).size.height / 360),
                          child : Text("5MB를 초과하지 않는 파일을\n첨부해주세요.", style: TextStyle(fontSize: 13 * (MediaQuery.of(context).size.width / 360), height: 0.7 * (MediaQuery.of(context).size.height / 360), color: Color(0xff151515), fontWeight: FontWeight.w400), textAlign: TextAlign.center, )
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
                            Container(
                                decoration: index <= _pickedImgs.length - 1
                                    ? BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    image: DecorationImage(fit: BoxFit.cover,image: FileImage(File(_pickedImgs[index].path)))
                                )
                                    : null,
                                //child: Text("asd ${index} || ${_pickedImgs.length }"),
                                child : _pickedImgs.length == index ? Center(
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
                                  /*IconButton(
                                onPressed: () {
                                  _pickImg();
                                },
                                icon: Container(
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(0.6), shape: BoxShape.circle
                                  ),
                                  child: Image(image: AssetImage("assets/upload_icon.png"))
                                ),
                              ),*/
                                ) : null
                            ),
                            if(index <= _pickedImgs.length - 1)
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
                                          _pickedImgs.remove(_pickedImgs[index]);
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
            margin : EdgeInsets.fromLTRB(15 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360),
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
            child: TextFormField(
              controller: _contsController,
              focusNode: contsNode,
              maxLines: 13,
              minLines: 9,
              decoration: InputDecoration(
                border: InputBorder.none,
                contentPadding : EdgeInsets.fromLTRB(15 * (MediaQuery.of(context).size.width / 360), 5 * (MediaQuery.of(context).size.height / 360), 0, 5 * (MediaQuery.of(context).size.height / 360)),
                // labelText: 'Search',
                hintText: "궁금한 내용을 질문해주세요.\n\n\질문 시 이런점을 주의해 주세요!\n답변이 등록되면 질문 수정/삭제가 불가합니다.\n질문 내용에 개인정보(실명, 전화번호, 메신저, 주소)\n가 포함되지 않게 해 주세요.",
                hintStyle: TextStyle(color:Color(0xffC4CCD0), fontSize: 15 * (MediaQuery.of(context).size.width / 360), height: 0.7 * (MediaQuery.of(context).size.height / 360)),
              ),
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: (value) {
                value = value?.trim();
                if(value == null || value.isEmpty) {
                  if(_titleController.text != null && _titleController.text != '') {
                    contsNode.requestFocus();
                  }
                  return "질문 내용은 필수 입력값입니다.";
                }
                return null;
              },
              style: TextStyle(fontSize: 15 * (MediaQuery.of(context).size.width / 360),fontFamily: ''),
            ),
          );
  }

  Container title(BuildContext context) {
    return Container(
            margin : EdgeInsets.fromLTRB(15 * (MediaQuery.of(context).size.width / 360), 5 * (MediaQuery.of(context).size.height / 360),
                15 * (MediaQuery.of(context).size.width / 360), 5 * (MediaQuery.of(context).size.height / 360)),
            width: 360 * (MediaQuery.of(context).size.width / 360),
            //height: 25 * (MediaQuery.of(context).size.height / 360),
            padding : EdgeInsets.fromLTRB(0 * (MediaQuery.of(context).size.width / 360), 2 * (MediaQuery.of(context).size.height / 360),
                0 * (MediaQuery.of(context).size.width / 360), 2 * (MediaQuery.of(context).size.height / 360)),
            decoration: BoxDecoration(
              border: Border.all(
                  color: Color.fromRGBO(243, 246, 248, 1)
              ),
              borderRadius: BorderRadius.circular(3 * (MediaQuery.of(context).size.height / 360)),
              color: Color.fromRGBO(255, 255, 255, 1),
            ),
            child: TextFormField(
              controller: _titleController,
              focusNode: titleNode,
              //maxLength: 255,
              decoration: InputDecoration(
                border: InputBorder.none,
                contentPadding : EdgeInsets.fromLTRB(15 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360), 0, 0),
                // labelText: 'Search',
                hintText: '제목',
                hintStyle: TextStyle(fontSize: 15 * (MediaQuery.of(context).size.width / 360), color:Color(0xffC4CCD0),),
              ),
              autovalidateMode: AutovalidateMode.onUserInteraction,
              onChanged: (value) {
                if(value != null && value != '') {
                  if(value.length > 100) {
                    _titleController.text = value.substring(0,100);
                    showDialog(
                      context: context,
                      barrierColor: Color(0xffE47421).withOpacity(0.4),
                      barrierDismissible: false,
                      builder: (BuildContext context) {
                        return WillPopScope(
                          onWillPop: () async => false,
                          child: textlimitalert(context, "제목은 띄어쓰기 포함 100자까지\n가능합니다."),
                        );
                      },
                    );
                  }

                }
              },
              validator: (value) {
                value = value?.trim();
                if(value == null || value.isEmpty) {
                  titleNode.requestFocus();
                  return "제목은 필수 입력값입니다.";
                }
                return null;
              },
              style: TextStyle(fontSize: 15 * (MediaQuery.of(context).size.width / 360),fontFamily: ''),
            ),
          );
  }

  Container maincategory(BuildContext context) {
    return Container(
            width : 360 * (MediaQuery.of(context).size.width / 360),
            //height : 25 * (MediaQuery.of(context).size.height / 360),
            margin : EdgeInsets.fromLTRB(14 * (MediaQuery.of(context).size.width / 360), 5 * (MediaQuery.of(context).size.height / 360),
                14 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360)),
            padding : EdgeInsets.fromLTRB(0 * (MediaQuery.of(context).size.width / 360), 2 * (MediaQuery.of(context).size.height / 360),
                0 * (MediaQuery.of(context).size.width / 360), 2 * (MediaQuery.of(context).size.height / 360)),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(3 * (MediaQuery.of(context).size.height / 360)),
              border: Border.all(
                  color: Color.fromRGBO(243, 246, 248, 1)
              ),
            ),
            child: DropdownButtonHideUnderline(
              child : DropdownButtonFormField2(
                isExpanded: true,
                value: _selectedValue,
                focusNode: maincategoryNode,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.fromLTRB(15 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360),
                      0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360)),
                ),
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (value) {
                  value = value?.trim();
                  if(value == null || value.isEmpty) {
                    FocusScope.of(context).requestFocus(maincategoryNode);
                    return "카테고리는 필수 선택값입니다.";
                  }
                  return null;
                },
                //isDense : false,
                hint: Text("카테고리를 선택해주세요.", style: TextStyle(fontSize: 14 * (MediaQuery.of(context).size.width / 360), color: Color(0xffC4CCD0)),),
                buttonStyleData: ButtonStyleData(
                  padding: EdgeInsets.fromLTRB(0 * (MediaQuery.of(context).size.width / 360), 1 * (MediaQuery.of(context).size.height / 360), 15 * (MediaQuery.of(context).size.width / 360), 0),
                  elevation: 0,
                ),
                iconStyleData: IconStyleData(
                  openMenuIcon: Icon(
                    Icons.keyboard_arrow_up_rounded,
                  ),
                  icon: Icon(
                    Icons.keyboard_arrow_down_rounded,
                  ),
                  iconSize: 30 * (MediaQuery.of(context).size.width / 360),
                  iconEnabledColor: Color(0xff151515),
                ),
                dropdownStyleData: DropdownStyleData( //드롭다운 스타일
                  elevation: 0,
                  padding : EdgeInsets.fromLTRB(0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360),
                      0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360)),
                ),
                menuItemStyleData: MenuItemStyleData( //드롭다운 내 메뉴 별 스타일
                  padding : EdgeInsets.fromLTRB(0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360),
                      0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360)),
                ),
                selectedItemBuilder: (BuildContext context) {
                  return mainCategory.map<Widget>((item) {
                    return Container(
                        width:double.infinity,
                        padding : EdgeInsets.fromLTRB(0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360),
                            0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360)),
                        alignment:Alignment.centerLeft,
                        decoration:BoxDecoration(
                            color: Color(0xffFFFFFF),
                        ),
                        //padding: const EdgeInsets.fromLTRB(0,8.0,0,6.0),
                        child:Text(item.name)
                    );
                  }).toList();
                },
                items: mainCategory.map((mainCategoryVO item) =>
                    DropdownMenuItem(value: item.idx,
                      child: Container(
                          width:double.infinity,
                          padding : EdgeInsets.fromLTRB(15 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360),
                              0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360)),
                          alignment:Alignment.centerLeft,
                          decoration:BoxDecoration(
                              color: Color(0xffFFFFFF),
                              border:Border(
                                  top:BorderSide(color:Color(0xffF3F6F8),width: item.seq == 1 ? 1 : 0),
                                  bottom:BorderSide(color:Color(0xffF3F6F8),width:1),
                                  left:BorderSide(color:Color(0xffF3F6F8),width:1),
                                  right:BorderSide(color:Color(0xffF3F6F8),width:1)
                              )
                          ),
                          //padding: const EdgeInsets.fromLTRB(0,8.0,0,6.0),
                          child:Text(item.name)
                      ),
                    ),
                ).toList(),
                onChanged: (String? value) => setState(() {
                  _selectedValue = value;
                }),
              )
            )
          );
  }

  Future<void> FlutterDialog(context) async {

    if(int.parse(_pointController.text) < 100) {
      showDialog(context: context,
          barrierColor: Color(0xffE47421).withOpacity(0.4),
          builder: (BuildContext context) {
            return MediaQuery(
              data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
              child: textalert(context,'지식인의 질문을 위해서는 최소 100 채택포인트가 필요합니다.'),
            );
          }
      ).then((_){
        click_check = 1;
        setState(() {
        });
      });
    } else {
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
            "attach": _files,
            "title": _titleController.text,
            "conts": _contsController.text,
            "main_category": _selectedValue,
            "etc01": _pointController.text,
            "tag_names": _tagsController.text,
            "public_yn": _isChecked == true ? "N" : "Y",
            "board_seq": "10",
            "session_ip": data["ip"].toString(),
            "session_member_id": reg_id,
            "session_member_nm": reg_nm,
            "table_nm": "KIN"
          }
      );

      Dio dio = Dio();

      dio.options.contentType = "multipart/form-data";

      final res = await dio.post(
          "http://www.hoty.company/mf/community/write.do", data: _formData)
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
        showDialog(
            context: context,
            //barrierDismissible - Dialog를 제외한 다른 화면 터치 x
            barrierDismissible: false,
            barrierColor: Color(0xffE47421).withOpacity(0.4),
            builder: (BuildContext context) {
              return MediaQuery(
                data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
                child: writecomplete2(context),
              );
            }
        ).then((value) {
          Navigator.pop(context);
          if(value == "list") {
            Navigator.push(context, MaterialPageRoute(
              builder: (context) {
                return KinList(success: true, failed: false,main_catcode: '',);
              },
            ));
          }
          if(value == "view") {
            Navigator.push(context, MaterialPageRoute(
              builder: (context) {
                return KinView(article_seq: int.parse("${res['params']['article_seq']}"), table_nm: 'KIN', adopt_chk: '');
              },
            ));
          }
        });
      } else {
        Navigator.push(context, MaterialPageRoute(
          builder: (context) {
            return KinList(success: false, failed: true,main_catcode: '',);
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