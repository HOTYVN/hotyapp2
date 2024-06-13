import 'dart:convert';
import 'dart:async';

import 'package:custom_radio_group_list/custom_radio_group_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_ip_address/get_ip_address.dart';
import 'package:hoty/common/dialog/commonAlert.dart';
import 'package:hoty/common/footer.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:hoty/community/privatelesson/lesson_list.dart';
import 'package:hoty/community/usedtrade/providers/main_category_provider.dart';
import 'package:hoty/community/usedtrade/trade_list.dart';
import 'package:hoty/main/main_page.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:dio/dio.dart';
import "package:http_parser/http_parser.dart";

import '../usedtrade/model/mainCategoryVO.dart';


class CommentReportwrite extends StatefulWidget {
  final int article_seq;
  final String article_title;
  final String table_nm;
  final int board_seq;
  final int comment_seq;

  const CommentReportwrite({Key? key,
    required this.article_seq,
    required this.article_title,
    required this.table_nm,
    required this.board_seq,
    required this.comment_seq,
  }) : super(key:key);

  @override
  _CommentReportwrite createState() => _CommentReportwrite();
}

class _CommentReportwrite extends State<CommentReportwrite> {

  final _formKey = GlobalKey<FormState>();

  int click_check = 1;

  List<mainCategoryVO> mainCategory = [];
  List<mainCategoryVO> cat02list = [];

  bool isLoading = true;
  MainCategoryProvider mainCategoryProvider = MainCategoryProvider();
  String? _selectedValue ;
  String? _selectRadioValue ;
  String? writeApi_result ; 

  final ImagePicker _picker = ImagePicker();
  List<XFile> _pickedImgs = [];

