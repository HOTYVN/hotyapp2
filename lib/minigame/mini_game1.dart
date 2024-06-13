import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_ip_address/get_ip_address.dart';
import 'package:hoty/main/main_page.dart';

import 'package:roulette/roulette.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';

void showMiniGame1(BuildContext context, isShow) {
  showDialog(
    barrierColor: isShow == 0 ? Color(0xffE47421).withOpacity(0.4) : Colors.transparent,
    barrierDismissible: false,
    context: context,
    builder: (BuildContext context) => MiniGame1(),
  );
}

void main() {
  runApp(const MiniGame1());
}

class MiniGame1 extends StatelessWidget {
  const MiniGame1({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
          scaffoldBackgroundColor: Colors.white,
          fontFamily: 'NanumSquareR',
          appBarTheme: AppBarTheme(
              color: Colors.white
          )
      ),
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
          child: child!,
        );
      },
      title: 'MiniGame1',
      home: const HomePage(),
    );
  }

}

class MyRoulette extends StatelessWidget {
  const MyRoulette({
    Key? key,
    required this.controller,
  }) : super(key: key);

  final RouletteController controller;



  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.topCenter,
      children: [
        SizedBox(
          width: 300,
          height: 300 ,
          child: Padding(
            padding: EdgeInsets.fromLTRB(0 * (MediaQuery.of(context).size.width / 360), 30,
                0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360)),
            child: Roulette(
              // Provide controller to update its state
              controller: controller,
              // Configure roulette's appearance
              style: const RouletteStyle(
                dividerThickness: 5,
                dividerColor: Colors.white,
                centerStickSizePercent: 0.30,
                centerStickerColor: Colors.white,
              ),
            ),
          ),
        ),
        // Positioned를 사용하여 이미지를 룰렛 위에 위치시킵니다.
        Positioned(
          top: 150,
          child: Image.asset(
            'assets/roullete_logo.png',
            width: 50,
          ),
        ),
        Container(
          width: 30 ,
          margin: EdgeInsets.fromLTRB(0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360),
              0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360)),
          //child:const Arrow() ,
          child: Wrap(
            children: [
              Image(image: AssetImage('assets/arrow.png')),
            ],
          ),
        ),
      ],
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  static final _random = Random();
  static final offset = _random.nextDouble();

  final bool _clockwise = true;

  bool isButtonPressed = false;
  String _notice_yn = '';

  String regist_nm = "";
  String regist_id = "";

  List<dynamic> getresult = [];

  var Baseurl = "http://www.hoty.company/mf";
  //var Baseurl = "http://www.hoty.company/mf";
  var Base_Imgurl = "http://www.hoty.company";

  Future<dynamic> getlistdata() async {

    Map paging = {}; // 페이징
    var totalpage = '';

    var url = Uri.parse(
        Baseurl + "/popup/list.do"
    );
    try {
      Map data = {
        "table_nm" : "main"
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

        getresult = json.decode(response.body)['result'];
        print("@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@");
        print(getresult);
      }
      // print(result.length);
    }
    catch(e){
      print(e);
    }
  }

  late RouletteController _controller;

  final units = [
    RouletteUnit.noText(color: Colors.red),
    RouletteUnit.noText(color: Colors.green),
    // ...other units
  ];

  final colors = <Color>[
    /*Colors.red.withAlpha(50),
    Colors.green.withAlpha(50),
    Colors.blue.withAlpha(50),
    Colors.yellow.withAlpha(50),
    Colors.amber.withAlpha(50),*/
  ];

  final icons = <IconData>[
    Icons.ac_unit,
    Icons.access_alarm,
    Icons.access_time,
    Icons.accessibility,
    Icons.account_balance,
    Icons.account_balance_wallet,
  ];

  final images = <ImageProvider>[
    // Use [AssetImage] if you have 2.0x, 3.0x images,
    // We only have 1 exact image here
    /*const NetworkImage("https://picsum.photos/seed/example4/400"),
    const NetworkImage("https://picsum.photos/seed/example5/400"),
    const NetworkImage("https://picsum.photos/seed/example4/400"),
    const NetworkImage("https://picsum.photos/seed/example5/400"),
    const NetworkImage("https://picsum.photos/seed/example4/400"),
    const NetworkImage("https://picsum.photos/seed/example5/400"),*/
    //const ExactAssetImage("https://picsum.photos/seed/example4/400"),
    //const NetworkImage("https://picsum.photos/seed/example5/400"),
    // MemoryImage(...)
    // FileImage(...)
    // ResizeImage(...)
    const ExactAssetImage("assets/white_back.jpg"),
    const ExactAssetImage("assets/white_back.jpg"),
    const ExactAssetImage("assets/white_back.jpg"),
    const ExactAssetImage("assets/white_back.jpg"),
    const ExactAssetImage("assets/white_back.jpg"),
    const ExactAssetImage("assets/white_back.jpg"),
  ];

  /* 미니게임api data 변수 초기화 */
  List<String> _rPointList = [];
  List<String> _wordsList = [];
  List<String> _colorList = [];

  late SharedPreferences _prefs;

  static final storage = FlutterSecureStorage();
  _asyncMethod() async {
    // read 함수로 key값에 맞는 정보를 불러오고 데이터타입은 String 타입
    // 데이터가 없을때는 null을 반환
    regist_id = (await storage.read(key:'memberId')) ?? "";
    regist_nm = (await storage.read(key:'memberNick')) ?? "";
    print("#############################################");
  }

  @override
  void initState() {
    super.initState();
    _asyncMethod();
    initSharedPreferences();
    initializeController();
    getlistdata();
  }

  Future<void> initializeController() async {
    await _loadData();

    Color _colorFromHex(String hexColor) {
      final hexCode = hexColor.replaceAll('#', '');
      return Color(int.parse('FF$hexCode', radix: 16));
    }

    for (int i = 0; i < _colorList.length; i++) {
      Color color = _colorFromHex( _colorList[i]);
      colors.add(color);
    }

    _controller = RouletteController(
      vsync: this,
      group: RouletteGroup.uniform(
        colors.length,
        colorBuilder: (index) => colors[index],
        textBuilder: (index) {
          return _wordsList?[index];
        },
        textStyleBuilder: (index) {
          return const TextStyle(color: Colors.white, fontSize: 16 , fontWeight: FontWeight.bold, );
        },
      ),
    );
  }


  Future<void> _loadData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {
      _rPointList = prefs.getStringList("_rPointList") ?? [];
      _wordsList = prefs.getStringList("_wordsList") ?? [];
      _colorList = prefs.getStringList("_colorList") ?? [];
      _notice_yn = prefs.getString("notice_yn") ?? '';
    });
  }

  Future<void> initSharedPreferences() async {
    _prefs = await SharedPreferences.getInstance();
  }

  Future<void> setData(String memberId) async {
    await _prefs.setString("memberId", memberId);
  }

  var _conts = "";

  /* 미니게임 포인트지급 api */
  void _pointUpdate(int point) async {
    //final url = Uri.parse('http://10.0.2.2:8080/mf/minigame/point_update.do');
    final url = Uri.parse('http://www.hoty.company/mf/minigame/point_update.do');

    _conts = "룰렛 게임 당첨금";

    final storage = FlutterSecureStorage();
    String? reg_id = await storage.read(key: "memberId");
    String? nickname = await storage.read(key: "memberNick");
    String? reg_nm = await storage.read(key: "memberNick");
    regist_nm = reg_nm!;
    regist_id = reg_id!;
    var ipAddress = IpAddress(type: RequestType.json);
    dynamic ipdata = await ipAddress.getIpAddress();

    Map<String, dynamic> data = {
      "member_id": reg_id,
      "member_nm": reg_nm,
      "pt_type": "출석 게임",
      "conts": _conts,
      "pt_enext": "I",
      "pt_usepay": point,
      "pt_ip": ipdata["ip"].toString(),
    };

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(data),
      );

      if (response.statusCode == 200) {
        print('성공적으로 전송되었습니다.');
        print(response.body);
      } else {
        print('요청 실패: ${response.statusCode}');
        print(response.body);
      }
    } catch (error) {
      print('오류: $error');
    }
  }

  @override
  Widget build(BuildContext context) {

    double pageWidth = MediaQuery.of(context).size.width;
    double m_height = (MediaQuery.of(context).size.height / 360 ) ;
    double aspectRatio = MediaQuery.of(context).size.aspectRatio;
    double c_height = m_height;
    double m_width = (MediaQuery.of(context).size.width/360);
    bool isFold = pageWidth > 480 ? true : false;

    if(pageWidth > 480) {
      c_height = m_height * ((m_height * 3)/10);
    }

    if(aspectRatio > 0.55) {
      if(isFold == true) {
        c_height = m_height * (1.5 * aspectRatio);
        // c_height = m_height * ( aspectRatio);
      } else {
        c_height = m_height *  (aspectRatio * 2);
      }
    } else {
      c_height = m_height *  (aspectRatio * 2);
    }


    return AlertDialog(

      insetPadding: EdgeInsets.fromLTRB(5, 20,
          5  , 20 ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(13.0),
      ),
      elevation: 0,
      // backgroundColor: Colors.blue,

      title: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Spacer(),
          Container(
            child: GestureDetector(
              onTap: (){
                Navigator.of(context, rootNavigator: true).pop('dialog');
              },
              child: Icon(Icons.close_rounded , size: 30,),
            ),
          ),
        ],
      ),
      titlePadding: EdgeInsets.fromLTRB(
        0 * (MediaQuery.of(context).size.width / 360),
        10,
        10,
        0 * (MediaQuery.of(context).size.height / 360),
      ),
      content: Container(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Column(
              children: [
                Text(
                  "출석 게임",
                  style: TextStyle(
                      fontSize: 28 ,
                      fontWeight: FontWeight.w800,
                      fontFamily: 'NanumSquareEB'
                  ),
                ),
              ],
            ),
            Container(
              margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
              child: Text(
                "안녕하세요 ${regist_nm} 님! 반갑습니다\n'시작' 버튼을 클릭하여 출석게임 룰렛을 돌려주세요!\n당첨되신 숫자만큼 호티포인트를 드립니다!",
                style: TextStyle(
                    fontSize: 12 ,
                    fontWeight: FontWeight.w400,
                    fontFamily: 'NanumSquareR',
                    height: 1.5
                ),
                maxLines: 3,
                textAlign: TextAlign.center,
              ),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
              child: MyRoulette(controller: _controller),
            ),
          ],
        ),
      ),
      actions: [
        Container(
            margin: EdgeInsets.fromLTRB(5 , 0 * (MediaQuery.of(context).size.height / 360),
                5, 10 ),
            child : Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextButton(
                  style: TextButton.styleFrom(
                      backgroundColor: isButtonPressed ? Color(0xffE47421) : Color(0xffE47421),
                      padding: EdgeInsets.symmetric(horizontal: 0 * (MediaQuery.of(context).size.width / 360), vertical: 24 ),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5 * (MediaQuery.of(context).size.height / 360))
                      ),
                      side: BorderSide(width:2, color:Color(0xffE47421)), //border width and color
                      elevation: 0
                  ),
                    onPressed: isButtonPressed ? null : () async {
                      await setData('${regist_id}');
                      int pickNum = _random.nextInt(_rPointList.length); //룰렛 번호
                      int point = 0;  //포인트
                      setState(() {
                        isButtonPressed = true;
                      });
                      _controller.rollTo(
                        pickNum,
                        clockwise: _clockwise,
                        offset: offset,
                      ).then((result) {
                        _rPointList?.asMap().forEach((index, value) {
                          if (index == pickNum) {
                            point = int.parse(value);
                          }
                        });
                        _pointUpdate(point);
                        pickNum = 0; //초기화
                        Navigator.of(context, rootNavigator: true).pop('dialog');
                        return SuccessDialog(point);
                      });
                      //SuccessDialog(100);
                      //_noticeModal(context);
                    },
                  child: Container(
                    alignment: Alignment.center,
                    width: 300,
                    // width: 300 ,
                    // padding: EdgeInsets.symmetric(horizontal: 5 * (MediaQuery.of(context).size.width / 360), vertical: 2 * (MediaQuery.of(context).size.height / 360)),
                    child : Text("시작",
                      style: TextStyle(
                          color: isButtonPressed ? Colors.white : Colors.white,
                          fontFamily: "NanumSquareR",
                          fontWeight: FontWeight.bold,
                          fontSize: 16 * (MediaQuery.of(context).size.width / 360)
                      ),
                    ),
                  ),
                ),
              ],
            )
        )

      ],
    );
  }


  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void SuccessDialog(int point) {
    showDialog(
      context: context,
      barrierColor: Color(0xffE47421).withOpacity(0.4),
      barrierDismissible: false,
      builder: (BuildContext context) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
          child: AlertDialog(
            insetPadding: EdgeInsets.fromLTRB(10, 20,
                10  , 20 ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(13.0),
            ),
            elevation: 0,
            title: Container(
              height: 14 ,
              alignment: Alignment.centerRight,
              child : IconButton(
                icon: Icon(Icons.close_rounded, size: 28 ,),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ),
            titlePadding: EdgeInsets.fromLTRB(
              0 * (MediaQuery.of(context).size.width / 360),
              5 ,
              5,
              0 * (MediaQuery.of(context).size.height / 360),
            ),
            content: Container(
              width: 300 ,
              height: 300,
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
                      5,
                      0 * (MediaQuery.of(context).size.width / 360),
                      5,
                    ),
                    child: Text(
                      "축하드립니다",
                      style: TextStyle(
                        letterSpacing: 1.0,
                        fontSize: 28 ,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'NanumSquareEB',
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.fromLTRB(
                      0 * (MediaQuery.of(context).size.width / 360),
                      0 * (MediaQuery.of(context).size.height / 360),
                      0 * (MediaQuery.of(context).size.width / 360),
                      1,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "${regist_nm} 님! ",
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.blue,
                          ),
                        ),
                        Text(
                          "${point}P",
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          " 당첨!",
                          style: TextStyle(
                            fontSize: 13 ,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: 190 ,
                    child: Wrap(
                      children: [
                        Image(image: AssetImage('assets/gift_box.png')),
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.fromLTRB(
                      5,
                      2 ,
                      5 ,
                      0 ,
                    ),
                    child: Container(
                      width: 300 ,
                      padding: EdgeInsets.fromLTRB(
                        0,
                        1 ,
                        0 ,
                        1 ,
                      ),
                      // height: 29 ,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(13.0),
                        color: Color(0xffE47421),
                      ),
                      child: Center(
                        child: TextButton(
                          onPressed: (){
                            Navigator.pop(context);
                          },
                          child: Center(
                            child: Text(
                              "홈으로 돌아가기",
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                // height: 1.5 * (MediaQuery.of(context).size.width / 360),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    ).then((value) {
      // print("미니게임 체크1");
      // print(_notice_yn);
      // print(getresult);
      if(_notice_yn == 'N'){ // 다시보지 않기 상태일때
        Navigator.push(context, MaterialPageRoute(
          builder: (context) {
            return MainPage();
          },
        ));
      }else{
        Navigator.of(context, rootNavigator: true).pop('dialog');
        if(getresult != null && getresult.length > 0) {
          _noticeModal(context, getresult);
        }
      }
    });
  }

}

void _noticeModal(context, getresult){
  showDialog(
    barrierColor: Color(0xffE47421).withOpacity(0.4),
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return MediaQuery(
        data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
        child: AlertDialog(
          insetPadding: EdgeInsets.all(15),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(13.0),
          ),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Spacer(),
              IconButton(
                icon: Icon(Icons.close_rounded),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
          titlePadding: EdgeInsets.fromLTRB(
            0 * (MediaQuery.of(context).size.width / 360),
            0 * (MediaQuery.of(context).size.height / 360),
            0 * (MediaQuery.of(context).size.width / 360),
            0 * (MediaQuery.of(context).size.height / 360),
          ),
          content: SizedBox(
            width: 330 * (MediaQuery.of(context).size.width / 360),
            height: 182 * (MediaQuery.of(context).size.height / 360),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  width: 300 * (MediaQuery.of(context).size.width / 360),
                  margin : EdgeInsets.fromLTRB(0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360),
                      0 * (MediaQuery.of(context).size.width / 360), 5 * (MediaQuery.of(context).size.height / 360)),
                  child : Text(
                    "${getresult[0]["title"]}",
                    style: TextStyle(
                      fontSize: 27,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                Container(
                  width: 300 * (MediaQuery.of(context).size.width / 360),
                  margin : EdgeInsets.fromLTRB(10 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360),
                      10 * (MediaQuery.of(context).size.width / 360), 4 * (MediaQuery.of(context).size.height / 360)),
                  child : Text(
                    "${getresult[0]["alt"]}",
                    style: TextStyle(
                      fontSize: 11 * (MediaQuery.of(context).size.width / 360),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                Container(
                  padding: EdgeInsets.fromLTRB(
                    0 * (MediaQuery.of(context).size.width / 360),
                    0 * (MediaQuery.of(context).size.height / 360),
                    0 * (MediaQuery.of(context).size.width / 360),
                    0 * (MediaQuery.of(context).size.height / 360),
                  ),
                  child: SizedBox(
                    width: 210 * (MediaQuery.of(context).size.width / 360),
                    height: 64 * (MediaQuery.of(context).size.height / 360),
                    child: Wrap(
                      children: [Image(image: CachedNetworkImageProvider('http://www.hoty.company${getresult[0]["file_path"]}'),),
                        Container(
                          padding: EdgeInsets.fromLTRB(
                            0 * (MediaQuery.of(context).size.width / 360),
                            0 * (MediaQuery.of(context).size.height / 360),
                            0 * (MediaQuery.of(context).size.width / 360),
                            0 * (MediaQuery.of(context).size.height / 360),
                          ),
                          child: Center(
                            child: TextButton(
                              onPressed: (){
                                Navigator.of(context).pop(true);
                              },
                              child: Center(
                                child: Text(
                                  "이벤트 참여",
                                  style: TextStyle(
                                    fontSize: 13 * (MediaQuery.of(context).size.width / 360),
                                    color: Colors.blueAccent,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      margin: EdgeInsets.fromLTRB(0 * (MediaQuery.of(context).size.width / 360), 28 * (MediaQuery.of(context).size.height / 360),
                          0 * (MediaQuery.of(context).size.width / 360), 3 * (MediaQuery.of(context).size.height / 360)),
                      child: Container(
                        width: 130 * (MediaQuery.of(context).size.width / 360),
                        height: 37 * (MediaQuery.of(context).size.height / 360),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.0),
                          color: Colors.white,
                          border: Border.all(
                            color: Color(0xffE47421),
                            width: 1,
                          ),
                        ),
                        child: Center(
                          child: TextButton(
                            onPressed: (){
                              Navigator.of(context).pop(false);
                            },
                            child: Center(
                              child: Text(
                                "다시 보지않기",
                                style: TextStyle(
                                  fontSize: 14 * (MediaQuery.of(context).size.width / 360),
                                  color: Color(0xffE47421),
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.fromLTRB(5 * (MediaQuery.of(context).size.width / 360), 28 * (MediaQuery.of(context).size.height / 360),
                          0 * (MediaQuery.of(context).size.width / 360), 3 * (MediaQuery.of(context).size.height / 360)),
                      child: Container(
                        width: 130 * (MediaQuery.of(context).size.width / 360),
                        height: 37 * (MediaQuery.of(context).size.height / 360),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.0),
                          color: Color(0xffE47421),
                        ),
                        child: Center(
                          child: TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: Center(
                              child: Text(
                                "이벤트에 참여하세요",
                                style: TextStyle(
                                  fontSize: 14 * (MediaQuery.of(context).size.width / 360),
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      );
    },
  ).then((value) {
    if(value == true) {
      Navigator.push(context, MaterialPageRoute(
        builder: (context) {
          return MainPage();
        },
      ));
    } else if(value == false) {
      _noticeCancle();
      Navigator.push(context, MaterialPageRoute(
        builder: (context) {
          return MainPage();
        },
      ));
    }
  });
}

/* 공지 다시보지 않기 여부 */
void _noticeCancle() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setString("notice_yn", 'N');
  print(prefs.getString("notice_yn"));
}

