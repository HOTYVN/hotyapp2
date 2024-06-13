import 'package:flutter/material.dart';
import 'package:hoty/common/footer.dart';
import 'package:hoty/main/main_page.dart';
import 'package:intl/intl.dart';

import '../common/dialog/commonAlert.dart';

class ProfileLanguage extends StatefulWidget {
  @override
  _ProfileLanguageState createState() => _ProfileLanguageState();
}

enum LocaleSet {KO, EN}
class _ProfileLanguageState extends State<ProfileLanguage> {

  int selectedLanguage = 1;

  @override
  void initState() {
    super.initState();
  }

  LocaleSet _localeSet = LocaleSet.KO;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
        titleSpacing: 5,
        leadingWidth: 40,
        title: Container(
          //width: 80 * (MediaQuery.of(context).size.width / 360),
          //height: 80 * (MediaQuery.of(context).size.height / 360),
          /*child: Image(image: AssetImage('assets/logo.png')),*/
          child: Text("언어 설정" , style: TextStyle(fontSize: 17,  color: Colors.black, fontWeight: FontWeight.bold,),
          ),
        ),
        //centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            TextButton(
              onPressed: () {
                Intl.defaultLocale = "en";
                setState(() {
                  selectedLanguage = 0;
                  _localeSet = LocaleSet.EN;
                });
              },
              child: Row(
                children: [
                  Container(
                    padding: EdgeInsets.fromLTRB(
                      10 * (MediaQuery.of(context).size.width / 360),
                      0 * (MediaQuery.of(context).size.height / 360),
                      10 * (MediaQuery.of(context).size.width / 360),
                      0,
                    ),
                    width: 300 * (MediaQuery.of(context).size.width / 360),
                    child: Row(
                      children: [
                        Image.asset('assets/united_kingdom.png', height: 10 * (MediaQuery.of(context).size.height / 360),),
                        SizedBox(width: 10),
                        Text(
                          "English",
                          style: TextStyle(
                            fontSize: 14 * (MediaQuery.of(context).size.width / 360),
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: 35 * (MediaQuery.of(context).size.width / 360),
                    child: Radio(
                      value: 0,
                      groupValue: selectedLanguage,
                      onChanged: (value) {
                        setState(() {
                          selectedLanguage = value!;
                        });
                        ready();
                      },
                      activeColor: Colors.orange,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: 340 * (MediaQuery.of(context).size.width / 360),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: Color.fromRGBO(243, 246, 248, 1),
                    width: 1 * (MediaQuery.of(context).size.width / 360),
                  ),
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                Intl.defaultLocale = "ko";
                setState(() {
                  selectedLanguage = 1;
                  _localeSet = LocaleSet.KO;
                });
                ready();
              },
              child: Row(
                children: [
                  Container(
                    padding: EdgeInsets.fromLTRB(
                      10 * (MediaQuery.of(context).size.width / 360),
                      0 * (MediaQuery.of(context).size.height / 360),
                      10 * (MediaQuery.of(context).size.width / 360),
                      0,
                    ),
                    width: 300 * (MediaQuery.of(context).size.width / 360),
                    child: Row(
                      children: [
                        Image.asset('assets/south_korea.png', height: 10 * (MediaQuery.of(context).size.height / 360),),
                        SizedBox(width: 10),
                        Text(
                          "한국어",
                          style: TextStyle(
                            fontSize: 14 * (MediaQuery.of(context).size.width / 360),
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: 35 * (MediaQuery.of(context).size.width / 360),
                    child: Radio(
                      value: 1,
                      groupValue: selectedLanguage,
                      onChanged: (value) {
                        setState(() {
                          selectedLanguage = value!;
                        });
                        ready();
                      },
                      activeColor: Colors.orange,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      extendBody: true,
bottomNavigationBar: Footer(nowPage: 'My_page'),
    );
  }

  void ready(){
    showDialog(
      barrierColor: Color(0xffE47421).withOpacity(0.4),
      barrierDismissible: false,
      context: context,
        builder: (BuildContext context) {
          return MediaQuery(
            data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
            child: textalert(context,'준비중입니다.'),
          );
        }
    );
  }
}