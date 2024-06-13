import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:hoty/common/footer.dart';
import 'package:hoty/main/main_page.dart';
import 'package:hoty/profile/partnership/profile_partnership_write.dart';

class ProfilePartnership extends StatefulWidget {
  const ProfilePartnership({super.key});

  @override
  State<ProfilePartnership> createState() => _ProfilePartnershipState();
}

class _ProfilePartnershipState extends State<ProfilePartnership> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(40 * (MediaQuery.of(context).size.height / 360)),
        child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          AppBar(
            leadingWidth: 40 * (MediaQuery.of(context).size.width / 360),
            toolbarHeight: 40 * (MediaQuery.of(context).size.height / 360),
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
              // alignment: AlignmentDirectional.bottomEnd,
              //width: 80 * (MediaQuery.of(context).size.width / 360),
              //height: 80 * (MediaQuery.of(context).size.height / 360),
              /*child: Image(image: AssetImage('assets/logo.png')),*/
              child: Container(
                margin: EdgeInsets.fromLTRB(0,  12 * (MediaQuery.of(context).size.height / 360), 0, 0),
                child: Text("제휴 안내" , style: TextStyle(fontSize: 30 * (MediaQuery.of(context).size.width / 360),  color: Color(0xff151515), fontWeight: FontWeight.bold,fontFamily: 'NanumSquareEB',),
                ),
              ),
            ),
            centerTitle: true,
          ),
        ],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
                margin : EdgeInsets.fromLTRB(0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360),
                    0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360)),
                width: 350 * (MediaQuery.of(context).size.width / 360),
                child : Text("호티에게 제안 해주세요!", style: TextStyle(
                    fontFamily: 'NanumSquareEB',
                    fontSize: 19 * (MediaQuery.of(context).size.width / 360), fontWeight: FontWeight.bold,
                    color: Color(0xff151515)
                ),
                  textAlign: TextAlign.center,
                )
            ),
            Container(
              // margin: EdgeInsets.fromLTRB(0, 10 * (MediaQuery.of(context).size.height / 360), 0, 0),
              // height: 250 * (MediaQuery.of(context).size.height / 360),
              child: Column(
                children: [
                  Container(
                    width: 350 * (MediaQuery.of(context).size.width / 360),
                    // height: 55 * (MediaQuery.of(context).size.height / 360),
                    margin : EdgeInsets.fromLTRB(15 * (MediaQuery.of(context).size.width / 360), 5 * (MediaQuery.of(context).size.height / 360),
                        15 * (MediaQuery.of(context).size.width / 360), 5 * (MediaQuery.of(context).size.height / 360)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          margin : EdgeInsets.fromLTRB(10 * (MediaQuery.of(context).size.width / 360), 5 * (MediaQuery.of(context).size.height / 360),
                              0 * (MediaQuery.of(context).size.width / 360), 5 * (MediaQuery.of(context).size.height / 360)),
                          padding: EdgeInsets.all(5),
                          // width: 80 * (MediaQuery.of(context).size.width / 360),
                          // height: 35 * (MediaQuery.of(context).size.height / 360),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Color.fromRGBO(255, 251, 249, 1),
                            // borderRadius: BorderRadius.circular(180 * (MediaQuery.of(context).size.height / 360)),
                          ),
                          child:
                          Center(
                            child: Container(
                              padding: EdgeInsets.all(5),
                              width: 80 * (MediaQuery.of(context).size.width / 360),
                              child: Image(image: AssetImage("assets/partnership_icon01.png"),
                                width: 15 * (MediaQuery.of(context).size.width / 360),
                                height: 28 * (MediaQuery.of(context).size.height / 360),),
                            ),
                          ),
                        ),
                        Container(
                          // width: 250 * (MediaQuery.of(context).size.width / 360),
                          // height: 50 * (MediaQuery.of(context).size.height / 360),
                          child: Column(
                            // mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                width: 200 * (MediaQuery.of(context).size.width / 360),
                                // height: 12 * (MediaQuery.of(context).size.height / 360),
                                margin : EdgeInsets.fromLTRB(10 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360),
                                    0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360)),
                                child: Text("제휴 제안 등록", style: TextStyle(fontWeight: FontWeight.bold,
                                    fontSize: 16 * (MediaQuery.of(context).size.width / 360)),),
                              ),
                              Container(
                                width: 200 * (MediaQuery.of(context).size.width / 360),
                                // height: 25 * (MediaQuery.of(context).size.height / 360),
                                margin : EdgeInsets.fromLTRB(10 * (MediaQuery.of(context).size.width / 360), 5 * (MediaQuery.of(context).size.height / 360),
                                    0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360)),
                                child: Text("HOTY에 제안 해 주실 내용을 등록 해주세요.", style: TextStyle(fontSize: 13 * (MediaQuery.of(context).size.width / 360),height: 0.6 * (MediaQuery.of(context).size.height / 360),),),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: 320 * (MediaQuery.of(context).size.width / 360),
                    child: DottedLine(
                      lineThickness:1.5,
                      dashLength: 1.0,
                      dashColor: Color.fromRGBO(228, 116, 33, 1),
                      direction: Axis.horizontal,
                    ),
                  ),
                  Container(
                    width: 350 * (MediaQuery.of(context).size.width / 360),
                    // height: 55 * (MediaQuery.of(context).size.height / 360),
                    margin : EdgeInsets.fromLTRB(15 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360),
                        15 * (MediaQuery.of(context).size.width / 360), 5 * (MediaQuery.of(context).size.height / 360)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          margin : EdgeInsets.fromLTRB(10 * (MediaQuery.of(context).size.width / 360), 5 * (MediaQuery.of(context).size.height / 360),
                              0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360)),
                          padding: EdgeInsets.all(5),
                          // width: 80 * (MediaQuery.of(context).size.width / 360),
                          // height: 35 * (MediaQuery.of(context).size.height / 360),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Color.fromRGBO(255, 251, 249, 1),
                            // borderRadius: BorderRadius.circular(180 * (MediaQuery.of(context).size.height / 360)),
                          ),
                          child:
                          Center(
                            child: Container(
                              padding: EdgeInsets.all(5),
                              width: 80 * (MediaQuery.of(context).size.width / 360),
                              child: Image(image: AssetImage("assets/partnership_icon02.png"),
                                width: 15 * (MediaQuery.of(context).size.width / 360),height: 28 * (MediaQuery.of(context).size.height / 360),),
                            ),
                          ),
                        ),
                        Container(
                          // width: 250 * (MediaQuery.of(context).size.width / 360),
                          // height: 50 * (MediaQuery.of(context).size.height / 360),
                          child: Column(
                            // mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                width: 200 * (MediaQuery.of(context).size.width / 360),
                                // height: 12 * (MediaQuery.of(context).size.height / 360),
                                margin : EdgeInsets.fromLTRB(10 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360),
                                    0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360)),
                                child: Text("제휴 제안 검토", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16 * (MediaQuery.of(context).size.width / 360)),),
                              ),
                              Container(
                                width: 200 * (MediaQuery.of(context).size.width / 360),
                                // height: 25 * (MediaQuery.of(context).size.height / 360),
                                margin : EdgeInsets.fromLTRB(10 * (MediaQuery.of(context).size.width / 360), 5 * (MediaQuery.of(context).size.height / 360),
                                    0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360)),
                                child: Text("등록해주신 제안을 HOTY \n서비스 담당자가 검토 해요.", style: TextStyle(fontSize: 13 * (MediaQuery.of(context).size.width / 360),height: 0.6 * (MediaQuery.of(context).size.height / 360),),),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: 320 * (MediaQuery.of(context).size.width / 360),
                    child: DottedLine(
                      lineThickness:1.5,
                      dashLength: 1.0,
                      dashColor: Color.fromRGBO(228, 116, 33, 1),
                      direction: Axis.horizontal,
                    ),
                  ),
                  Container(
                    width: 350 * (MediaQuery.of(context).size.width / 360),
                    // height: 55 * (MediaQuery.of(context).size.height / 360),
                    margin : EdgeInsets.fromLTRB(15 * (MediaQuery.of(context).size.width / 360), 5 * (MediaQuery.of(context).size.height / 360),
                        15 * (MediaQuery.of(context).size.width / 360), 5 * (MediaQuery.of(context).size.height / 360)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          margin : EdgeInsets.fromLTRB(10 * (MediaQuery.of(context).size.width / 360), 5 * (MediaQuery.of(context).size.height / 360),
                              0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360)),
                          padding: EdgeInsets.all(5),
                          // width: 80 * (MediaQuery.of(context).size.width / 360),
                          // height: 35 * (MediaQuery.of(context).size.height / 360),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Color.fromRGBO(255, 251, 249, 1),
                            // borderRadius: BorderRadius.circular(180 * (MediaQuery.of(context).size.height / 360)),
                          ),
                          child:
                          Center(
                            child: Container(
                              padding: EdgeInsets.all(5),
                              width: 80 * (MediaQuery.of(context).size.width / 360),
                              child: Image(image: AssetImage("assets/partnership_icon03.png"),
                                width: 15 * (MediaQuery.of(context).size.width / 360),height: 28 * (MediaQuery.of(context).size.height / 360),),
                            ),
                          ),
                        ),
                        Container(
                          // width: 250 * (MediaQuery.of(context).size.width / 360),
                          // height: 50 * (MediaQuery.of(context).size.height / 360),
                          child: Column(
                            // mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                width: 200 * (MediaQuery.of(context).size.width / 360),
                                // height: 12 * (MediaQuery.of(context).size.height / 360),
                                margin : EdgeInsets.fromLTRB(10 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360),
                                    0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360)),
                                child: Text("제휴 제안 회신", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16 * (MediaQuery.of(context).size.width / 360)),),
                              ),
                              Container(
                                width: 200 * (MediaQuery.of(context).size.width / 360),
                                // height: 25 * (MediaQuery.of(context).size.height / 360),
                                margin : EdgeInsets.fromLTRB(10 * (MediaQuery.of(context).size.width / 360), 5 * (MediaQuery.of(context).size.height / 360),
                                    0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360)),
                                child: Text("제안을 검토 한 후 이메일로 검토 결과를 회신 드려요.", style: TextStyle(fontSize: 13 * (MediaQuery.of(context).size.width / 360),height: 0.6 * (MediaQuery.of(context).size.height / 360),),),
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
      ),
      floatingActionButton: SizedBox(
        width: 360 * (MediaQuery.of(context).size.width / 360),
        child:  Container(
          width: 340 * (MediaQuery.of(context).size.width / 360),
          margin: EdgeInsets.fromLTRB(30 * (MediaQuery.of(context).size.width / 360),0,
              0 * (MediaQuery.of(context).size.width / 360),5),
          height: 28 * (MediaQuery.of(context).size.height / 360),
          child:
          ElevatedButton(
            style: ElevatedButton.styleFrom(
                elevation: 0,
                backgroundColor: Color.fromRGBO(228, 116, 33, 1),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(3 * (MediaQuery.of(context).size.height / 360))
                )
            ),
            onPressed: (){
              Navigator.push(context, MaterialPageRoute(
                builder: (context) {
                  return ProfilePartnershipWrite();
                },
              ));
            },
            child: (
                Text("제안하러 가기", style: TextStyle(fontSize: 20 , fontWeight: FontWeight.bold , color:Color.fromRGBO(255,255,255,1)),)
            ),
          ),
        ),
      ),
      extendBody: true,
        bottomNavigationBar: Footer(nowPage: 'My_page'),
    );
  }
}