import 'package:flutter/material.dart';
import 'package:hoty/landing/landing.dart';
import 'package:url_launcher/url_launcher.dart';

class Follow_us extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return
      Container(
          width: 350 * (MediaQuery.of(context).size.width / 360),
          // height: 85 * (MediaQuery.of(context).size.height / 360),
          child : Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children : [
                Container(
                  padding : EdgeInsets.fromLTRB(0 * (MediaQuery.of(context).size.width / 360), 10  * (MediaQuery.of(context).size.height / 360), 0 * (MediaQuery.of(context).size.width / 360), 0),
                  height: 25 * (MediaQuery.of(context).size.height / 360),
                  child :
                  Text ("Follow us", style : TextStyle(
                    fontSize : 16 * (MediaQuery.of(context).size.width / 360),
                    fontWeight: FontWeight.bold,
                      fontFamily: 'NanumSquareEB',
                    color: Color(0xff0F1316)
                  ),
                    textAlign: TextAlign.center,
                  ),
                ),
                Container(
                    // height: 35 * (MediaQuery.of(context).size.height / 360),
                    margin : EdgeInsets.fromLTRB(2 * (MediaQuery.of(context).size.width / 360), 0  * (MediaQuery.of(context).size.height / 360), 2 * (MediaQuery.of(context).size.width / 360), 0),
                    child : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children : [
                          Column(
                            children: [
                              GestureDetector(
                                onTap: (){
                                  _launchURL("https://www.instagram.com/hoty.official/?next=%2F");
                                },
                                child : Container(
                                  padding : EdgeInsets.fromLTRB(15 * (MediaQuery.of(context).size.width / 360), 0  * (MediaQuery.of(context).size.height / 360), 15 * (MediaQuery.of(context).size.width / 360), 0),
                                  child : Image(image: AssetImage('assets/Instagram.png'), width: (30 * (MediaQuery.of(context).size.width / 360))),
                                ),
                              ),
                              GestureDetector(
                                onTap: (){
                                  Navigator.push(context, MaterialPageRoute(
                                    builder: (context) {
                                      return Landing();
                                    },
                                  ));
                                },
                                child : Container(
                                  // height: 15 * (MediaQuery.of(context).size.height / 360),
                                  padding : EdgeInsets.fromLTRB(0 * (MediaQuery.of(context).size.width / 360), 5  * (MediaQuery.of(context).size.height / 360), 10 * (MediaQuery.of(context).size.width / 360), 5  * (MediaQuery.of(context).size.height / 360)),
                                  child :
                                  Text ("호티소개", style : TextStyle(
                                      fontSize : 14 * (MediaQuery.of(context).size.width / 360),
                                      fontFamily: 'NanumSquareR',
                                      color: Color(0xff0F1316)
                                  ),
                                  ),
                                ),
                              )
                            ],
                          ),
                          GestureDetector(
                            onTap: (){
                              _launchURL("http://pf.kakao.com/_gYrxnG");
                            },
                            child: Column(
                              children: [
                                Container(
                                  padding : EdgeInsets.fromLTRB(15 * (MediaQuery.of(context).size.width / 360), 0  * (MediaQuery.of(context).size.height / 360), 15 * (MediaQuery.of(context).size.width / 360), 0),
                                  child : Image(image: AssetImage('assets/kakaotalk.png'), width: (30 * (MediaQuery.of(context).size.width / 360))),
                                ),
                                Container(
                                  // height: 15 * (MediaQuery.of(context).size.height / 360),
                                  padding : EdgeInsets.fromLTRB(10 * (MediaQuery.of(context).size.width / 360), 5  * (MediaQuery.of(context).size.height / 360), 0 * (MediaQuery.of(context).size.width / 360), 5  * (MediaQuery.of(context).size.height / 360)),
                                  child :
                                  Text ("고객센터", style : TextStyle(
                                      fontSize : 14 * (MediaQuery.of(context).size.width / 360),
                                      fontFamily: 'NanumSquareR',
                                      color: Color(0xff0F1316)
                                  ),
                                  ),
                                ),
                              ],
                            )
                          )
                        ]
                    )
                ),
                Container(
                  // height: 20 * (MediaQuery.of(context).size.height / 360),
                  padding : EdgeInsets.fromLTRB(0 * (MediaQuery.of(context).size.width / 360), 5  * (MediaQuery.of(context).size.height / 360), 0 * (MediaQuery.of(context).size.width / 360), 5  * (MediaQuery.of(context).size.height / 360)),
                  child :
                  Text ("© 2024 HOTY All rights reserved.", style : TextStyle(
                    fontSize : 12 * (MediaQuery.of(context).size.width / 360),
                      fontFamily: 'NanumSquareR',
                      color: Color(0xff0F1316)
                  ),
                  ),
                ),
              ]
          )
      );
  }
  _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}