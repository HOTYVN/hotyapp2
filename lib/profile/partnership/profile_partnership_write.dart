
import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_ip_address/get_ip_address.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';

import '../../common/dialog/commonAlert.dart';
import '../../common/footer.dart';
import '../../main/main_page.dart';
import '../../service/model/serviceVO.dart';
import '../../service/providers/service_provider.dart';
import '../profile_main.dart';

class ProfilePartnershipWrite extends StatefulWidget{
  const ProfilePartnershipWrite({super.key});

  @override
  State<ProfilePartnershipWrite> createState() => _ProfilePartnershipWriteState();
}

class _ProfilePartnershipWriteState extends State<ProfilePartnershipWrite> {
  final storage = FlutterSecureStorage();
  String? reg_id;

  final _formKey = GlobalKey<FormState>();

  int click_check = 1;

  List<serviceVO> phoneNumberCategory = [];
  String? _phoneNumberCategoryValue ;
  serviceProvider mainCategoryProvider = serviceProvider();

  List<dynamic> _catList = [];
  String? _selectRadioValue ;

  bool _isCheck1 = false;

  final TextEditingController _title = TextEditingController();
  final TextEditingController _descript = TextEditingController();
  final TextEditingController _company = TextEditingController();
  final TextEditingController _name = TextEditingController();
  final TextEditingController _position = TextEditingController();
  final TextEditingController _phone = TextEditingController();
  final TextEditingController _email = TextEditingController();

  late FocusNode titleNode;
  late FocusNode descriptNode;
  late FocusNode companyNode;
  late FocusNode nameNode;
  late FocusNode positionNode;
  late FocusNode phoneNode;
  late FocusNode emailNode;

  List<dynamic> coderesult = []; // 공통코드 리스트
  List<String> dropdown = [];

  final ImagePicker _picker = ImagePicker();
  List<XFile> _pickedImgs = [];

  bool _visibility1 = true;
  bool _visibility2 = false;

