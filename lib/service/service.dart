import 'dart:async';
import 'dart:convert';

import 'package:booking_calendar/booking_calendar.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hoty/categorymenu/living_list.dart';
import 'package:hoty/categorymenu/living_view.dart';
import 'package:hoty/common/footer.dart';
import 'package:hoty/community/dailytalk/community_dailyTalk.dart';
import 'package:hoty/community/dailytalk/community_dailyTalk_view.dart';
import 'package:hoty/community/privatelesson/lesson_list.dart';
import 'package:hoty/community/privatelesson/lesson_view.dart';
import 'package:hoty/community/usedtrade/trade_list.dart';
import 'package:hoty/community/usedtrade/trade_view.dart';
import 'package:hoty/counseling/counseling_guide.dart';
import 'package:hoty/kin/kin_view.dart';
import 'package:hoty/kin/kinlist.dart';
import 'package:hoty/main/main_page.dart';
import 'package:hoty/profile/service/profile_service_detail.dart';
import 'package:hoty/service/providers/service_provider.dart';
import 'package:hoty/service/service_guide.dart';
import 'package:hoty/service/service_location_search.dart';
import 'package:hoty/service/service_time.dart';
import 'package:hoty/today/today_advicelist.dart';
import 'package:hoty/today/today_list.dart';
import 'package:hoty/today/today_view.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:dio/dio.dart';
import "package:http_parser/http_parser.dart";
import 'package:intl/intl.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_ip_address/get_ip_address.dart';
import 'package:url_launcher/url_launcher.dart';
import '../common/dialog/commonAlert.dart';
import '../common/dialog/showDialog_modal.dart';
import '../profile/profile_service_history.dart';
import 'model/serviceVO.dart';

class Service extends StatefulWidget {
  final dynamic table_nm;

  const Service({Key ? key,
    required this.table_nm
  }) : super(key:key);

  @override
  State<Service> createState() => _ServiceState();
}

class _ServiceState extends State<Service> {

  String hoty_address = "70 Đ. 51, An Phú, Thủ Đức, Thành phố Hồ Chí Minh";
  double hoty_lat = 10.7827583197085;
  double hoty_lng = 106.7450681697085;

  double address_lat = 0;
  double address_lng = 0;

  var distance = Distance();

  int km = 0;

  final GlobalKey servicecat_key = GlobalKey();
  final _formKey = GlobalKey<FormState>();

  int click_check = 1;

  var base_Imgurl = 'http://www.hoty.company';
  //var base_Imgurl = 'http://www.hoty.company';

  Widget getBanner = Container(); //공통배너

  final now = DateTime.now();
  late BookingService mockBookingService;

  List<serviceVO> mainCategory = [];
  List<serviceVO> cat02 = [];
  List<serviceVO> phoneNumberCategory = [];

  List<dynamic> discountfeeList = [];
  List<dynamic> apartlist = [];

  serviceProvider mainCategoryProvider = serviceProvider();

  final PageController _pageController = PageController();
  int _currentPage = 0;

  List<dynamic> getbresult = [];

  String? _selectedValue ;
  String? member_id = "";
  String? _mainCategoryValue ;
  String? _levelCategoryValue ;
  String? _phoneNumberCategoryValue ;

  int point = 0;
  int service_fee = 0;
  int service_money = 0;

  int level_discount = 0;
  int time_discount = 0;
  int distance_discount = 0;
  int basic_time_discount = 0;

  String time_money_type = "";
  String level_money_type = "";

  File? selectedFile;

  final ImagePicker _picker = ImagePicker();
  List<XFile> _pickedImgs = [];

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

  bool _visibility1 = true;
  bool _visibility2 = false;
  bool visible_category1 = false;
  bool visible_category2 = false;

  bool name_visible = false;
  bool phone_visible = false;
  bool address_visible = false;
  bool address_detail_visible = false;
  bool level_visible = false;
  bool time_visible = false;
  bool conts_visible = false;
  bool terms_visible = false;
  bool paymentinformation_visible = false;
  bool announcement_visible = false;
  bool apply_visible = false;
  bool upload_visible = false;

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

  void getBoardList() async {
    var url = Uri.parse(
      'http://www.hoty.company/mf/member/getMemberApartment.do',
      //'http://192.168.100.31:8080/mf/member/getMemberApartment.do',
    );

    try {

      Map data = {
        "memberId": member_id,
      };

      var body = json.encode(data);
      var response = await http.post(
          url,
          headers: {"Content-Type": "application/json"},
          body: body
      );

      print('get data');
      if(json.decode(response.body)['state'] == 200) {
        print(json.decode(response.body)['result']['apartList']);
        setState(() {
          apartlist = json.decode(response.body)['result']['apartList'];
          for(int i = 0; i < apartlist.length; i++) {
            apartlist[i]["is_checked"] = false;
          }
        });
      } else {
        setState(() {
          apartlist = [];
        });
      }

    }catch(e) {
      print(e);
    }

  }

  Future initmainCategory() async {
    mainCategory = await mainCategoryProvider.getCategory(widget.table_nm);
  }

  Future initcat02() async {
    cat02 = await mainCategoryProvider.getCat02();
  }

  Future initphoneNumberCategory() async {
    phoneNumberCategory = await mainCategoryProvider.getphoneNumberCategory();
  }

  Future initgetpointview() async {
    member_id = (await storage.read(key:'memberId')) ?? "";
    point = await mainCategoryProvider.getpointview(member_id);
  }

  Future initgetservicefee(String category) async {
    service_fee = await mainCategoryProvider.getserviceFee(category);
    service_money = service_fee;
  }

  Future initgetdiscountfee(String category) async {
    discountfeeList = await mainCategoryProvider.getdiscountfee(category);
  }

  Column bannerlist2(context){

    return Column(
      children: [
        Expanded(
          // flex: 1,
          child: Stack(
            children: [
              PageView(
                controller: _pageController,
                onPageChanged: (int page) {
                  setState(() {
                    _currentPage = page;
                  });
                },
                children: [
                  if(getbresult.length > 0)
                    for(var i=0; i<getbresult.length; i++)
                      buildBanner('${getbresult[i]['title']}', i,'${getbresult[i]['file_path']}', '${getbresult[i]['type']}', '${getbresult[i]['table_nm']}', int.parse('${getbresult[i]['article_seq'] ?? 0}') , '${getbresult[i]['main_category']}'),
                ],
              ),
              /*Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  margin: EdgeInsets.symmetric(vertical: 4.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if(getbresult.length > 0)
                        for(var i=0; i<getbresult.length; i++)
                          Container(
                            margin: EdgeInsets.all(3.0),
                            width: 8.0,
                            height: 8.0,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: _currentPage == i
                                  ? Colors.grey
                                  : Colors.grey.withOpacity(0.5),
                            ),
                          ),
                    ],
                  ),
                ),
              ),*/
            ],
          ),
        ),
      ],

    );
  }

