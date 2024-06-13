import 'package:flutter/material.dart';
import 'package:hoty/common/footer.dart';
import 'package:hoty/counseling/counseling_filter.dart';
import 'package:hoty/counseling/counseling_write.dart';
import 'package:hoty/main/main_page.dart';
import 'package:hoty/service/service.dart';

import '../common/dialog/commonAlert.dart';
import 'counseling_guide.dart';

class CounselingList extends StatefulWidget {
  final String table_nm;

  const CounselingList({Key? key,
    required this.table_nm
  }) : super(key:key);

  @override
  State<CounselingList> createState() => _CounselingListState();
}

class _CounselingListState extends State<CounselingList> {
  final GlobalKey servicecat_key = GlobalKey();

  List<String> interiorList = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Scrollable.ensureVisible(
        servicecat_key.currentContext!,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          // visualDensity: VisualDensity(horizontal: -2.0, vertical: -2.0),
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
          padding : EdgeInsets.fromLTRB(0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360),
              0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360)),
          child: Text("선호 인테리어 선택" , style: TextStyle(fontSize: 17,  color: Colors.black, fontWeight: FontWeight.bold,),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            category(context),
            Container(
                width: 360 * (MediaQuery.of(context).size.width / 360),
                height: 35 * (MediaQuery.of(context).size.height / 360),
                padding: EdgeInsets.fromLTRB(15 * (MediaQuery.of(context).size.width / 360), 7 * (MediaQuery.of(context).size.height / 360),
                    15 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360) ),
                child: Column(
                  children: [
                    Container(
                      alignment: Alignment.centerLeft,
                      padding: EdgeInsets.fromLTRB(5 * (MediaQuery.of(context).size.width / 360),0,
                          0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360) ),
                      child: Text("인테리어 선택",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          // color: Color(0xffE47421),
                        ),
                        textAlign: TextAlign.left,
                      ),
                    ),
                    Container(
                      alignment: Alignment.centerLeft,
                      padding: EdgeInsets.fromLTRB(5 * (MediaQuery.of(context).size.width / 360), 5 * (MediaQuery.of(context).size.height / 360),
                          0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360) ),
                      child: Text("선호하는 인테리어를 클릭해주세요(중복 선택 가능)",
                        style: TextStyle(
                          fontSize: 14,
                          // fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.left,
                      ),
                    ),
                  ],
                )
            ),

            interior(context),

          ],
        ),
      ),
      extendBody: true,
