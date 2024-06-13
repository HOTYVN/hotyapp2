import 'package:dio/dio.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_ip_address/get_ip_address.dart';
import 'package:hoty/common/footer.dart';
import 'package:hoty/counseling/counseling_guide.dart';
import 'package:hoty/main/main_page.dart';
import 'package:hoty/service/model/serviceVO.dart';
import 'package:hoty/service/providers/service_provider.dart';
import 'package:hoty/service/service_guide.dart';
import 'package:hoty/service/service_time.dart';

import '../common/dialog/loginAlert.dart';
import '../common/dialog/showDialog_modal.dart';
import '../login/login.dart';

class CounselingWrite extends StatefulWidget {
  final List<String> checkList;
  final String table_nm;
  final List<String> interiorList;

  const CounselingWrite({Key? key,
    required this.checkList,
    required this.table_nm,
    required this.interiorList,
  }) : super(key:key);

  @override
  State<CounselingWrite> createState() => _CounselingWriteState();

}

class _CounselingWriteState extends State<CounselingWrite> {
  final now = DateTime.now();

  final _formKey = GlobalKey<FormState>();

  int click_check = 1;

  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _TimeController = TextEditingController();
  final _contsController = TextEditingController();

  late FocusNode nameNode;
  late FocusNode phoneNode;
  late FocusNode timeNode;
  late FocusNode contsNode;

  String? _phoneNumberCategoryValue ;

  List<serviceVO> phoneNumberCategory = [];

  serviceProvider mainCategoryProvider = serviceProvider();
  String member_id = "";

  Future initphoneNumberCategory() async {
    phoneNumberCategory = await mainCategoryProvider.getphoneNumberCategory();
  }

  static final storage = FlutterSecureStorage();
  _asyncMethod() async {
    // read 함수로 key값에 맞는 정보를 불러오고 데이터타입은 String 타입
    // 데이터가 없을때는 null을 반환
    member_id = (await storage.read(key:'memberId')) ?? "";
    _nameController.text = (await storage.read(key:'memberNm')) ?? "";
    print("#############################################");
    print(member_id);
  }

  @override
  void initState() {
    super.initState();

    nameNode = FocusNode();
    phoneNode = FocusNode();
    timeNode = FocusNode();
    contsNode = FocusNode();

    _phoneNumberCategoryValue = "84";
    _asyncMethod();
    initphoneNumberCategory().then((_) {
      setState(() {
        print(widget.interiorList);
        print(widget.checkList);
      });
    });
  }

  @override
  void dispose() {
    nameNode.dispose();
    phoneNode.dispose();
    timeNode.dispose();
    contsNode.dispose();
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
            title: Container(
              padding : EdgeInsets.fromLTRB(0 * (MediaQuery.of(context).size.width / 360), 1 * (MediaQuery.of(context).size.height / 360),
                  0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360)),
              //width: 80 * (MediaQuery.of(context).size.width / 360),
              //height: 80 * (MediaQuery.of(context).size.height / 360),
              /*child: Image(image: AssetImage('assets/logo.png')),*/
              child: Text("부동산 상담신청" , style: TextStyle(fontSize: 17,  color: Colors.black, fontWeight: FontWeight.bold,),
              ),
            ),
            //centerTitle: true,
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                Form(
                    key: _formKey,
                    child : Column (
                      children: [
                        Name(context),
                        phoneNumber(context),
                        time(context),
                        conts(context),
                      ],
                    )
                ),
                Announcement(context),
                apply(context)
              ],
            ),
          ),
          extendBody: true,