  bool _visibility1 = true;
  bool _visibility2 = false;

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
            builder: (BuildContext context) {
              return imageLimitalert(context);
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
            builder: (BuildContext context) {
              return imageLimitalert(context);
            }
        );
      }

    }
  }

  Future initmainCategory() async {
    mainCategory = await mainCategoryProvider.getCategory();
  }

  Future initcat02() async {
    var type = 'M';
    cat02list = await mainCategoryProvider.getCat02(type);
  }


  final _titleController = TextEditingController();
  final _contsController = TextEditingController();
  final _articletitleController = TextEditingController();
  final _priceController = TextEditingController();

  late FocusNode titleNode;
  late FocusNode contsNode;

  @override
  void initState() {
    super.initState();

    titleNode = FocusNode();
    contsNode = FocusNode();

    _articletitleController.text = widget.article_title;
    initmainCategory().then((_) {
      setState(() {

      });
    });
    initcat02().then((_) {
      setState(() {

      });
    });

    /*_selectRadioValue = cat02list.first.idx;*/
  }

  @override
  void dispose() {

    titleNode.dispose();
    contsNode.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap : () => FocusManager.instance.primaryFocus?.unfocus(),
      child : Scaffold(
        appBar: AppBar(
          titleSpacing: 0,
          leadingWidth: 40,
          backgroundColor: Colors.white,
          elevation: 0,
          automaticallyImplyLeading: true,
          leading: IconButton(
            padding: EdgeInsets.fromLTRB(12, 0, 0, 0),
            icon: Icon(Icons.arrow_back_rounded),
            iconSize: 12 * (MediaQuery.of(context).size.height / 360),
            color: Colors.black,
            // alignment: Alignment.centerLeft,
            // padding: EdgeInsets.zero,
            // visualDensity: VisualDensity(horizontal: -2.0, vertical: -3.0),
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
          title:     Container(
            padding : EdgeInsets.fromLTRB(0 * (MediaQuery.of(context).size.width / 360), 1 * (MediaQuery.of(context).size.height / 360),
                0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360)),
            // width: 240 * (MediaQuery.of(context).size.width / 360),
            child: Text(
              "신고",
              style: TextStyle(
                fontSize: 17 * (MediaQuery.of(context).size.width / 360),
                color: Colors.black87,
                fontWeight: FontWeight.bold,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
          //centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width : 180 * (MediaQuery.of(context).size.width / 360),
                child: Image(image : AssetImage("assets/Report02.png"), height: 80 * (MediaQuery.of(context).size.height / 360),),
                margin: EdgeInsets.fromLTRB(0, 10 * (MediaQuery.of(context).size.height / 360), 0, 10 * (MediaQuery.of(context).size.height / 360)),
              ),
              Form(
                  key : _formKey,
                  child : Column(
                    children: [
                      articletitle(context),
                      title(context),
                      conts(context),
                    ],
                  )
              ),
              // apply(context)
            ],
          ),
        ),
        bottomNavigationBar: apply(context),
        // bottomNavigationBar: Footer(nowPage: ''),
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
                        elevation: 0,
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
                        GestureDetector(
                          child: Text('등록하기', style: TextStyle(fontSize: 17 * (MediaQuery.of(context).size.width / 360), color: click_check == 0 ? Color(0xffE47421) : Colors.white , fontWeight: FontWeight.w600),textAlign: TextAlign.center,),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          );
  }

  Container cat02(BuildContext context) {

    return  Container(
      padding : EdgeInsets.fromLTRB(15 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360),
          15 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360)),
      child : SizedBox(
        width: 360 * (MediaQuery.of(context).size.width / 360),
        height: 30 * (MediaQuery.of(context).size.height / 360),

        child: RadioGroup(
          items: cat02list,
          //disabled: true,
          scrollDirection: Axis.horizontal,
          onChanged: (value) {
            _selectRadioValue = value.idx;
          },
          selectedItem: _selectRadioValue,
          shrinkWrap: true,
          labelBuilder: (ctx, index) {
            return Text(
              cat02list[index].name,
            );
          },
        ),
      ),
    );
  }

  Container conts(BuildContext context) {
    return Container(
      margin : EdgeInsets.fromLTRB(15 * (MediaQuery.of(context).size.width / 360), 5 * (MediaQuery.of(context).size.height / 360),
          15 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360)),
      width: 360 * (MediaQuery.of(context).size.width / 360),
      // height: 200 * (MediaQuery.of(context).size.height / 360),
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
        maxLines: 9,
        minLines: 9,
        decoration: InputDecoration(
          border: InputBorder.none,
          contentPadding : EdgeInsets.fromLTRB(15 * (MediaQuery.of(context).size.width / 360), 10 * (MediaQuery.of(context).size.height / 360), 0, 0),
        /*  enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(5)),
            borderSide: BorderSide(
              color: Color.fromRGBO(255, 255, 255, 1),
            ),
          ),*/
          // labelText: 'Search',
          hintText: '신고 사유 입력',
          hintStyle: TextStyle(color:Color(0xffC4CCD0),),
        ),
        autovalidateMode: AutovalidateMode.onUserInteraction,
        validator: (value) {
          value = value?.trim();
          if(value == null || value.isEmpty) {
            if(_titleController.text != null && _titleController.text != '') {
              contsNode.requestFocus();
            }
            return "신고 사유를 입력해주세요.";
          }
          return null;
        },
        style: TextStyle(fontFamily: ''),
      ),
    );
  }

  Container price(BuildContext context) {
    return Container(
      margin : EdgeInsets.fromLTRB(15 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360),
          15 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360)),
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
        controller: _priceController,
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
          hintText: 'Price',
          hintStyle: TextStyle(color:Color(0xffC4CCD0),),
        ),
        autovalidateMode: AutovalidateMode.onUserInteraction,
        validator: (value) {
          value = value?.trim();
          if(value == null || value.isEmpty) {
            return "Entering the price value is required.";
          }
          return null;
        },
      ),
    );
  }

  Container articletitle(BuildContext context) {
    return Container(
      margin : EdgeInsets.fromLTRB(15 * (MediaQuery.of(context).size.width / 360), 5 * (MediaQuery.of(context).size.height / 360),
          15 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360)),
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
        readOnly: true,
        controller: _articletitleController,
        decoration: InputDecoration(
          border: InputBorder.none,
          contentPadding : EdgeInsets.fromLTRB(15 * (MediaQuery.of(context).size.width / 360), 3 * (MediaQuery.of(context).size.height / 360), 0, 0),
          /*enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(5)),
            borderSide: BorderSide(
              color: Color.fromRGBO(255, 255, 255, 1),
            ),
          ),*/
          // labelText: 'Search',
          hintText: 'PostTitle',
          hintStyle: TextStyle(color:Color(0xffC4CCD0),),
        ),
        autovalidateMode: AutovalidateMode.onUserInteraction,
        validator: (value) {
          value = value?.trim();
          if(value == null || value.isEmpty) {
            return "게시글 제목을 입력해주세요.";
          }
          return null;
        },
        style: TextStyle(fontFamily: ''),
      ),
    );
  }

  Container title(BuildContext context) {
    return Container(
      margin : EdgeInsets.fromLTRB(15 * (MediaQuery.of(context).size.width / 360), 4 * (MediaQuery.of(context).size.height / 360),
          15 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360)),
      padding : EdgeInsets.fromLTRB(0 * (MediaQuery.of(context).size.width / 360), 2 * (MediaQuery.of(context).size.height / 360),
          0 * (MediaQuery.of(context).size.width / 360), 2 * (MediaQuery.of(context).size.height / 360)),
      width: 360 * (MediaQuery.of(context).size.width / 360),
      //height: 25 * (MediaQuery.of(context).size.height / 360),
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
        decoration: InputDecoration(
          border: InputBorder.none,
          contentPadding : EdgeInsets.fromLTRB(15 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360), 0, 0),
          /*enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(5)),
            borderSide: BorderSide(
              color: Color.fromRGBO(255, 255, 255, 1),
            ),
          ),*/
          // labelText: 'Search',
          hintText: '제목',
          hintStyle: TextStyle(color:Color(0xffC4CCD0),),
        ),
        autovalidateMode: AutovalidateMode.onUserInteraction,
        validator: (value) {
          value = value?.trim();
          if(value == null || value.isEmpty) {
            titleNode.requestFocus();
            return "제목을 입력해주세요.";
          }
          return null;
        },
        style: TextStyle(fontFamily: ''),
      ),
    );
  }


  Container main_category(BuildContext context) {

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
        hint: Text("Select category", style: TextStyle(fontSize: 15, color: Color(0xffC4CCD0)),),
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
            return "Selecting a category is required.";
          }
          return null;
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
                                child: Image(image: AssetImage("assets/upload_photo_icon.png"), width: 30 * (MediaQuery.of(context).size.width / 360),),
                              ),
                              Container(
                                height: 10 * (MediaQuery.of(context).size.height / 360),
                                margin : EdgeInsets.fromLTRB(0 * (MediaQuery.of(context).size.width / 360), 3 * (MediaQuery.of(context).size.height / 360),
                                    0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360)),
                                child: Text("사진 첨부", style: TextStyle(fontSize: 16, color: Color.fromRGBO(228, 116, 33, 1), fontWeight: FontWeight.w700),),
                              ),
                            ],
                          ),
                        ),
                        Container(
                            height: 20 * (MediaQuery.of(context).size.height / 360),
                            child : Text("5MB를 초과하지 않는 jpg,png,jpeg\n형식의 파일을 첨부 해주세요.", style: TextStyle(fontSize: 14, color: Color(0xff151515), fontWeight: FontWeight.w400), textAlign: TextAlign.center, )
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

  Future<void> FlutterDialog(context) async {

    /*FormData _formData = FormData.fromMap(
        {
          "article_seq" : widget.article_title,
          "article_title" : _articletitleController.text,
          "reporttitle": _titleController.text,
          "reportconts" : _contsController.text,
          "table_nm" : widget.table_nm,
          "board_seq" : widget.board_seq,
          "reg_id" : "admin",
          "reg_nm" : "관리자",
          "ip" : "127.0.0.1"
        }
    );

    Dio dio = Dio();

    dio.options.contentType = "application/json";

    final res = await dio.post("http://www.hoty.company/mf/report/write.do", data: _formData).then((res) {
      return res.data;
    });*/

    // Create storage
    final storage = FlutterSecureStorage();
    String? reg_id = await storage.read(key: "memberId");
    String? nickname = await storage.read(key: "memberNick");
    String? reg_nm = await storage.read(key: "memberNick");

    var ipAddress = IpAddress(type: RequestType.json);
    dynamic ipdata = await ipAddress.getIpAddress();

    Map data = {
      "article_seq" : widget.article_seq,
      "article_title" : _articletitleController.text,
      "reporttitle": _titleController.text,
      "reportconts" : _contsController.text,
      "table_nm" : widget.table_nm,
      "board_seq" : widget.board_seq,
      "comment_seq" : widget.comment_seq,
      "member_id" : await storage.read(key: "memberId"),
      "member_nm" : await storage.read(key: "memberNick"),
      "ip" : ipdata["ip"].toString(),
    };

    var url = Uri.parse(
      'http://www.hoty.company/mf/report/write.do',
    );
    var body = json.encode(data);
    var response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: body
    );

    var res = json.decode(response.body);
    /*Future initWrite(rst) async {
      writeApi_result = await mainCategoryProvider.writeApi(rst);
    }*/
    
    /*if(writeApi_result == "success")*/
    if(res["result"] != null && res["resultstatus"] == "Y") {
      showDialog(
        context: context,
        barrierColor: Color(0xffE47421).withOpacity(0.4),
        barrierDismissible: false,
        builder: (BuildContext context) {
          return MediaQuery(
            data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
            child: textalert2(context, '등록이 완료되었습니다.'),
          );
        },
      ).then((value) => {
       Navigator.pop(context),
      });
    }
  }
  AlertDialog imageLimitalert(BuildContext context) {
    return AlertDialog(
      // RoundedRectangleBorder - Dialog 화면 모서리 둥글게 조절
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0)),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            "이미지를 6개를 초과해서 선택하실수 없습니다.",
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