  Future<void> _getCatList() async {
    final url = Uri.parse('http://www.hoty.company/mf/member/getCatList.do');
    //final url = Uri.parse('http://192.168.0.176:8080/mf/member/getCatList.do');
    final storage = FlutterSecureStorage();
    String? reg_id = await storage.read(key: "memberId");
    try {
      Map data = {
        "board_seq" : "19",
      };
      var body = json.encode(data);

      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: body,
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> responseData = json.decode(response.body);
        setState(() {
          _catList = responseData['result']['getCatList'];
        });
      } else {
        print('Status Code: ${response.statusCode}');
      }
    } catch (error) {
      print('Error: $error');
    }
  }

  Future initphoneNumberCategory() async {
    phoneNumberCategory = await mainCategoryProvider.getphoneNumberCategory();
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

  @override
  void initState() {
    super.initState();

    titleNode = FocusNode();
    descriptNode = FocusNode();
    companyNode = FocusNode();
    nameNode = FocusNode();
    positionNode = FocusNode();
    phoneNode = FocusNode();
    emailNode = FocusNode();

    _getCatList();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _asyncMethod();
      /*getcodedata();*/
    });
    initphoneNumberCategory().then((_) {
      setState(() {
        _phoneNumberCategoryValue = "84";
      });
    });
  }

  @override
  void dispose() {
    titleNode.dispose();
    descriptNode.dispose();
    companyNode.dispose();
    nameNode.dispose();
    positionNode.dispose();
    phoneNode.dispose();
    emailNode.dispose();
    super.dispose();
  }

  Future<dynamic> _asyncMethod() async {
    reg_id = await storage.read(key:'memberId');
    return true;
  }

  Future<void> writePartnership() async {

    final List<MultipartFile> _files =
    _pickedImgs.map(
            (img) => MultipartFile.fromFileSync(img.path,  contentType: new MediaType("image", "jpg"))
    ).toList();

    var ipAddress = IpAddress(type: RequestType.json);
    dynamic data = await ipAddress.getIpAddress();

    // Create storage
    final storage = FlutterSecureStorage();
    String? reg_id = await storage.read(key: "memberId");
    String? nickname = await storage.read(key: "memberNick");
    String? reg_nm = await storage.read(key: "memberNick");

    FormData formData = FormData.fromMap(
        {
          "attach" : _files,
          "title" : _title.text,
          "conts" : _descript.text,
          "etc04" : _phone.text,
          "etc05" : _email.text,
          "cat" : _selectRadioValue,
          "etc01" : _company.text,
          "etc02" : _name.text,
          "etc03" : _position.text,
          "board_seq" : "19",
          "session_ip" : data["ip"].toString(),
          "session_member_id" : reg_id,
          "session_member_nm" : reg_nm,
          "table_nm" : "MC_ARTICLE"
        }
    );

    Dio dio = Dio();

    dio.options.contentType = "multipart/form-data";

    final res = await dio.post("http://www.hoty.company/mf/community/write.do", data: formData).then((res) {
      return res.data;
    });
  }

  /*Future<dynamic> getcodedata() async {
    var url = Uri.parse(
      'http://www.hoty.company/mf/common/commonCode.do',
    );
    try {
      Map data = {
        "pidx": "TEL",
      };
      var body = json.encode(data);
      var response = await http.post(
          url,
          headers: {"Content-Type": "application/json"},
          body: body
      );

      if (response.statusCode == 200) {
        coderesult = json.decode(response.body)['result'];
        for (var i in coderesult) {
          setState(() {
            dropdown.add(i['val'].toString());
          });
        }
        print(dropdown);
      }
    }
    catch(e){
      print(e);
    }
  }*/

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap : () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        appBar: AppBar(
          titleSpacing: 5,
          leadingWidth: 40,
          backgroundColor: Colors.white,
          elevation: 0,
          automaticallyImplyLeading: true,
          leading: IconButton(
            padding: EdgeInsets.fromLTRB(12, 0, 0, 0),
            icon: Icon(Icons.arrow_back_rounded),
            iconSize: 12 * (MediaQuery.of(context).size.height / 360),
            color: Colors.black,
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
          title: Container(
            padding : EdgeInsets.fromLTRB(0 * (MediaQuery.of(context).size.width / 360), 1 * (MediaQuery.of(context).size.height / 360),
                0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360)),
            child: Text(
              "제휴문의",
              style: TextStyle(
                fontSize: 16 * (MediaQuery.of(context).size.width / 360),
                color: Color(0xff151515),
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
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    Container(
                        margin : EdgeInsets.fromLTRB(15 * (MediaQuery.of(context).size.width / 360), 5 * (MediaQuery.of(context).size.height / 360),
                            15 * (MediaQuery.of(context).size.width / 360), 5 * (MediaQuery.of(context).size.height / 360)),
                        width: 350 * (MediaQuery.of(context).size.width / 360),
                        child : Text("제휴 제안 신청 하기", style: TextStyle(
                            fontSize: 16 * (MediaQuery.of(context).size.width / 360),
                            fontWeight: FontWeight.bold
                        ),
                        )
                    ),
                    Container(
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
                        controller: _title,
                        focusNode : titleNode,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          contentPadding : EdgeInsets.fromLTRB(15 * (MediaQuery.of(context).size.width / 360), 3 * (MediaQuery.of(context).size.height / 360), 0, 0),
                         /* enabledBorder: OutlineInputBorder(
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
                            return "제목을 입력해주세요";
                          }
                          return null;
                        },
                        style: TextStyle(fontFamily: ''),
                      ),
                    ),
                    Container(
                      width: 360 * (MediaQuery.of(context).size.width / 360),
                      height: 80 * (MediaQuery.of(context).size.height / 360),
                      margin : EdgeInsets.fromLTRB(15 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360),
                          15 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360)),
                      padding : EdgeInsets.fromLTRB(5 * (MediaQuery.of(context).size.height / 360), 5 * (MediaQuery.of(context).size.height / 360),
                          0 * (MediaQuery.of(context).size.height / 360), 0 * (MediaQuery.of(context).size.height / 360)),
                      decoration: BoxDecoration(
                        border: Border.all(
                            color: Color.fromRGBO(243, 246, 248, 1)
                        ),
                        borderRadius: BorderRadius.circular(3 * (MediaQuery.of(context).size.height / 360)),
                        color: Color.fromRGBO(255, 255, 255, 1),
                      ),
                      child: TextFormField(
                        controller: _descript,
                        focusNode: descriptNode,
                        maxLines: 5,
                        minLines: 5,
                        decoration: InputDecoration(
                          contentPadding : EdgeInsets.fromLTRB(5 * (MediaQuery.of(context).size.width / 360), 3 * (MediaQuery.of(context).size.height / 360), 0, 0),
                          border: InputBorder.none,
                       /*   enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(5)),
                            borderSide: BorderSide(
                              color: Color.fromRGBO(255, 255, 255, 1),
                            ),
                          ),*/
                          // labelText: 'Search',
                          hintText: '내용',
                          hintStyle: TextStyle(color:Color(0xffC4CCD0),),
                        ),
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: (value) {
                          value = value?.trim();
                          if(value == null || value.isEmpty) {
                            if(_title.text != null && _title.text != '') {
                              descriptNode.requestFocus();
                            }
                            return "내용을 입력해주세요";
                          }
                          return null;
                        },
                        style: TextStyle(fontFamily: ''),
                      ),
                    ),
                    upload(context),
                    Container(
                        margin : EdgeInsets.fromLTRB(15 * (MediaQuery.of(context).size.width / 360), 5 * (MediaQuery.of(context).size.height / 360),
                            15 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360)),
                        width: 350 * (MediaQuery.of(context).size.width / 360),
                        child : Text("제휴제안 업체정보", style: TextStyle(
                            fontSize: 16 * (MediaQuery.of(context).size.width / 360),
                            fontWeight: FontWeight.bold
                        ),
                        )
                    ),
                    Row(
                      children: [

                      for(int i=0; i<_catList.length; i++)
                        Container(
                          width: 120 * (MediaQuery.of(context).size.width / 360),
                          // height: 15 * (MediaQuery.of(context).size.height / 360),
                          padding: EdgeInsets.fromLTRB(
                            4 * (MediaQuery.of(context).size.width / 360),
                            0 * (MediaQuery.of(context).size.height / 360),
                            0 * (MediaQuery.of(context).size.width / 360),
                            0 * (MediaQuery.of(context).size.height / 360),
                          ),
                          alignment: Alignment.centerLeft,
                          child: RadioListTile<String>(
                            contentPadding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                            controlAffinity: ListTileControlAffinity.leading,
                            title: Transform.translate(
                              offset: const Offset(-15, 0),
                              child: Text(
                                _catList[i]['CAT_NM'].toString(),
                                style: TextStyle(
                                  color: Color(0xff151515),
                                  fontSize: 13 * (MediaQuery.of(context).size.width / 360),
                                ),
                              ),
                            ),
                            value: _catList[i]['BOARD_CAT_SEQ'].toString(),
                            // checkColor: Colors.white,
                            activeColor: Color(0xffE47421),
                            groupValue: _selectRadioValue,
                            onChanged: (String? value) {
                              setState(() {
                                _selectRadioValue = value;
                              });
                            },
                          ),
                        ),
                    ],
                  ),
                  Container(
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
                      controller: _company,
                      focusNode : companyNode,
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
                        hintText: '회사명',
                        hintStyle: TextStyle(color:Color(0xffC4CCD0),),
                      ),
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (value) {
                        value = value?.trim();
                        if(value == null || value.isEmpty) {
                          if(_title.text != null && _title.text != '' && _descript.text != null && _descript.text != '') {
                            companyNode.requestFocus();
                          }
                          return "회사명을 입력해주세요.";
                        }
                        return null;
                      },
                      style: TextStyle(fontFamily: ''),
                    ),
                  ),


                  Container(
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
                      controller: _name,
                      focusNode : nameNode,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        contentPadding : EdgeInsets.fromLTRB(15 * (MediaQuery.of(context).size.width / 360), 3 * (MediaQuery.of(context).size.height / 360), 0, 0),
                        // labelText: 'Search',
                        hintText: '담당자 성함',
                        hintStyle: TextStyle(color:Color(0xffC4CCD0),),
                      ),
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (value) {
                        value = value?.trim();
                        if(value == null || value.isEmpty) {
                          if(_title.text != null && _title.text != '' && _descript.text != null && _descript.text != '' && _company.text != null && _company.text != '') {
                            nameNode.requestFocus();
                          }
                          return "담당자 성함은 필수값 입니다.";
                        }
                        return null;
                      },
                      style: TextStyle(fontFamily: ''),
                    ),
                  ),

                  Container(
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
                      controller: _position,
                      focusNode: positionNode,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        contentPadding : EdgeInsets.fromLTRB(15 * (MediaQuery.of(context).size.width / 360), 3 * (MediaQuery.of(context).size.height / 360), 0, 0),
                        // labelText: 'Search',
                        hintText: '담당자 직함',
                        hintStyle: TextStyle(color:Color(0xffC4CCD0),),
                      ),
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (value) {
                        value = value?.trim();
                        if(value == null || value.isEmpty) {
                          if(_title.text != null && _title.text != '' && _descript.text != null && _descript.text != '' && _company.text != null && _company.text != '' && _name.text != null && _name.text != '') {
                            positionNode.requestFocus();
                          }
                          return "담당자 직함은 필수 값 입니다.";
                        }
                        return null;
                      },
                      style: TextStyle(fontFamily: ''),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.fromLTRB(
                      15 * (MediaQuery.of(context).size.width / 360),
                      0 * (MediaQuery.of(context).size.height / 360),
                      0 * (MediaQuery.of(context).size.width / 360),
                      0 * (MediaQuery.of(context).size.height / 360),
                    ),
                    child: Row(
                      children: [
                        Container(
                          margin : EdgeInsets.fromLTRB(0 * (MediaQuery.of(context).size.width / 360), 5 * (MediaQuery.of(context).size.height / 360),
                              0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360)),
                          width: 140 * (MediaQuery.of(context).size.width / 360),
                          height: 25 * (MediaQuery.of(context).size.height / 360),
                          decoration: BoxDecoration(
                            border: Border.all(
                                color: Color.fromRGBO(243, 246, 248, 1)
                            ),
                            borderRadius: BorderRadius.circular(3 * (MediaQuery.of(context).size.height / 360)),
                            color: Color.fromRGBO(255, 255, 255, 1),
                          ),
                          child: DropdownButtonFormField(
                            icon: const Icon(Icons.keyboard_arrow_down_rounded),
                            isExpanded: true,
                            hint: Text("+84", style: TextStyle(fontSize: 14 * (MediaQuery.of(context).size.width / 360), color: Color(0xff151515), fontWeight: FontWeight.w500),),
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              fillColor: Color(0xffFFFFFF),
                              /*enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.all(Radius.circular(3)),
                                borderSide: BorderSide(
                                  color:Color(0xffFFFFFF),
                                ),
                              ),*/
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.all(Radius.circular(3)),
                                borderSide: BorderSide(
                                  color:Color(0xffFFFFFF),
                                ),
                              ),
                              contentPadding : EdgeInsets.fromLTRB(15 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360), 0, 0),
                            ),
                            padding: EdgeInsets.fromLTRB(0 * (MediaQuery.of(context).size.width / 360), 2 * (MediaQuery.of(context).size.height / 360), 0, 0),
                            items: phoneNumberCategory.map((serviceVO item) => DropdownMenuItem(value: item.idx,child: Text(item.name),),)
                                .toList(),
                            onChanged: (String? value) => setState(() {
                              this._phoneNumberCategoryValue = value;
                              setState(() {

                              });
                            }),
                            value : _phoneNumberCategoryValue,
                            autovalidateMode: AutovalidateMode.onUserInteraction,
                            validator: (value) {
                              value = value?.trim();
                              if(value == null || value.isEmpty) {
                                return "전화번호를 입력해주세요";
                              }
                              return null;
                            },
                          ),
                        ),
                        Container(
                          margin : EdgeInsets.fromLTRB(15 * (MediaQuery.of(context).size.width / 360), 5 * (MediaQuery.of(context).size.height / 360),
                              15 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360)),
                          width: 175 * (MediaQuery.of(context).size.width / 360),
                          height: 25 * (MediaQuery.of(context).size.height / 360),
                          decoration: BoxDecoration(
                            border: Border.all(
                                color: Color.fromRGBO(243, 246, 248, 1)
                            ),
                            borderRadius: BorderRadius.circular(3 * (MediaQuery.of(context).size.height / 360)),
                            color: Color.fromRGBO(255, 255, 255, 1),
                          ),
                          child: TextFormField(
                            controller: _phone,
                            focusNode: phoneNode,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                            ],
                            style: TextStyle(
                              fontSize: 15 * (MediaQuery.of(context).size.width / 360),
                              color: Colors.black,
                            ),
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              contentPadding : EdgeInsets.fromLTRB(15 * (MediaQuery.of(context).size.width / 360), 3 * (MediaQuery.of(context).size.height / 360), 0, 0),
                              hintText: '전화번호',
                              hintStyle: TextStyle(color:Color(0xffC4CCD0),),
                            ),
                            autovalidateMode: AutovalidateMode.onUserInteraction,
                            validator: (value) {
                              value = value?.trim();
                              if(value == null || value.isEmpty) {
                                if(_title.text != null && _title.text != '' && _descript.text != null && _descript.text != '' && _company.text != null && _company.text != '' && _name.text != null && _name.text != '' && _position.text != null && _position.text != '') {
                                  phoneNode.requestFocus();
                                }
                                return "전화번호는 필수 값 입니다.";
                              }
                              return null;
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
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
                      controller: _email,
                      focusNode: emailNode,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        contentPadding : EdgeInsets.fromLTRB(15 * (MediaQuery.of(context).size.width / 360), 3 * (MediaQuery.of(context).size.height / 360), 0, 0),
                        // labelText: 'Search',
                        hintText: '이메일',
                        hintStyle: TextStyle(color:Color(0xffC4CCD0),),
                      ),
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (value) {
                        value = value?.trim();
                        if(value == null || value.isEmpty) {
                          if(_title.text != null && _title.text != '' && _descript.text != null && _descript.text != '' && _company.text != null && _company.text != '' && _name.text != null && _name.text != '' && _position.text != null && _position.text != '' && _phone.text != null && _phone.text != '') {
                            emailNode.requestFocus();
                          }
                          return "이메일은 필수 값 입니다.";
                        }
                        return null;
                      },
                      style: TextStyle(fontFamily: ''),
                    ),
                  ),
                  Container(
                    width: 330 * (MediaQuery.of(context).size.width / 360),
                    // height: 158 * (MediaQuery.of(context).size.height / 360),
                    margin: EdgeInsets.fromLTRB(
                      0 * (MediaQuery.of(context).size.width / 360),
                      10 * (MediaQuery.of(context).size.height / 360),
                      0 * (MediaQuery.of(context).size.width / 360),
                      10 * (MediaQuery.of(context).size.height / 360),
                    ),
                    padding: EdgeInsets.fromLTRB(
                      0 * (MediaQuery.of(context).size.width / 360),
                      5 * (MediaQuery.of(context).size.height / 360),
                      0 * (MediaQuery.of(context).size.width / 360),
                      0 * (MediaQuery.of(context).size.height / 360),
                    ),
                    decoration: BoxDecoration(
                      color: Color(0xffF3F6F8),
                      borderRadius: BorderRadius.circular(13.0),
                    ),
                    child: Column(
                      children: [
                        Container(
                          alignment: Alignment.centerLeft,
                          padding: EdgeInsets.fromLTRB(
                            13 * (MediaQuery.of(context).size.width / 360),
                            3 * (MediaQuery.of(context).size.height / 360),
                            0 * (MediaQuery.of(context).size.width / 360),
                            0 * (MediaQuery.of(context).size.height / 360),
                          ),
                          child: Text(
                            '개인정보수집 이용동의',
                            style: TextStyle(
                              fontSize: 15 * (MediaQuery.of(context).size.width / 360),
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Container(

                          padding: EdgeInsets.fromLTRB(
                            15 * (MediaQuery.of(context).size.width / 360),
                            6 * (MediaQuery.of(context).size.height / 360),
                            10 * (MediaQuery.of(context).size.width / 360),
                            0 * (MediaQuery.of(context).size.height / 360),
                          ),
                          child: Text(
                              "1. 목적 : 제휴 제안에 따른 연락처 정보 확인\n"
                              "2. 항목 : 회사(기관)명,제안자명,전화번호,메일주소\n"
                              "3. 보유기간 : 제휴 제안 사항 상담서비스를 위해 제안\n 등록 후 90일간 보관하며,이후 해당 정보를 지체 없이\n파기합니다.\n"
                              "단, 제휴 제안의 기각 및 거절시에는 해당 정보는 즉시 파기합니다.\n"
                              "위 정보 수집에 대한 동의를 거부할 권리가 있으며, 동의\n거부 시에는 제휴 제안 접수가 제한될 수 있습니다. \n"
                              "더 자세한 내용에 대해서는 HOTY 고객센터를 참고하시길\n바랍니다."
                            ,
                            style: TextStyle(
                              fontSize: 13 * (MediaQuery.of(context).size.width / 360),
                              color: Color(0xff4E4E4E),
                              height: 0.8 * (MediaQuery.of(context).size.height / 360)
                            ),
                            textAlign: TextAlign.left,
                          )
                        ),
                        Container(
                          padding: EdgeInsets.fromLTRB(
                            3 * (MediaQuery.of(context).size.width / 360),
                            1 * (MediaQuery.of(context).size.height / 360),
                            0 * (MediaQuery.of(context).size.width / 360),
                            1 * (MediaQuery.of(context).size.height / 360),
                          ),
                          child: Row(
                            children: [
                              Checkbox(
                                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                side: BorderSide(
                                  color: Color(0xffC4CCD0),
                                  width: 2,
                                ),
                                value: _isCheck1,
                                checkColor: Colors.white,
                                activeColor: Colors.orange,
                                onChanged: (value) {
                                  setState(() {
                                    _isCheck1 = value!;
                                  });
                                },
                              ),
                              Text(
                                "동의",
                                style: TextStyle(
                                  fontSize: 14 * (MediaQuery.of(context).size.width / 360),
                                  color: Color(0xff151515),
                                ),
                                textAlign: TextAlign.left,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: 350 * (MediaQuery.of(context).size.width / 360),
                    margin: EdgeInsets.fromLTRB(15 * (MediaQuery.of(context).size.width / 360),0,
                        15 * (MediaQuery.of(context).size.width / 360),
                        10),
                    height: 27 * (MediaQuery.of(context).size.height / 360),
                    child:
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Color.fromRGBO(228, 116, 33, 1),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(3 * (MediaQuery.of(context).size.height / 360))
                          )
                      ),
                      onPressed: (){
                        fail_dialog();
                      },
                      child: (
                          Text("제휴 제안 신청 하기", style: TextStyle(fontSize: 18 * (MediaQuery.of(context).size.width / 360) ,
                              fontWeight: FontWeight.w800 , color:Color.fromRGBO(255,255,255,1)),)
                      ),
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
            )
          ],
        ),
      ),
      extendBody: true,
bottomNavigationBar: Footer(nowPage: ''),

      ),
    );

  }

  Container upload(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          Visibility(visible: _visibility1,child:
            Container(
              width: 360 * (MediaQuery.of(context).size.width / 360),
              height: 75 * (MediaQuery.of(context).size.height / 360),
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
                          // height: 35 * (MediaQuery.of(context).size.height / 360),
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
                                margin: EdgeInsets.fromLTRB(0, 3 * (MediaQuery.of(context).size.height / 360), 0, 3 * (MediaQuery.of(context).size.height / 360),),
                                // height: 10 * (MediaQuery.of(context).size.height / 360),
                                child: Text("파일첨부", style: TextStyle(fontSize: 14 * (MediaQuery.of(context).size.width / 360), fontWeight: FontWeight.w500,color: Color.fromRGBO(228, 116, 33, 1)),),
                              ),
                            ],
                          ),
                        ),
                        Container(
                            // height: 20 * (MediaQuery.of(context).size.height / 360),
                            // child : Text("5MB를 초과하지 않는 파일을\n첨부해주세요.", style: TextStyle(fontSize: 14, color: Color(0xff151515), fontWeight: FontWeight.w400), textAlign: TextAlign.center, )
                          child : Text("5MB를 초과하지 않는 파일을\n첨부해주세요.",
                            style: TextStyle(
                              fontSize: 12 * (MediaQuery.of(context).size.width / 360),
                              color: Color(0xff151515),
                              fontWeight: FontWeight.w400,
                              height: 0.7 * (MediaQuery.of(context).size.height / 360),
                            ),
                            textAlign: TextAlign.center, )
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
                  15 * (MediaQuery.of(context).size.width / 360), 5 * (MediaQuery.of(context).size.height / 360)),
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
      )
    );
  }

  void success_dialog(){
    showDialog(
      barrierDismissible: false,
      barrierColor: Color(0xffE47421).withOpacity(0.4),
      context: context,
      builder: (BuildContext context) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
          child: textalert2(context,'등록이 완료되었습니다.'),
        );
        return AlertDialog(
          insetPadding: EdgeInsets.all(15),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(13.0),
          ),
          content: Container(
            width: 350 * (MediaQuery.of(context).size.width / 360),
            height: 82 * (MediaQuery.of(context).size.height / 360),
            padding: EdgeInsets.fromLTRB(
              0 * (MediaQuery.of(context).size.width / 360),
              10 * (MediaQuery.of(context).size.height / 360),
              0 * (MediaQuery.of(context).size.width / 360),
              0 * (MediaQuery.of(context).size.height / 360),
            ),
            margin: EdgeInsets.fromLTRB(
              0 * (MediaQuery.of(context).size.width / 360),
              0 * (MediaQuery.of(context).size.height / 360),
              0 * (MediaQuery.of(context).size.width / 360),
              0 * (MediaQuery.of(context).size.height / 360),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                  margin: EdgeInsets.fromLTRB(
                    0 * (MediaQuery.of(context).size.width / 360),
                    0 * (MediaQuery.of(context).size.height / 360),
                    0 * (MediaQuery.of(context).size.width / 360),
                    0 * (MediaQuery.of(context).size.height / 360),
                  ),
                  child: Text(
                    "등록이 완료되었습니다.",
                    style: TextStyle(
                      fontSize: 26 * (MediaQuery.of(context).size.width / 360),
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                Container(
                  padding: EdgeInsets.fromLTRB(
                    10 * (MediaQuery.of(context).size.width / 360),
                    15 * (MediaQuery.of(context).size.height / 360),
                    10 * (MediaQuery.of(context).size.width / 360),
                    0 * (MediaQuery.of(context).size.height / 360),
                  ),
                  child: Container(
                    width: 130 * (MediaQuery.of(context).size.width / 360),
                    height: 30 * (MediaQuery.of(context).size.height / 360),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(13.0),
                      color: Color(0xffE47421),
                    ),
                    child: TextButton(
                      onPressed: (){
                        Navigator.push(context, MaterialPageRoute(
                          builder: (context) {
                            return Profile_main();
                          },
                        ));
                      },
                      child: Center(
                        child: Text(
                          "닫기",
                          style: TextStyle(
                            fontSize: 17 * (MediaQuery.of(context).size.width / 360),
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            // height: 1.5 * (MediaQuery.of(context).size.width / 360),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    ).then((value) {
      Navigator.push(context, MaterialPageRoute(
        builder: (context) {
          return Profile_main();
        },
      ));
    });
  }
  void fail_dialog(){
    showDialog(
      barrierDismissible: false,
      barrierColor: Color(0xffE47421).withOpacity(0.4),
      context: context,
      builder: (BuildContext context) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
          child: deletechecktext2(context,'정확하게 작성하셨는지 \n제안 내용을 한번 더 확인해주세요', '돌아가기', '신청하기'),
        );
      },
    ).then((value) {
      if(value == true) {
        if(_formKey.currentState!.validate()) {
          if(click_check == 1) {
            setState(() {
              click_check = 0;
            });
            writePartnership().then((value) => success_dialog());
          }
        }
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

