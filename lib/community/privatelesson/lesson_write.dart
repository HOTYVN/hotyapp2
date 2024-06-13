import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_ip_address/get_ip_address.dart';
import 'package:hoty/common/footer.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:hoty/community/privatelesson/lesson_list.dart';
import 'package:hoty/community/privatelesson/providers/privatelesson_provider.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:dio/dio.dart';
import "package:http_parser/http_parser.dart";

import '../../common/dialog/commonAlert.dart';
import '../../profile/profile_my_post.dart';
import 'model/privatelessonVO.dart';

class Lessonwrite extends StatefulWidget {
  @override
  State<Lessonwrite> createState() => _LessonwriteState();
}

class _LessonwriteState extends State<Lessonwrite> {

  final _formKey = GlobalKey<FormState>();

  int click_check = 1;

  List<privatelessonVO> mainCategory = [];
  List<privatelessonVO> cat02list = [];

  bool isLoading = true;
  privatelessonProvider mainCategoryProvider = privatelessonProvider();
  String? _selectedValue ;
  String? _selectRadioValue ;
  String? writeApi_result ;

  final ImagePicker _picker = ImagePicker();
  List<XFile> _pickedImgs = [];

  bool _visibility1 = true;
  bool _visibility2 = false;

  File? selectedFile;
  String filePath = '';
  void _openFilePicker() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      setState(() {
        filePath = result.files.single.path!;
        selectedFile = File(result.files.single.path!);
      });

    } else {
      // User canceled the picker
    }
  }

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
            barrierColor: Color(0xffE47421).withOpacity(0.4),
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
    cat02list = await mainCategoryProvider.getCat02();
  }


  final _titleController = TextEditingController();
  final _priceController = TextEditingController();
  final _telController = TextEditingController();
  final _descriptionController = TextEditingController();

  late FocusNode titleNode;
  late FocusNode priceNode;
  late FocusNode telNode;
  late FocusNode descriptionNode;

  @override
  void initState() {
    super.initState();

    titleNode = FocusNode();
    priceNode = FocusNode();
    telNode = FocusNode();
    descriptionNode = FocusNode();

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
    priceNode.dispose();
    telNode.dispose();
    descriptionNode.dispose();

    super.dispose();
  }



  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap : () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        appBar: AppBar(
          titleSpacing: 0,
          leadingWidth: 40,
          backgroundColor: Colors.white,
          elevation: 0,
          automaticallyImplyLeading: true,
          leading: Container(
            // margin: EdgeInsets.fromLTRB(0, 2 * (MediaQuery.of(context).size.height / 360), 0, 0),
            child: IconButton(
              icon: Icon(Icons.arrow_back_rounded),
              iconSize: 12 * (MediaQuery.of(context).size.height / 360),
              color: Colors.black,
              // alignment: Alignment.centerLeft,
              // padding: EdgeInsets.zero,
              // visualDensity: VisualDensity(horizontal: -2.0, vertical: -3.0),
              onPressed: (){
                Navigator.pop(context);
              },
            ),
          ),
          title: Container(
            /*width: 80 * (MediaQuery.of(context).size.width / 360),
          height: 80 * (MediaQuery.of(context).size.height / 360),
          child: Image(image: AssetImage('assets/logo.png')),*/
            child: Text("개인과외 등록요청" , style: TextStyle(fontSize: 18,  color: Colors.black, fontWeight: FontWeight.bold,)),
          ),
          //centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Form(
                  key: _formKey,
                  child : Column(
                    children: [
                      upload(context),
                      passport(context),
                      main_category(context),
                      title(context),
                      price(context),
                      tel(context),
                      description(context),
                      announcement(context),
                      apply(context)
                    ],
                  )
              )
            ],
          ),
        ),
        extendBody: true,
