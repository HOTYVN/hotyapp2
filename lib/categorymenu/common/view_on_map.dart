import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/services.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:hoty/categorymenu/common/list_filter.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hoty/common/follow_us.dart';
import 'package:hoty/common/footer.dart';

import '../../common/Nodata.dart';
import '../../common/dialog/showDialog_modal.dart';
import '../../common/icons/my_icons.dart';
import '../../community/device_id.dart';
import '../living_view.dart';
import '../providers/living_provider.dart';
import 'list_filter_map.dart';

class ViewOnMap extends StatefulWidget{
  final String title_catcode;
  final String rolling;
  final Map params;
  final List<String> check_sub_catlist; // 서브카테고리 체크
  // final List<String> allcheck_detail_catlist = []; // 세부카테고리 all
  final List<String> check_detail_catlist;
  final List<String> check_detail_arealist; // 지역리스트

  const ViewOnMap({super.key, required this.title_catcode,
    required this.rolling,
    required this.params,
    required this.check_sub_catlist,
    required this.check_detail_catlist,
    required this.check_detail_arealist
  });

  @override
  _ViewOnMap createState() => _ViewOnMap();
}

class _ViewOnMap extends State<ViewOnMap> {
  var _isChecked = false;
  // 카테고리 검색조건
  List<String> sub_checkList = []; // 서브 카테고리 체크리스트
  List<String> sub_allcheckList = []; // 서브 카테고리 전체체크
  //검색지역카테고리
  List<String> check_detail_arealist = [];
  //검색서브카테고리
  List<String> checklist = [];

  String likes_yn = '';
  late GoogleMapController mapController;
  String location = "위치 명:";
  final LatLng _center = const LatLng(10.7949932,106.7218215);
  CameraPosition? cameraPosition;
  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  var base_Imgurl = 'http://www.hoty.company';
  List<Marker> _markers = []; // 지도 마커
  Map params = {};
  // 메뉴카테고리 selectkey
  final GlobalKey titlecat_key = GlobalKey();
  // 생활정보 카테고리
  List<dynamic> coderesult = []; // 공통코드 리스트
  // List<dynamic> cattitle = []; // 카테고리타이틀 리스트
  List<dynamic> main_catname = []; // 메인카테고리 리스트
  List<dynamic> title_catname = []; // 메뉴타이틀테고리 리스트
  List<dynamic> areaname = []; // 지역카테고리 리스트

  //아파트,병원,학교,학원 분류
  List<String> gubun = ['C101','C102','C103','C104'];

  List<dynamic> result = []; // 리스트데이터
  List<dynamic> result2 = []; // 리스트데이터
  Map pagination = {}; // 페이징데이터
  var totalpage = 0; // 총 리스트페이지

  // 노데이터
  Widget _noData = Container();

  // 고유정보
  var table_nm = "LIVING_INFO"; // 생활정보 테이블네임
  var title_catcode = ''; // 메뉴카테고리 코드값 //추후 링크연동시 code값 필요.
  //params 정보
  var cpage = 1;
  var rows = 999999;
  var board_seq = 11;
  var reg_id = "admin"; //임시 ID값
  var condition = "TITLE"; // 검색구분
  var keyword = ''; // serch
  var _sortvalue = "likeup"; // sort

  var _isviewselect = true;
  var map_height = 120;
  var conts_height = 160;




  // 공통코드 호출
  Future<dynamic> setcode() async {
    //코드 전체리스트 가져오기
    coderesult = await livingProvider().getcodedata();

    // 생활정보 코드 리스트
    /*   for(int i=0; i<coderesult.length; i++){
      if(coderesult[i]['pidx'] == table_nm){
        cattitle.add(coderesult[i]);
      }
    }*/

    // 타이틀코드,지역코드
    coderesult.forEach((value) {
      if(value['pidx'] == 'LIVING_INFO'){
        title_catname.add(value);
      }
      if(value['pidx'] == 'C2'){
        areaname.add(value);
      }
    });

    // 첫번째 카테고리
    /*   for(var i=0; i<title_catname.length; i++){
      if(i == 5){
        title_catcode = title_catname[i]['idx'];
      }
    }*/

  }

  List<dynamic> listcat01 = []; // cat01 체크리스트ㄲ
  List<dynamic> listcat02 = []; // cat02 체크리스트
  List<dynamic> listcat03 = []; // cat03 체크리스트
  List<dynamic> listcat04 = []; // cat04 체크리스트
  List<dynamic> listcat05 = []; // cat05 체크리스트
  List<dynamic> listcat06 = []; // cat06 체크리스트
  List<dynamic> listcat07 = []; // cat07 체크리스트
  List<dynamic> listcat08 = []; // cat08 체크리스트
  List<dynamic> listcat09 = []; // cat09 체크리스트
  List<dynamic> listcat10 = []; // cat10 체크리스트
  List<dynamic> listcat11 = []; // cat11 체크리스트
  String stay_yn = 'N';
  Map<String, dynamic> catrst = {};

  void catckclear() {
    listcat01.clear();
    listcat02.clear();
    listcat03.clear();
    listcat04.clear();
    listcat05.clear();
    listcat06.clear();
    listcat07.clear();
    listcat08.clear();
    listcat09.clear();
    listcat10.clear();
    listcat11.clear();
    stay_yn = 'N';
  }

  Future<dynamic> checkcatlist() async {

    List<dynamic> pidxcode = [];



    var pidx = '';
    for (var i = 0; i < checklist.length; i++) {
      coderesult.forEach((element) {
        if(element['idx'] == checklist[i]) {
          coderesult.forEach((subel) {
            if(subel['idx'] == element['pidx']){
              if(subel['seq'] == 1) {
                listcat01.add(element['idx']);
              }
              if(subel['seq'] == 2) {
                listcat02.add(element['idx']);
              }
              if(subel['seq'] == 3) {
                listcat03.add(element['idx']);
              }
              if(subel['seq'] == 4) {
                listcat04.add(element['idx']);
              }
              if(subel['seq'] == 5) {
                listcat05.add(element['idx']);
              }
              if(subel['seq'] == 6) {
                listcat06.add(element['idx']);
              }
              if(subel['seq'] == 7) {
                listcat07.add(element['idx']);
              }
              if(subel['seq'] == 8) {
                listcat08.add(element['idx']);
              }
              if(subel['seq'] == 9) {
                listcat09.add(element['idx']);
              }
              if(subel['seq'] == 10) {
                listcat10.add(element['idx']);
              }
              if(subel['seq'] == 11) {
                listcat11.add(element['idx']);
              }
            }
          });
        }
      });
    }
    if(title_catcode == 'C101' || title_catcode == 'C302') {
      stay_yn = 'Y';
    }


    print('####################');




    print(listcat01);
    print(listcat02);
    print(listcat03);
    print(listcat04);
    print(listcat05);
    print(listcat06);
    print(listcat07);
    print(listcat08);
    print(listcat09);
    print(listcat10);
    print(listcat11);


  }