bottomNavigationBar: Footer(nowPage: ''),
    );
  }

  Container interior(BuildContext context) {
    return Container(
            width: 360 * (MediaQuery.of(context).size.width / 360),
            child: Column(
              children: [
                Container(
                  width: 360 * (MediaQuery.of(context).size.width / 360),
                  margin : EdgeInsets.fromLTRB(15 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360),
                      15 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360)),
                  child: Column(
                    children: [
                      Container(
                        margin : EdgeInsets.fromLTRB(0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360),
                            0 * (MediaQuery.of(context).size.width / 360), 5 * (MediaQuery.of(context).size.height / 360)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              width: 160 * (MediaQuery.of(context).size.width / 360),
                              height: 75 * (MediaQuery.of(context).size.height / 360),
                              child: Column(
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        if(interiorList.contains("Vintage")) {
                                          interiorList.remove("Vintage");
                                        }else if(!interiorList.contains("Vintage")) {
                                          interiorList.add("Vintage");
                                        }
                                      });
                                      setState(() {
                                      });
                                    },
                                    child :
                                      Container(
                                        width: 165 * (MediaQuery.of(context).size.width / 360),
                                        height: 75 * (MediaQuery.of(context).size.height / 360),
                                        clipBehavior: Clip.antiAlias,
                                        decoration: BoxDecoration(
                                          image: DecorationImage(
                                            colorFilter: ColorFilter.mode(
                                              Color(0xFFE47421).withOpacity(0.7),
                                              interiorList.contains("Vintage") == true ? BlendMode.srcOver : BlendMode.dst, // 적용할 블렌딩 모드 선택
                                            ),
                                            image: AssetImage('assets/counseling_list01.png'),
                                          ),
                                          borderRadius: BorderRadius.circular(8 * (MediaQuery.of(context).size.height / 360)),
                                        ),
                                        child : Column(
                                          children: [
                                            Container(
                                              child : Row(
                                                mainAxisAlignment: MainAxisAlignment.end,
                                                children: [
                                                  Container(
                                                      width: 30 * (MediaQuery.of(context).size.width / 360),
                                                      height: 13 * (MediaQuery.of(context).size.height / 360),
                                                      margin : EdgeInsets.fromLTRB(15 * (MediaQuery.of(context).size.width / 360), 4 * (MediaQuery.of(context).size.height / 360),
                                                          10 * (MediaQuery.of(context).size.width / 360), 4 * (MediaQuery.of(context).size.height / 360)),
                                                      padding : EdgeInsets.fromLTRB(8 * (MediaQuery.of(context).size.width / 360), 4 * (MediaQuery.of(context).size.height / 360),
                                                          8 * (MediaQuery.of(context).size.width / 360), 4 * (MediaQuery.of(context).size.height / 360)),
                                                      clipBehavior: Clip.antiAlias,
                                                      decoration: BoxDecoration(
                                                        shape: BoxShape.circle,
                                                        color: Colors.white,
                                                      ),
                                                      /*decoration: ShapeDecoration(
                                                        color: Colors.white,
                                                        shape: RoundedRectangleBorder(
                                                          borderRadius: BorderRadius.circular(100),
                                                        ),
                                                      ),*/
                                                      child : Image(image: AssetImage("assets/check_icon.png",), width: 2 * (MediaQuery.of(context).size.width / 360),height: 2 * (MediaQuery.of(context).size.height / 360), color : interiorList.contains("Vintage") == true ? Color(0xFFE47421) : Color(0xffC4CCD0) )
                                                  ),
                                                ],
                                              )
                                            ),
                                            Center(
                                              child : Container(
                                                margin : EdgeInsets.fromLTRB(8 * (MediaQuery.of(context).size.width / 360), 6 * (MediaQuery.of(context).size.height / 360),
                                                    8 * (MediaQuery.of(context).size.width / 360), 2 * (MediaQuery.of(context).size.height / 360)),
                                                padding : EdgeInsets.fromLTRB(25 * (MediaQuery.of(context).size.width / 360), 5 * (MediaQuery.of(context).size.height / 360),
                                                    25 * (MediaQuery.of(context).size.width / 360), 5 * (MediaQuery.of(context).size.height / 360)),
                                                decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.circular(30),
                                                    border: Border.all(width : 3 * (MediaQuery.of(context).size.width / 360), color: Color(0xffFFFFFF))
                                                ),
                                                child: Text("Vintage", style: TextStyle(color: Color(0xffFFFFFF), fontWeight: FontWeight.bold),),
                                              ),
                                            ),
                                          ],
                                        )
                                      ),
                                  ),
                                  // 하단 정보

                                ],
                              ),
                            ),
                            Container(
                              width: 160 * (MediaQuery.of(context).size.width / 360),
                              height: 75 * (MediaQuery.of(context).size.height / 360),
                              child: Column(
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        if(interiorList.contains("Minimal")) {
                                          interiorList.remove("Minimal");
                                        } else if(!interiorList.contains("Minimal")) {
                                          interiorList.add("Minimal");
                                        }
                                      });
                                      setState(() {
                                      });
                                    },
                                    child : Container(
                                        width: 165 * (MediaQuery.of(context).size.width / 360),
                                        height: 75 * (MediaQuery.of(context).size.height / 360),
                                        clipBehavior: Clip.antiAlias,
                                        decoration: BoxDecoration(
                                          image: DecorationImage(
                                            colorFilter: ColorFilter.mode(
                                              Color(0xFFE47421).withOpacity(0.7),
                                              interiorList.contains("Minimal") == true ? BlendMode.srcOver : BlendMode.dst, // 적용할 블렌딩 모드 선택
                                            ),
                                            image: AssetImage('assets/counseling_list02.png'),
                                          ),
                                          borderRadius: BorderRadius.circular(8 * (MediaQuery.of(context).size.height / 360)),
                                        ),
                                        child : Column(
                                          children: [
                                            Container(
                                                child : Row(
                                                  mainAxisAlignment: MainAxisAlignment.end,
                                                  children: [
                                                    Container(
                                                        width: 30 * (MediaQuery.of(context).size.width / 360),
                                                        height: 13 * (MediaQuery.of(context).size.height / 360),
                                                        margin : EdgeInsets.fromLTRB(15 * (MediaQuery.of(context).size.width / 360), 4 * (MediaQuery.of(context).size.height / 360),
                                                            10 * (MediaQuery.of(context).size.width / 360), 4 * (MediaQuery.of(context).size.height / 360)),
                                                        padding : EdgeInsets.fromLTRB(8 * (MediaQuery.of(context).size.width / 360), 4 * (MediaQuery.of(context).size.height / 360),
                                                            8 * (MediaQuery.of(context).size.width / 360), 4 * (MediaQuery.of(context).size.height / 360)),
                                                        clipBehavior: Clip.antiAlias,
                                                        decoration: BoxDecoration(
                                                          shape: BoxShape.circle,
                                                          color: Colors.white,
                                                        ),
                                                        /*decoration: ShapeDecoration(
                                                        color: Colors.white,
                                                        shape: RoundedRectangleBorder(
                                                          borderRadius: BorderRadius.circular(100),
                                                        ),
                                                      ),*/
                                                        child : Image(image: AssetImage("assets/check_icon.png",), width: 2 * (MediaQuery.of(context).size.width / 360),height: 2 * (MediaQuery.of(context).size.height / 360), color : interiorList.contains("Minimal") == true ? Color(0xFFE47421) : Color(0xffC4CCD0) )
                                                    ),
                                                  ],
                                                )
                                            ),
                                            Center(
                                              child : Container(
                                                margin : EdgeInsets.fromLTRB(8 * (MediaQuery.of(context).size.width / 360), 6 * (MediaQuery.of(context).size.height / 360),
                                                    8 * (MediaQuery.of(context).size.width / 360), 2 * (MediaQuery.of(context).size.height / 360)),
                                                padding : EdgeInsets.fromLTRB(25 * (MediaQuery.of(context).size.width / 360), 5 * (MediaQuery.of(context).size.height / 360),
                                                    25 * (MediaQuery.of(context).size.width / 360), 5 * (MediaQuery.of(context).size.height / 360)),
                                                decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.circular(30),
                                                    border: Border.all(width : 3 * (MediaQuery.of(context).size.width / 360), color: Color(0xffFFFFFF))
                                                ),
                                                child: Text("Minimal", style: TextStyle(color: Color(0xffFFFFFF), fontWeight: FontWeight.bold),),
                                              ),
                                            ),
                                          ],
                                        )
                                    ),
                                  ),
                                  // 하단 정보

                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        margin : EdgeInsets.fromLTRB(0 * (MediaQuery.of(context).size.width / 360), 2.5 * (MediaQuery.of(context).size.height / 360),
                            0 * (MediaQuery.of(context).size.width / 360), 5 * (MediaQuery.of(context).size.height / 360)),
                        // padding: EdgeInsets.all(5),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              width: 160 * (MediaQuery.of(context).size.width / 360),
                              height: 75 * (MediaQuery.of(context).size.height / 360),
                              child: Column(
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        if(interiorList.contains("Modern")) {
                                          interiorList.remove("Modern");
                                        }else if(!interiorList.contains("Modern")) {
                                          interiorList.add("Modern");
                                        }
                                      });
                                      setState(() {
                                      });
                                    },
                                    child : Container(
                                        width: 165 * (MediaQuery.of(context).size.width / 360),
                                        height: 75 * (MediaQuery.of(context).size.height / 360),
                                        clipBehavior: Clip.antiAlias,
                                        decoration: BoxDecoration(
                                          image: DecorationImage(
                                            colorFilter: ColorFilter.mode(
                                              Color(0xFFE47421).withOpacity(0.7),
                                              interiorList.contains("Modern") == true ? BlendMode.srcOver : BlendMode.dst, // 적용할 블렌딩 모드 선택
                                            ),
                                            image: AssetImage('assets/counseling_list03.png'),
                                          ),
                                          borderRadius: BorderRadius.circular(8 * (MediaQuery.of(context).size.height / 360)),
                                        ),
                                        child : Column(
                                          children: [
                                            Container(
                                                child : Row(
                                                  mainAxisAlignment: MainAxisAlignment.end,
                                                  children: [
                                                    Container(
                                                        width: 30 * (MediaQuery.of(context).size.width / 360),
                                                        height: 13 * (MediaQuery.of(context).size.height / 360),
                                                        margin : EdgeInsets.fromLTRB(15 * (MediaQuery.of(context).size.width / 360), 4 * (MediaQuery.of(context).size.height / 360),
                                                            10 * (MediaQuery.of(context).size.width / 360), 4 * (MediaQuery.of(context).size.height / 360)),
                                                        padding : EdgeInsets.fromLTRB(8 * (MediaQuery.of(context).size.width / 360), 4 * (MediaQuery.of(context).size.height / 360),
                                                            8 * (MediaQuery.of(context).size.width / 360), 4 * (MediaQuery.of(context).size.height / 360)),
                                                        clipBehavior: Clip.antiAlias,
                                                        decoration: BoxDecoration(
                                                          shape: BoxShape.circle,
                                                          color: Colors.white,
                                                        ),
                                                        /*decoration: ShapeDecoration(
                                                        color: Colors.white,
                                                        shape: RoundedRectangleBorder(
                                                          borderRadius: BorderRadius.circular(100),
                                                        ),
                                                      ),*/
                                                        child : Image(image: AssetImage("assets/check_icon.png",), width: 2 * (MediaQuery.of(context).size.width / 360),height: 2 * (MediaQuery.of(context).size.height / 360), color : interiorList.contains("Modern") == true ? Color(0xFFE47421) : Color(0xffC4CCD0) )
                                                    ),
                                                  ],
                                                )
                                            ),
                                            Center(
                                              child : Container(
                                                margin : EdgeInsets.fromLTRB(8 * (MediaQuery.of(context).size.width / 360), 6 * (MediaQuery.of(context).size.height / 360),
                                                    8 * (MediaQuery.of(context).size.width / 360), 2 * (MediaQuery.of(context).size.height / 360)),
                                                padding : EdgeInsets.fromLTRB(25 * (MediaQuery.of(context).size.width / 360), 5 * (MediaQuery.of(context).size.height / 360),
                                                    25 * (MediaQuery.of(context).size.width / 360), 5 * (MediaQuery.of(context).size.height / 360)),
                                                decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.circular(30),
                                                    border: Border.all(width : 3 * (MediaQuery.of(context).size.width / 360), color: Color(0xffFFFFFF))
                                                ),
                                                child: Text("Modern", style: TextStyle(color: Color(0xffFFFFFF), fontWeight: FontWeight.bold),),
                                              ),
                                            ),
                                          ],
                                        )
                                    ),
                                  ),
                                  // 하단 정보
                                ],
                              ),
                            ),
                            Container(
                              width: 160 * (MediaQuery.of(context).size.width / 360),
                              height: 75 * (MediaQuery.of(context).size.height / 360),
                              child: Column(
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        if(interiorList.contains("Natural")) {
                                          interiorList.remove("Natural");
                                        } else if(!interiorList.contains("Natural")) {
                                          interiorList.add("Natural");
                                        }
                                      });
                                      setState(() {
                                      });
                                    },
                                    child : Container(
                                        width: 165 * (MediaQuery.of(context).size.width / 360),
                                        height: 75 * (MediaQuery.of(context).size.height / 360),
                                        clipBehavior: Clip.antiAlias,
                                        decoration: BoxDecoration(
                                          image: DecorationImage(
                                            colorFilter: ColorFilter.mode(
                                              Color(0xFFE47421).withOpacity(0.7),
                                              interiorList.contains("Natural") == true ? BlendMode.srcOver : BlendMode.dst, // 적용할 블렌딩 모드 선택
                                            ),
                                            image: AssetImage('assets/counseling_list04.png'),
                                          ),
                                          borderRadius: BorderRadius.circular(8 * (MediaQuery.of(context).size.height / 360)),
                                        ),
                                        child : Column(
                                          children: [
                                            Container(
                                                child : Row(
                                                  mainAxisAlignment: MainAxisAlignment.end,
                                                  children: [
                                                    Container(
                                                        width: 30 * (MediaQuery.of(context).size.width / 360),
                                                        height: 13 * (MediaQuery.of(context).size.height / 360),
                                                        margin : EdgeInsets.fromLTRB(15 * (MediaQuery.of(context).size.width / 360), 4 * (MediaQuery.of(context).size.height / 360),
                                                            10 * (MediaQuery.of(context).size.width / 360), 4 * (MediaQuery.of(context).size.height / 360)),
                                                        padding : EdgeInsets.fromLTRB(8 * (MediaQuery.of(context).size.width / 360), 4 * (MediaQuery.of(context).size.height / 360),
                                                            8 * (MediaQuery.of(context).size.width / 360), 4 * (MediaQuery.of(context).size.height / 360)),
                                                        clipBehavior: Clip.antiAlias,
                                                        decoration: BoxDecoration(
                                                          shape: BoxShape.circle,
                                                          color: Colors.white,
                                                        ),
                                                        /*decoration: ShapeDecoration(
                                                        color: Colors.white,
                                                        shape: RoundedRectangleBorder(
                                                          borderRadius: BorderRadius.circular(100),
                                                        ),
                                                      ),*/
                                                        child : Image(image: AssetImage("assets/check_icon.png",), width: 2 * (MediaQuery.of(context).size.width / 360),height: 2 * (MediaQuery.of(context).size.height / 360), color : interiorList.contains("Natural") == true ? Color(0xFFE47421) : Color(0xffC4CCD0) )
                                                    ),
                                                  ],
                                                )
                                            ),
                                            Center(
                                              child : Container(
                                                margin : EdgeInsets.fromLTRB(8 * (MediaQuery.of(context).size.width / 360), 6 * (MediaQuery.of(context).size.height / 360),
                                                    8 * (MediaQuery.of(context).size.width / 360), 2 * (MediaQuery.of(context).size.height / 360)),
                                                padding : EdgeInsets.fromLTRB(25 * (MediaQuery.of(context).size.width / 360), 5 * (MediaQuery.of(context).size.height / 360),
                                                    25 * (MediaQuery.of(context).size.width / 360), 5 * (MediaQuery.of(context).size.height / 360)),
                                                decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.circular(30),
                                                    border: Border.all(width : 3 * (MediaQuery.of(context).size.width / 360), color: Color(0xffFFFFFF))
                                                ),
                                                child: Text("Natural", style: TextStyle(color: Color(0xffFFFFFF), fontWeight: FontWeight.bold),),
                                              ),
                                            ),
                                          ],
                                        )
                                    ),
                                  ),
                                  // 하단 정보
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        margin : EdgeInsets.fromLTRB(0 * (MediaQuery.of(context).size.width / 360), 2.5 * (MediaQuery.of(context).size.height / 360),
                            0 * (MediaQuery.of(context).size.width / 360), 5 * (MediaQuery.of(context).size.height / 360)),
                        // padding: EdgeInsets.all(5),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              width: 160 * (MediaQuery.of(context).size.width / 360),
                              height: 75 * (MediaQuery.of(context).size.height / 360),
                              child: Column(
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        if(interiorList.contains("Nordic")) {
                                          interiorList.remove("Nordic");
                                        } else if(!interiorList.contains("Nordic")) {
                                          interiorList.add("Nordic");
                                        }
                                      });
                                      setState(() {
                                      });
                                    },
                                    child : Container(
                                        width: 165 * (MediaQuery.of(context).size.width / 360),
                                        height: 75 * (MediaQuery.of(context).size.height / 360),
                                        clipBehavior: Clip.antiAlias,
                                        decoration: BoxDecoration(
                                          image: DecorationImage(
                                            colorFilter: ColorFilter.mode(
                                              Color(0xFFE47421).withOpacity(0.7),
                                              interiorList.contains("Nordic") == true ? BlendMode.srcOver : BlendMode.dst, // 적용할 블렌딩 모드 선택
                                            ),
                                            image: AssetImage('assets/counseling_list05.png'),
                                          ),
                                          borderRadius: BorderRadius.circular(8 * (MediaQuery.of(context).size.height / 360)),
                                        ),
                                        child : Column(
                                          children: [
                                            Container(
                                                child : Row(
                                                  mainAxisAlignment: MainAxisAlignment.end,
                                                  children: [
                                                    Container(
                                                        width: 30 * (MediaQuery.of(context).size.width / 360),
                                                        height: 13 * (MediaQuery.of(context).size.height / 360),
                                                        margin : EdgeInsets.fromLTRB(15 * (MediaQuery.of(context).size.width / 360), 4 * (MediaQuery.of(context).size.height / 360),
                                                            10 * (MediaQuery.of(context).size.width / 360), 4 * (MediaQuery.of(context).size.height / 360)),
                                                        padding : EdgeInsets.fromLTRB(8 * (MediaQuery.of(context).size.width / 360), 4 * (MediaQuery.of(context).size.height / 360),
                                                            8 * (MediaQuery.of(context).size.width / 360), 4 * (MediaQuery.of(context).size.height / 360)),
                                                        clipBehavior: Clip.antiAlias,
                                                        decoration: BoxDecoration(
                                                          shape: BoxShape.circle,
                                                          color: Colors.white,
                                                        ),
                                                        /*decoration: ShapeDecoration(
                                                        color: Colors.white,
                                                        shape: RoundedRectangleBorder(
                                                          borderRadius: BorderRadius.circular(100),
                                                        ),
                                                      ),*/
                                                        child : Image(image: AssetImage("assets/check_icon.png",), width: 2 * (MediaQuery.of(context).size.width / 360),height: 2 * (MediaQuery.of(context).size.height / 360), color : interiorList.contains("Nordic") == true ? Color(0xFFE47421) : Color(0xffC4CCD0) )
                                                    ),
                                                  ],
                                                )
                                            ),
                                            Center(
                                              child : Container(
                                                margin : EdgeInsets.fromLTRB(8 * (MediaQuery.of(context).size.width / 360), 6 * (MediaQuery.of(context).size.height / 360),
                                                    8 * (MediaQuery.of(context).size.width / 360), 2 * (MediaQuery.of(context).size.height / 360)),
                                                padding : EdgeInsets.fromLTRB(25 * (MediaQuery.of(context).size.width / 360), 5 * (MediaQuery.of(context).size.height / 360),
                                                    25 * (MediaQuery.of(context).size.width / 360), 5 * (MediaQuery.of(context).size.height / 360)),
                                                decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.circular(30),
                                                    border: Border.all(width : 3 * (MediaQuery.of(context).size.width / 360), color: Color(0xffFFFFFF))
                                                ),
                                                child: Text("Nordic", style: TextStyle(color: Color(0xffFFFFFF), fontWeight: FontWeight.bold),),
                                              ),
                                            ),
                                          ],
                                        )
                                    ),
                                  ),
                                  // 하단 정보
                                ],
                              ),
                            ),
                            Container(
                              width: 160 * (MediaQuery.of(context).size.width / 360),
                              height: 75 * (MediaQuery.of(context).size.height / 360),
                              child: Column(
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        if(interiorList.contains("Romantic")) {
                                          interiorList.remove("Romantic");
                                        } else if(!interiorList.contains("Romantic")) {
                                          interiorList.add("Romantic");
                                        }
                                      });
                                      setState(() {
                                      });
                                    },
                                    child : Container(
                                        width: 165 * (MediaQuery.of(context).size.width / 360),
                                        height: 75 * (MediaQuery.of(context).size.height / 360),
                                        clipBehavior: Clip.antiAlias,
                                        decoration: BoxDecoration(
                                          image: DecorationImage(
                                            colorFilter: ColorFilter.mode(
                                              Color(0xFFE47421).withOpacity(0.7),
                                              interiorList.contains("Romantic") == true ? BlendMode.srcOver : BlendMode.dst, // 적용할 블렌딩 모드 선택
                                            ),
                                            image: AssetImage('assets/counseling_list06.png'),
                                          ),
                                          borderRadius: BorderRadius.circular(8 * (MediaQuery.of(context).size.height / 360)),
                                        ),
                                        child : Column(
                                          children: [
                                            Container(
                                                child : Row(
                                                  mainAxisAlignment: MainAxisAlignment.end,
                                                  children: [
                                                    Container(
                                                        width: 30 * (MediaQuery.of(context).size.width / 360),
                                                        height: 13 * (MediaQuery.of(context).size.height / 360),
                                                        margin : EdgeInsets.fromLTRB(15 * (MediaQuery.of(context).size.width / 360), 4 * (MediaQuery.of(context).size.height / 360),
                                                            10 * (MediaQuery.of(context).size.width / 360), 4 * (MediaQuery.of(context).size.height / 360)),
                                                        padding : EdgeInsets.fromLTRB(8 * (MediaQuery.of(context).size.width / 360), 4 * (MediaQuery.of(context).size.height / 360),
                                                            8 * (MediaQuery.of(context).size.width / 360), 4 * (MediaQuery.of(context).size.height / 360)),
                                                        clipBehavior: Clip.antiAlias,
                                                        decoration: BoxDecoration(
                                                          shape: BoxShape.circle,
                                                          color: Colors.white,
                                                        ),
                                                        /*decoration: ShapeDecoration(
                                                        color: Colors.white,
                                                        shape: RoundedRectangleBorder(
                                                          borderRadius: BorderRadius.circular(100),
                                                        ),
                                                      ),*/
                                                        child : Image(image: AssetImage("assets/check_icon.png",), width: 2 * (MediaQuery.of(context).size.width / 360),height: 2 * (MediaQuery.of(context).size.height / 360), color : interiorList.contains("Romantic") == true ? Color(0xFFE47421) : Color(0xffC4CCD0) )
                                                    ),
                                                  ],
                                                )
                                            ),
                                            Center(
                                              child : Container(
                                                margin : EdgeInsets.fromLTRB(8 * (MediaQuery.of(context).size.width / 360), 6 * (MediaQuery.of(context).size.height / 360),
                                                    8 * (MediaQuery.of(context).size.width / 360), 2 * (MediaQuery.of(context).size.height / 360)),
                                                padding : EdgeInsets.fromLTRB(25 * (MediaQuery.of(context).size.width / 360), 5 * (MediaQuery.of(context).size.height / 360),
                                                    25 * (MediaQuery.of(context).size.width / 360), 5 * (MediaQuery.of(context).size.height / 360)),
                                                decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.circular(30),
                                                    border: Border.all(width : 3 * (MediaQuery.of(context).size.width / 360), color: Color(0xffFFFFFF))
                                                ),
                                                child: Text("Romantic", style: TextStyle(color: Color(0xffFFFFFF), fontWeight: FontWeight.bold),),
                                              ),
                                            ),
                                          ],
                                        )
                                    ),
                                  ),
                                  // 하단 정보
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ), // list


                Container(
                  width: 350 * (MediaQuery.of(context).size.width / 360),
                  height: 30 * (MediaQuery.of(context).size.height / 360),
                  margin : EdgeInsets.fromLTRB(0 * (MediaQuery.of(context).size.width / 360), 10 * (MediaQuery.of(context).size.height / 360),
                      0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360)),
                  child: Row(
                    children: [
                      Container(
                        width: 350 * (MediaQuery.of(context).size.width / 360),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Color.fromRGBO(228, 116, 33, 1),
                              padding: EdgeInsets.symmetric(horizontal: 5 * (MediaQuery.of(context).size.width / 360), vertical: 10 * (MediaQuery.of(context).size.height / 360)),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8 * (MediaQuery.of(context).size.height / 360))
                              )
                          ),
                          onPressed: (){
                            if(interiorList.length > 0) {
                              Navigator.push(context, MaterialPageRoute(
                                builder: (context) {
                                  return CounselingFilter(subtitle: "I2",
                                    getcheckList: [],
                                    table_nm: widget.table_nm,
                                    interiorList: interiorList,);
                                },
                              ));
                            } else {
                              showDialog(context: context,
                                  builder: (BuildContext context) {
                                    return textalert(context,  "최소 1개 이상은 선택해야합니다.",);
                                  }
                              );
                            }
                          },
                          child:  Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text('다음으로', style: TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),textAlign: TextAlign.center,),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                )// more
                ,Container(
                  margin: EdgeInsets.fromLTRB(
                    0 * (MediaQuery.of(context).size.width / 360),
                    40 * (MediaQuery.of(context).size.height / 360),
                    0 * (MediaQuery.of(context).size.width / 360),
                    0 * (MediaQuery.of(context).size.height / 360),
                  ),
                ),
              ],
            ),
          );
  }

  Container category(BuildContext context) {
    return Container(
      child : SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
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
            if(widget.table_nm == "REAL_ESTATE_INTRP_SRVC")
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
              ),
          ],
        ),
      ),

    );
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
            "최소 1개 이상은 선택해야합니다.",
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