  Widget buildBanner(String text, int index, file_path, type, table_nm, article_seq, category) {
    return GestureDetector(
      onTap : (){
        var title_living = ['M01','M02','M03','M04','M05'];

        if(getbresult[index]["link_yn"] == "Y") {
          if(type == "list") {

            // 박정범
            if(title_living.contains(table_nm)){
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return LivingList(title_catcode: category,
                    check_sub_catlist: [],
                    check_detail_catlist: [],
                    check_detail_arealist: []);
              },
              ));
            }
            if(table_nm == 'M06'){
              Navigator.push(context, MaterialPageRoute(
                builder: (context) {
                  return Service_guide(table_nm : category);
                },
              ));
            }
            if(table_nm == 'M07'){
              Navigator.push(context, MaterialPageRoute(
                builder: (context) {
                  if(category == 'USED_TRNSC') {
                    return TradeList(checkList: [],);
                  } else if(category == 'PERSONAL_LESSON'){
                    return LessonList(checkList: [],);
                  } else {
                    return CommunityDailyTalk(main_catcode: category);
                  }
                },
              ));
            }
            if(table_nm == 'M08'){
              Navigator.push(context, MaterialPageRoute(
                builder: (context) {
                  return TodayList(main_catcode: '',table_nm : category);
                },
              ));
            }
            // 지식인
            if(table_nm == 'M09'){
              Navigator.push(context, MaterialPageRoute(
                builder: (context) {
                  return KinList(success: false, failed: false,main_catcode: '',);
                },
              ));
            }


          } else if(type == "view") {
            if(title_living.contains(table_nm)){
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return LivingView(article_seq: article_seq, table_nm: table_nm, title_catcode: category, params: {});
              },
              ));
            }
            if(table_nm == 'M06'){
              Navigator.push(context, MaterialPageRoute(
                builder: (context) {
                  return Service_guide(table_nm : category);
                },
              ));
            }
            if(table_nm == 'M07'){
              Navigator.push(context, MaterialPageRoute(
                builder: (context) {
                  if(category == 'USED_TRNSC') {
                    return TradeView(article_seq: article_seq, table_nm: table_nm, params: {}, checkList: []);
                  } else if(category == 'PERSONAL_LESSON'){
                    return LessonView(article_seq: article_seq, table_nm: table_nm, params: {}, checkList: []);
                  } else {
                    return CommunityDailyTalkView(article_seq: article_seq, table_nm: table_nm, main_catcode: category, params: {});
                  }
                },
              ));
            }
            if(table_nm == 'M08'){

              Navigator.push(context, MaterialPageRoute(
                builder: (context) {
                  return todayView(article_seq: article_seq, title_catcode: category, cat_name: '', table_nm: table_nm);
                },
              ));
            }
            // 지식인
            if(table_nm == 'M09'){
              Navigator.push(context, MaterialPageRoute(
                builder: (context) {
                  return KinView(article_seq: article_seq, table_nm: table_nm, adopt_chk: '');
                },
              ));
            }
          }
        }
      },
      child : Container(
        margin : EdgeInsets.fromLTRB(0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360),
            0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360)),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0), // 원하는 둥근 정도를 설정합니다.
          // color: Colors.blueGrey,
          image: DecorationImage(
              image: NetworkImage('$base_Imgurl$file_path'),
              // image: NetworkImage(''),
              fit: BoxFit.fill
          ),
        ),
        // child: Center(child: Text(text)), // 타이틀글 사용시 주석해제
      )
    );
  }

  Future<dynamic> getlistdata2() async {

    Map paging = {}; // 페이징
    var totalpage = '';

    var url = Uri.parse(
        base_Imgurl + "/mf/popup/list.do"
    );
    try {
      Map data = {
        "table_nm" : widget.table_nm
      };
      var body = json.encode(data);
      var response = await http.post(
          url,
          headers: {"Content-Type": "application/json"},
          body: body
      );
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');
      if(response.statusCode == 200) {
        var resultstatus = json.decode(response.body)['resultstatus'];

        getbresult = json.decode(response.body)['result'];
         print("@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@");
         print(getbresult);
        getBanner = bannerbuild(context); // 카테고리별 배너 셋팅
      }
      // print(result.length);
    }
    catch(e){
      print(e);
    }
  }

  Container bannerbuild(context) {
    return Container(
      width: 350 * (MediaQuery.of(context).size.width / 360),
      // height: 65 * (MediaQuery.of(context).size.height / 360), // 이미지 사이즈
      /* margin : EdgeInsets.fromLTRB(5 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360),
          0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360)),*/
      child: bannerlist2(context),
    );
  }


  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();
  final _detailAddressController = TextEditingController();
  final _startTimeController = TextEditingController();
  final _endTimeController = TextEditingController();
  final _contsController = TextEditingController();
  final _pointController = TextEditingController();

  late FocusNode nameNode;
  late FocusNode phoneNode;
  late FocusNode addressNode;
  late FocusNode detailAddressNode;
  late FocusNode startTimeNode;
  late FocusNode endTimeNode;
  late FocusNode contsNode;
  late FocusNode pointNode;

  void valueReset () {
    _nameController.text = "";
    _phoneController.text = "";
    _addressController.text = "";
    _detailAddressController.text = "";
    _startTimeController.text = "";
    _endTimeController.text = "";
    _contsController.text = "";
    _mainCategoryValue = "";
    _levelCategoryValue = "";
    _pointController.text = "";
    setState(() {
    });
  }

  static final storage = FlutterSecureStorage();
  _asyncMethod() async {
    // read 함수로 key값에 맞는 정보를 불러오고 데이터타입은 String 타입
    // 데이터가 없을때는 null을 반환
    member_id = (await storage.read(key:'memberId')) ?? "";
    _nameController.text = (await storage.read(key:'memberNick')) ?? "";
    print("#############################################");
    print(member_id);
  }



  @override
  void initState() {
    super.initState();

    nameNode = FocusNode();
    phoneNode = FocusNode();
    addressNode = FocusNode();
    detailAddressNode = FocusNode();
    startTimeNode = FocusNode();
    endTimeNode = FocusNode();
    contsNode = FocusNode();
    pointNode = FocusNode();

    _asyncMethod();
    // _pointController.text = "0";
    _phoneNumberCategoryValue = "84";
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _asyncMethod().then((value){
        getlistdata2();
        getBoardList();
        initmainCategory().then((_) {
          setState(() {

          });
        });
        initcat02().then((_) {
          setState(() {

          });
        });
        initphoneNumberCategory().then((_) {
          setState(() {

          });
        });

        initgetpointview().then((_) {
          setState(() {

          });
        });
        setState(() {
          Timer.periodic(Duration(seconds: 3), (Timer timer) {
            if (_currentPage < getbresult.length) {
              _currentPage++;
            } else {
              _currentPage = 0;
            }

            _pageController.animateToPage(
              _currentPage,
              duration: Duration(milliseconds: 350),
              curve: Curves.easeIn,
            );

          });
        });
      });
    });

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Scrollable.ensureVisible(
        servicecat_key.currentContext!,
      );
    });
  }

  @override
  void dispose() {
    nameNode.dispose();
    phoneNode.dispose();
    addressNode.dispose();
    detailAddressNode.dispose();
    startTimeNode.dispose();
    endTimeNode.dispose();
    contsNode.dispose();
    pointNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap : () => FocusManager.instance.primaryFocus?.unfocus(),
      child : Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            automaticallyImplyLeading: true,
            titleSpacing: 5,
            leadingWidth: 40,
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
              //width: 80 * (MediaQuery.of(context).size.width / 360),
              //height: 80 * (MediaQuery.of(context).size.height / 360),
              /*child: Image(image: AssetImage('assets/logo.png')),*/
              child: Text("서비스" , style: TextStyle(fontSize: 18,  color: Colors.black, fontWeight: FontWeight.bold,),
              ),
            ),
            //centerTitle: true,
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                category(context),
                if(getbresult.length > 0)
                  Container(
                    width: 340 * (MediaQuery.of(context).size.width / 360),
                    height: 70 * (MediaQuery.of(context).size.height / 360), // 이미지 사이즈
                    margin : EdgeInsets.fromLTRB(5 * (MediaQuery.of(context).size.width / 360), 8 * (MediaQuery.of(context).size.height / 360),
                        5 * (MediaQuery.of(context).size.width / 360), 3 * (MediaQuery.of(context).size.height / 360)),
                    child: getBanner,
                  ),
                if(widget.table_nm != "AGENCY_SRVC" && widget.table_nm != "REAL_ESTATE_INTRP_SRVC")
                Container(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: <Widget>[
                        for(int i = 0; i < apartlist.length; i++)
                        Container(
                          child: Row(
                            children: [
                              TextButton(
                                onPressed: (){
                                  /*Navigator.push(context, MaterialPageRoute(
                                    builder: (context) {
                                      return Service(table_nm : widget.table_nm);
                                    },
                                  ));*/
                                },
                                child: Container(
                                  margin : EdgeInsets.fromLTRB(10 * (MediaQuery.of(context).size.width / 360), 5 * (MediaQuery.of(context).size.height / 360),
                                      0 * (MediaQuery.of(context).size.width / 360), 5 * (MediaQuery.of(context).size.height / 360)),
                                  width: 290 * (MediaQuery.of(context).size.width / 360),
                                  height: 60 * (MediaQuery.of(context).size.height / 360),
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                        color: apartlist[i]["is_checked"] == true ? Color.fromRGBO(228, 116, 33, 1) : Color(0xffFFFFFF)
                                    ),
                                    borderRadius: BorderRadius.circular(3 * (MediaQuery.of(context).size.height / 360)),
                                    color: apartlist[i]["is_checked"] == true ? Color.fromRGBO(255, 251, 249, 1) : Color(0xffFFFFFF),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(0.2),
                                        spreadRadius: 1,
                                        blurRadius: 8,
                                        offset: Offset(0, 1), // changes position of shadow
                                      ),
                                    ],
                                  ),

                                  child: Column(
                                    children: [
                                      Container(
                                        // height: 27 * (MediaQuery.of(context).size.height / 360),
                                        child: Row(
                                          children: [
                                            Container(
                                              width: 230 * (MediaQuery.of(context).size.width / 360),
                                              padding : EdgeInsets.fromLTRB(10 * (MediaQuery.of(context).size.width / 360), 6 * (MediaQuery.of(context).size.height / 360),
                                                  0 * (MediaQuery.of(context).size.width / 360), 5 * (MediaQuery.of(context).size.height / 360)),
                                              child: Text("${apartlist[i]["NAME"]}",
                                                style: TextStyle(
                                                    fontSize: 14,
                                                    fontFamily: 'NanumSquareR',
                                                    fontWeight: FontWeight.w600,
                                                    color: Colors.black,
                                                  height: 0.7 * (MediaQuery.of(context).size.height / 360),

                                                ),
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                            Transform.scale(
                                              scale: 0.8,
                                              child: CupertinoSwitch(
                                                value: apartlist[i]["is_checked"],
                                                activeColor: Color(0xffE47421),
                                                onChanged: (bool? value) {
                                                  apartlist[i]["is_checked"] = value!;
                                                  if(apartlist[i]["is_checked"] == true) {
                                                    _addressController.text = apartlist[i]["ADDRESS"];
                                                    _detailAddressController.text = apartlist[i]["ADDRESS_DETAIL"];
                                                    distance_check();
                                                  }
                                                  if(apartlist[i]["is_checked"] == false) {
                                                    _addressController.text = "";
                                                    _detailAddressController.text = "";
                                                    distance_discount = 0;
                                                    address_lat = 0;
                                                    address_lng = 0;
                                                  }
                                                  setState(() {
                                                  });
                                                },
                                              ),
                                            ),

                                          ],
                                        ),
                                      ),
                                      Container(
                                        width: 270 * (MediaQuery.of(context).size.width / 360),
                                        padding : EdgeInsets.fromLTRB(0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360),
                                            0 * (MediaQuery.of(context).size.width / 360), 5 * (MediaQuery.of(context).size.height / 360)),
                                        // height: 28 * (MediaQuery.of(context).size.height / 360),
                                        child: Text("${apartlist[i]["ADDRESS"]}${apartlist[i]["ADDRESS_DETAIL"]}",
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.w400,
                                            fontFamily: 'NanumSquareR',
                                            fontSize: 14,
                                            height: 0.7 * (MediaQuery.of(context).size.height / 360),
                                          ),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,

                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Form(
                    key: _formKey,
                    child : Column(
                      children: [
                        MainCategory(context),
                        Name(context),
                        phoneNumber(context),
                        address(context),
                        detailAddress(context),
                        level(context),
                        time(context),
                        conts(context),
                        upload(context),
                        Terms(context),
                        Announcement(context),
                        paymentInformation(context),
                      ],
                    )
                ),
                apply(context),

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
          bottomNavigationBar: Footer(nowPage: 'Main_menu',)
      )
    );
  }

  Container category(BuildContext context) {
    return Container(
            child : SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if(widget.table_nm == "ON_SITE")
                  Container(
                    key: servicecat_key,
                    child : TextButton(
                      style: TextButton.styleFrom(
                          padding: EdgeInsets.zero,
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          alignment: Alignment.center
                      ),
                      onPressed: (){
                        Navigator.push(context, MaterialPageRoute(
                          builder: (context) {
                            return Service(table_nm : "ON_SITE");
                          },
                        ));
                      },
                      child: Container(
                        margin : EdgeInsets.fromLTRB(0 * (MediaQuery.of(context).size.width / 360), 5 * (MediaQuery.of(context).size.height / 360),
                            0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360)),
                        padding : EdgeInsets.fromLTRB(15 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360),
                            10 * (MediaQuery.of(context).size.width / 360), 5 * (MediaQuery.of(context).size.height / 360)),
                        decoration: BoxDecoration (
                            color: Colors.white,
                            border : Border(
                                bottom: BorderSide(
                                    color: widget.table_nm == "ON_SITE"
                                        ? Color(0xffE47421)
                                        : Color(0xffF3F6F8),
                                    width : 2 * (MediaQuery.of(context).size.width / 360)
                                )
                            )
                        ),
                        child: Text(
                          "출장 서비스",
                          style: TextStyle(
                            fontSize: 15 * (MediaQuery.of(context).size.width / 360),
                            color: Color(0xff151515),
                            fontWeight: FontWeight.w800,
                            fontFamily: 'NanumSquareR',
                            // height: 1.5 * (MediaQuery.of(context).size.width / 360),
                          ),
                        ),
                      ),
                    ),
                  ),
                  if(widget.table_nm != "ON_SITE")
                  Container(
                    child : TextButton(
                      style: TextButton.styleFrom(
                          padding: EdgeInsets.zero,
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          alignment: Alignment.center
                      ),
                      onPressed: (){
                        Navigator.push(context, MaterialPageRoute(
                          builder: (context) {
                            return Service(table_nm : "ON_SITE");
                          },
                        ));
                      },
                      child: Container(
                        margin : EdgeInsets.fromLTRB(0 * (MediaQuery.of(context).size.width / 360), 5 * (MediaQuery.of(context).size.height / 360),
                            0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360)),
                        padding : EdgeInsets.fromLTRB(15 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360),
                            10 * (MediaQuery.of(context).size.width / 360), 5 * (MediaQuery.of(context).size.height / 360)),
                        decoration: BoxDecoration (
                            color: Colors.white,
                            border : Border(
                                bottom: BorderSide(
                                    color: widget.table_nm == "ON_SITE"
                                        ? Color(0xffE47421)
                                        : Color(0xffF3F6F8),
                                    width : 2 * (MediaQuery.of(context).size.width / 360)
                                )
                            )
                        ),
                        child: Text(
                          "출장 서비스",
                          style: TextStyle(
                            fontSize: 15 * (MediaQuery.of(context).size.width / 360),
                            color: Color(0xff151515),
                            fontWeight: FontWeight.w800,
                            fontFamily: 'NanumSquareR',
                            // height: 1.5 * (MediaQuery.of(context).size.width / 360),
                          ),
                        ),
                      ),
                    ),
                  ),
                  //if(widget.table_nm == "INTRP_SRVC")
                  //Container(
                  //  key: servicecat_key,
                  //  child : TextButton(
                  //    style: TextButton.styleFrom(
                  //        padding: EdgeInsets.zero,
                  //        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  //        alignment: Alignment.center
                  //    ),
                  //    onPressed: (){
                  //      Navigator.push(context, MaterialPageRoute(
                  //        builder: (context) {
                  //          return Service(table_nm : "INTRP_SRVC");
                  //        },
                  //      ));
                  //    },
                  //    child: Container(
                  //      margin : EdgeInsets.fromLTRB(0 * (MediaQuery.of(context).size.width / 360), 5 * (MediaQuery.of(context).size.height / 360),
                  //          0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360)),
                  //      padding : EdgeInsets.fromLTRB(15 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360),
                  //          10 * (MediaQuery.of(context).size.width / 360), 5 * (MediaQuery.of(context).size.height / 360)),
                  //      decoration: BoxDecoration (
                  //          color: Colors.white,
                  //          border : Border(
                  //              bottom: BorderSide(
                  //                  color: widget.table_nm == "INTRP_SRVC"
                  //                      ? Color(0xffE47421)
                  //                      : Color(0xffF3F6F8),
                  //                  width : 2 * (MediaQuery.of(context).size.width / 360)
                  //              )
                  //          )
                  //      ),
                  //      child: Text(
                  //        "24시 긴급 출장 통역 서비스",
                  //        style: TextStyle(
                  //          fontSize: 15 * (MediaQuery.of(context).size.width / 360),
                  //          color: Color(0xff151515),
                  //          fontWeight: FontWeight.w800,
                  //          fontFamily: 'NanumSquareR',
                  //          // height: 1.5 * (MediaQuery.of(context).size.width / 360),
                  //        ),
                  //      ),
                  //    ),
                  //  )
                  //),
                  //if(widget.table_nm != "INTRP_SRVC")
                  //Container(
                  //    child : TextButton(
                  //      style: TextButton.styleFrom(
                  //          padding: EdgeInsets.zero,
                  //          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  //          alignment: Alignment.center
                  //      ),
                  //      onPressed: (){
                  //        Navigator.push(context, MaterialPageRoute(
                  //          builder: (context) {
                  //            return Service(table_nm : "INTRP_SRVC");
                  //          },
                  //        ));
                  //      },
                  //      child: Container(
                  //        margin : EdgeInsets.fromLTRB(0 * (MediaQuery.of(context).size.width / 360), 5 * (MediaQuery.of(context).size.height / 360),
                  //            0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360)),
                  //        padding : EdgeInsets.fromLTRB(15 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360),
                  //            10 * (MediaQuery.of(context).size.width / 360), 5 * (MediaQuery.of(context).size.height / 360)),
                  //        decoration: BoxDecoration (
                  //            color: Colors.white,
                  //            border : Border(
                  //                bottom: BorderSide(
                  //                    color: widget.table_nm == "INTRP_SRVC"
                  //                        ? Color(0xffE47421)
                  //                        : Color(0xffF3F6F8),
                  //                    width : 2 * (MediaQuery.of(context).size.width / 360)
                  //                )
                  //            )
                  //        ),
                  //        child: Text(
                  //          "24시 긴급 출장 통역 서비스",
                  //          style: TextStyle(
                  //            fontSize: 15 * (MediaQuery.of(context).size.width / 360),
                  //            color: Color(0xff151515),
                  //            fontWeight: FontWeight.w800,
                  //            fontFamily: 'NanumSquareR',
                  //            // height: 1.5 * (MediaQuery.of(context).size.width / 360),
                  //          ),
                  //        ),
                  //      ),
                  //    )
                  //),
                  if(widget.table_nm == "AGENCY_SRVC")
                  Container(
                    key: servicecat_key,
                    child : TextButton(
                      style: TextButton.styleFrom(
                          padding: EdgeInsets.zero,
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          alignment: Alignment.center
                      ),
                      onPressed: (){
                        Navigator.push(context, MaterialPageRoute(
                          builder: (context) {
                            return Service(table_nm : "AGENCY_SRVC");
                          },
                        ));
                      },
                      child: Container(
                        margin : EdgeInsets.fromLTRB(0 * (MediaQuery.of(context).size.width / 360), 5 * (MediaQuery.of(context).size.height / 360),
                            0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360)),
                        padding : EdgeInsets.fromLTRB(15 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360),
                            10 * (MediaQuery.of(context).size.width / 360), 5 * (MediaQuery.of(context).size.height / 360)),
                        decoration: BoxDecoration (
                            color: Colors.white,
                            border : Border(
                                bottom: BorderSide(
                                    color: widget.table_nm == "AGENCY_SRVC"
                                        ? Color(0xffE47421)
                                        : Color(0xffF3F6F8),
                                    width : 2 * (MediaQuery.of(context).size.width / 360)
                                )
                            )
                        ),
                        child: Text(
                          "비자 서비스",
                          style: TextStyle(
                            fontSize: 15 * (MediaQuery.of(context).size.width / 360),
                            color: Color(0xff151515),
                            fontWeight: FontWeight.w800,
                            fontFamily: 'NanumSquareR',
                            // height: 1.5 * (MediaQuery.of(context).size.width / 360),
                          ),
                        ),
                      ),
                    )
                  ),
                  if(widget.table_nm != "AGENCY_SRVC")
                  Container(
                      child : TextButton(
                        style: TextButton.styleFrom(
                            padding: EdgeInsets.zero,
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            alignment: Alignment.center
                        ),
                        onPressed: (){
                          Navigator.push(context, MaterialPageRoute(
                            builder: (context) {
                              return Service(table_nm : "AGENCY_SRVC");
                            },
                          ));
                        },
                        child: Container(
                          margin : EdgeInsets.fromLTRB(0 * (MediaQuery.of(context).size.width / 360), 5 * (MediaQuery.of(context).size.height / 360),
                              0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360)),
                          padding : EdgeInsets.fromLTRB(15 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360),
                              10 * (MediaQuery.of(context).size.width / 360), 5 * (MediaQuery.of(context).size.height / 360)),
                          decoration: BoxDecoration (
                              color: Colors.white,
                              border : Border(
                                  bottom: BorderSide(
                                      color: widget.table_nm == "AGENCY_SRVC"
                                          ? Color(0xffE47421)
                                          : Color(0xffF3F6F8),
                                      width : 2 * (MediaQuery.of(context).size.width / 360)
                                  )
                              )
                          ),
                          child: Text(
                            "비자 서비스",
                            style: TextStyle(
                              fontSize: 15 * (MediaQuery.of(context).size.width / 360),
                              color: Color(0xff151515),
                              fontWeight: FontWeight.w800,
                              fontFamily: 'NanumSquareR',
                              // height: 1.5 * (MediaQuery.of(context).size.width / 360),
                            ),
                          ),
                        ),
                      )
                  ),
                  //if(widget.table_nm == "REAL_ESTATE")
                  //Container(
                  //  key: servicecat_key,
                  //  child : TextButton(
                  //    style: TextButton.styleFrom(
                  //        padding: EdgeInsets.zero,
                  //        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  //        alignment: Alignment.center
                  //    ),
                  //    onPressed: (){
                  //      Navigator.push(context, MaterialPageRoute(
                  //        builder: (context) {
                  //          return Counseling_guide(table_nm : "REAL_ESTATE");
                  //        },
                  //      ));
                  //    },
                  //    child: Container(
                  //      margin : EdgeInsets.fromLTRB(0 * (MediaQuery.of(context).size.width / 360), 5 * (MediaQuery.of(context).size.height / 360),
                  //          0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360)),
                  //      padding : EdgeInsets.fromLTRB(15 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360),
                  //          10 * (MediaQuery.of(context).size.width / 360), 5 * (MediaQuery.of(context).size.height / 360)),
                  //      decoration: BoxDecoration (
                  //          color: Colors.white,
                  //          border : Border(
                  //              bottom: BorderSide(
                  //                  color: widget.table_nm == "REAL_ESTATE"
                  //                      ? Color(0xffE47421)
                  //                      : Color(0xffF3F6F8),
                  //                  width : 2 * (MediaQuery.of(context).size.width / 360)
                  //              )
                  //          )
                  //      ),
                  //      child: Text(
                  //        "부동산 상담 신청",
                  //        style: TextStyle(
                  //          fontSize: 15 * (MediaQuery.of(context).size.width / 360),
                  //          color: Color(0xff151515),
                  //          fontWeight: FontWeight.w800,
                  //          fontFamily: 'NanumSquareR',
                  //          // height: 1.5 * (MediaQuery.of(context).size.width / 360),
                  //        ),
                  //      ),
                  //    ),
                  //  )
                  //),
                  //if(widget.table_nm != "REAL_ESTATE")
                  //Container(
                  //    child : TextButton(
                  //      style: TextButton.styleFrom(
                  //          padding: EdgeInsets.zero,
                  //          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  //          alignment: Alignment.center
                  //      ),
                  //      onPressed: (){
                  //        Navigator.push(context, MaterialPageRoute(
                  //          builder: (context) {
                  //            return Counseling_guide(table_nm : "REAL_ESTATE");
                  //          },
                  //        ));
                  //      },
                  //      child: Container(
                  //        margin : EdgeInsets.fromLTRB(0 * (MediaQuery.of(context).size.width / 360), 5 * (MediaQuery.of(context).size.height / 360),
                  //            0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360)),
                  //        padding : EdgeInsets.fromLTRB(15 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360),
                  //            10 * (MediaQuery.of(context).size.width / 360), 5 * (MediaQuery.of(context).size.height / 360)),
                  //        decoration: BoxDecoration (
                  //            color: Colors.white,
                  //            border : Border(
                  //                bottom: BorderSide(
                  //                    color: widget.table_nm == "REAL_ESTATE"
                  //                        ? Color(0xffE47421)
                  //                        : Color(0xffF3F6F8),
                  //                    width : 2 * (MediaQuery.of(context).size.width / 360)
                  //                )
                  //            )
                  //        ),
                  //        child: Text(
                  //          "부동산 상담 신청",
                  //          style: TextStyle(
                  //            fontSize: 15 * (MediaQuery.of(context).size.width / 360),
                  //            color: Color(0xff151515),
                  //            fontWeight: FontWeight.w800,
                  //            fontFamily: 'NanumSquareR',
                  //            // height: 1.5 * (MediaQuery.of(context).size.width / 360),
                  //          ),
                  //        ),
                  //      ),
                  //    )
                  //),
                  /*if(widget.table_nm == "REAL_ESTATE_INTRP_SRVC")
                    Container(
                        key: servicecat_key,
                        child : TextButton(
                          style: TextButton.styleFrom(
                              padding: EdgeInsets.zero,
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              alignment: Alignment.center
                          ),
                          onPressed: (){
                            Navigator.push(context, MaterialPageRoute(
                              builder: (context) {
                                return Service(table_nm : "REAL_ESTATE_INTRP_SRVC");
                              },
                            ));
                          },
                          child: Container(
                            margin : EdgeInsets.fromLTRB(0 * (MediaQuery.of(context).size.width / 360), 5 * (MediaQuery.of(context).size.height / 360),
                                0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360)),
                            padding : EdgeInsets.fromLTRB(15 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360),
                                10 * (MediaQuery.of(context).size.width / 360), 5 * (MediaQuery.of(context).size.height / 360)),
                            decoration: BoxDecoration (
                                color: Colors.white,
                                border : Border(
                                    bottom: BorderSide(
                                        color: widget.table_nm == "REAL_ESTATE_INTRP_SRVC"
                                            ? Color(0xffE47421)
                                            : Color(0xffF3F6F8),
                                        width : 2 * (MediaQuery.of(context).size.width / 360)
                                    )
                                )
                            ),
                            child: Text(
                              "부동산통역서비스",
                              style: TextStyle(
                                fontSize: 15 * (MediaQuery.of(context).size.width / 360),
                                color: Color(0xff151515),
                                fontWeight: FontWeight.w800,
                                fontFamily: 'NanumSquareR',
                                // height: 1.5 * (MediaQuery.of(context).size.width / 360),
                              ),
                            ),
                          ),
                        )
                    ),
                  if(widget.table_nm != "REAL_ESTATE_INTRP_SRVC")
                    Container(
                        child : TextButton(
                          style: TextButton.styleFrom(
                              padding: EdgeInsets.zero,
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              alignment: Alignment.center
                          ),
                          onPressed: (){
                            Navigator.push(context, MaterialPageRoute(
                              builder: (context) {
                                return Service(table_nm : "REAL_ESTATE_INTRP_SRVC");
                              },
                            ));
                          },
                          child: Container(
                            margin : EdgeInsets.fromLTRB(0 * (MediaQuery.of(context).size.width / 360), 5 * (MediaQuery.of(context).size.height / 360),
                                0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360)),
                            padding : EdgeInsets.fromLTRB(15 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360),
                                10 * (MediaQuery.of(context).size.width / 360), 5 * (MediaQuery.of(context).size.height / 360)),
                            decoration: BoxDecoration (
                                color: Colors.white,
                                border : Border(
                                    bottom: BorderSide(
                                        color: widget.table_nm == "REAL_ESTATE_INTRP_SRVC"
                                            ? Color(0xffE47421)
                                            : Color(0xffF3F6F8),
                                        width : 2 * (MediaQuery.of(context).size.width / 360)
                                    )
                                )
                            ),
                            child: Text(
                              "부동산통역서비스",
                              style: TextStyle(
                                fontSize: 15 * (MediaQuery.of(context).size.width / 360),
                                color: Color(0xff151515),
                                fontWeight: FontWeight.w800,
                                fontFamily: 'NanumSquareR',
                                // height: 1.5 * (MediaQuery.of(context).size.width / 360),
                              ),
                            ),
                          ),
                        )
                    ),*/
                ],
              ),
            ),

          );
  }

  Container banner(BuildContext context) {
    return Container( //배너 이미지
      width: 350 * (MediaQuery.of(context).size.width / 360),
      height: 55 * (MediaQuery.of(context).size.height / 360),
      child: getBanner,
    );
  }

  Visibility apply(BuildContext context) {
    return Visibility(
              visible : apply_visible,
              child : Container(
                width: 340 * (MediaQuery.of(context).size.width / 360),
                height: 30 * (MediaQuery.of(context).size.height / 360),
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
                            print("체크");
                            if (_formKey.currentState!.validate()) {
                              print("체크2");
                              if(click_check == 1) {
                                print("체크3");
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
                            Text('신청하기', style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold, color: click_check == 0 ? Color(0xffE47421) : Colors.white),textAlign: TextAlign.center,),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
          );
  }

  Visibility paymentInformation(BuildContext context) {
    return Visibility(
            visible : paymentinformation_visible,
            child : Container(
              width: 360 * (MediaQuery.of(context).size.width / 360),
              height: 120 * (MediaQuery.of(context).size.height / 360),
              margin: EdgeInsets.fromLTRB(15 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360),
                  15 * (MediaQuery.of(context).size.width / 360), 15 * (MediaQuery.of(context).size.height / 360) ),
              padding: EdgeInsets.fromLTRB(0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360),
                  0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360) ),
              decoration: BoxDecoration(
                color: Color(0xffFFFFFF),
                border: Border.all(
                  color: Colors.white,  width: 5 * (MediaQuery.of(context).size.width / 360),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    spreadRadius: 1,
                    blurRadius: 1,
                    offset: Offset(0, 1), // changes position of shadow
                  ),
                ],
              ),
              child: Column(
                children: [
                  Container(
                    width: 330 * (MediaQuery.of(context).size.width / 360),
                    // height: 16 * (MediaQuery.of(context).size.height / 360),
                    margin: EdgeInsets.fromLTRB(15 * (MediaQuery.of(context).size.width / 360), 5 * (MediaQuery.of(context).size.height / 360),
                        0 * (MediaQuery.of(context).size.width / 360), 5 * (MediaQuery.of(context).size.height / 360) ),
                    padding: EdgeInsets.fromLTRB(5 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360),
                        0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360) ),
                    decoration: BoxDecoration(
                      border: Border(
                          left: BorderSide(color: Color(0xffE47421),  width: 4 * (MediaQuery.of(context).size.width / 360),),
                      ),
                    ),
                    child: Text("결제 정보", style: TextStyle(
                        fontSize: 22,
                        fontFamily: 'NanumSquareR',
                        fontWeight: FontWeight.w800
                      ),
                    )
                  ),
                  Container(
                    width: 330 * (MediaQuery.of(context).size.width / 360),
                    height: 75 * (MediaQuery.of(context).size.height / 360),
                    margin : EdgeInsets.fromLTRB(15 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360),
                        15 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360) ),
                    decoration: BoxDecoration(
                      border: Border(
                        top: BorderSide(color: Color(0xffE47421),  width: 1 * (MediaQuery.of(context).size.width / 360),),
                      ),
                    ),
                    child: Column(
                      children: [
                        Container(
                          width: 330 * (MediaQuery.of(context).size.width / 360),
                          // height: 10 * (MediaQuery.of(context).size.height / 360),
                          margin : EdgeInsets.fromLTRB(0 * (MediaQuery.of(context).size.width / 360), 5 * (MediaQuery.of(context).size.height / 360),
                              0 * (MediaQuery.of(context).size.width / 360), 5 * (MediaQuery.of(context).size.height / 360) ),
                          child: Row(
                            children: [
                              Container(
                                width: 140 * (MediaQuery.of(context).size.width / 360),
                                child : Text("서비스 금액", style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w800,
                                  ),
                                )
                              ),
                              Container(
                                width: 150 * (MediaQuery.of(context).size.width / 360),
                                child : Text(
                                  NumberFormat('###,###,###,###').format(int.parse('${service_money + time_discount + level_discount + distance_discount + basic_time_discount}')).replaceAll(' ', '')
                                      +" VND", style: TextStyle(
                                    fontSize: 16,
                                  fontWeight: FontWeight.w800,
                                  ),
                                  textAlign: TextAlign.end,
                                )
                              ),
                            ],
                          ),
                        ),
                        Container(
                          width: 330 * (MediaQuery.of(context).size.width / 360),
                          height: 55 * (MediaQuery.of(context).size.height / 360),
                          margin : EdgeInsets.fromLTRB(0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360),
                              0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360) ),
                          decoration: BoxDecoration(
                            color: Color.fromRGBO(243, 246, 248, 1),
                            borderRadius: BorderRadius.circular(2 * (MediaQuery.of(context).size.height / 360)),
                          ),
                          child: Column(
                            children: [
                              Container(
                                // height: 15 * (MediaQuery.of(context).size.height / 360),

                                margin : EdgeInsets.fromLTRB(0 * (MediaQuery.of(context).size.width / 360), 10 * (MediaQuery.of(context).size.height / 360),
                                    0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360) ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text("보유포인트 : ", style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w400,

                                    ),
                                    ),
                                    Container(
                                      constraints: BoxConstraints(maxWidth : 180 * (MediaQuery.of(context).size.width / 360)),
                                      child: Text(
                                        NumberFormat('###,###,###,###').format(int.parse('${point}')).replaceAll(' ', '') + " P",
                                        style: TextStyle(color: Color.fromRGBO(228, 116, 33, 1),
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                      ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                width: 260 * (MediaQuery.of(context).size.width / 360),
                                //height: 20 * (MediaQuery.of(context).size.height / 360),
                                margin : EdgeInsets.fromLTRB(0 * (MediaQuery.of(context).size.width / 360), 5 * (MediaQuery.of(context).size.height / 360),
                                    0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360) ),
                                padding : EdgeInsets.fromLTRB(0 * (MediaQuery.of(context).size.width / 360), 2 * (MediaQuery.of(context).size.height / 360),
                                    0 * (MediaQuery.of(context).size.width / 360), 2 * (MediaQuery.of(context).size.height / 360)),
                                decoration: BoxDecoration(
                                  color: Color.fromRGBO(255, 255, 255, 1),
                                  borderRadius: BorderRadius.circular(2 * (MediaQuery.of(context).size.height / 360)),
                                ),
                                child: TextFormField(
                                  controller: _pointController,
                                  focusNode: pointNode,
                                  keyboardType: TextInputType.number,
                                  inputFormatters: <TextInputFormatter>[
                                    FilteringTextInputFormatter.digitsOnly,
                                  ],
                                  onChanged: (value) {
                                    setState(() {
                                        if(point! < int.parse(value)) {
                                          _pointController.text = "0";
                                          showDialog(
                                            context: context,
                                            barrierColor: Color(0xffE47421).withOpacity(0.4),
                                            barrierDismissible: false,
                                            builder: (BuildContext context) {
                                              return MediaQuery(
                                                data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
                                                child: textalert(context,'보유한 포인트보다 더 많은 포인트를 설정할 수 없습니다.'),
                                              );
                                            },
                                          );
                                        } else if((service_money + time_discount + level_discount + distance_discount + basic_time_discount)! < int.parse(value)) {
                                          _pointController.text = "0";
                                          showDialog(
                                            context: context,
                                            barrierColor: Color(0xffE47421).withOpacity(0.4),
                                            barrierDismissible: false,
                                            builder: (BuildContext context) {
                                              return MediaQuery(
                                                data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
                                                child: textalert(context,'서비스 포인트보다 더 많은 포인트를 설정할 수 없습니다.'),
                                              );
                                            },
                                          );
                                        }
                                      }
                                    );
                                  },
                                  decoration: InputDecoration(
                                    contentPadding : EdgeInsets.fromLTRB(15 * (MediaQuery.of(context).size.width / 360), 0, 0, 0),
                                    border: InputBorder.none,
                                    // labelText: 'Search',
                                    hintText: '보유포인트를 입력해주세요.',
                                    hintStyle: TextStyle(color:Color(0xffC4CCD0), fontSize: 16),
                                  ),
                                  autovalidateMode: AutovalidateMode.onUserInteraction,
                                  validator: (value) {
                                    value = value?.trim();
                                    if(value == null || value.isEmpty) {
                                      if(widget.table_nm == "ON_SITE") {
                                        if (_selectedValue == "OS_001") {
                                          if(_nameController.text != null && _nameController.text != '' && _phoneController.text != null && _phoneController.text != '' && _addressController.text != null && _addressController.text != '' && _detailAddressController.text != null && _detailAddressController.text != '' && _contsController.text != null && _contsController.text != '') {
                                            pointNode.requestFocus();
                                          }
                                        }
                                        if (_selectedValue == "OS_002") {
                                          if(_nameController.text != null && _nameController.text != '' && _phoneController.text != null && _phoneController.text != '' && _addressController.text != null && _addressController.text != '' && _detailAddressController.text != null && _detailAddressController.text != '' && _contsController.text != null && _contsController.text != '') {

                                          }
                                        }
                                      }

                                      if(widget.table_nm == "INTRP_SRVC") {
                                        if(_nameController.text != null && _nameController.text != '' && _phoneController.text != null && _phoneController.text != '' && _addressController.text != null && _addressController.text != '' && _detailAddressController.text != null && _detailAddressController.text != '' && _contsController.text != null && _contsController.text != '') {
                                          pointNode.requestFocus();
                                        }
                                      }

                                      if(widget.table_nm == "AGENCY_SRVC") {
                                        if(_nameController.text != null && _nameController.text != '' && _phoneController.text != null && _phoneController.text != '' && _contsController.text != null && _contsController.text != '') {

                                        }
                                      }

                                      if(widget.table_nm == "REAL_ESTATE_INTRP_SRVC") {
                                        if(_nameController.text != null && _nameController.text != '' && _phoneController.text != null && _phoneController.text != '' && _contsController.text != null && _contsController.text != '') {

                                        }
                                      }
                                      return "보유포인트를 입력해주세요.";
                                    }
                                    return null;
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: 360 * (MediaQuery.of(context).size.width / 360),
                    // height: 20 * (MediaQuery.of(context).size.height / 360),
                    padding: EdgeInsets.fromLTRB(15 * (MediaQuery.of(context).size.width / 360), 3 * (MediaQuery.of(context).size.height / 360),
                        15 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360) ),
                    child: Row(
                      children: [
                        Container(
                          width: 140 * (MediaQuery.of(context).size.width / 360),
                          margin : EdgeInsets.fromLTRB(0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360),
                              0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360) ),
                            child : Text("현장 결제 금액", style: TextStyle(color: Color.fromRGBO(0, 0, 0, 1), fontSize: 15, fontWeight: FontWeight.bold),)
                        ),
                        Container(
                            width: 150 * (MediaQuery.of(context).size.width / 360),
                            margin : EdgeInsets.fromLTRB(0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360),
                                0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360) ),
                            child : Text(
                              staypoint("${(service_money + time_discount + level_discount + distance_discount + basic_time_discount)}","${_pointController.text}")
                              , style: TextStyle(color: Color.fromRGBO(0, 0, 0, 1), fontSize: 22, fontWeight: FontWeight.bold),textAlign: TextAlign.end,
                            maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            )
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
  }

  // 포인트 계산
  String staypoint(point,s_point) {
    // var point = "";
    var nowpoint = 0;

    if(point != null && point != '' && s_point != null && s_point != '') {
      nowpoint =  int.parse(point) - int.parse(s_point);
    } else{
      nowpoint = int.parse(point);
    }

    point = NumberFormat('###,###,###,###').format(nowpoint).replaceAll(' ', '') + " VND";

    return point;
  }

  Visibility Announcement(BuildContext context) {
    return Visibility(
            visible : announcement_visible,
            child : Container(
              margin : EdgeInsets.fromLTRB(15 * (MediaQuery.of(context).size.width / 360), 5 * (MediaQuery.of(context).size.height / 360),
                  15 * (MediaQuery.of(context).size.width / 360), 8 * (MediaQuery.of(context).size.height / 360)),
              width: 360 * (MediaQuery.of(context).size.width / 360),
              height: 50 * (MediaQuery.of(context).size.height / 360),
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
                        fontSize: 15 * (MediaQuery.of(context).size.width / 360),
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
                      fontSize: 13 * (MediaQuery.of(context).size.width / 360),
                      height: 0.8 * (MediaQuery.of(context).size.height / 360),
                      fontFamily: 'NanumSquareR',
                    ),
                    ),
                  ),
                ],
              ),
            ),
          );
  }

  Visibility Terms(BuildContext context) {
    return Visibility(
            visible : terms_visible,
            child : Container(
              width: 360 * (MediaQuery.of(context).size.width / 360),
              // height: 20 * (MediaQuery.of(context).size.height / 360),
              padding: EdgeInsets.fromLTRB(16 * (MediaQuery.of(context).size.width / 360), 10 * (MediaQuery.of(context).size.height / 360),
                  0 * (MediaQuery.of(context).size.width / 360), 5 * (MediaQuery.of(context).size.height / 360) ),
              child: Text("서비스 이용 약관", style: TextStyle(
                  color: Color.fromRGBO(47, 103, 211, 1),
                  fontSize: 15,
                fontFamily: 'NanumSquareR',

              ),
                textAlign: TextAlign.left,
              ),
            ),
          );
  }

  Visibility conts(BuildContext context) {
    return Visibility(
            visible : conts_visible,
            child : Container(
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
                  contentPadding : EdgeInsets.fromLTRB(5 * (MediaQuery.of(context).size.width / 360), 5 * (MediaQuery.of(context).size.height / 360), 5 * (MediaQuery.of(context).size.width / 360), 0),
                  border: InputBorder.none,
                /*  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                    borderSide: BorderSide(
                      color: Color.fromRGBO(255, 255, 255, 1),
                    ),
                  ),*/
                  // labelText: 'Search',
                  hintText: '출장 요청하실 내용을 입력해주세요',
                  hintStyle: TextStyle(fontSize: 15 * (MediaQuery.of(context).size.width / 360), color:Color(0xffC4CCD0),),
                ),
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (value) {
                  value = value?.trim();
                  if(value == null || value.isEmpty) {
                    if(widget.table_nm == "ON_SITE") {
                      if (_selectedValue == "OS_001") {
                        if(_nameController.text != null && _nameController.text != '' && _phoneController.text != null && _phoneController.text != '' && _addressController.text != null && _addressController.text != '' && _detailAddressController.text != null && _detailAddressController.text != '') {
                          contsNode.requestFocus();
                        }
                      }
                      if (_selectedValue == "OS_002") {
                        if(_nameController.text != null && _nameController.text != '' && _phoneController.text != null && _phoneController.text != '' && _addressController.text != null && _addressController.text != '' && _detailAddressController.text != null && _detailAddressController.text != '') {
                          contsNode.requestFocus();
                        }
                      }
                    }

                    if(widget.table_nm == "INTRP_SRVC") {
                      if(_nameController.text != null && _nameController.text != '' && _phoneController.text != null && _phoneController.text != '' && _addressController.text != null && _addressController.text != '' && _detailAddressController.text != null && _detailAddressController.text != '') {
                        contsNode.requestFocus();
                      }
                    }

                    if(widget.table_nm == "AGENCY_SRVC") {
                      if(_nameController.text != null && _nameController.text != '' && _phoneController.text != null && _phoneController.text != '') {
                        contsNode.requestFocus();
                      }
                    }

                    if(widget.table_nm == "REAL_ESTATE_INTRP_SRVC") {
                      if(_nameController.text != null && _nameController.text != '' && _phoneController.text != null && _phoneController.text != '') {
                        contsNode.requestFocus();
                      }
                    }
                    return "내용을 입력해주세요.";
                  }
                  return null;
                },
                style: TextStyle(fontSize: 15 * (MediaQuery.of(context).size.width / 360),fontFamily: ''),
              ),
            ),
          );
  }

  Visibility time(BuildContext context) {
    return Visibility(
            visible : time_visible,
            child : Container(
              width: 360 * (MediaQuery.of(context).size.width / 360),
              height: 25 * (MediaQuery.of(context).size.height / 360),
              margin : EdgeInsets.fromLTRB(15 * (MediaQuery.of(context).size.width / 360), 5 * (MediaQuery.of(context).size.height / 360),
                  15 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360)),
              child: Row(
                children: <Widget>[

                  GestureDetector(
                    child : Container(
                      width: 160 * (MediaQuery.of(context).size.width / 360),
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
                          if(_startTimeController.text == "")
                          Container(
                            margin : EdgeInsets.fromLTRB(15 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360),
                                0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360)),
                            width: 110 * (MediaQuery.of(context).size.width / 360),
                            child :
                            Text('시작일', style: TextStyle(color: Color(0xffC4CCD0), fontSize: 15 * (MediaQuery.of(context).size.width / 360)),),
                          ),
                          if(_startTimeController.text != "")
                            Container(
                              margin : EdgeInsets.fromLTRB(15 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360),
                                  0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360)),
                              width: 110 * (MediaQuery.of(context).size.width / 360),
                              child :
                              Text(_startTimeController.text, style: TextStyle(fontSize: 15 * (MediaQuery.of(context).size.width / 360),),),
                            ),
                           Container(
                              width: 30 * (MediaQuery.of(context).size.width / 360),
                               child : Image(image: AssetImage("assets/edit_calendar.png",), width: 10 * (MediaQuery.of(context).size.width / 360), height : 10 * (MediaQuery.of(context).size.height / 360),)
                              /*child : Icon(Icons.edit_calendar, size: 20,),*/
                            ),
                        ],
                      ),
                    ),
                    onTap : () async {
                    final route = MaterialPageRoute(builder: (context) => ServiceTime(time : _endTimeController.text, time_type: "start_time",));
                    final addResult = await Navigator.push(context, route);
                    _startTimeController.text = addResult;
                    setState(() {

                    });
                    initgetdiscountfee(_selectedValue.toString()).then((_) {
                      setState(() {

                        if(_startTimeController.text != null && _startTimeController.text.isNotEmpty && _endTimeController.text != null && _endTimeController.text.isNotEmpty) {
                          int diffrencee = int.parse(DateTime.parse(_endTimeController.text.toString()).difference(DateTime.parse(_startTimeController.text.toString())).inHours.toString());
                          int discount = 0;
                          String discount_unit = "";
                          print("시간체크");
                          print(diffrencee);

                          List<dynamic> timelist = [];

                          for(int i = 0; i < discountfeeList.length; i++) {
                            if(discountfeeList[i]["time_cost_use_yn"] == "Y") {
                              if (discountfeeList[i]["time"] != null && discountfeeList[i]["time"] != "") {
                                timelist.add(discountfeeList[i]);
                              }
                            }
                          }

                          for(int cnt = 0; cnt < timelist.length; cnt++) {
                            var money = timelist[cnt]["money"].toString();
                            var money_type = money.toString().substring(0,1);

                            if(money_type == "+" || money_type == "-") { // 음수 양수 구분
                              if(int.parse(timelist[cnt]["time"]) == diffrencee) { // 신청시간 체크하여 서비스 할인,증액 비용 시간 비교하여 동일 시간 체크
                                time_money_type = money_type;
                                if(money_type == "-") {  // 음수의 경우 그대로 사용하여 서비스 금액 계산시 2~3중으로 계산 안하도록 처리
                                  discount = int.parse(money);
                                  discount_unit = timelist[cnt]["money_unit"];
                                } else { // 양수의 경우 + 기호 삭제하여 서비스 금액 계산시 정상적으로 계산 되도록 기호 삭제처리
                                  discount = int.parse(money.substring(1, money.length));
                                  discount_unit = timelist[cnt]["money_unit"];
                                }
                              }
                            } else {
                              if(int.parse(timelist[cnt]["time"]) == diffrencee) {
                                time_money_type = "+";
                                discount = int.parse(money);
                                discount_unit = timelist[cnt]["money_unit"];
                              }
                            }

                          }

                          if(timelist.length > 0) {
                            if(discount == 0) {

                              var money = timelist[0]["money"].toString();
                              var money_type = money.toString().substring(0,1);

                              if(money.toString().substring(0,1) == "+" || money.toString().substring(0,1) == "-") {
                                if(int.parse(timelist[0]["time"]) <= diffrencee) {
                                  time_money_type = money_type;

                                  if(money_type == "-") {
                                    discount = int.parse(money);
                                    discount_unit = timelist[0]["money_unit"];
                                  } else {
                                    discount = int.parse(money.substring(1, money.length));
                                    discount_unit = timelist[0]["money_unit"];
                                  }

                                }
                              } else {
                                if(int.parse(timelist[0]["time"]) <= diffrencee) {
                                  time_money_type = "+";
                                  discount = int.parse(money);
                                  discount_unit = timelist[0]["money_unit"];
                                }
                              }
                              if(discount == 0) {
                                diffrencee = diffrencee - 1;
                              }
                            }

                            if(discount_unit != null && discount_unit != "") {
                              if(discount_unit == "P") {
                                service_fee = service_fee + time_discount;
                                service_fee = service_fee - (service_fee * (discount / 100)).toInt();
                                time_discount = (service_money * (discount / 100)).toInt().floor();
                              }
                              if(discount_unit == "C") {
                                service_fee = service_fee + time_discount;
                                service_fee = service_fee - discount;
                                time_discount = discount;
                              }
                            }

                            if(discount_unit == null || discount_unit == "") {
                              service_fee = service_fee + time_discount;
                            }
                          }
                        }

                        if(_startTimeController.text != null && _startTimeController.text.isNotEmpty && _endTimeController.text != null && _endTimeController.text.isNotEmpty) {
                          int diffrencee = int.parse(DateTime.parse(_endTimeController.text.toString()).difference(DateTime.parse(_startTimeController.text.toString())).inHours.toString());
                          int discount = 0;
                          String discount_unit = "";
                          print("시간체크");
                          print(diffrencee);

                          List<dynamic> timelist = [];

                          for(int i = 0; i < discountfeeList.length; i++) {
                            if(discountfeeList[i]["cost_type"] == "B") {
                              if (discountfeeList[i]["time"] != null && discountfeeList[i]["time"] != "") {
                                timelist.add(discountfeeList[i]);
                              }
                            }
                          }

                          for(int cnt = 0; cnt < timelist.length; cnt++) {
                            var money = timelist[cnt]["money"].toString();
                            var money_type = money.toString().substring(0,1);

                            if(money_type == "+" || money_type == "-") { // 음수 양수 구분
                              if(int.parse(timelist[cnt]["time"]) == diffrencee) { // 신청시간 체크하여 서비스 할인,증액 비용 시간 비교하여 동일 시간 체크
                                if(money_type == "-") {  // 음수의 경우 그대로 사용하여 서비스 금액 계산시 2~3중으로 계산 안하도록 처리
                                  discount = int.parse(money);
                                  discount_unit = timelist[cnt]["money_unit"];
                                } else { // 양수의 경우 + 기호 삭제하여 서비스 금액 계산시 정상적으로 계산 되도록 기호 삭제처리
                                  discount = int.parse(money.substring(1, money.length));
                                  discount_unit = timelist[cnt]["money_unit"];
                                }
                              }
                            } else {
                              if(int.parse(timelist[cnt]["time"]) == diffrencee) {
                                discount = int.parse(money);
                                discount_unit = timelist[cnt]["money_unit"];
                              }
                            }

                          }

                          if(timelist.length > 0) {
                            if(discount == 0) {

                              var money = timelist[0]["money"].toString();
                              var money_type = money.toString().substring(0,1);

                              if(money.toString().substring(0,1) == "+" || money.toString().substring(0,1) == "-") {
                                if(int.parse(timelist[0]["time"]) <= diffrencee) {

                                  if(money_type == "-") {
                                    discount = int.parse(money);
                                    discount_unit = timelist[0]["money_unit"];
                                  } else {
                                    discount = int.parse(money.substring(1, money.length));
                                    discount_unit = timelist[0]["money_unit"];
                                  }

                                }
                              } else {
                                if(int.parse(timelist[0]["time"]) <= diffrencee) {
                                  discount = int.parse(money);
                                  discount_unit = timelist[0]["money_unit"];
                                }
                              }
                              if(discount == 0) {
                                diffrencee = diffrencee - 1;
                              }
                            }

                            if(discount_unit != null && discount_unit != "") {
                              if(discount_unit == "P") {
                                basic_time_discount = (service_money * (discount / 100)).toInt().floor();
                              }
                              if(discount_unit == "C") {
                                basic_time_discount = discount;
                              }
                            }
                          }
                        }


                      });
                    });
                  },
                  ),
                  SizedBox(width: 10 * (MediaQuery.of(context).size.width / 360)),
                  GestureDetector(
                    child : Container(
                    width: 160 * (MediaQuery.of(context).size.width / 360),
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
                        if(_endTimeController.text == "")
                          Container(
                            margin : EdgeInsets.fromLTRB(15 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360),
                                0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360)),
                            width: 110 * (MediaQuery.of(context).size.width / 360),
                            child :
                            Text('종료일', style: TextStyle(color: Color(0xffC4CCD0), fontSize: 15 * (MediaQuery.of(context).size.width / 360)),),
                          ),
                        if(_endTimeController.text != "")
                          Container(
                            margin : EdgeInsets.fromLTRB(15 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360),
                                0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360)),
                            width: 110 * (MediaQuery.of(context).size.width / 360),
                            child :
                            Text(_endTimeController.text , style: TextStyle(fontSize: 15 * (MediaQuery.of(context).size.width / 360),),),
                          ),
                        Container(
                            width: 30 * (MediaQuery.of(context).size.width / 360),
                            child : Image(image: AssetImage("assets/edit_calendar.png",), width: 10 * (MediaQuery.of(context).size.width / 360), height : 10 * (MediaQuery.of(context).size.height / 360),)
                            /*child : Icon(Icons.edit_calendar, size: 20,),*/
                          ),
                      ],
                    ),
                  ),
                    onTap : () async {
                      final route = MaterialPageRoute(builder: (context) => ServiceTime(time : _startTimeController.text, time_type: "end_time",));
                      final addResult = await Navigator.push(context, route);
                      _endTimeController.text = addResult ?? "";
                      setState(() {

                      });
                      initgetdiscountfee(_selectedValue.toString()).then((_) {
                        setState(() {

                          if(_startTimeController.text != null && _startTimeController.text.isNotEmpty && _endTimeController.text != null && _endTimeController.text.isNotEmpty) {
                            int diffrencee = int.parse(DateTime.parse(_endTimeController.text.toString()).difference(DateTime.parse(_startTimeController.text.toString())).inHours.toString());
                            int discount = 0;
                            String discount_unit = "";
                            print("시간체크");
                            print(diffrencee);

                            List<dynamic> timelist = [];

                            for(int i = 0; i < discountfeeList.length; i++) {
                              if(discountfeeList[i]["time_cost_use_yn"] == "Y") {
                                if (discountfeeList[i]["time"] != null && discountfeeList[i]["time"] != "") {
                                  timelist.add(discountfeeList[i]);
                                }
                              }
                            }

                            for(int cnt = 0; cnt < timelist.length; cnt++) {

                              var money = timelist[cnt]["money"].toString();
                              var money_type = money.toString().substring(0,1);

                              if(money_type == "+" || money_type == "-") { // 음수 양수 구분
                                if(int.parse(timelist[cnt]["time"]) == diffrencee) { // 신청시간 체크하여 서비스 할인,증액 비용 시간 비교하여 동일 시간 체크
                                  time_money_type = money_type;
                                  if(money_type == "-") {  // 음수의 경우 그대로 사용하여 서비스 금액 계산시 2~3중으로 계산 안하도록 처리
                                    discount = int.parse(money);
                                    discount_unit = timelist[cnt]["money_unit"];
                                  } else { // 양수의 경우 + 기호 삭제하여 서비스 금액 계산시 정상적으로 계산 되도록 기호 삭제처리
                                    discount = int.parse(money.substring(1, money.length));
                                    discount_unit = timelist[cnt]["money_unit"];
                                  }
                                }
                              } else {
                                if(int.parse(timelist[cnt]["time"]) == diffrencee) {
                                  time_money_type = "+";
                                  discount = int.parse(money);
                                  discount_unit = timelist[cnt]["money_unit"];
                                }
                              }

                            }

                            if(timelist.length > 0) {
                              if(discount == 0) {

                                var money = timelist[0]["money"].toString();
                                var money_type = money.toString().substring(0,1);

                                if(money.toString().substring(0,1) == "+" || money.toString().substring(0,1) == "-") {
                                  if(int.parse(timelist[0]["time"]) <= diffrencee) {
                                    time_money_type = money_type;

                                    if(money_type == "-") {
                                      discount = int.parse(money);
                                      discount_unit = timelist[0]["money_unit"];
                                    } else {
                                      discount = int.parse(money.substring(1, money.length));
                                      discount_unit = timelist[0]["money_unit"];
                                    }

                                  }
                                } else {
                                  if(int.parse(timelist[0]["time"]) <= diffrencee) {
                                    time_money_type = "+";
                                    discount = int.parse(money);
                                    discount_unit = timelist[0]["money_unit"];
                                  }
                                }
                                if(discount == 0) {
                                  diffrencee = diffrencee - 1;
                                }
                              }

                              print("discount_unit");
                              print(discount_unit);

                              if(discount_unit != null && discount_unit != "") {
                                if(discount_unit == "P") {
                                  service_fee = service_fee + time_discount;
                                  time_discount = (service_fee * (discount / 100)).toInt();
                                  service_fee = service_fee - (service_fee * (discount / 100)).toInt();
                                  time_discount = (service_money * (discount / 100)).toInt();
                                }
                                if(discount_unit == "C") {
                                  service_fee = service_fee + time_discount;
                                  time_discount = discount;
                                  service_fee = service_fee - discount;
                                  time_discount = discount;
                                }
                              }

                              if(discount_unit == null || discount_unit == "") {
                                service_fee = service_fee + time_discount;
                              }
                            }

                            print("time_discount");
                            print(time_discount);

                          }

                          if(_startTimeController.text != null && _startTimeController.text.isNotEmpty && _endTimeController.text != null && _endTimeController.text.isNotEmpty) {
                            int diffrencee = int.parse(DateTime.parse(_endTimeController.text.toString()).difference(DateTime.parse(_startTimeController.text.toString())).inHours.toString());
                            int discount = 0;
                            String discount_unit = "";
                            print("시간체크");
                            print(diffrencee);

                            List<dynamic> timelist = [];

                            for(int i = 0; i < discountfeeList.length; i++) {
                              if(discountfeeList[i]["cost_type"] == "B") {
                                if (discountfeeList[i]["time"] != null && discountfeeList[i]["time"] != "") {
                                  timelist.add(discountfeeList[i]);
                                }
                              }
                            }

                            for(int cnt = 0; cnt < timelist.length; cnt++) {
                              var money = timelist[cnt]["money"].toString();
                              var money_type = money.toString().substring(0,1);
                              print(money); print(money_type);
                              if(money_type == "+" || money_type == "-") { // 음수 양수 구분
                                if(int.parse(timelist[cnt]["time"]) == diffrencee) { // 신청시간 체크하여 서비스 할인,증액 비용 시간 비교하여 동일 시간 체크
                                  if(money_type == "-") {  // 음수의 경우 그대로 사용하여 서비스 금액 계산시 2~3중으로 계산 안하도록 처리
                                    discount = int.parse(money);
                                    discount_unit = timelist[cnt]["money_unit"];
                                  } else { // 양수의 경우 + 기호 삭제하여 서비스 금액 계산시 정상적으로 계산 되도록 기호 삭제처리
                                    discount = int.parse(money.substring(1, money.length));
                                    discount_unit = timelist[cnt]["money_unit"];
                                  }
                                }
                              } else {
                                if(int.parse(timelist[cnt]["time"]) == diffrencee) {
                                  discount = int.parse(money);
                                  discount_unit = timelist[cnt]["money_unit"];
                                }
                              }

                            }

                            if(timelist.length > 0) {
                              if(discount == 0) {

                                var money = timelist[0]["money"].toString();
                                var money_type = money.toString().substring(0,1);

                                if(money.toString().substring(0,1) == "+" || money.toString().substring(0,1) == "-") {
                                  if(int.parse(timelist[0]["time"]) <= diffrencee) {

                                    if(money_type == "-") {
                                      discount = int.parse(money);
                                      discount_unit = timelist[0]["money_unit"];
                                    } else {
                                      discount = int.parse(money.substring(1, money.length));
                                      discount_unit = timelist[0]["money_unit"];
                                    }

                                  }
                                } else {
                                  if(int.parse(timelist[0]["time"]) <= diffrencee) {
                                    discount = int.parse(money);
                                    discount_unit = timelist[0]["money_unit"];
                                  }
                                }
                                if(discount == 0) {
                                  diffrencee = diffrencee - 1;
                                }
                              }

                              if(discount_unit != null && discount_unit != "") {
                                if(discount_unit == "P") {
                                  basic_time_discount = (service_money * (discount / 100)).toInt().floor();
                                }
                                if(discount_unit == "C") {
                                  basic_time_discount = discount;
                                }
                              }
                            }
                          }

                        });
                      });
                  },
                  )
                ],
              ),
            ),
          );
  }

  Visibility level(BuildContext context) {
    return Visibility(
            visible : level_visible,
            child : Container(
              width : 360 * (MediaQuery.of(context).size.width / 360),
              //height : 25 * (MediaQuery.of(context).size.height / 360),
              margin : EdgeInsets.fromLTRB(15 * (MediaQuery.of(context).size.width / 360), 5 * (MediaQuery.of(context).size.height / 360),
                  15 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360)),
              padding : EdgeInsets.fromLTRB(0 * (MediaQuery.of(context).size.width / 360), 2 * (MediaQuery.of(context).size.height / 360),
                  0 * (MediaQuery.of(context).size.width / 360), 2 * (MediaQuery.of(context).size.height / 360)),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(3 * (MediaQuery.of(context).size.height / 360)),
                border: Border.all(
                  color:Color(0xffF3F6F8),
                ),
              ),
              child: DropdownButtonHideUnderline(
                  child : DropdownButtonFormField2 (
                    isExpanded: true,
                    value : _levelCategoryValue,
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
                    hint: Text("번역 수준", style: TextStyle(fontSize: 14 * (MediaQuery.of(context).size.width / 360), color: Color(0xffC4CCD0)),),
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
                      return cat02.map<Widget>((item) {
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
                    items: cat02.map((serviceVO item) =>
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
                      this._levelCategoryValue = value;
                      _pointController.text = "";
                      setState(() {
                        /*if(value == "OS_001") {
                      visible_category1 = true;
                      visible_category2 = true;
                    }
                    if(value == "OS_002") {
                      visible_category1 = true;
                      visible_category2 = false;
                    }*/
                      });
                      initgetdiscountfee(_selectedValue.toString()).then((_) {
                        setState(() {

                          List<dynamic> levelList = [];

                          for(int i = 0; i < discountfeeList.length; i++) {
                            if(discountfeeList[i]["interpretation_cost_use_yn"] == "Y") {
                              if (discountfeeList[i]["level"] != null && discountfeeList[i]["level"] != "") {
                                levelList.add(discountfeeList[i]);
                              }
                            }
                          }

                          int discount = 0;
                          String discount_unit = "";
                          for(int cnt = 0; cnt < levelList.length; cnt++) {
                            if(levelList[cnt]["interpretation_cost_use_yn"] == "Y") {
                              if(levelList[cnt]["level"] == value) {

                                var money = levelList[cnt]["money"].toString();
                                var money_type = money.substring(0,1);

                                if(money_type == "+" || money_type == "-") {
                                  if(money_type == "+") {
                                    discount = int.parse(money.substring(1, money.length));
                                    discount_unit = levelList[cnt]["money_unit"];
                                  } else {
                                    discount = int.parse(money);
                                    discount_unit = levelList[cnt]["money_unit"];
                                  }


                                } else {

                                  discount = int.parse(levelList[cnt]["money"]);
                                  discount_unit = levelList[cnt]["money_unit"];

                                }
                              }
                            }
                          }

                          print("discount_unit");
                          print(discount_unit);

                          if(discount_unit != null && discount_unit != "") {
                            if(discount_unit == "P") {
                              service_fee = service_fee + level_discount;
                              level_discount = (service_fee * (discount / 100)).floor() as int;
                              service_fee = service_fee - (service_fee * (discount / 100)).floor() as int;
                            }
                            if(discount_unit == "C") {
                              service_fee = service_fee + level_discount;
                              level_discount = discount;
                              service_fee = service_fee - discount;
                            }
                          }
                          if(discount == 0) {
                            service_fee = service_fee + level_discount;
                            level_discount = 0;
                          }

                        });
                      });


                    }),
                  )
              ),
            ),
          );
  }

  Visibility detailAddress(BuildContext context) {
    return Visibility(
            visible : address_detail_visible,
            child : Container(
              width: 360 * (MediaQuery.of(context).size.width / 360),
              //height: 25 * (MediaQuery.of(context).size.height / 360),
              margin : EdgeInsets.fromLTRB(15 * (MediaQuery.of(context).size.width / 360), 5 * (MediaQuery.of(context).size.height / 360),
                  15 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360)),
              padding : EdgeInsets.fromLTRB(0 * (MediaQuery.of(context).size.width / 360), 2 * (MediaQuery.of(context).size.height / 360),
                  0 * (MediaQuery.of(context).size.width / 360), 2 * (MediaQuery.of(context).size.height / 360)),
              decoration: BoxDecoration(
                border: Border.all(
                    color: Color.fromRGBO(243, 246, 248, 1)
                ),
                borderRadius: BorderRadius.circular(3 * (MediaQuery.of(context).size.height / 360)),
                color: Color.fromRGBO(255, 255, 255, 1),
              ),
              child: Row(
                children: [
                  Container(
                    width: 325 * (MediaQuery.of(context).size.width / 360),
                    /*padding : EdgeInsets.fromLTRB(10 * (MediaQuery.of(context).size.height / 360), 0 * (MediaQuery.of(context).size.height / 360),
                        3 * (MediaQuery.of(context).size.height / 360), 0 * (MediaQuery.of(context).size.height / 360)),*/
                    child: TextFormField(
                      controller: _detailAddressController,
                      focusNode : detailAddressNode,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        contentPadding : EdgeInsets.fromLTRB(15 * (MediaQuery.of(context).size.width / 360), 0, 0, 0),
                        /*enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(5)),
                          borderSide: BorderSide(
                            color: Color.fromRGBO(255, 255, 255, 1),
                          ),
                        ),*/
                        // labelText: 'Search',
                        hintText: '상세주소',
                        hintStyle: TextStyle(fontSize: 15 * (MediaQuery.of(context).size.width / 360), color:Color(0xffC4CCD0),),
                      ),
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (value) {
                        value = value?.trim();
                        if(value == null || value.isEmpty) {
                          if(widget.table_nm == "ON_SITE") {
                            if (_selectedValue == "OS_001") {
                              if(_nameController.text != null && _nameController.text != '' && _phoneController.text != null && _phoneController.text != '' && _addressController.text != null && _addressController.text != '') {
                                detailAddressNode.requestFocus();
                              }
                            }
                            if (_selectedValue == "OS_002") {
                              if(_nameController.text != null && _nameController.text != '' && _phoneController.text != null && _phoneController.text != '' && _addressController.text != null && _addressController.text != '') {
                                detailAddressNode.requestFocus();
                              }
                            }
                          }

                          if(widget.table_nm == "INTRP_SRVC") {
                            if(_nameController.text != null && _nameController.text != '' && _phoneController.text != null && _phoneController.text != '' && _addressController.text != null && _addressController.text != '') {
                              detailAddressNode.requestFocus();
                            }
                          }
                          return "상세주소를 입력해주세요.";
                        }
                        return null;
                      },
                      style: TextStyle(fontSize: 15 * (MediaQuery.of(context).size.width / 360),fontFamily: ''),
                    ),
                  ),
                ],
              ),
            ),
          );
  }

  Visibility address(BuildContext context) {
    return Visibility(
            visible : address_visible,
            child : Container(
              width: 360 * (MediaQuery.of(context).size.width / 360),
              //height: 25 * (MediaQuery.of(context).size.height / 360),
              margin : EdgeInsets.fromLTRB(15 * (MediaQuery.of(context).size.width / 360), 5 * (MediaQuery.of(context).size.height / 360),
                  15 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360)),
              padding : EdgeInsets.fromLTRB(0 * (MediaQuery.of(context).size.width / 360), 2 * (MediaQuery.of(context).size.height / 360),
                  0 * (MediaQuery.of(context).size.width / 360), 2 * (MediaQuery.of(context).size.height / 360)),
              decoration: BoxDecoration(
                border: Border.all(
                    color: Color.fromRGBO(243, 246, 248, 1)
                ),
                borderRadius: BorderRadius.circular(3 * (MediaQuery.of(context).size.height / 360)),
                color: Color.fromRGBO(255, 255, 255, 1),
              ),
              child: Row(
                children: [
                  Container(
                    width: 265 * (MediaQuery.of(context).size.width / 360),
                    /*padding : EdgeInsets.fromLTRB(10 * (MediaQuery.of(context).size.height / 360), 0 * (MediaQuery.of(context).size.height / 360),
                        3 * (MediaQuery.of(context).size.height / 360), 0 * (MediaQuery.of(context).size.height / 360)),*/
                    child: TextFormField(
                      controller: _addressController,
                      focusNode: addressNode,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        contentPadding : EdgeInsets.fromLTRB(15 * (MediaQuery.of(context).size.width / 360), 0, 0, 0),
                        /*enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(5)),
                          borderSide: BorderSide(
                            color: Color.fromRGBO(255, 255, 255, 1),
                          ),
                        ),*/
                        // labelText: 'Search',
                        hintText: '출장 요청 주소',
                        hintStyle: TextStyle(fontSize: 15 * (MediaQuery.of(context).size.width / 360), color:Color(0xffC4CCD0),),
                      ),
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (value) {
                        value = value?.trim();
                        if(value == null || value.isEmpty) {
                          if(widget.table_nm == "ON_SITE") {
                            if (_selectedValue == "OS_001") {
                              if(_nameController.text != null && _nameController.text != '' && _phoneController.text != null && _phoneController.text != '') {
                                addressNode.requestFocus();
                              }
                            }
                            if (_selectedValue == "OS_002") {
                              if(_nameController.text != null && _nameController.text != '' && _phoneController.text != null && _phoneController.text != '') {
                                addressNode.requestFocus();
                              }
                            }
                          }

                          if(widget.table_nm == "INTRP_SRVC") {
                            if(_nameController.text != null && _nameController.text != '' && _phoneController.text != null && _phoneController.text != '') {
                              addressNode.requestFocus();
                            }
                          }
                          return "출장요청주소를 입력해주세요.";
                        }
                        return null;
                      },
                      style: TextStyle(fontSize: 15 * (MediaQuery.of(context).size.width / 360),fontFamily: ''),
                    ),
                  ),
                 TextButton(
                     onPressed: () async {
                       final route = MaterialPageRoute(builder: (context) => ServiceLocationSearch());

                       final addResult = await Navigator.push(context, route);
                       print("##########################################");
                       print(addResult);
                       _addressController.text = addResult;
                       distance_discount = 0;
                       address_lat = 0;
                       address_lng = 0;
                       distance_check();

                     },
                     child:  Container(
                         width: 20 * (MediaQuery.of(context).size.width / 360),
                         child: Center(
                             child : Image(image: AssetImage("assets/my_location2.png"), width: 20 * (MediaQuery.of(context).size.width / 360),)
                         )
                     ),
                 )
                ],
              ),
            ),
          );
  }

  Visibility phoneNumber(BuildContext context) {
    return Visibility(
            visible : phone_visible,
            child : Container(
              width: 360 * (MediaQuery.of(context).size.width / 360),
              //height: 25 * (MediaQuery.of(context).size.height / 360),
              margin : EdgeInsets.fromLTRB(15 * (MediaQuery.of(context).size.width / 360), 5 * (MediaQuery.of(context).size.height / 360),
                  15 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360)),

              child: Row(
                children: [
                  Container(
                    width: 135 * (MediaQuery.of(context).size.width / 360),
                   // height: 25 * (MediaQuery.of(context).size.height / 360),
                    padding : EdgeInsets.fromLTRB(0 * (MediaQuery.of(context).size.width / 360), 2 * (MediaQuery.of(context).size.height / 360),
                        0 * (MediaQuery.of(context).size.width / 360), 2 * (MediaQuery.of(context).size.height / 360)),
                    decoration: BoxDecoration(
                      border: Border.all(
                          color: Color.fromRGBO(243, 246, 248, 1)
                      ),
                      borderRadius: BorderRadius.circular(3 * (MediaQuery.of(context).size.height / 360)),
                      color: Color.fromRGBO(255, 255, 255, 1),
                    ),
                    child: DropdownButtonHideUnderline(
                        child : DropdownButton2(
                          isExpanded: true,
                          value : _phoneNumberCategoryValue,
                          //isDense : true,
                          hint: Text("+84", style: TextStyle(fontSize: 14 * (MediaQuery.of(context).size.width / 360), color: Color(0xff151515)),),
                          buttonStyleData: ButtonStyleData(
                            padding: EdgeInsets.fromLTRB(15 * (MediaQuery.of(context).size.width / 360), 1 * (MediaQuery.of(context).size.height / 360), 5 * (MediaQuery.of(context).size.width / 360), 0),
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
                          items: phoneNumberCategory.map((serviceVO item) =>
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
                            setState(() {

                            });
                          }),
                        )
                    ),
                  ),
                  SizedBox(width : 10 * (MediaQuery.of(context).size.width / 360)),
                  Container(
                    width: 185 * (MediaQuery.of(context).size.width / 360),
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
                      controller: _phoneController,
                      focusNode: phoneNode,
                      keyboardType: TextInputType.number,
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                      decoration: InputDecoration(
                        contentPadding : EdgeInsets.fromLTRB(15 * (MediaQuery.of(context).size.width / 360), 0, 0, 0),
                        border: InputBorder.none,
                        /*enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(5)),
                          borderSide: BorderSide(
                            color: Color.fromRGBO(255, 255, 255, 1),
                          ),
                        ),*/
                        // labelText: 'Search',
                        hintText: '전화 번호',
                        hintStyle: TextStyle(fontSize: 15 * (MediaQuery.of(context).size.width / 360), color:Color(0xffC4CCD0),),
                      ),
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (value) {
                        value = value?.trim();
                        if(value == null || value.isEmpty) {
                          if(_nameController.text != null && _nameController.text != '') {
                            phoneNode.requestFocus();
                          }
                          return "전화번호를 입력해주세요.";
                        }
                        return null;
                      },
                      style: TextStyle(fontSize: 15 * (MediaQuery.of(context).size.width / 360),fontFamily: ''),
                    ),
                  ),
                ],
              ),
            ),
          );
  }

  Visibility Name(BuildContext context) {
    return Visibility(visible : name_visible,
            child : Container(
              width: 360 * (MediaQuery.of(context).size.width / 360),
              //height: 25 * (MediaQuery.of(context).size.height / 360),
              margin : EdgeInsets.fromLTRB(15 * (MediaQuery.of(context).size.width / 360), 5 * (MediaQuery.of(context).size.height / 360),
                  15 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360)),
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
                controller: _nameController,
                focusNode: nameNode,
                decoration: InputDecoration(
                  contentPadding : EdgeInsets.fromLTRB(15 * (MediaQuery.of(context).size.width / 360), 0, 0, 0),
                  border: InputBorder.none,
                 /* enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                    borderSide: BorderSide(
                      color: Color.fromRGBO(255, 255, 255, 1),
                    ),
                  ),*/
                  // labelText: 'Search',
                  hintText: '이름',
                  hintStyle: TextStyle(fontSize: 15 * (MediaQuery.of(context).size.width / 360), color:Color(0xffC4CCD0),),
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
                style: TextStyle(fontSize: 15 * (MediaQuery.of(context).size.width / 360),fontFamily: ''),
              ),
            ),
          );
  }

  Container MainCategory(BuildContext context) {
    return Container(
            width : 360 * (MediaQuery.of(context).size.width / 360),
            //height : 26 * (MediaQuery.of(context).size.height / 360),
            margin : EdgeInsets.fromLTRB(15 * (MediaQuery.of(context).size.width / 360), 5 * (MediaQuery.of(context).size.height / 360),
                15 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360)),
            padding : EdgeInsets.fromLTRB(0 * (MediaQuery.of(context).size.width / 360), 2 * (MediaQuery.of(context).size.height / 360),
                0 * (MediaQuery.of(context).size.width / 360), 2 * (MediaQuery.of(context).size.height / 360)),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(3 * (MediaQuery.of(context).size.height / 360)),
              border: Border.all(
                color:Color(0xffF3F6F8),
              ),
            ),
            child: DropdownButtonHideUnderline(
                child : DropdownButtonFormField2(
                  isExpanded: true,
                  value : _selectedValue,
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
                  items:  mainCategory.map((serviceVO item) =>
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
                    setState(() {
                      if(widget.table_nm == "ON_SITE") {
                        if (value == "OS_001") {
                          name_visible = true;
                          phone_visible = true;
                          address_visible = true;
                          address_detail_visible = true;
                          level_visible = true;
                          time_visible = true;
                          conts_visible = true;
                          terms_visible = true;
                          paymentinformation_visible = true;
                          announcement_visible = true;
                          apply_visible = true;
                          upload_visible = false;
                        }
                        if (value == "OS_002") {
                          name_visible = true;
                          phone_visible = true;
                          address_visible = true;
                          address_detail_visible = true;
                          level_visible = false;
                          time_visible = true;
                          conts_visible = true;
                          terms_visible = true;
                          paymentinformation_visible = false;
                          announcement_visible = true;
                          apply_visible = true;
                          upload_visible = false;
                        }
                      }

                      if(widget.table_nm == "INTRP_SRVC") {
                        name_visible = true;
                        phone_visible = true;
                        address_visible = true;
                        address_detail_visible = true;
                        level_visible = false;
                        time_visible = false;
                        conts_visible = false;
                        terms_visible = true;
                        paymentinformation_visible = true;
                        announcement_visible = true;
                        apply_visible = true;
                        upload_visible = false;
                      }

                      if(widget.table_nm == "AGENCY_SRVC") {
                        name_visible = true;
                        phone_visible = true;
                        address_visible = false;
                        address_detail_visible = false;
                        level_visible = false;
                        time_visible = false;
                        conts_visible = true;
                        terms_visible = true;
                        paymentinformation_visible = false;
                        announcement_visible = true;
                        apply_visible = true;
                        upload_visible = true;
                      }

                      if(widget.table_nm == "REAL_ESTATE_INTRP_SRVC") {
                        name_visible = true;
                        phone_visible = true;
                        address_visible = false;
                        address_detail_visible = false;
                        level_visible = false;
                        time_visible = false;
                        conts_visible = true;
                        terms_visible = true;
                        paymentinformation_visible = false;
                        announcement_visible = true;
                        apply_visible = true;
                        upload_visible = true;
                      }

                      initgetservicefee(value.toString()).then((_) {
                        setState(() {

                        });
                      });
                    });
                  }),

                )
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
          Visibility(visible: upload_visible,child:
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
                    upload_visible = false;
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

  void FlutterDialog(context) async {
    var board_seq = 0;

    if(_pointController.text == '' || _pointController.text == null) {
      _pointController.text = '0';
    }

    if(widget.table_nm == "ON_SITE") {
      board_seq = 12;
    }

    if(widget.table_nm == "INTRP_SRVC") {
      board_seq = 13;
    }

    if(widget.table_nm == "AGENCY_SRVC") {
      board_seq = 14;
    }

    if(widget.table_nm == "REAL_ESTATE_INTRP_SRVC") {
      board_seq = 28;
    }

    var ipAddress = IpAddress(type: RequestType.json);
    dynamic data = await ipAddress.getIpAddress();

    // Create storage
    final storage = FlutterSecureStorage();
    String? reg_id = await storage.read(key: "memberId");
    String? nickname = await storage.read(key: "memberNick");
    String? reg_nm = await storage.read(key: "memberNick");


    FormData _formData = FormData.fromMap(
        {}
    );
    if(widget.table_nm == "ON_SITE" || widget.table_nm == "INTRP_SRVC") {
      _formData = FormData.fromMap(
          {
            "title": "서비스",
            "conts": _contsController.text + " ",
            "sdate": _startTimeController.text,
            "edate": _endTimeController.text,
            "etc09": _phoneNumberCategoryValue.toString() + "-" +
                _phoneController.text, //외국전화번호의 경우 자릿수가 천차만별이라 따로 저장
            "adres": _addressController.text,
            "adres_detail": _detailAddressController.text,
            "main_category": _selectedValue,
            "cat01": "SRVE_001", // 처리상태 -> 신청완료
            "cat02": _levelCategoryValue,
            "etc01": _pointController.text,
            "etc02": "${((service_money + time_discount + level_discount + distance_discount + basic_time_discount) - int.parse(_pointController.text))}",
            "board_seq": board_seq,
            "session_ip": data["ip"].toString(),
            "session_member_id": reg_id,
            "session_member_nm": _nameController.text,
            "table_nm": widget.table_nm
          }
      );
    }

    if((widget.table_nm == "AGENCY_SRVC" || widget.table_nm == "REAL_ESTATE_INTRP_SRVC") && _pickedImgs != null) {

      final List<MultipartFile> _files =
      _pickedImgs.map(
              (img) => MultipartFile.fromFileSync(img.path,  contentType: new MediaType("image", "jpg"))
      ).toList();

      _formData = FormData.fromMap(
          {
            "title": "서비스",
            "attach": _files,
            "conts": " " + _contsController.text,
            "sdate": _startTimeController.text,
            "edate": _endTimeController.text,
            "etc09": _phoneNumberCategoryValue.toString() + "-" +
                _phoneController.text, //외국전화번호의 경우 자릿수가 천차만별이라 따로 저장
            "adres": _addressController.text,
            "adres_detail": _detailAddressController.text,
            "main_category": _selectedValue,
            "cat01": "SRVE_001", // 처리상태 -> 신청완료
            "cat02": _levelCategoryValue,
            "etc01": _pointController.text,
            "etc02": "${((service_money + time_discount + level_discount + distance_discount + basic_time_discount) - int.parse(_pointController.text))}",
            "board_seq": board_seq,
            "session_ip": data["ip"].toString(),
            "session_member_id": reg_id,
            "session_member_nm": _nameController.text,
            "table_nm": widget.table_nm
          }
      );
    }

    if((widget.table_nm == "AGENCY_SRVC" || widget.table_nm == "REAL_ESTATE_INTRP_SRVC") && _pickedImgs == null) {
      _formData = FormData.fromMap(
          {
            "title": "서비스",
            "conts": " " + _contsController.text,
            "sdate": _startTimeController.text,
            "edate": _endTimeController.text,
            "etc09": _phoneNumberCategoryValue.toString() + "-" +
                _phoneController.text, //외국전화번호의 경우 자릿수가 천차만별이라 따로 저장
            "adres": _addressController.text,
            "adres_detail": _detailAddressController.text,
            "main_category": _selectedValue,
            "cat01": "SRVE_001", // 처리상태 -> 신청완료
            "cat02": _levelCategoryValue,
            "etc01": _pointController.text,
            "etc02": "${((service_fee  + time_discount + level_discount + distance_discount + basic_time_discount) - int.parse(_pointController.text))}",
            "board_seq": board_seq,
            "session_ip": data["ip"].toString(),
            "session_member_id": reg_id,
            "session_member_nm": _nameController.text,
            "table_nm": widget.table_nm
          }
      );
    }

    Dio dio = Dio();

    dio.options.contentType = "multipart/form-data";

    final res = await dio.post("http://www.hoty.company/mf/community/write.do", data: _formData).then((res) {
      return res.data;
    });


    print("결과입니다.");
    print(res);

    showDialog(
      context: context,
      barrierColor: Color(0xffE47421).withOpacity(0.4),
      barrierDismissible: false,
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
            content: Container(
              child : Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(
                    margin : EdgeInsets.fromLTRB(0 * (MediaQuery.of(context).size.width / 360), 10 * (MediaQuery.of(context).size.height / 360),
                        0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360)),
                    child : Image(image: AssetImage("assets/check_circle.png"), width: 50 * (MediaQuery.of(context).size.width / 360),),
                  ),
                  if(widget.table_nm == "ON_SITE")
                    Container(
                      margin : EdgeInsets.fromLTRB(0 * (MediaQuery.of(context).size.width / 360), 5 * (MediaQuery.of(context).size.height / 360),
                          0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360)),
                      child : Text("출장 서비스 신청이 완료 되었습니다.", style: TextStyle(fontFamily: 'NanumSquareB', fontSize: 16 * (MediaQuery.of(context).size.width / 360), fontWeight: FontWeight.bold),),
                    ),
                  if(widget.table_nm == "ON_SITE")
                    Container(
                        margin : EdgeInsets.fromLTRB(0 * (MediaQuery.of(context).size.width / 360), 5 * (MediaQuery.of(context).size.height / 360),
                            0 * (MediaQuery.of(context).size.width / 360), 5 * (MediaQuery.of(context).size.height / 360)),
                        child : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text("시작일 : ", style: TextStyle(fontFamily: 'NanumSquareB', fontSize: 14 * (MediaQuery.of(context).size.width / 360), fontWeight: FontWeight.w600),),
                            Text("${_startTimeController.text}", style: TextStyle(fontFamily: 'NanumSquareB', fontSize: 14 * (MediaQuery.of(context).size.width / 360)),),
                          ],
                        )
                    ),
                  if(widget.table_nm == "ON_SITE")
                    Container(
                        margin : EdgeInsets.fromLTRB(0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360),
                            0 * (MediaQuery.of(context).size.width / 360), 5 * (MediaQuery.of(context).size.height / 360)),
                        child : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text("종료일 : ", style: TextStyle(fontFamily: 'NanumSquareB', fontSize: 14 * (MediaQuery.of(context).size.width / 360), fontWeight: FontWeight.w600),),
                            Text("${_endTimeController.text}", style: TextStyle(fontFamily: 'NanumSquareB', fontSize: 14 * (MediaQuery.of(context).size.width / 360)),),
                          ],
                        )
                    ),
                  if(widget.table_nm == "ON_SITE")
                    Container(
                      margin : EdgeInsets.fromLTRB(0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360),
                          0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360)),
                      child : Text("신청 해주신 내용을 담당자가 확인 후 입력해주신 휴대폰 번호로 연락 드리겠습니다.", style: TextStyle(fontFamily: 'NanumSquareB', color: Color(0xff2F67D3), fontSize: 14 * (MediaQuery.of(context).size.width / 360)),textAlign: TextAlign.center,),
                    ),

                  if(widget.table_nm == "INTRP_SRVC")
                    Container(
                      margin : EdgeInsets.fromLTRB(0 * (MediaQuery.of(context).size.width / 360), 5 * (MediaQuery.of(context).size.height / 360),
                          0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360)),
                      child : Text("24시 긴급 출장 통역 서비스 신청이", style: TextStyle(fontFamily: 'NanumSquareB', fontSize: 17 * (MediaQuery.of(context).size.width / 360), fontWeight: FontWeight.bold),),
                    ),
                  if(widget.table_nm == "INTRP_SRVC")
                    Container(
                      child : Text("완료 되었습니다.", style: TextStyle(fontFamily: 'NanumSquareB', fontSize: 17 * (MediaQuery.of(context).size.width / 360), fontWeight: FontWeight.bold),),
                    ),
                  if(widget.table_nm == "INTRP_SRVC")
                    Container(
                      margin : EdgeInsets.fromLTRB(0 * (MediaQuery.of(context).size.width / 360), 5 * (MediaQuery.of(context).size.height / 360),
                          0 * (MediaQuery.of(context).size.width / 360), 5 * (MediaQuery.of(context).size.height / 360)),
                      child : Text.rich(
                        TextSpan(
                          children: <TextSpan>[
                            TextSpan(text : "출장 요청 장소 : ", style: TextStyle(fontFamily: 'NanumSquareB', fontSize: 14 * (MediaQuery.of(context).size.width / 360), fontWeight: FontWeight.w600),),
                            TextSpan(text : "${_addressController.text} ${_detailAddressController.text}", style: TextStyle(fontFamily: 'NanumSquareB', fontSize: 14 * (MediaQuery.of(context).size.width / 360), height: 1.5 ),),
                          ],
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  if(widget.table_nm == "INTRP_SRVC")
                    Container(
                      margin : EdgeInsets.fromLTRB(0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360),
                          0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360)),
                      child : Text("담당자가 출발 시 입력하신 연락처로 연락 드릴 예정입니다.", style: TextStyle(fontFamily: 'NanumSquareB', color: Color(0xff2F67D3), fontSize: 13 * (MediaQuery.of(context).size.width / 360)),textAlign: TextAlign.center,),
                    ),

                  if(widget.table_nm == "AGENCY_SRVC")
                    Container(
                      margin : EdgeInsets.fromLTRB(0 * (MediaQuery.of(context).size.width / 360), 5 * (MediaQuery.of(context).size.height / 360),
                          0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360)),
                      child : Text("비자 서비스 신청이 완료 되었습니다.", style: TextStyle(fontFamily: 'NanumSquareB', fontSize: 17 * (MediaQuery.of(context).size.width / 360), fontWeight: FontWeight.bold),),
                    ),
                  if(widget.table_nm == "AGENCY_SRVC")
                    Container(
                      child : Text("완료", style: TextStyle(fontFamily: 'NanumSquareB', fontSize: 16 * (MediaQuery.of(context).size.width / 360), fontWeight: FontWeight.bold),),
                    ),
                  if(widget.table_nm == "AGENCY_SRVC")
                    Container(
                      margin : EdgeInsets.fromLTRB(0 * (MediaQuery.of(context).size.width / 360), 5 * (MediaQuery.of(context).size.height / 360),
                          0 * (MediaQuery.of(context).size.width / 360), 5 * (MediaQuery.of(context).size.height / 360)),
                      child : Text.rich(
                        TextSpan(
                          children: <TextSpan>[
                            TextSpan(text : "신청구분 : ", style: TextStyle(fontFamily: 'NanumSquareB', fontSize: 14 * (MediaQuery.of(context).size.width / 360), fontWeight: FontWeight.w600),),
                            for(var i = 0; i < mainCategory.length; i++)
                              if(mainCategory[i].idx == _selectedValue)
                                TextSpan(text : "${mainCategory[i].name}", style: TextStyle(fontFamily: 'NanumSquareB', fontSize: 14 * (MediaQuery.of(context).size.width / 360), height: 1.5 ),),
                          ],
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  if(widget.table_nm == "AGENCY_SRVC")
                    Container(
                      margin : EdgeInsets.fromLTRB(0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360),
                          0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360)),
                      child : Text("신청 해주신 내용을 담당자가 확인 후 입력해주신 휴대폰 번호로 연락 드리겠습니다.", style: TextStyle(fontFamily: 'NanumSquareB', color: Color(0xff2F67D3), fontSize: 14 * (MediaQuery.of(context).size.width / 360)),textAlign: TextAlign.center,),
                    ),
                  if(widget.table_nm == "REAL_ESTATE_INTRP_SRVC")
                    Container(
                      margin : EdgeInsets.fromLTRB(0 * (MediaQuery.of(context).size.width / 360), 5 * (MediaQuery.of(context).size.height / 360),
                          0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360)),
                      child : Text("부동산통역서비스 신청이 완료 되었습니다.", style: TextStyle(fontFamily: 'NanumSquareB', fontSize: 15 * (MediaQuery.of(context).size.width / 360), fontWeight: FontWeight.bold),),
                    ),
                  if(widget.table_nm == "REAL_ESTATE_INTRP_SRVC")
                    Container(
                      child : Text("완료", style: TextStyle(fontFamily: 'NanumSquareB', fontSize: 16 * (MediaQuery.of(context).size.width / 360), fontWeight: FontWeight.bold),),
                    ),
                  if(widget.table_nm == "REAL_ESTATE_INTRP_SRVC")
                    Container(
                      margin : EdgeInsets.fromLTRB(0 * (MediaQuery.of(context).size.width / 360), 5 * (MediaQuery.of(context).size.height / 360),
                          0 * (MediaQuery.of(context).size.width / 360), 5 * (MediaQuery.of(context).size.height / 360)),
                      child : Text.rich(
                        TextSpan(
                          children: <TextSpan>[
                            TextSpan(text : "신청구분 : ", style: TextStyle(fontFamily: 'NanumSquareB', fontSize: 14 * (MediaQuery.of(context).size.width / 360), fontWeight: FontWeight.w600),),
                            for(var i = 0; i < mainCategory.length; i++)
                              if(mainCategory[i].idx == _selectedValue)
                                TextSpan(text : "${mainCategory[i].name}", style: TextStyle(fontFamily: 'NanumSquareB', fontSize: 14 * (MediaQuery.of(context).size.width / 360), height: 1.5 ),),
                          ],
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  if(widget.table_nm == "REAL_ESTATE_INTRP_SRVC")
                    Container(
                      margin : EdgeInsets.fromLTRB(0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360),
                          0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360)),
                      child : Text("신청 해주신 내용을 담당자가 확인 후 입력해주신 휴대폰 번호로 연락 드리겠습니다.", style: TextStyle(fontFamily: 'NanumSquareB', color: Color(0xff2F67D3), fontSize: 14 * (MediaQuery.of(context).size.width / 360)),textAlign: TextAlign.center,),
                    ),
                ],
              ),
            ),
            actions: <Widget>[
              Container(
                  child : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextButton(
                        child: Container(
                          /*width : 360 * (MediaQuery.of(context).size.width / 360),*/
                          padding : EdgeInsets.fromLTRB(15 * (MediaQuery.of(context).size.width / 360), 5 * (MediaQuery.of(context).size.height / 360),
                              15 * (MediaQuery.of(context).size.width / 360), 5 * (MediaQuery.of(context).size.height / 360)),
                          decoration: BoxDecoration(
                            color: Color(0xffFFFFFF),
                            borderRadius: BorderRadius.circular(50 * (MediaQuery.of(context).size.height / 360)),
                            border: Border.all(
                                color: Color(0xffE47421),
                                width: 2
                            ),
                            /*border: Border(
                            left: BorderSide(color: Color(0xffE47421),  width: 4 * (MediaQuery.of(context).size.width / 360),),
                          ),*/
                          ),
                          child : Text("1:1 문의하기", style: TextStyle(color: Color(0xffE47421),fontFamily: 'NanumSquareB',fontSize: 16 * (MediaQuery.of(context).size.width / 360) , fontWeight: FontWeight.w600), textAlign: TextAlign.center,),
                        ),
                        onPressed: ()  {
                          Navigator.pop(context,true);
                        },
                      ),
                      TextButton(
                        child: Container(
                          /*width : 360 * (MediaQuery.of(context).size.width / 360),*/
                          padding : EdgeInsets.fromLTRB(15 * (MediaQuery.of(context).size.width / 360), 5 * (MediaQuery.of(context).size.height / 360),
                              15 * (MediaQuery.of(context).size.width / 360), 5 * (MediaQuery.of(context).size.height / 360)),
                          decoration: BoxDecoration(
                            color: Color(0xffE47421),
                            borderRadius: BorderRadius.circular(50 * (MediaQuery.of(context).size.height / 360)),
                          ),
                          child : Text("신청내역 조회", style: TextStyle(color: Color(0xffFFFFFF),fontFamily: 'NanumSquareB',fontSize: 16 * (MediaQuery.of(context).size.width / 360) , fontWeight: FontWeight.w600), textAlign: TextAlign.center,),
                        ),
                        onPressed: () {
                          Navigator.pop(context,false);
                        },
                      ),
                    ],
                  )
              ),
            ],
          ),
        );
      },
    ).then((value) => {
      if(value == true) {
        Navigator.pop(context),
        launch("http://pf.kakao.com/_gYrxnG"),
      } else {
        Navigator.pop(context),
        Navigator.push(context, MaterialPageRoute(
          builder: (context) {
            return Profile_service_history();
          },
        )),
      }
    });
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

  void distance_check () async {
    getGeocode(_addressController.text + " " + _detailAddressController.text);
  }

  void getGeocode (String input) async {
    String kPLACES_API_KEY = "AIzaSyBK7t1Cd8aDa9uUKpty1pfHyE7HSg7Lejs";
    String type = '(regions)';
    String baseURL =
        'https://maps.googleapis.com/maps/api/geocode/json';
    String request =
        '$baseURL?address=$input&key=$kPLACES_API_KEY';

    print(request);
    var url = Uri.parse(
        request
    );

    var response = await http.get(url);
    if (response.statusCode == 200) {
      setState(() {
        print(json.decode(response.body)['results']);
        Map rst = json.decode(response.body)['results'][0]['geometry']['viewport']['southwest'];
        print('지역값 체크');
        print(rst);
        address_lat = rst["lat"];
        address_lng = rst["lng"];
        print(address_lat);
        print(address_lng);

        final m1 = distance.as(LengthUnit.Meter, LatLng(hoty_lat, hoty_lng), LatLng(address_lat, address_lng));

        initgetdiscountfee(_selectedValue.toString()).then((_) {
          setState(() {
            print('거리값');
            print(m1);
            var discount = 0;
            var discount_unit = "";

            List<dynamic> distancelist = [];

            for (int i = 0; i < discountfeeList.length; i++) {
              if (discountfeeList[i]["distance_cost_use_yn"] == "Y") {
                if (discountfeeList[i]["distance"] != null) {
                  distancelist.add(discountfeeList[i]);
                }
              }
            }

            print("??");
            print(distancelist.length);

            if (distancelist.length > 0) {
              for (var i = 0; i < distancelist.length; i++) {
                if (distancelist[i]["distance_unit"] == "km") { // km > m 변환
                  distancelist[i]["distance"] = distancelist[i]["distance"] * 1000;
                }
              }

              distancelist.sort((a, b) => a['distance'].compareTo(b['distance']));
              distancelist = List.from(distancelist.reversed);



              for (var i = 0; i < distancelist.length; i++) {
                if (m1 == distancelist[i]["distance"]) {
                  var money = distancelist[i]["money"].toString();
                  var money_type = money.substring(0, 1);

                  if (money_type == "+" || money_type == "-") {
                    if (money_type == "+") {
                      discount = int.parse(money.substring(1, money.length));
                      discount_unit = distancelist[i]["money_unit"];
                    } else {
                      discount = int.parse(money);
                      discount_unit = distancelist[i]["money_unit"];
                    }
                  } else {
                    discount = int.parse(money);
                    discount_unit = distancelist[i]["money_unit"];
                  }
                }
              }

              if(distancelist.length > 0) {
                if (discount == 0) {
                  if ((m1.toDouble()) > int.parse(distancelist[0]["distance"])) {
                    var money = distancelist[0]["money"].toString();
                    var money_type = money.substring(0, 1);

                    if (money_type == "+" || money_type == "-") {
                      if (money_type == "+") {
                        discount = int.parse(money.substring(1, money.length));
                        discount_unit = distancelist[0]["money_unit"];
                      } else {
                        discount = int.parse(money);
                        discount_unit = distancelist[0]["money_unit"];
                      }
                    } else {
                      discount = int.parse(money);
                      discount_unit = distancelist[0]["money_unit"];
                    }
                  }
                }

                if (discount_unit != null && discount_unit != "") {
                  if (discount_unit == "P") {
                    distance_discount = (service_money * (discount / 100)).toInt().floor();
                  }
                  if (discount_unit == "C") {
                    distance_discount = discount;
                  }
                }
              }
            }


            print(discount);
            print(discount_unit);
            print('거리값 확인용');
          });
        });
      });
    } else {
      throw Exception('Failed to load geometry');
    }
  }

}