  // 리스트 호출
  Future<dynamic> setlist() async {

    Map data = {
      "board_seq": board_seq.toString(),
      "cpage": cpage.toString(),
      "rows": rows.toString(),
      "table_nm" : table_nm,
      "reg_id" : (await storage.read(key:'memberId')) ??  await getMobileId(),
      "sort_nm" : _sortvalue,
      "keyword" : widget.params['keyword'] ?? '',
      "condition" : condition,
      "main_category" : title_catcode,
      "sub_category" : sub_checkList.toList(),
      "checklist" : checklist.toList(),
      "area_category" : check_detail_arealist.toList(),
      "listcat01" : listcat01.toList(),
      "listcat02" : listcat02.toList(),
      "listcat03" : listcat03.toList(),
      "listcat04" : listcat04.toList(),
      "listcat05" : listcat05.toList(),
      "listcat06" : listcat06.toList(),
      "listcat07" : listcat07.toList(),
      "listcat08" : listcat08.toList(),
      "listcat09" : listcat09.toList(),
      "listcat10" : listcat10.toList(),
      "listcat11" : listcat11.toList(),
      "stay_yn" : stay_yn,
    };

    Map<String, dynamic> rst = {};
    List<dynamic> getresult = [];

    params.addAll(data);
    /*print('params -->');
    print(params);*/

    rst = await livingProvider().getlistdata(data);
    //리스트 데이터
    getresult = rst['list'];
    getresult.forEach((element) {
      result.add(element);
      result2.add(element);
    });


    //페이징처리
    pagination = rst['pagination'];
    totalpage = pagination['totalpage'];

   /* print(result);
    print(totalpage);*/
    mapmarking();
    getRating().then((_) {
      setState(() {

      });
    });
  }

  // 좋아요
  Future<dynamic> updatelike(int aritcle_seq, String table_nm, apptitle) async {
    String like_status = "";

    Map params = {
      "article_seq" : aritcle_seq,
      "table_nm" : table_nm,
      "title" : apptitle,
      "likes_yn" : likes_yn,
      "reg_id" : reg_id != "" ? reg_id : await getMobileId(),
    };
    like_status = await livingProvider().updatelike(params);
  }

  Future<dynamic> getRating() async {
    if(result.length > 0) {
      for (int i = 0; i < result.length; i++) {
        if (title_catcode == "C106" || title_catcode == "C107" ||
            title_catcode == "C104") {
          if (result[i]["etc10"] != null && result[i]["etc10"] != "") {
            dynamic Map = await fetchPlaceRating(result[i]["etc10"]);
            result[i]["place_rating"] = Map["result"]["rating"];
            result[i]["place_rating_cnt"] = Map["result"]["user_ratings_total"];
          }
        }
      }
    }
    setState(() {

    });
  }