bottomNavigationBar: Footer(nowPage: ''),
      ),
    );
  }
  Container Name(BuildContext context) {
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
        child: TextFormField(
          controller: _nameController,
          focusNode: nameNode,
          decoration: InputDecoration(
            contentPadding : EdgeInsets.fromLTRB(15 * (MediaQuery.of(context).size.width / 360), 0, 0, 0),
            border: InputBorder.none,

            // labelText: 'Search',
            hintText: '이름',
            hintStyle: TextStyle(color:Color(0xffC4CCD0),),
          ),
          autovalidateMode: AutovalidateMode.onUserInteraction,
          validator: (value) {
            value = value?.trim();
            if(value == null || value.isEmpty) {
              nameNode.requestFocus();
              return "이름을 입력해주세요.";
            }
            return null;
          },
          style: TextStyle(fontFamily: ''),
        ),
    );
  }
  Container phoneNumber(BuildContext context) {
    return Container(
        width: 360 * (MediaQuery.of(context).size.width / 360),
        height: 25 * (MediaQuery.of(context).size.height / 360),
        margin : EdgeInsets.fromLTRB(15 * (MediaQuery.of(context).size.width / 360), 5 * (MediaQuery.of(context).size.height / 360),
            15 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360)),

        child: Row(
          children: [
            Container(
              width: 120 * (MediaQuery.of(context).size.width / 360),
              height: 25 * (MediaQuery.of(context).size.height / 360),
              decoration: BoxDecoration(
                border: Border.all(
                    color: Color.fromRGBO(243, 246, 248, 1)
                ),
                borderRadius: BorderRadius.circular(3 * (MediaQuery.of(context).size.height / 360)),
                color: Color.fromRGBO(255, 255, 255, 1),
              ),
              child: DropdownButtonHideUnderline(
                  child : DropdownButtonFormField2(
                    isExpanded: true,
                    value: _phoneNumberCategoryValue,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.fromLTRB(15 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360),
                          0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360)),
                    ),
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (value) {
                      value = value?.trim();
                      if(value == null || value.isEmpty) {
                        return "전화번호를 입력해주세요.";
                      }
                      return null;
                    },
                    //isDense : true,
                    hint: Text("+84", style: TextStyle(fontSize: 14 * (MediaQuery.of(context).size.width / 360), color: Color(0xffC4CCD0)),),
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
                      return phoneNumberCategory.map<Widget>((item) {
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
                    items: phoneNumberCategory.map((serviceVO  item) =>
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
                      this._phoneNumberCategoryValue = value;
                    }),
                  )
              ),
            ),
            SizedBox(width: 10 * (MediaQuery.of(context).size.width / 360)),
            Container(
              width: 200 * (MediaQuery.of(context).size.width / 360),
              height: 25 * (MediaQuery.of(context).size.height / 360),
              /*padding : EdgeInsets.fromLTRB(10 * (MediaQuery.of(context).size.height / 360), 7 * (MediaQuery.of(context).size.height / 360),
                        3 * (MediaQuery.of(context).size.height / 360), 0 * (MediaQuery.of(context).size.height / 360)),*/
              decoration: BoxDecoration(
                border: Border.all(
                    color: Color.fromRGBO(243, 246, 248, 1)
                ),
                borderRadius: BorderRadius.circular(3 * (MediaQuery.of(context).size.height / 360)),
                color: Color.fromRGBO(255, 255, 255, 1),
              ),
              child: TextFormField(
                controller: _phoneController,
                focusNode: phoneNode,
                keyboardType: TextInputType.number,
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.digitsOnly,
                ],
                decoration: InputDecoration(
                  contentPadding : EdgeInsets.fromLTRB(15 * (MediaQuery.of(context).size.width / 360), 0, 0, 0),
                  border: InputBorder.none,
                  fillColor: Color(0xffFFFFFF),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(3)),
                    borderSide: BorderSide(
                      color:Color(0xffFFFFFF),
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(3)),
                    borderSide: BorderSide(
                      color:Color(0xffFFFFFF),
                    ),
                  ),
                  // labelText: 'Search',
                  hintText: '전화 번호',
                  hintStyle: TextStyle(color:Color(0xffC4CCD0),),
                ),
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (value) {
                  value = value?.trim();
                  if(value == null || value.isEmpty) {
                    if(_nameController.text != null && _nameController.text != '') {
                      phoneNode.requestFocus();
                    }
                    return "전화 번호를 입력해주세요.";
                  }
                  return null;
                },
              ),
            ),
          ],
        ),
    );
  }
  Container time(BuildContext context) {
    return Container(
        width: 360 * (MediaQuery.of(context).size.width / 360),
        height: 25 * (MediaQuery.of(context).size.height / 360),
        margin : EdgeInsets.fromLTRB(15 * (MediaQuery.of(context).size.width / 360), 5 * (MediaQuery.of(context).size.height / 360),
            15 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360)),
        child: Row(
          children: <Widget>[
            Container(
              width: 330 * (MediaQuery.of(context).size.width / 360),
              height: 25 * (MediaQuery.of(context).size.height / 360),
              decoration: BoxDecoration(
                border: Border.all(
                    color: Color.fromRGBO(243, 246, 248, 1)
                ),
                borderRadius: BorderRadius.circular(3 * (MediaQuery.of(context).size.height / 360)),
                color: Color.fromRGBO(255, 255, 255, 1),
              ),
              child: Row(
                children: [
                  GestureDetector(
                    onTap : () async {
                      final route = MaterialPageRoute(builder: (context) => ServiceTime(time : "", time_type: "start_time",));
                      final addResult = await Navigator.push(context, route);
                      _TimeController.text = addResult;
                      setState(() {

                      });
                    },
                    child : Row(
                      children: [
                        if(_TimeController.text == "")
                          Container(
                            margin : EdgeInsets.fromLTRB(15 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360),
                                0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360)),
                            width: 270 * (MediaQuery.of(context).size.width / 360),
                            child :
                            Text('상담시간', style: TextStyle(color: Color(0xffC4CCD0), fontSize: 15 * (MediaQuery.of(context).size.width / 360)),),
                          ),
                        if(_TimeController.text != "")
                          Container(
                            margin : EdgeInsets.fromLTRB(15 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360),
                                0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360)),
                            width: 270 * (MediaQuery.of(context).size.width / 360),
                            child :
                            Text(_TimeController.text),
                          ),
                        Container(
                            width: 30 * (MediaQuery.of(context).size.width / 360),
                            child : Image(image: AssetImage("assets/edit_calendar.png",), width: 10 * (MediaQuery.of(context).size.width / 360), height : 10 * (MediaQuery.of(context).size.height / 360),)
                          /*child : Icon(Icons.edit_calendar, size: 20,),*/
                        ),
                      ],
                    )
                  )

                ],
              ),
            ),
          ],
        ),
    );
  }
  Container conts(BuildContext context) {
    return Container(
        width: 360 * (MediaQuery.of(context).size.width / 360),
        height: 80 * (MediaQuery.of(context).size.height / 360),
        margin : EdgeInsets.fromLTRB(15 * (MediaQuery.of(context).size.width / 360), 5 * (MediaQuery.of(context).size.height / 360),
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
          maxLines: 5,
          minLines: 5,
          controller: _contsController,
          focusNode: contsNode,
          decoration: InputDecoration(
            contentPadding : EdgeInsets.fromLTRB(10 * (MediaQuery.of(context).size.width / 360), 10 * (MediaQuery.of(context).size.height / 360), 10 * (MediaQuery.of(context).size.width / 360), 0),
            border: InputBorder.none,
            /*enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(5)),
              borderSide: BorderSide(
                color: Color.fromRGBO(255, 255, 255, 1),
              ),
            ),*/
            // labelText: 'Search',
            hintText: '부동산 상담을 요청하실 내용을 입력해주세요\n입주시기,예산,아파트 이름과 같은\n구체적인 내용을 입력 해주시면\n원하시는 매물을 더 빠르게 보실 수 있어요',
            hintStyle: TextStyle(color:Color(0xffC4CCD0), fontSize: 13 * (MediaQuery.of(context).size.width / 360),),
          ),
          autovalidateMode: AutovalidateMode.onUserInteraction,
          validator: (value) {
            value = value?.trim();
            if(value == null || value.isEmpty) {
              if(_nameController.text != null && _nameController.text != '' && _phoneController.text != null && _phoneController.text != '') {
                contsNode.requestFocus();
              }
              return "내용을 입력해주세요.";
            }
            return null;
          },
          style: TextStyle(fontFamily: ''),
        ),
    );
  }
  Container Announcement(BuildContext context) {
    return Container(
        margin : EdgeInsets.fromLTRB(15 * (MediaQuery.of(context).size.width / 360), 8 * (MediaQuery.of(context).size.height / 360),
            15 * (MediaQuery.of(context).size.width / 360), 8 * (MediaQuery.of(context).size.height / 360)),
        width: 360 * (MediaQuery.of(context).size.width / 360),
        height: 45 * (MediaQuery.of(context).size.height / 360),
        decoration: BoxDecoration(
          border: Border.all(
              color: Color.fromRGBO(255, 255, 255, 1)
          ),
          borderRadius: BorderRadius.circular(3 * (MediaQuery.of(context).size.height / 360)),
          color: Color.fromRGBO(243, 246, 248, 1),
        ),

      child: Column(
        children: [
          Container(
            width: 350 * (MediaQuery.of(context).size.width / 360),
            // height: 15 * (MediaQuery.of(context).size.height / 360),
            padding: EdgeInsets.fromLTRB(15 * (MediaQuery.of(context).size.width / 360), 7 * (MediaQuery.of(context).size.height / 360),
                0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360) ),
            child: Text("안내문", style: TextStyle(
              fontSize: 15,
              fontFamily: 'NanumSquareR',
              fontWeight: FontWeight.w800,
            ),
            ),
          ),
          Container(
            width: 350 * (MediaQuery.of(context).size.width / 360),
            // height: 20 * (MediaQuery.of(context).size.height / 360),
            padding: EdgeInsets.fromLTRB(15 * (MediaQuery.of(context).size.width / 360), 3 * (MediaQuery.of(context).size.height / 360),
                20 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360) ),
            child: Text("신청 해주신 내용을 담당자가 확인 후 입력해주신 \n휴대폰 번호로 연락 드리겠습니다.", style: TextStyle(
              fontSize: 13,
              height: 0.8 * (MediaQuery.of(context).size.height / 360),
              fontFamily: 'NanumSquareR',
            ),
            ),
          ),
        ],
      ),
    );
  }
  Container apply(BuildContext context) {
    return Container(
        width: 340 * (MediaQuery.of(context).size.width / 360),
        height: 31 * (MediaQuery.of(context).size.height / 360),
        padding : EdgeInsets.fromLTRB(5 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360),
            5 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360)),
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
                    padding: EdgeInsets.symmetric(horizontal: 5 * (MediaQuery.of(context).size.width / 360), vertical: 10 * (MediaQuery.of(context).size.height / 360)),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5 * (MediaQuery.of(context).size.height / 360))
                    )
                ),
                /*onPressed: (){
                          Navigator.push(context, MaterialPageRoute(
                            builder: (context) {
                              return Service();
                            },
                          ));
                        },*/
                onPressed : () {
                  if(member_id != null && member_id != "") {
                    if(_formKey.currentState!.validate()) {
                      if(click_check == 1) {
                        setState(() {
                          click_check = 0;
                        });
                        FlutterDialog(context);
                      }
                    }
                  }

                  if(member_id == null || member_id == "") {
                    showModal(context, 'loginalert', '');
                  }
                },
                child:  Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text('상담신청 완료하기', style: TextStyle(
                        fontSize: 19,
                        fontWeight: FontWeight.w800,
                        color: click_check == 0 ? Color(0xffE47421) : Colors.white),textAlign: TextAlign.center,),
                  ],
                ),
              ),
            )
          ],
        ),
    );
  }

  void FlutterDialog(context) async {
    var board_seq = 0;

    if(widget.table_nm == "ON_SITE") {
      board_seq = 12;
    }

    if(widget.table_nm == "INTRP_SRVC") {
      board_seq = 13;
    }

    if(widget.table_nm == "AGENCY_SRVC") {
      board_seq = 14;
    }

    if(widget.table_nm == "REAL_ESTATE") {
      board_seq = 17;
    }

    var ipAddress = IpAddress(type: RequestType.json);
    dynamic data = await ipAddress.getIpAddress();

    String cat02 = "";
    String cat03 = "";
    String cat04 = "";
    String cat05 = "";
    String cat06 = "";
    String cat07 = "";
    String cat08 = "";

    for(var i = 0; i < widget.checkList.length; i++) {
      if(widget.checkList[i].contains("I201")) {
        cat02 = cat02 + widget.checkList[i] + ",";
      }
      if(widget.checkList[i].contains("I202")) {
        cat03 = cat03 + widget.checkList[i] + ",";
      }
      if(widget.checkList[i].contains("I203")) {
        cat04 = cat04 + widget.checkList[i] + ",";
      }
      if(widget.checkList[i].contains("I204")) {
        cat05 = cat05 + widget.checkList[i] + ",";
      }
      if(widget.checkList[i].contains("I205")) {
        cat06 = cat06 + widget.checkList[i] + ",";
      }
      if(widget.checkList[i].contains("I206")) {
        cat07 = cat07 + widget.checkList[i] + ",";
      }
    }
    for(var i = 0; i < widget.interiorList.length; i++) {
      cat08 = cat08 + widget.interiorList[i] + ",";
    }

    if(cat02 != null && cat02 != "") {
      cat02 = cat02.substring(0, cat02.length-1);
    }
    if(cat03 != null && cat03 != "") {
      cat03 = cat03.substring(0, cat03.length-1);
    }
    if(cat04 != null && cat04 != "") {
      cat04 = cat04.substring(0, cat04.length-1);
    }
    if(cat05 != null && cat05 != "") {
      cat05 = cat05.substring(0, cat05.length-1);
    }
    if(cat06 != null && cat06 != "") {
      cat06 = cat06.substring(0, cat06.length-1);
    }
    if(cat07 != null && cat07 != "") {
      cat07 = cat07.substring(0, cat07.length-1);
    }
    print(cat02);
    print(cat03);
    print(cat04);
    print(cat05);
    print(cat06);
    print(cat07);

    // Create storage
    final storage = FlutterSecureStorage();
    String? reg_id = await storage.read(key: "memberId");
    String? nickname = await storage.read(key: "memberNick");
    String? reg_nm = await storage.read(key: "memberNick");

    FormData _formData = FormData.fromMap(
        {
          "title" : "상담신청",
          "conts" : " " + _contsController.text,
          "etc01" : _TimeController.text,
          "etc09" : _phoneNumberCategoryValue.toString() + "-" + _phoneController.text, //외국전화번호의 경우 자릿수가 천차만별이라 따로 저장
          "cat01" : "I301", // 처리상태 -> 신청완료
          "cat02" : cat02,
          "cat03" : cat03,
          "cat04" : cat04,
          "cat05" : cat05,
          "cat06" : cat06,
          "cat07" : cat07,
          "cat08" : cat08,
          "board_seq" : board_seq,
          "session_ip" : data["ip"].toString(),
          "session_member_id" : reg_id,
          "session_member_nm" : _nameController.text,
          "table_nm" : widget.table_nm
        }
    );

    Dio dio = Dio();

    dio.options.contentType = "multipart/form-data";

    final res = await dio.post("http://www.hoty.company/mf/community/write.do", data: _formData).then((res) {
      return res.data;
    });


    print("결과입니다.");
    print(res);

    showDialog(
        context: context,
        //barrierDismissible - Dialog를 제외한 다른 화면 터치 불가
        barrierDismissible: false,
        barrierColor: Color(0xffE47421).withOpacity(0.4),
        builder: (BuildContext context) {
          return MediaQuery(
            data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
            child: AlertDialog(
              // RoundedRectangleBorder - Dialog 화면 모서리 둥글게 조절
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0)),
              //Dialog Main Title
              /*title: Column(
              children: <Widget>[
                new Text("Dialog Title"),
              ],
            ),*/
              //
              insetPadding: EdgeInsets.fromLTRB(25 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360),
                  25 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360)),
              contentPadding: EdgeInsets.fromLTRB(15 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360),
                  15 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360)),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(
                    margin : EdgeInsets.fromLTRB(0 * (MediaQuery.of(context).size.width / 360), 10 * (MediaQuery.of(context).size.height / 360),
                        0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360)),
                    child : Image(image: AssetImage("assets/check_circle.png"), width: 50 * (MediaQuery.of(context).size.width / 360),),
                  ),
                  Container(
                    margin : EdgeInsets.fromLTRB(0 * (MediaQuery.of(context).size.width / 360), 5 * (MediaQuery.of(context).size.height / 360),
                        0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360)),
                    child : Text("부동산 상담 신청이", style: TextStyle(fontFamily: 'NanumSquareB', fontSize: 18 * (MediaQuery.of(context).size.width / 360), fontWeight: FontWeight.bold),),
                  ),
                  Container(
                    child : Text("완료되었습니다.", style: TextStyle(fontFamily: 'NanumSquareB', fontSize: 18 * (MediaQuery.of(context).size.width / 360), fontWeight: FontWeight.bold),),
                  ),
                  Container(
                      margin : EdgeInsets.fromLTRB(0 * (MediaQuery.of(context).size.width / 360), 5 * (MediaQuery.of(context).size.height / 360),
                          0 * (MediaQuery.of(context).size.width / 360), 5 * (MediaQuery.of(context).size.height / 360)),
                      child : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text("시작 시간 : ", style: TextStyle( fontSize: 14 * (MediaQuery.of(context).size.width / 360), fontWeight: FontWeight.w600),),
                          Text("${_TimeController.text}", style: TextStyle( fontSize: 14 * (MediaQuery.of(context).size.width / 360)),),
                        ],
                      )
                  ),
                  Container(
                    margin : EdgeInsets.fromLTRB(0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360),
                        0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360)),
                    child : Text("신청 내용을 담당자가 확인 후 입력해주신 ", style: TextStyle( fontSize: 14 * (MediaQuery.of(context).size.width / 360)),),
                  ),
                  Container(
                    margin : EdgeInsets.fromLTRB(0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360),
                        0 * (MediaQuery.of(context).size.width / 360), 5 * (MediaQuery.of(context).size.height / 360)),
                    child : Text("휴대폰 번호로 연락 드리겠습니다.", style: TextStyle(fontSize: 14 * (MediaQuery.of(context).size.width / 360)),),
                  ),
                ],
              ),
              actions: <Widget>[
                TextButton(
                  child: Container(
                    width : 360 * (MediaQuery.of(context).size.width / 360),
                    padding : EdgeInsets.fromLTRB(0 * (MediaQuery.of(context).size.width / 360), 10 * (MediaQuery.of(context).size.height / 360),
                        0 * (MediaQuery.of(context).size.width / 360), 10 * (MediaQuery.of(context).size.height / 360)),
                    decoration: BoxDecoration(
                      color: Color(0xffE47421),
                      borderRadius: BorderRadius.circular(3 * (MediaQuery.of(context).size.height / 360)),
                    ),
                    child : Text("홈으로 이동", style: TextStyle(color: Color(0xffFFFFFF),fontFamily: 'NanumSquareB',fontSize: 14 * (MediaQuery.of(context).size.width / 360) , fontWeight: FontWeight.w600), textAlign: TextAlign.center,),
                  ),
                  onPressed: () {
                    Navigator.pop(context,true);
                  },
                ),
              ],
            ),
          );
        },
       ).then((value) => {
          if(value == true) {
            Navigator.push(context, MaterialPageRoute(
              builder: (context) {
                return MainPage();
              },
            )),
          }
    });
  }


}