import 'package:flutter/material.dart';
import 'package:hoty/main/main_page.dart';

void showNoticeModal(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) => _buildNoticeModal(context),
  );
}

Widget _buildNoticeModal(BuildContext context) {
  return AlertDialog(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(15.0),
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
    titlePadding: EdgeInsets.only(bottom: 3),
    content: Container(
      width: 330 * (MediaQuery.of(context).size.width / 360),
      height: 170 * (MediaQuery.of(context).size.height / 360),
      margin : EdgeInsets.fromLTRB(5 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360),
          3 * (MediaQuery.of(context).size.width / 360), 3 * (MediaQuery.of(context).size.height / 360)),
      child: Column(
        children: <Widget>[
          Column(
            children: [
              Text(
                "공지사항",
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          SizedBox(height: 7),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                " hello. This is Hoti. We are holding a participation event.\n Participate in the event and receive points and coupons.\n thank you",
                style: TextStyle(
                  fontSize: 11,
                ),
              ),
            ],
          ),
          SizedBox(height: 10),
          Container(
            padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
            child: SizedBox(
              width: 190 * (MediaQuery.of(context).size.width / 360),
              height: 57 * (MediaQuery.of(context).size.height / 360),
              child: Wrap(
                children: [Image(image: AssetImage('assets/coupon.png')),
                  Container(
                    child: Center(
                      child: TextButton(
                        onPressed: (){

                        },
                        child: Center(
                          child: Text(
                            "Go participate in the event",
                            style: TextStyle(
                              fontSize: 11 * (MediaQuery.of(context).size.width / 360),
                              color: Colors.blueAccent,
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
          ),
          Row(
            children: [
              Container(
                margin: EdgeInsets.fromLTRB(0 * (MediaQuery.of(context).size.width / 360), 20 * (MediaQuery.of(context).size.height / 360),
                    0 * (MediaQuery.of(context).size.width / 360), 3 * (MediaQuery.of(context).size.height / 360)),
                child: Container(
                  width: 115 * (MediaQuery.of(context).size.width / 360),
                  height: 25 * (MediaQuery.of(context).size.height / 360),
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
                        Navigator.push(context, MaterialPageRoute(
                          builder: (context) {
                            return MainPage();
                          },
                        ));
                      },
                      child: Center(
                        child: Text(
                          "don't watch again",
                          style: TextStyle(
                            fontSize: 12 * (MediaQuery.of(context).size.width / 360),
                            color: Color(0xffE47421),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(width: 8), // Adjust the space between the two containers
              Container(
                margin: EdgeInsets.fromLTRB(0 * (MediaQuery.of(context).size.width / 360), 20 * (MediaQuery.of(context).size.height / 360),
                    0 * (MediaQuery.of(context).size.width / 360), 3 * (MediaQuery.of(context).size.height / 360)),
                child: Container(
                  width: 115 * (MediaQuery.of(context).size.width / 360),
                  height: 25 * (MediaQuery.of(context).size.height / 360),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    color: Color(0xffE47421),
                  ),
                  child: Center(
                    child: TextButton(
                      /*onPressed: () {
                          Navigator.of(context, rootNavigator: true).pop('dialog');

                          int randomNumber = Random().nextInt(2);
                          Widget miniGameToShow = (randomNumber == 0) ? MiniGame1() : MiniGame2();
                          showDialog(
                            context: context,
                            barrierDismissible: true,
                            builder: (BuildContext context) => miniGameToShow,
                          );
                        },*/
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Center(
                        child: Text(
                          "이벤트 참여하기",
                          style: TextStyle(
                            fontSize: 12 * (MediaQuery.of(context).size.width / 360),
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
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
  );
}

/*class NoticeModal extends StatefulWidget {
  NoticeModal(BuildContext context);

  @override
  _NoticeModalState createState() => _NoticeModalState();
}

class _NoticeModalState extends State<NoticeModal> {

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
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
      titlePadding: EdgeInsets.only(bottom: 3),
      content: Container(
        width: 330 * (MediaQuery.of(context).size.width / 360),
        height: 170 * (MediaQuery.of(context).size.height / 360),
        margin : EdgeInsets.fromLTRB(5 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360),
            3 * (MediaQuery.of(context).size.width / 360), 3 * (MediaQuery.of(context).size.height / 360)),
        child: Column(
          children: <Widget>[
            Column(
              children: [
                Text(
                  "공지사항",
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            SizedBox(height: 7),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  " 안녕하세요. 호티 입니다. 참여하기 이벤트를 진행 하고 있 \n 습니다. 이벤트 참여하셔서 포인트 및 쿠폰을 받아가세요. \n 감사합니다.",
                  style: TextStyle(
                    fontSize: 11,
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
            Container(
              padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
              child: SizedBox(
                width: 190 * (MediaQuery.of(context).size.width / 360),
                height: 57 * (MediaQuery.of(context).size.height / 360),
                child: Wrap(
                  children: [Image(image: AssetImage('assets/coupon.png')),
                    Container(
                      child: Center(
                        child: TextButton(
                          onPressed: (){

                          },
                          child: Center(
                            child: Text(
                              "이벤트 참여하러 가기",
                              style: TextStyle(
                                fontSize: 11 * (MediaQuery.of(context).size.width / 360),
                                color: Colors.blueAccent,
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
            ),
            Row(
              children: [
                Container(
                  margin: EdgeInsets.fromLTRB(0 * (MediaQuery.of(context).size.width / 360), 20 * (MediaQuery.of(context).size.height / 360),
                      0 * (MediaQuery.of(context).size.width / 360), 3 * (MediaQuery.of(context).size.height / 360)),
                  child: Container(
                    width: 115 * (MediaQuery.of(context).size.width / 360),
                    height: 25 * (MediaQuery.of(context).size.height / 360),
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
                          Navigator.push(context, MaterialPageRoute(
                            builder: (context) {
                              return MainPage();
                            },
                          ));
                        },
                        child: Center(
                          child: Text(
                            "다시보지 않기",
                            style: TextStyle(
                              fontSize: 12 * (MediaQuery.of(context).size.width / 360),
                              color: Color(0xffE47421),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 8), // Adjust the space between the two containers
                Container(
                  margin: EdgeInsets.fromLTRB(0 * (MediaQuery.of(context).size.width / 360), 20 * (MediaQuery.of(context).size.height / 360),
                      0 * (MediaQuery.of(context).size.width / 360), 3 * (MediaQuery.of(context).size.height / 360)),
                  child: Container(
                    width: 115 * (MediaQuery.of(context).size.width / 360),
                    height: 25 * (MediaQuery.of(context).size.height / 360),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      color: Color(0xffE47421),
                    ),
                    child: Center(
                      child: TextButton(
                        *//*onPressed: () {
                          Navigator.of(context, rootNavigator: true).pop('dialog');

                          int randomNumber = Random().nextInt(2);
                          Widget miniGameToShow = (randomNumber == 0) ? MiniGame1() : MiniGame2();
                          showDialog(
                            context: context,
                            barrierDismissible: true,
                            builder: (BuildContext context) => miniGameToShow,
                          );
                        },*//*
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Center(
                          child: Text(
                            "이벤트 참여하기",
                            style: TextStyle(
                              fontSize: 12 * (MediaQuery.of(context).size.width / 360),
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
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
    );
  }

}*/