  Future<dynamic> fetchPlaceRating(String placeId) async {
    final apiKey = 'AIzaSyBK7t1Cd8aDa9uUKpty1pfHyE7HSg7Lejs';
    final apiUrl = 'https://maps.googleapis.com/maps/api/place/details/json?fields=rating,user_ratings_total';

    final response = await http.get(Uri.parse('$apiUrl&place_id=$placeId&key=$apiKey'));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      final double rating = data['result']['rating'] ?? 0;
      return data;
    } else {
      throw Exception('Failed to load place rating');
    }
  }

  late Uint8List markerIcon;

  void setCustomMapPin() async {
    markerIcon = await getBytesFromAsset(width: 100, path: 'assets/maker01.png');
  }

  Future<Uint8List> getBytesFromAsset({required String path, required int width}) async {
    final ByteData _data = await rootBundle.load(path);
    final ui.Codec _codec = await ui.instantiateImageCodec(_data.buffer.asUint8List(), targetWidth: width);
    final ui.FrameInfo _fi = await _codec.getNextFrame();
    final Uint8List _bytes = (await _fi.image.toByteData(format: ui.ImageByteFormat.png))!.buffer.asUint8List();
    return _bytes;
  }

  Future<dynamic> mapmarking() async {


    if(result.length > 0) {
      for(var i=0; i<result.length; i++) {
        _markers.add(Marker(
            markerId: MarkerId("${result[i]['article_seq']}"),
            infoWindow: InfoWindow(title:"${result[i]['title']}"),
            draggable: true,
            icon: BitmapDescriptor.fromBytes(markerIcon),
            onTap: ()  {
              result.clear();
              result.addAll(result2);
              result.insert(0, result[i]);
              result.removeAt(i + 1);
              setState(() {

              });
            },
            position: LatLng(
                double.parse(result[i]['lat']), double.parse(result[i]['lng']))
        ));

      }
    }



  }

  static final storage = FlutterSecureStorage();
  _asyncMethod() async {
    // read 함수로 key값에 맞는 정보를 불러오고 데이터타입은 String 타입
    // 데이터가 없을때는 null을 반환
    reg_id = (await storage.read(key:'memberId')) ?? "";
    print("#############################################");
    print(reg_id);
  }

  @override
  void initState() {
    if(widget.check_detail_arealist.length > 0) {
      check_detail_arealist.addAll(widget.check_detail_arealist);
    }
    if(widget.check_detail_catlist.length > 0){
      checklist.addAll(widget.check_detail_catlist);
    }
    if(widget.check_sub_catlist.length > 0) {
      sub_checkList.addAll(widget.check_sub_catlist);
      // print('@@@@@@@@@@@@@@@@@@@@@@@@@@@');
      // print(widget.check_sub_catlist);
    }
    super.initState();
    _asyncMethod();
    title_catcode = widget.title_catcode;
    setCustomMapPin();// 타이틀 코드 셋팅
      setcode().then((_) {
        checkcatlist().then((_) {
          setlist().then((_) {
            _noData = Nodata();
            setState(() {
              /*WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                Scrollable.ensureVisible(
                  titlecat_key.currentContext!,
                );
              });*/
            });
          });
        });
      });
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(30 * (MediaQuery.of(context).size.height / 360),),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              AppBar(
                titleSpacing: 0,
                leadingWidth: 40,
                backgroundColor: Colors.white,
                  elevation: 0,
                  // titleSpacing: 10 * (MediaQuery.of(context).size.width / 360),
                  automaticallyImplyLeading: true,
                  /*iconTheme: IconThemeData(
            color: Colors.black,
          ),*/
                  leading: IconButton(
                    icon: Icon(Icons.arrow_back_rounded),
                    iconSize: 12 * (MediaQuery.of(context).size.height / 360),
                    color: Color(0xff151515),
                    alignment: Alignment.centerLeft,
                    // padding: EdgeInsets.zero,
                    // visualDensity: VisualDensity(horizontal: -2.0, vertical: -2.0),
                    onPressed: (){
                      if(widget.rolling == 'true'){
                        Navigator.of(context, rootNavigator: true).pop();
                      } else {
                        Navigator.of(context, rootNavigator: false).pop();
                      }

                    },
                  ),
                  title: Container(
                    padding : EdgeInsets.fromLTRB(0 * (MediaQuery.of(context).size.width / 360), 1 * (MediaQuery.of(context).size.height / 360),
                        0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360)),
                    child: Text("지도에서 보기", style: TextStyle(fontSize: 16 * (MediaQuery.of(context).size.width / 360),  color: Colors.black, fontWeight: FontWeight.bold,)),
                  ),
                actions: [
                  Container(
                    margin: EdgeInsets.fromLTRB(0, 0, 10 * (MediaQuery.of(context).size.width / 360), 0),
                      child:Row(
                        children: [
                          GestureDetector(
                            onTap:() {
                              Navigator.push(context, MaterialPageRoute(
                                builder: (context) {
                                  return Catmenu_Filter_Map(title_catcode : title_catcode, getcheck_sublist: sub_checkList, getcheck_detiallist: checklist, getcheck_areadetiallist: check_detail_arealist,);
                                },
                              ));
                            },
                            child:Row(
                              children: [
                                Icon(Icons.filter_list_outlined, size: 10 * (MediaQuery.of(context).size.height / 360),  color: Color(0xffC4CCD0),),
                                Container(
                                  padding : EdgeInsets.fromLTRB(2 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360),
                                      0 * (MediaQuery.of(context).size.height / 360), 0 * (MediaQuery.of(context).size.width / 360)),
                                  child: Text('필터',
                                    style: TextStyle(
                                      fontSize: 14 * (MediaQuery.of(context).size.width / 360),
                                      // fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                  ),
                                )
                              ],
                            ),
                          )
                          ,
                          Container(
                              margin : EdgeInsets.fromLTRB(10 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360),
                                  1 * (MediaQuery.of(context).size.height / 360), 0 * (MediaQuery.of(context).size.width / 360)),
                              child : Row(
                                children: [
                                  GestureDetector(
                                    onTap:() {
                                      showModalBottomSheet(
                                        context: context,
                                        clipBehavior: Clip.hardEdge,
                                        barrierColor: Color(0xffE47421).withOpacity(0.4),
                                        shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.vertical(
                                                top: Radius.circular(25))),
                                        builder: (BuildContext context) {
                                          return sortby();
                                        },
                                      );
                                    },
                                    child:Row(
                                      children: [
                                        Icon(Icons.sort, size: 10 * (MediaQuery.of(context).size.height / 360),  color: Color(0xffC4CCD0),),
                                        Container(
                                          padding : EdgeInsets.fromLTRB(2 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360),
                                              0 * (MediaQuery.of(context).size.height / 360), 0 * (MediaQuery.of(context).size.width / 360)),
                                          child:  Text('정렬 기준',
                                            style: TextStyle(
                                              fontSize: 14 * (MediaQuery.of(context).size.width / 360),
                                              // fontWeight: FontWeight.bold,
                                              color: Colors.black,
                                            ),
                                          ),
                                        )

                                      ],
                                    ),
                                  )
                                ],
                              )
                          ),
                        ],
                      )
                  ),
                ],
                // centerTitle: false,
              ),
            ],
          )
      ),
      body: Column(
        children: [
          Container(
            width: 360 * (MediaQuery.of(context).size.width / 360),
            height: map_height * (MediaQuery.of(context).size.height / 360),
            child: googlemap(context),
          ),
          Container(
            width: 360 * (MediaQuery.of(context).size.width / 360),
            height: 5 * (MediaQuery.of(context).size.height / 360),
          ),
          Container(
            height: conts_height * (MediaQuery.of(context).size.height / 360),
            child: SingleChildScrollView(
              child: getConts(context),
            ),
          ),
        ],
      ),
      extendBody: true,
      bottomNavigationBar: Footer(nowPage: ''),
    );
  }

  Container Listtitle(BuildContext context) {
    return Container(
      // height: 20 * (MediaQuery.of(context).size.height / 360),
      margin : EdgeInsets.fromLTRB(10 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360),
          5 * (MediaQuery.of(context).size.height / 360), 3 * (MediaQuery.of(context).size.width / 360)),
      decoration: BoxDecoration(
        border: Border(
          // left: BorderSide(color: Color(0xffE47421),  width: 5 * (MediaQuery.of(context).size.width / 360),),
            bottom: BorderSide(color: Color(0xffE47421), )
        ),
      ),
      // width: 100 * (MediaQuery.of(context).size.width / 360),
      // height: 100 * (MediaQuery.of(context).size.width / 360),
      child:Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            // height: 15 * (MediaQuery.of(context).size.height / 360),
            decoration: BoxDecoration(
              border: Border(
                left: BorderSide(color: Color(0xffE47421),  width: 4 * (MediaQuery.of(context).size.width / 360),),
              ),
            ),
            margin : EdgeInsets.fromLTRB(2 * (MediaQuery.of(context).size.width / 360), 5 * (MediaQuery.of(context).size.height / 360),
                0 * (MediaQuery.of(context).size.height / 360), 8 * (MediaQuery.of(context).size.width / 360)),
            child:Row(
              children: [
                Container(
                  margin : EdgeInsets.fromLTRB(7 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360),
                      0 * (MediaQuery.of(context).size.height / 360), 0 * (MediaQuery.of(context).size.width / 360)),
                  child:Text(gettitlename(),
                    style: TextStyle(
                      fontSize: 20 * (MediaQuery.of(context).size.width / 360),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                )
              ],
            ),
          ),
          Container(
              child:Row(
                children: [
                  GestureDetector(
                    onTap:() {
                      Navigator.push(context, MaterialPageRoute(
                        builder: (context) {
                          return Catmenu_Filter_Map(title_catcode : title_catcode, getcheck_sublist: sub_checkList, getcheck_detiallist: checklist, getcheck_areadetiallist: check_detail_arealist,);
                        },
                      ));
                    },
                    child:Row(
                      children: [
                        Icon(Icons.filter_list_outlined, size: 10 * (MediaQuery.of(context).size.height / 360),  color: Color(0xffC4CCD0),),
                        Container(
                          padding : EdgeInsets.fromLTRB(2 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360),
                              0 * (MediaQuery.of(context).size.height / 360), 0 * (MediaQuery.of(context).size.width / 360)),
                          child: Text('필터',
                            style: TextStyle(
                              fontSize: 14 * (MediaQuery.of(context).size.width / 360),
                              // fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        )
                      ],
                    ),
                  )
                  ,
                  Container(
                      margin : EdgeInsets.fromLTRB(10 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360),
                          1 * (MediaQuery.of(context).size.height / 360), 0 * (MediaQuery.of(context).size.width / 360)),
                      child : Row(
                        children: [
                          GestureDetector(
                            onTap:() {
                              showModalBottomSheet(
                                context: context,
                                clipBehavior: Clip.hardEdge,
                                barrierColor: Color(0xffE47421).withOpacity(0.4),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.vertical(
                                        top: Radius.circular(25))),
                                builder: (BuildContext context) {
                                  return sortby();
                                },
                              );
                            },
                            child:Row(
                              children: [
                                Icon(Icons.sort, size: 10 * (MediaQuery.of(context).size.height / 360),  color: Color(0xffC4CCD0),),
                                Container(
                                  padding : EdgeInsets.fromLTRB(2 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360),
                                      0 * (MediaQuery.of(context).size.height / 360), 0 * (MediaQuery.of(context).size.width / 360)),
                                  child:  Text('정렬 기준',
                                    style: TextStyle(
                                      fontSize: 14 * (MediaQuery.of(context).size.width / 360),
                                      // fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                  ),
                                )

                              ],
                            ),
                          )
                        ],
                      )
                  ),
                ],
              )
          ),
        ],
      ),
    );
  }
  Widget Maincategory(context) {
    List<String> allcheckList = [];

    List<dynamic> main_catlist = [];

    if(gubun.contains(title_catcode)){
      main_catlist = areaname;
    }else{
      coderesult.forEach((element) {
        if(element['pidx'] == title_catcode) {
          main_catlist.add(element);
        }
      });
    }

    return
      Container(
          width: 360 * (MediaQuery.of(context).size.width / 360),
          height: 17 * (MediaQuery.of(context).size.height / 360),
          margin: EdgeInsets.fromLTRB(0 * (MediaQuery.of(context).size.width / 360), 5 * (MediaQuery.of(context).size.width / 360),
            5 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.width / 360),),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  height: 9 * (MediaQuery.of(context).size.height / 360),
                  child: Row(
                    children: [
                      Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Container(
                              child: Checkbox(
                                side: BorderSide(
                                  color: Color(0xffC4CCD0),
                                  width: 2,
                                ),
                                splashRadius: 12,
                                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                // materialTapTargetSize: MaterialTapTargetSize.padded,
                                value: _isChecked,
                                checkColor: Colors.white,
                                activeColor: Color(0xffE47421),
                                onChanged: (val) {
                                  _allSelected(val!,main_catlist);
                                },
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.fromLTRB(0, 0, 10, 0),
                              // padding: EdgeInsets.fromLTRB(0, 0, 5, 0),
                              child: Text(
                                "전체",
                                style: TextStyle(
                                  fontSize: 14 * (MediaQuery.of(context).size.width / 360),
                                  // fontWeight: FontWeight.bold,
                                  // overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      DottedLine(
                        lineThickness:1,
                        dashLength: 2.0,
                        dashColor: Color(0xffC4CCD0),
                        direction: Axis.vertical,
                      ),
                    ],
                  ),
                ),
                for(var i=0; i<main_catlist.length; i++)
                  Container(
                    height: 9 * (MediaQuery.of(context).size.height / 360),
                    child: Row(
                      children: [
                        Container(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              if(gubun.contains(title_catcode))
                                Container(
                                  child: Checkbox(
                                    side: BorderSide(
                                      color: Color(0xffC4CCD0),
                                      width: 2,
                                    ),
                                    splashRadius: 12,
                                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                    // materialTapTargetSize: MaterialTapTargetSize.padded,
                                    value: check_detail_arealist.contains(main_catlist[i]['idx']),
                                    checkColor: Colors.white,
                                    activeColor: Color(0xffE47421),
                                    onChanged: (val) {
                                      _onSelected(val!, main_catlist[i]['idx']);
                                    },
                                  ),
                                ),
                              if(!gubun.contains(title_catcode))
                                Container(
                                  child: Checkbox(
                                    side: BorderSide(
                                      color: Color(0xffC4CCD0),
                                      width: 2,
                                    ),
                                    splashRadius: 12,
                                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                    // materialTapTargetSize: MaterialTapTargetSize.padded,
                                    value: sub_checkList.contains(main_catlist[i]['idx']),
                                    checkColor: Colors.white,
                                    activeColor: Color(0xffE47421),
                                    onChanged: (val) {
                                      _onSelected(val!, main_catlist[i]['idx']);
                                    },
                                  ),
                                ),
                              Container(
                                margin: EdgeInsets.fromLTRB(0, 0, 10, 0),
                                // padding: EdgeInsets.fromLTRB(0, 0, 5, 0),
                                child: Text(
                                  "${main_catlist[i]['name']}",
                                  style: TextStyle(
                                    fontSize: 14 * (MediaQuery.of(context).size.width / 360),
                                    // fontWeight: FontWeight.bold,
                                    // overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        if(i+1 < main_catlist.length)
                          DottedLine(
                            lineThickness:1,
                            dashLength: 2.0,
                            dashColor: Color(0xffC4CCD0),
                            direction: Axis.vertical,
                          ),
                      ],
                    ),
                  )
              ],
            ),
          )
      )
    ;
  }

  void _allSelected(bool selected, main_catlist) {
    _markers.clear();
    catckclear();
    check_detail_arealist.clear();
    checklist.clear();
    if (selected == true) {
      _isChecked = true;
      for(var m2=0; m2<main_catlist.length; m2++) {
        if(gubun.contains(title_catcode)){
          check_detail_arealist.add(main_catlist[m2]['idx']);
        } else{
          sub_checkList.add(main_catlist[m2]['idx']);
        }
      }
      result.clear();
      result2.clear();
      pagination.clear();
      catckclear();
      cpage = 1;

      setlist().then((_) {
        setState(() {
          // sub_checkList.add(dataName);
        });
      });
    } else {
      _isChecked = false;
      sub_checkList.clear();
      check_detail_arealist.clear();
      result.clear();
      result2.clear();
      pagination.clear();
      cpage = 1;
      setlist().then((_) {
        setState(() {
          // sub_checkList.add(dataName);
        });
      });
    }
  }
  void _onSelected(bool selected, String dataName) {
    catckclear();
    checklist.clear();
    _markers.clear();
    catckclear();
    if (selected == true) {
      result.clear();
      result2.clear();
      pagination.clear();
      cpage = 1;
      if(gubun.contains(title_catcode)){
        check_detail_arealist.add(dataName);
      } else{
        sub_checkList.add(dataName);
      }
      setlist().then((_) {
        setState(() {
          // sub_checkList.add(dataName);
        });
      });
    } else {
      result.clear();
      result2.clear();
      pagination.clear();
      cpage = 1;
      if(gubun.contains(title_catcode)){
        check_detail_arealist.remove(dataName);
      } else{
        sub_checkList.remove(dataName);
      }
      setlist().then((_) {
        setState(() {
          // sub_checkList.remove(dataName);
        });
      });
    }
  }


  Widget sortby() {

    return Container(
      // width: 340 * (MediaQuery.of(context).size.width / 360),
      height: 140 * (MediaQuery.of(context).size.height / 360),
      decoration: BoxDecoration(
        color : Colors.white,
        borderRadius: BorderRadius.only(
          /*topLeft: Radius.circular(20 * (MediaQuery.of(context).size.width / 360)),
          topRight: Radius.circular(20 * (MediaQuery.of(context).size.width / 360)),*/
        ),
      ),
      child: Column(
        children: [
          Container(
            height: 22 * (MediaQuery.of(context).size.height / 360),
            child: Row(
              // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  margin: EdgeInsets.fromLTRB(20, 0, 0, 0),
                  alignment: Alignment.center,
                  width: 280 * (MediaQuery.of(context).size.width / 360),
                  child: Container(
                    margin: EdgeInsets.fromLTRB(20 * (MediaQuery.of(context).size.height / 360), 0, 0, 0),
                    child:
                    Text("정렬 기준",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                ),
                Container(
                  margin: EdgeInsets.fromLTRB(5, 0, 0, 0),
                  child: IconButton(
                    icon: Icon(Icons.close,size: 32,),
                    onPressed: (){
                      Navigator.pop(context);
                    },
                  ),

                )
              ],
            ),

          ),

          Container(
              width: 340 * (MediaQuery.of(context).size.width / 360),
              padding: EdgeInsets.fromLTRB(0, 5, 0, 0),
              decoration : BoxDecoration (
                  border : Border(
                      bottom: BorderSide(color : Color.fromRGBO(243, 246, 248, 1), width: 1 * (MediaQuery.of(context).size.width / 360),)
                  )
              )
          ),

          Container(
            padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
            // width: 120 * (MediaQuery.of(context).size.width / 360),
            height: 22 * (MediaQuery.of(context).size.height / 360),
            // child: Radio(value: '', groupValue: 'lang', onChanged: (value){}, fillColor: MaterialStateColor.resolveWith((states) => Color.fromRGBO(228, 116, 33, 1))),
            child: RadioListTile<String>(
              contentPadding: EdgeInsets.fromLTRB(0, 0, 0, 0),
              controlAffinity: ListTileControlAffinity.leading,
              title: Transform.translate(
                offset: const Offset(-20, 0),
                child: Text(
                  '최근등록일',
                  style: TextStyle(
                      color: Colors.black
                  ),
                ),
              ),
              value: '',
              // checkColor: Colors.white,
              activeColor: Color(0xffE47421),
              onChanged: (String? value) {
                changesort(value);
              },
              groupValue: _sortvalue,
            ),
          ),
          Container(
            padding: EdgeInsets.fromLTRB(5, 0, 0, 0),

            // width: 120 * (MediaQuery.of(context).size.width / 360),
            height: 20 * (MediaQuery.of(context).size.height / 360),
            // child: Radio(value: '', groupValue: 'lang', onChanged: (value){}, fillColor: MaterialStateColor.resolveWith((states) => Color.fromRGBO(228, 116, 33, 1))),
            child: RadioListTile<String>(
              contentPadding: EdgeInsets.fromLTRB(0, 0, 0, 0),
              controlAffinity: ListTileControlAffinity.leading,
              title: Transform.translate(
                offset: const Offset(-20, 0),
                child: Row(
                  children: [
                    Container(
                      child: Text(
                        '좋아요',
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 16
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.fromLTRB(0, 0, 0, 2),
                      child: Text(
                        '↑',
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 15
                        ),
                      ),
                    )
                  ],
                ),
              ),
              value: 'likeup',
              // checkColor: Colors.white,
              activeColor: Color(0xffE47421),
              onChanged: (String? value) {
                changesort(value);
              },
              groupValue: _sortvalue,
            ),
          ),
          Container(
            // width: 120 * (MediaQuery.of(context).size.width / 360),
            height: 20 * (MediaQuery.of(context).size.height / 360),
            padding: EdgeInsets.fromLTRB(5, 0, 0, 0),

            // child: Radio(value: '', groupValue: 'lang', onChanged: (value){}, fillColor: MaterialStateColor.resolveWith((states) => Color.fromRGBO(228, 116, 33, 1))),
            child: RadioListTile<String>(
              contentPadding: EdgeInsets.fromLTRB(0, 0, 0, 0),
              controlAffinity: ListTileControlAffinity.leading,
              title: Transform.translate(
                offset: const Offset(-20, 0),
                child: Row(
                  children: [
                    Container(
                      child: Text(
                        '좋아요',
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 16
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.fromLTRB(0, 0, 0, 2),
                      child: Text(
                        '↓',
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 15
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              value: 'likedown',
              // checkColor: Colors.white,
              activeColor: Color(0xffE47421),
              onChanged: (String? value) {
                changesort(value);
              },
              groupValue: _sortvalue,
            ),
          ),
          Container(
            padding: EdgeInsets.fromLTRB(5, 0, 0, 0),

            // width: 120 * (MediaQuery.of(context).size.width / 360),
            height: 22 * (MediaQuery.of(context).size.height / 360),
            // child: Radio(value: '', groupValue: 'lang', onChanged: (value){}, fillColor: MaterialStateColor.resolveWith((states) => Color.fromRGBO(228, 116, 33, 1))),
            child: RadioListTile<String>(
              contentPadding: EdgeInsets.fromLTRB(0, 0, 0, 0),
              controlAffinity: ListTileControlAffinity.leading,
              title: Transform.translate(
                offset: const Offset(-20, 0),
                child: Row(
                  children: [
                    Container(
                      child: Text(
                        '조회수',
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 16
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.fromLTRB(0, 0, 0, 2),
                      child: Text(
                        '↑',
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 15
                        ),
                      ),
                    )
                  ],
                ),
              ),
              value: 'viewup',
              // checkColor: Colors.white,
              activeColor: Color(0xffE47421),
              onChanged: (String? value) {
                changesort(value);
              },
              groupValue: _sortvalue,
            ),
          ),
          Container(
            // width: 120 * (MediaQuery.of(context).size.width / 360),
            height: 22 * (MediaQuery.of(context).size.height / 360),
            padding: EdgeInsets.fromLTRB(5, 0, 0, 0),

            // child: Radio(value: '', groupValue: 'lang', onChanged: (value){}, fillColor: MaterialStateColor.resolveWith((states) => Color.fromRGBO(228, 116, 33, 1))),
            child: RadioListTile<String>(
              contentPadding: EdgeInsets.fromLTRB(0, 0, 0, 0),
              controlAffinity: ListTileControlAffinity.leading,
              title: Transform.translate(
                offset: const Offset(-20, 0),
                child: Row(
                  children: [
                    Container(
                      child: Text(
                        '조회수',
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 16
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.fromLTRB(0, 0, 0, 2),
                      child: Text(
                        '↓',
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 15
                        ),
                      ),
                    )
                  ],
                ),
              ),
              value: 'viewdown',
              // checkColor: Colors.white,
              activeColor: Color(0xffE47421),
              onChanged: (String? value) {
                changesort(value);
              },
              groupValue: _sortvalue,
            ),
          ),
        ],
      ),
    );

  }

  void changesort(val) {
    // print(val);
    setState(() {
      _sortvalue = val;
      result.clear();
      pagination.clear();
      cpage = 1;
      Navigator.pop(context);
      setlist().then((_) {
        setState(() {
        });
      });
    });
  }

  // 타이틀 설정
  String gettitlename() {
    String titlename = '';

    for(var i=0; i<title_catname.length; i++) {
      if(title_catname[i]['idx'] == title_catcode) {
        titlename = title_catname[i]['name'];
      }
    }

    return titlename;
  }


  // 카테고리 타이틀 메뉴
  Container category(BuildContext context) {
    return Container(
      width: 360 *  (MediaQuery.of(context).size.width / 360),
      child : Row(
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  width: 5 *  (MediaQuery.of(context).size.width / 360),
                  padding : EdgeInsets.fromLTRB(0 * (MediaQuery.of(context).size.width / 360), 5 * (MediaQuery.of(context).size.height / 360),
                      0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360)),
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        // color: Color(0xffF3F6F8),
                        // color:Color(0xffF3F6F8),
                        color:Color(0xffF3F6F8),
                        width: 1 * (MediaQuery.of(context).size.width / 360),),
                    ),
                  ),
                  child: Container(
                    padding: EdgeInsets.fromLTRB(
                      0 * (MediaQuery.of(context).size.width / 360),
                      0 * (MediaQuery.of(context).size.height / 360),
                      0 * (MediaQuery.of(context).size.width / 360),
                      5 * (MediaQuery.of(context).size.height / 360),
                    ),
                    child: Text(
                      "",
                      style: TextStyle(
                        // color: cateIndex == i ? Color(0xffE47421) : Color(0xff151515),
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                      ),
                    ),

                  ),
                ),
                Container(
                  // width: 360 *  (MediaQuery.of(context).size.width / 360),
                  padding : EdgeInsets.fromLTRB(0 * (MediaQuery.of(context).size.width / 360), 5 * (MediaQuery.of(context).size.height / 360),
                      0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360)),
                  /*decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            // color: Color(0xffF3F6F8),
                            color:Color(0xffF3F6F8),
                            width: 1 * (MediaQuery.of(context).size.width / 360),),
                        ),
                      ),*/
                  child: GestureDetector(
                    child: Row(
                      children: [
                        for(int m2=0; m2<title_catname.length; m2++)
                          GestureDetector(
                            onTap: (){
                              if(title_catcode != title_catname[m2]['idx']){
                                title_catcode = title_catname[m2]['idx'];
                                result.clear();
                                result2.clear();
                                _markers.clear();
                                pagination.clear();
                                cpage = 1;
                                _isChecked = false;
                                sub_checkList.clear();
                                catckclear(); // 검색cat~ 초기화
                                check_detail_arealist.clear();
                                checklist.clear();

                                setlist().then((_) {
                                  setState(() {
                                    FocusScope.of(context).unfocus();
                                  });
                                });
                              }

                            },
                            child: Container(
                                padding: EdgeInsets.fromLTRB(
                                  0 * (MediaQuery.of(context).size.width / 360),
                                  0 * (MediaQuery.of(context).size.height / 360),
                                  0 * (MediaQuery.of(context).size.width / 360),
                                  0 * (MediaQuery.of(context).size.height / 360),
                                ),
                                decoration: BoxDecoration(
                                  border: Border(
                                    bottom: BorderSide(
                                      // color: Color(0xffF3F6F8),
                                      color: title_catname[m2]['idx'] == title_catcode ? Color(0xffE47421) : Color(0xffF3F6F8),
                                      width: 1 * (MediaQuery.of(context).size.width / 360),),
                                  ),
                                ),
                                child: Container(
                                  padding: EdgeInsets.fromLTRB(
                                    8 * (MediaQuery.of(context).size.width / 360),
                                    0 * (MediaQuery.of(context).size.height / 360),
                                    8 * (MediaQuery.of(context).size.width / 360),
                                    5 * (MediaQuery.of(context).size.height / 360),
                                  ),
                                  child: Text(
                                    title_catname[m2]['name'],
                                    style: TextStyle(
                                      // color: cateIndex == i ? Color(0xffE47421) : Color(0xff151515),
                                      color: title_catname[m2]['idx'] == title_catcode ? Color(0xffE47421) : Color(0xff151515),
                                      fontSize: 14 * (MediaQuery.of(context).size.width / 360),
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),

                                )
                            ),
                          )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Container(
              // width: 25 *  (MediaQuery.of(context).size.width / 360),
              padding : EdgeInsets.fromLTRB(0 * (MediaQuery.of(context).size.width / 360), 5 * (MediaQuery.of(context).size.height / 360),
                  0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360)),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    // color: Color(0xffF3F6F8),
                    // color:Color(0xffF3F6F8),
                    color:Color(0xffF3F6F8),
                    width: 1 * (MediaQuery.of(context).size.width / 360),),
                ),
              ),
              child: Container(
                padding: EdgeInsets.fromLTRB(
                  0 * (MediaQuery.of(context).size.width / 360),
                  0 * (MediaQuery.of(context).size.height / 360),
                  0 * (MediaQuery.of(context).size.width / 360),
                  5 * (MediaQuery.of(context).size.height / 360),
                ),
                child: Text(
                  "",
                  style: TextStyle(
                    // color: cateIndex == i ? Color(0xffE47421) : Color(0xff151515),
                    fontSize: 14 * (MediaQuery.of(context).size.width / 360),
                    fontWeight: FontWeight.w800,
                  ),
                ),

              ),
            ),
          ),
        ],
      ),
    );
  }


  Widget getConts(context) {
    return
      Column(
        children: [
          //카테고리
          category(context),
       /*   Container( // 카테고리
            width: 360 * (MediaQuery.of(context).size.width / 360),
            // height: 25 * (MediaQuery.of(context).size.height / 360),
            *//*margin: EdgeInsets.fromLTRB(10 * (MediaQuery.of(context).size.width / 360),
                5 * (MediaQuery.of(context).size.height / 360),
                0,
                0 * (MediaQuery.of(context).size.height / 360)),*//*
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  Container(
                    // alignment: Alignment.center,
                    margin: EdgeInsets.fromLTRB(0 * (MediaQuery.of(context).size.width / 360),0,0,0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        for(int m2=0; m2<title_catname.length; m2++)
                          Container(
                            child: Row(
                              children: [
                                if(title_catname[m2]['idx'] == title_catcode)
                                  Container(
                                    key: titlecat_key,
                                    alignment: Alignment.center,
                                    margin: EdgeInsets.fromLTRB(1 * (MediaQuery.of(context).size.width / 360), 0,
                                        5 * (MediaQuery.of(context).size.width / 360), 0),
                                    padding: EdgeInsets.fromLTRB(2 * (MediaQuery.of(context).size.width / 360), 0,
                                        2 * (MediaQuery.of(context).size.width / 360), 0),
                                    // height: 18 * (MediaQuery.of(context).size.height / 360),
                                    decoration: BoxDecoration(
                                      // color: Color(0xffE47421).withOpacity(0.4),
                                      color: Color(0xffE47421),
                                      borderRadius: BorderRadius.circular(40 * (MediaQuery.of(context).size.height / 360)),
                                    ),
                                    child:Row(
                                      children: [
                                        TextButton(
                                          style: TextButton.styleFrom(
                                            elevation: 0,
                                            // primary: Color(0xffF3F6F8),
                                            minimumSize: Size.zero,
                                            padding: EdgeInsets.fromLTRB(7 * (MediaQuery.of(context).size.width / 360), 5 * (MediaQuery.of(context).size.height / 360),
                                                7 * (MediaQuery.of(context).size.width / 360), 5 * (MediaQuery.of(context).size.height / 360)),
                                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                          ),
                                          autofocus: true,
                                          onPressed: () {  },
                                          child: Text(
                                            "${title_catname[m2]['name']}",
                                            style: TextStyle(
                                              fontSize: 14 * (MediaQuery.of(context).size.width / 360),
                                              fontWeight: FontWeight.w400,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                if(title_catname[m2]['idx'] != title_catcode)
                                  Container(
                                      alignment: Alignment.center,
                                      margin: EdgeInsets.fromLTRB(1 * (MediaQuery.of(context).size.width / 360), 0, 5 * (MediaQuery.of(context).size.width / 360), 0),
                                      padding: EdgeInsets.fromLTRB(2 * (MediaQuery.of(context).size.width / 360), 0, 2 * (MediaQuery.of(context).size.width / 360), 0),
                                      // height: 18 * (MediaQuery.of(context).size.height / 360),
                                      *//* decoration: BoxDecoration(
                                      color: Color(0xffF3F6F8),
                                      borderRadius: BorderRadius.circular(40 * (MediaQuery.of(context).size.height / 360)),
                                    ),*//*
                                      decoration: ShapeDecoration(
                                        color: Color(0xffF3F6F8),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(120),
                                        ),
                                    *//*    shadows: [
                                          BoxShadow(
                                            color: Color(0x14545B5F),
                                            blurRadius: 4,
                                            offset: Offset(2, 2),
                                            spreadRadius: 1,
                                          )
                                        ],*//*
                                      ),
                                      child: Row(
                                        children: [
                                          TextButton(
                                            style: TextButton.styleFrom(
                                              elevation: 0,
                                              primary: Color(0xffF3F6F8),
                                              minimumSize: Size.zero,
                                              padding: EdgeInsets.fromLTRB(7 * (MediaQuery.of(context).size.width / 360), 5 * (MediaQuery.of(context).size.height / 360),
                                                  7 * (MediaQuery.of(context).size.width / 360), 5 * (MediaQuery.of(context).size.height / 360)),
                                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                            ),
                                            onPressed: () {
                                              // sub_checkList.clear();
                                              // _isChecked = false;
                                              title_catcode = title_catname[m2]['idx'];
                                              result.clear();
                                              result2.clear();
                                              _markers.clear();
                                              pagination.clear();
                                              cpage = 1;
                                              _isChecked = false;
                                              sub_checkList.clear();
                                              catckclear(); // 검색cat~ 초기화
                                              check_detail_arealist.clear();
                                              checklist.clear();

                                              setlist().then((_) {
                                                setState(() {
                                                  FocusScope.of(context).unfocus();
                                                });
                                              });
                                              // result.clear();
                                              *//*livingProvider().getlistdata().then((_) {
                                    setState(() {
                                    });
                                  });*//*
                                            },
                                            child: Text(
                                              "${title_catname[m2]['name']}",
                                              style: TextStyle(
                                                fontSize: 14 * (MediaQuery.of(context).size.width / 360),
                                                fontWeight: FontWeight.w400,
                                                color: Color(0xff151515),
                                              ),
                                            ),
                                          ),
                                        ],
                                      )
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
          ),*/
          // Listtitle(context),
          Maincategory(context),
         //리스트
          if(result.length == 0)
            _noData,
          if(result.length > 0)
            Container(
            child: getlist(context),
          ),
          if(cpage < totalpage)
          Container(
            width: 100 * (MediaQuery.of(context).size.width / 360),
            // height: 20 * (MediaQuery.of(context).size.height / 360),
            margin: EdgeInsets.fromLTRB(0, 5 * (MediaQuery.of(context).size.height / 360), 0, 0),
            child: Wrap(
              children: [
                TextButton(
                  style: TextButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10 * (MediaQuery.of(context).size.height / 360)),
                        side : BorderSide(color: Color(0xff2F67D3),width: 2),
                      )
                  ),
                  onPressed: (){
                    if(cpage < totalpage) {
                      cpage = cpage + 1;
                      setlist().then((_) {
                        setState(() {
                        });
                      });
                    }
                    else {
                      showModal(context, 'listalert','');
                    }
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        margin: EdgeInsets.fromLTRB(8 * (MediaQuery.of(context).size.width / 360), 4 * (MediaQuery.of(context).size.width / 360),
                            8 * (MediaQuery.of(context).size.width / 360), 4 * (MediaQuery.of(context).size.width / 360)),
                        alignment: Alignment.center,
                        // width: 50 * (MediaQuery.of(context).size.width / 360),
                        child: Text('더보기', style: TextStyle(fontSize: 16, color: Color(0xff2F67D3),fontWeight: FontWeight.bold,),
                        ),
                      ),
                      Icon(My_icons.rightarrow, size: 12, color: Color(0xff2F67D3),),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Follow_us(),
        ],
      );
  }

  Container googlemap(context) {
    return Container(
          child: Stack(
            children: [
              GoogleMap(
                onMapCreated: _onMapCreated,
                mapType: MapType.normal,
                myLocationButtonEnabled: true,
                myLocationEnabled: true,
                markers: Set.from(_markers),
                initialCameraPosition: CameraPosition(
                  target: _center,
                  zoom: 10,
                ),
                /*onTap: ()=> _currentLocation(),*/
                onCameraMove: (CameraPosition cameraPositiona) {
                  cameraPosition = cameraPositiona; //when map is dragging
                },
                onCameraIdle: () async { //when map drag stops
                  List<Placemark> placemarks = await placemarkFromCoordinates(cameraPosition!.target.latitude, cameraPosition!.target.longitude);
                  setState(() { //get place name from lat and lang
                    location = placemarks.first.administrativeArea.toString() + ", " +  placemarks.first.street.toString();
                    // print(location);
                  });
                },
              ),
            ],
          ),
          // color: Colors.amberAccent,
        );
  }

  Widget getlist(context) {

    return
      Column(
        children: [
          for(int i=0; i<result.length; i++)
            Container(
              width: 360 * (MediaQuery.of(context).size.width / 360),
              /* padding: EdgeInsets.fromLTRB(0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360),
                  0 * (MediaQuery.of(context).size.width / 360), 33 * (MediaQuery.of(context).size.height / 360)),*/
              child:Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: EdgeInsets.fromLTRB(10 * (MediaQuery.of(context).size.width / 360),  5 * (MediaQuery.of(context).size.height / 360),
                        10 * (MediaQuery.of(context).size.width / 360),  5 * (MediaQuery.of(context).size.height / 360)),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        GestureDetector(
                          onTap: (){
                            Navigator.push(context, MaterialPageRoute(
                              builder: (context) {
                                return LivingView(article_seq: result[i]['article_seq'], table_nm : result[i]['table_nm'], title_catcode: title_catcode, params: params,);
                              },
                            ));
                          },
                          child: Container(
                            width: 150 * (MediaQuery.of(context).size.width / 360),
                            child: AspectRatio(
                              aspectRatio: 16 / 9,
                              child: Container(
                                decoration: BoxDecoration(
                                  image: result[i]['main_img'] != null &&  result[i]['main_img'] != '' ? DecorationImage(
                                      image: CachedNetworkImageProvider('$base_Imgurl${result[i]['main_img_path']}${result[i]['main_img']}'),
                                      fit: BoxFit.cover
                                  ) : DecorationImage(
                                      image: AssetImage('assets/noimage.png'),
                                      fit: BoxFit.cover
                                  ),
                                  borderRadius: BorderRadius.circular(5 * (MediaQuery.of(context).size.height / 360)),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                        margin : EdgeInsets.fromLTRB(6 * (MediaQuery.of(context).size.width / 360), 3 * (MediaQuery.of(context).size.height / 360),
                                            0 , 0 ),
                                        decoration: BoxDecoration(
                                          color: Color(0xff2F67D3),
                                          borderRadius: BorderRadius.circular(3 * (MediaQuery.of(context).size.height / 360)),
                                        ),
                                        child:Row(
                                          children: [
                                            if(result[i]['area_category'] != null && result[i]['area_category'] != '')
                                              Container(
                                                padding : EdgeInsets.fromLTRB(6 * (MediaQuery.of(context).size.width / 360), 3,
                                                    6 * (MediaQuery.of(context).size.width / 360) , 3 ),
                                                child: Text(getSubcodename(result[i]['area_category']),
                                                  style: TextStyle(
                                                    fontSize: 13 * (MediaQuery.of(context).size.width / 360),
                                                    color: Colors.white,
                                                    // fontWeight: FontWeight.bold,
                                                    // height: 0.6 * (MediaQuery.of(context).size.height / 360),
                                                  ),
                                                  textAlign: TextAlign.center,
                                                ),
                                              ),
                                          ],
                                        )
                                    ),
                                    Container(
                                        margin : EdgeInsets.fromLTRB(0, 3 * (MediaQuery.of(context).size.height / 360), 6 * (MediaQuery.of(context).size.width / 360), 0),
                                        // width: 40 * (MediaQuery.of(context).size.width / 360),
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          // borderRadius: BorderRadius.circular(10 * (MediaQuery.of(context).size.height / 360)),
                                          shape: BoxShape.circle,
                                        ),
                                        child:Row(
                                          children: [
                                            if(result[i]['like_yn'] != null && result[i]['like_yn'] > 0)
                                              GestureDetector(
                                                onTap: () {
                                                  _isLiked(true, result[i]["article_seq"], result[i]["table_nm"], result[i]["title"], i);
                                                },
                                                child : Container(
                                                  padding : EdgeInsets.fromLTRB(4 * (MediaQuery.of(context).size.width / 360), 2 * (MediaQuery.of(context).size.height / 360),
                                                    4 * (MediaQuery.of(context).size.width / 360) , 2 * (MediaQuery.of(context).size.height / 360),),
                                                  child: Icon(Icons.favorite, color: Color(0xffE47421), size: 15 , ),
                                                ),
                                              ),
                                            if(result[i]['like_yn'] == null || result[i]['like_yn'] == 0)
                                              GestureDetector(
                                                onTap: () {
                                                  _isLiked(false, result[i]["article_seq"], result[i]["table_nm"], result[i]["title"], i);
                                                },
                                                child : Container(
                                                  padding : EdgeInsets.fromLTRB(4 * (MediaQuery.of(context).size.width / 360), 2 * (MediaQuery.of(context).size.height / 360),
                                                    4 * (MediaQuery.of(context).size.width / 360) , 2 * (MediaQuery.of(context).size.height / 360),),
                                                  child: Icon(Icons.favorite, color: Color(0xffC4CCD0), size: 15 , ),
                                                ),
                                              ),
                                          ],
                                        )
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        Container(
                          width: 190 * (MediaQuery.of(context).size.width / 360),
                          // height: 50 * (MediaQuery.of(context).size.height / 360),
                          padding: EdgeInsets.fromLTRB(10 * (MediaQuery.of(context).size.width / 360), 0, 0, 0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              GestureDetector(
                                onTap: (){
                                  Navigator.push(context, MaterialPageRoute(
                                    builder: (context) {
                                      return LivingView(article_seq: result[i]['article_seq'], table_nm : result[i]['table_nm'], title_catcode: title_catcode, params: params,);
                                    },
                                  ));
                                },
                                child: Container(
                                  // height: 25 * (MediaQuery.of(context).size.height / 360),
                                  child: Text(
                                    '${result[i]['title']}',
                                    style: TextStyle(
                                      fontSize: 16 * (MediaQuery.of(context).size.width / 360),
                                      // color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      // height: 1.5 * (MediaQuery.of(context).size.width / 360),
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ),
                              if(result[i]['place_rating'] == null || result[i]["place_rating_cnt"] == null)
                                Container(
                                  // height: 10 * (MediaQuery.of(context).size.height / 360),
                                ),
                              if(result[i]['place_rating'] != null && result[i]["place_rating_cnt"] != null)
                                Container(
                                    constraints: BoxConstraints(maxWidth : 190 * (MediaQuery.of(context).size.width / 360)),
                                    margin : EdgeInsets.fromLTRB( 0  * (MediaQuery.of(context).size.width / 360), 3  * (MediaQuery.of(context).size.height / 360), 0,2 * (MediaQuery.of(context).size.height / 360)),
                                    /*width: 340 * (MediaQuery.of(context).size.width / 360),*/
                                    // height: 10 * (MediaQuery.of(context).size.height / 360),
                                    child:Row(
                                      children: [
                                        Text("구글평점 ${result[i]["place_rating"]}",style: TextStyle(fontSize: 12 * (MediaQuery.of(context).size.width / 360)),
                                          maxLines: 2, overflow: TextOverflow.ellipsis,),
                                        RatingBarIndicator(
                                          unratedColor: Color(0xffC4CCD0),
                                          rating: result[i]["place_rating"].toDouble(),
                                          itemBuilder: (context, index) => Icon(
                                            Icons.star,
                                            color: Colors.amber,
                                          ),
                                          itemCount: 5,
                                          itemSize: 15.0,
                                          direction: Axis.horizontal,
                                        ),
                                        Container(
                                          constraints: BoxConstraints(maxWidth : 40 * (MediaQuery.of(context).size.width / 360)),
                                          child: Text("(${result[i]["place_rating_cnt"]})",style: TextStyle(fontSize: 12 * (MediaQuery.of(context).size.width / 360),),
                                            maxLines: 1, overflow: TextOverflow.ellipsis,
                                          ),
                                        )
                                      ],
                                    )

                                ),
                              Container(
                                // width: 340 * (MediaQuery.of(context).size.width / 360),
                                // height: 15 * (MediaQuery.of(context).size.height / 360),
                                margin : EdgeInsets.fromLTRB( 0  * (MediaQuery.of(context).size.width / 360),
                                    3  * (MediaQuery.of(context).size.height / 360), 0, 0),
                                // color: Colors.purpleAccent,
                                child: SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Container(
                                        height: 10 * (MediaQuery.of(context).size.height / 360),
                                        // width: 340 * (MediaQuery.of(context).size.width / 360),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: [
                                            Container(
                                              // width: 70 * (MediaQuery.of(context).size.width / 360),
                                                child: Row(
                                                  children: [
                                                    Icon(Icons.favorite, size: 8 * (MediaQuery.of(context).size.height / 360),  color: Color(0xffEB5757),),
                                                    Container(
                                                      constraints: BoxConstraints(maxWidth : 70 * (MediaQuery.of(context).size.width / 360)),
                                                      margin : EdgeInsets.fromLTRB(4 * (MediaQuery.of(context).size.width / 360),0, 0, 0),
                                                      padding: EdgeInsets.fromLTRB(0, 0, 8 * (MediaQuery.of(context).size.width / 360), 0),
                                                      child: Text(
                                                        '${result[i]['like_cnt']}',
                                                        style: TextStyle(
                                                          fontSize: 14 * (MediaQuery.of(context).size.width / 360),
                                                          color: Color(0xff151515),
                                                          overflow: TextOverflow.ellipsis,
                                                          // fontWeight: FontWeight.bold,
                                                          // height: 1.5 * (MediaQuery.of(context).size.width / 360),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                )
                                            ),
                                            DottedLine(
                                              lineThickness:1,
                                              dashLength: 2.0,
                                              dashColor: Color(0xffC4CCD0),
                                              direction: Axis.vertical,
                                            ),
                                            Container(
                                              // width: 70 * (MediaQuery.of(context).size.width / 360),
                                              padding: EdgeInsets.fromLTRB(8 * (MediaQuery.of(context).size.width / 360), 0, 0, 0),
                                              child: Row(
                                                children: [
                                                  Icon(Icons.remove_red_eye, size: 8 * (MediaQuery.of(context).size.height / 360), color: Color(0xff925331),),
                                                  Container(
                                                    constraints: BoxConstraints(maxWidth : 70 * (MediaQuery.of(context).size.width / 360)),
                                                    margin : EdgeInsets.fromLTRB(4 * (MediaQuery.of(context).size.width / 360),0, 0, 0),
                                                    padding: EdgeInsets.fromLTRB(0, 0, 8 * (MediaQuery.of(context).size.width / 360), 0),
                                                    child: Text(
                                                      '${result[i]['view_cnt']}',
                                                      style: TextStyle(
                                                        fontSize: 14 * (MediaQuery.of(context).size.width / 360),
                                                        color: Color(0xff151515),
                                                        overflow: TextOverflow.ellipsis,
                                                        // fontWeight: FontWeight.bold,
                                                        // height: 1.5 * (MediaQuery.of(context).size.width / 360),
                                                      ),
                                                      textAlign: TextAlign.center,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            for(var a = 0; a < result[i]["icon_list"].length; a++)
                                              Container(
                                                  child : Row (
                                                    children: [
                                                      DottedLine(
                                                        lineThickness:1,
                                                        dashLength: 2.0,
                                                        dashColor: Color(0xffC4CCD0),
                                                        direction: Axis.vertical,
                                                      ),
                                                      Container(
                                                        padding: EdgeInsets.fromLTRB(10 * (MediaQuery.of(context).size.width / 360), 0, 10 * (MediaQuery.of(context).size.width / 360), 0),
                                                        child: Row(
                                                          children: [
                                                            Image(image: CachedNetworkImageProvider("http://www.hoty.company/images/app_icon/${result[i]["icon_list"][a]["icon"]}.png"), height: 10 * (MediaQuery.of(context).size.height / 360),),
                                                            Container(
                                                              margin : EdgeInsets.fromLTRB(4 * (MediaQuery.of(context).size.width / 360),0, 0, 0),
                                                              child: Text(
                                                                "${result[i]["icon_list"][a]["icon_nm"]}",
                                                                style: TextStyle(
                                                                  fontSize: 12 * (MediaQuery.of(context).size.width / 360),
                                                                  color: Color(0xff151515),
                                                                  overflow: TextOverflow.ellipsis,
                                                                  // fontWeight: FontWeight.bold,
                                                                  // height: 1.5 * (MediaQuery.of(context).size.width / 360),
                                                                ),
                                                                textAlign: TextAlign.center,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  )
                                              )
                                          ],
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
                  if(result.length != i+1)
                    Divider(thickness: 5, height: 5 * (MediaQuery.of(context).size.height / 360), color: Color(0xffF3F6F8)),
                ],
              ),

            ),
        ],
      )
    ;
  }

  String getSubcodename(getcode) {
    var Codename = '';
    List<dynamic> main_catlist = [];

    coderesult.forEach((element) {
      if(element['idx'] == getcode) {
        Codename = element['name'];
      }
    });

    return Codename;
  }

  void _isLiked(like_yn, article_seq, table_nm, apptitle, index) {

    like_yn = !like_yn;
    if(like_yn) {
      likes_yn = 'Y';
      updatelike( article_seq, table_nm, apptitle);
      setState(() {
        result[index]['like_yn'] = 1;
      });
    } else{
      likes_yn = 'N';
      updatelike( article_seq, table_nm, apptitle);
      setState(() {
        result[index]['like_yn'] = 0;
      });
    }

    setState(() {

    });
  }
}