bottomNavigationBar: Footer(nowPage: 'Main_menu'),
      ),
    );
  }

  Container apply(BuildContext context) {
    return Container(
      width: 360 * (MediaQuery.of(context).size.width / 360),
      height: 30 * (MediaQuery.of(context).size.height / 360),
      padding : EdgeInsets.fromLTRB(15 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360),
          15 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360)),
      margin : EdgeInsets.fromLTRB(0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360),
          0 * (MediaQuery.of(context).size.width / 360), 45 * (MediaQuery.of(context).size.height / 360)),
      child: Row(
        children: [
          Container(
            width: 330 * (MediaQuery.of(context).size.width / 360),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: click_check == 0
                      ? Color.fromRGBO(255, 243, 234, 1)
                      : Color.fromRGBO(228, 116, 33, 1),
                  padding: EdgeInsets.symmetric(horizontal: 5 * (MediaQuery.of(context).size.width / 360), vertical: 10 * (MediaQuery.of(context).size.height / 360)),
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
                  Text('등록하기', style: TextStyle(fontSize: 20, color: click_check == 0 ? Color(0xffE47421) : Colors.white),textAlign: TextAlign.center,),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Container announcement(BuildContext context) {
    return Container(
      width: 360 * (MediaQuery.of(context).size.width / 360),
      padding : EdgeInsets.fromLTRB(15 * (MediaQuery.of(context).size.width / 360), 3 * (MediaQuery.of(context).size.height / 360),
          10 * (MediaQuery.of(context).size.width / 360) , 3 * (MediaQuery.of(context).size.height / 360) ),
      margin : EdgeInsets.fromLTRB(15 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360),
          15 * (MediaQuery.of(context).size.width / 360) , 10 * (MediaQuery.of(context).size.height / 360) ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(3 * (MediaQuery.of(context).size.height / 360)),
        color: Color.fromRGBO(243, 246, 248, 1)
      ),
      child: Column(
        children: [
          Container(
            margin : EdgeInsets.fromLTRB(0 * (MediaQuery.of(context).size.width / 360), 5 * (MediaQuery.of(context).size.height / 360),
                0 * (MediaQuery.of(context).size.width / 360) , 0 * (MediaQuery.of(context).size.height / 360) ),
            width: 360 * (MediaQuery.of(context).size.width / 360),
            //height: 10 * (MediaQuery.of(context).size.height / 360),
            child: Text("안내문", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
          ),
          Container(
            width: 360 * (MediaQuery.of(context).size.width / 360),
            margin : EdgeInsets.fromLTRB(0 * (MediaQuery.of(context).size.width / 360), 5 * (MediaQuery.of(context).size.height / 360),
                0 * (MediaQuery.of(context).size.width / 360) , 5 * (MediaQuery.of(context).size.height / 360) ),
            child: Text("1.연락처와 회당 시간을 필수 기입 해주세요.\n2.상세한 비용 안내 부탁드립니다. 예) 1회당 XX만동, 월 8회 XX 만동 등\n3. 개인과외글은 담당자 검수 후 등록 됩니다.", style: TextStyle(fontSize: 16),),
          ),
        ],
      ),
    );
  }

  Container description(BuildContext context) {
    return Container(
      margin : EdgeInsets.fromLTRB(15 * (MediaQuery.of(context).size.width / 360), 5 * (MediaQuery.of(context).size.height / 360),
          15 * (MediaQuery.of(context).size.width / 360), 10 * (MediaQuery.of(context).size.height / 360)),
      width: 360 * (MediaQuery.of(context).size.width / 360),
      height: 50 * (MediaQuery.of(context).size.height / 360),
      decoration: BoxDecoration(
        border: Border.all(
            color: Color.fromRGBO(243, 246, 248, 1)
        ),
        borderRadius: BorderRadius.circular(3 * (MediaQuery.of(context).size.height / 360)),
        color: Color.fromRGBO(255, 255, 255, 1),
      ),
      child: TextFormField(
        controller: _descriptionController,
        focusNode: descriptionNode,
        maxLines: 5,
        minLines: 5,
        decoration: InputDecoration(
          border: InputBorder.none,
          contentPadding : EdgeInsets.fromLTRB(15 * (MediaQuery.of(context).size.width / 360), 5 * (MediaQuery.of(context).size.height / 360), 0, 0),
          // labelText: 'Search',
          hintText: '내용',
          hintStyle: TextStyle(color:Color(0xffC4CCD0),),
        ),
        autovalidateMode: AutovalidateMode.onUserInteraction,
        validator: (value) {
          value = value?.trim();
          if(value == null || value.isEmpty) {
            if(_titleController.text != null && _titleController.text != '' && _priceController.text != null && _priceController.text != '' && _telController.text != null && _telController.text != '') {
              descriptionNode.requestFocus();
            }
            return "내용을 입력해주세요.";
          }
          return null;
        },
        style: TextStyle(fontFamily: ''),
      ),
    );
  }

  Container tel(BuildContext context) {
    return Container(
      margin : EdgeInsets.fromLTRB(15 * (MediaQuery.of(context).size.width / 360), 5 * (MediaQuery.of(context).size.height / 360),
          15 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360)),
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
        controller: _telController,
        focusNode: telNode,
        decoration: InputDecoration(
          border: InputBorder.none,
          contentPadding : EdgeInsets.fromLTRB(15 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360), 0, 0),
          // labelText: 'Search',
          hintText: '연락처',
          hintStyle: TextStyle(color:Color(0xffC4CCD0),),
        ),
        autovalidateMode: AutovalidateMode.onUserInteraction,
        validator: (value) {
          value = value?.trim();
          if(value == null || value.isEmpty) {
            if(_titleController.text != null && _titleController.text != '' && _priceController.text != null && _priceController.text != '') {
              telNode.requestFocus();
            }
            return "연락처를 입력해주세요.";
          }
          return null;
        },
        style: TextStyle(fontFamily: ''),
      ),
    );
  }

  Container price(BuildContext context) {
    return Container(
      margin : EdgeInsets.fromLTRB(15 * (MediaQuery.of(context).size.width / 360), 5 * (MediaQuery.of(context).size.height / 360),
          15 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360)),
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
        controller: _priceController,
        focusNode: priceNode,
        keyboardType: TextInputType.number,
        inputFormatters: <TextInputFormatter>[
          FilteringTextInputFormatter.digitsOnly,
        ],
        decoration: InputDecoration(
          border: InputBorder.none,
          contentPadding : EdgeInsets.fromLTRB(15 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360), 0, 0),
          // labelText: 'Search',
          hintText: '금액',
          hintStyle: TextStyle(color:Color(0xffC4CCD0),),
        ),
        autovalidateMode: AutovalidateMode.onUserInteraction,
        validator: (value) {
          value = value?.trim();
          if(value == null || value.isEmpty) {
            if(_titleController.text != null && _titleController.text != '') {
              priceNode.requestFocus();
            }
            return "금액을 입력해주세요.";
          }
          return null;
        },
        style: TextStyle(fontFamily: ''),
      ),
    );
  }

  Container title(BuildContext context) {
    return Container(
      margin : EdgeInsets.fromLTRB(15 * (MediaQuery.of(context).size.width / 360), 5 * (MediaQuery.of(context).size.height / 360),
          15 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360)),
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
        decoration: InputDecoration(
          border: InputBorder.none,
          contentPadding : EdgeInsets.fromLTRB(15 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360), 0, 0),
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
      //height : 20 * (MediaQuery.of(context).size.height / 360),
      padding : EdgeInsets.fromLTRB(0 * (MediaQuery.of(context).size.width / 360), 2 * (MediaQuery.of(context).size.height / 360),
          0 * (MediaQuery.of(context).size.width / 360), 2 * (MediaQuery.of(context).size.height / 360)),
      margin : EdgeInsets.fromLTRB(14 * (MediaQuery.of(context).size.width / 360), 5 * (MediaQuery.of(context).size.height / 360),
          14 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360)),
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
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.fromLTRB(15 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360),
                  0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360)),
            ),
            autovalidateMode: AutovalidateMode.onUserInteraction,
            validator: (value) {
              value = value?.trim();
              if(value == null || value.isEmpty) {
                return "카테고리는 필수 선택값입니다.";
              }
              return null;
            },
            //isDense : true,
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
            items: mainCategory.map((privatelessonVO item) =>
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
              this._selectedValue = value;
            }),
          )
      ),
    );
  }

  Container passport(BuildContext context) {
    return Container(
        width: 360 * (MediaQuery.of(context).size.width / 360),
        // height: 50 * (MediaQuery.of(context).size.height / 360),
        margin : EdgeInsets.fromLTRB(15 * (MediaQuery.of(context).size.width / 360), 2 * (MediaQuery.of(context).size.height / 360),
            15 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360)),
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
              GestureDetector(
                child : Container(
                  width: 350 * (MediaQuery.of(context).size.width / 360),
                  height: 50 * (MediaQuery.of(context).size.height / 360),
                  margin : EdgeInsets.fromLTRB(0 * (MediaQuery.of(context).size.width / 360), 5 * (MediaQuery.of(context).size.height / 360),
                      0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if(filePath == "")
                      Container(
                        height: 20 * (MediaQuery.of(context).size.height / 360),
                        child: Image(image: AssetImage("assets/passport_icon.png"), width: 30 * (MediaQuery.of(context).size.width / 360),),
                      ),
                      if(filePath == "")
                      Container(
                        height: 15 * (MediaQuery.of(context).size.height / 360),
                        margin : EdgeInsets.fromLTRB(0 * (MediaQuery.of(context).size.width / 360), 3 * (MediaQuery.of(context).size.height / 360),
                            0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360)),
                        child: Text("여권 사진 첨부", style: TextStyle(fontSize: 20, color: Color.fromRGBO(228, 116, 33, 1), fontWeight: FontWeight.w700),),
                      ),
                      if(filePath != "")
                        Container(
                            // height: 10 * (MediaQuery.of(context).size.height / 360),
                            child : Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text("${filePath.split('/').last}", style: TextStyle(fontSize: 14, color: Color(0xff151515), fontWeight: FontWeight.w400), textAlign: TextAlign.center, ),
                                IconButton(
                                    padding: EdgeInsets.zero,
                                    constraints: BoxConstraints(),
                                    icon: Icon(Icons.close, color: Color(0xffEB5757), size : 15),
                                    onPressed: () {
                                      setState(() {
                                        filePath = "";
                                      });
                                    }
                                )
                              ],
                            )
                        )
                    ],
                  ),
                ),
                onTap: () async {
                  _openFilePicker();
                },
              ),
            ],
          ),
        )
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
                      barrierColor: Color(0xffE47421).withOpacity(0.4),
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
                                              barrierColor: Color(0xffE47421).withOpacity(0.4),
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

    final List<MultipartFile> _files =
    _pickedImgs.map(
            (img) => MultipartFile.fromFileSync(img.path,  contentType: new MediaType("image", "jpg"))
    ).toList();

    FormData _formData = FormData.fromMap(
        {
        }
    );

    var ipAddress = IpAddress(type: RequestType.json);
    dynamic data = await ipAddress.getIpAddress();

    // Create storage
    final storage = FlutterSecureStorage();
    String? reg_id = await storage.read(key: "memberId");
    String? nickname = await storage.read(key: "memberNick");
    String? reg_nm = await storage.read(key: "memberNick");

    if(selectedFile == null) {
      _formData = FormData.fromMap(
          {
            "attach": _files,
            "title": _titleController.text,
            "cat02" : "E201",
            "conts": _descriptionController.text,
            "etc01": _priceController.text,
            "etc02": _telController.text,
            "main_category": _selectedValue,
            "board_seq": "16",
            "session_ip": data["ip"].toString(),
            "session_member_id": reg_id,
            "session_member_nm": reg_nm,
            "table_nm": "PERSONAL_LESSON"
          }
      );
    }

    if(selectedFile != null) {
      _formData = FormData.fromMap(
          {
            "attach": _files,
            "attach2": await MultipartFile.fromFile(
              selectedFile!.path,
              filename: selectedFile!
                  .path
                  .split('/')
                  .last,
            ),
            "cat02" : "E201",
            "title": _titleController.text,
            "conts": _descriptionController.text,
            "etc01": _priceController.text,
            "etc02": _telController.text,
            "main_category": _selectedValue,
            "board_seq": "16",
            "session_ip": data["ip"].toString(),
            "session_member_id": reg_id,
            "session_member_nm": reg_nm,
            "table_nm": "PERSONAL_LESSON"
          }
      );
    }

    Dio dio = Dio();

    dio.options.contentType = "multipart/form-data";

    final res = await dio.post("http://www.hoty.company/mf/community/write.do", data: _formData).then((res) {
    /*final res = await dio.post("http://www.hoty.company/mf/community/write.do", data: _formData).then((res) {*/
      return res.data;
    });

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
    }).then((value) {
      if(value == 'view') {
        Navigator.pop(context);
        Navigator.push(context, MaterialPageRoute(
          builder: (context) {
            return Profile_my_post(table_nm : 'PERSONAL_LESSON', category: 'PERSONAL_LESSON',);
          },
        ));
      }
      if(value == 'list') {
        Navigator.pop(context);
        Navigator.push(context, MaterialPageRoute(
          builder: (context) {
            return LessonList(checkList: [],);
          },
        ));
      }
    });
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

