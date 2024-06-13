import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:hoty/common/footer.dart';
import 'package:hoty/main/main_page.dart';
import 'package:http/http.dart' as http;

import '../../common/icons/my_icons.dart';

class ProfileCustomerServiceDetail extends StatefulWidget {
  final int cat;
  final String title;

  const ProfileCustomerServiceDetail({super.key, required int this.cat, required String this.title});

  @override
  State<ProfileCustomerServiceDetail> createState() => _ProfileCustomerServiceDetail();
}
class FAQItem {
  String question;
  String answer;
  bool isExpanded;

  FAQItem({required this.question, required this.answer, this.isExpanded = false});
}
class _ProfileCustomerServiceDetail extends State<ProfileCustomerServiceDetail> {
  List<FAQItem> faqItems = [];
  List<dynamic> list = [];
  bool isExpanded = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getBoardList();
    });

  }

  void getBoardList() async {
    var url = Uri.parse(
      'http://www.hoty.company/mf/member/getMemberServiceGuide.do',
      //'http://192.168.100.31:8080/mf/member/getMemberServiceGuide.do',
    );

    try {

      Map data = {
        "cat": widget.cat,
      };

      var body = json.encode(data);
      var response = await http.post(
          url,
          headers: {"Content-Type": "application/json"},
          body: body
      );

      print('get data');
      if(json.decode(response.body)['state'] == 200) {
        print(json.decode(response.body));
        setState(() {
          list = json.decode(response.body)['result']['boardList'];

          for(var i = 0; i < list.length; i++) {
            faqItems.add(
                FAQItem(
                  question: list[i]['TITLE'],
                  answer: list[i]['CONTS'],
                )
            );
          }
        });
      }

    }catch(e) {
      print(e);
    }

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight( 20 * (MediaQuery.of(context).size.height / 360)),
        child: AppBar(
          titleSpacing: 5,
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
            //width: 80 * (MediaQuery.of(context).size.width / 360),
            //height: 80 * (MediaQuery.of(context).size.height / 360),
            /*child: Image(image: AssetImage('assets/logo.png')),*/
            child: Text(widget.title , style: TextStyle(fontSize: 16 * (MediaQuery.of(context).size.width / 360),  color: Colors.black, fontWeight: FontWeight.bold,),
            ),
          ),
          //centerTitle: true,
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            /*ExpansionPanelList(
              elevation: 1,
              expandedHeaderPadding: EdgeInsets.all(0),
              expansionCallback: (int index, bool isExpanded) {
                setState(() {
                  if(isExpanded){
                    faqItems[index].isExpanded = true;
                  } else {
                    faqItems[index].isExpanded = false;
                  }
                });
              },
              children: faqItems.map<ExpansionPanel>((FAQItem faqItem) {
                return ExpansionPanel(
                  backgroundColor: Colors.white,
                  headerBuilder: (BuildContext context, bool isExpanded) {
                    return ListTile(
                      visualDensity: VisualDensity(vertical: 0, horizontal: -4),
                      horizontalTitleGap: 5 * (MediaQuery.of(context).size.width / 360),
                      onTap: (){
                        setState(() {
                          if(faqItem.isExpanded){
                            faqItem.isExpanded = false;
                          } else {
                            faqItem.isExpanded = true;
                          }
                        });
                      },

                      leading:
                      Container(
                        padding: EdgeInsets.fromLTRB(0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360),
                            0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360) ),
                        margin: EdgeInsets.fromLTRB(0 * (MediaQuery.of(context).size.width / 360), 3 * (MediaQuery.of(context).size.height / 360),
                            0 * (MediaQuery.of(context).size.width / 360), 3 * (MediaQuery.of(context).size.height / 360) ),
                        width: 30 * (MediaQuery.of(context).size.width / 360),
                        child:Icon(My_icons.my_05, size: 22 * (MediaQuery.of(context).size.width / 360),  color: Color(0xffE47421),),
                      ),
                      title: Text(faqItem.question,
                      style: TextStyle(
                        color: faqItem.isExpanded == true ? Color(0xffE47421) : Color(0xff151515)
                      ),
                      ),
                    );
                  },
                  body: ListTile(
                    isThreeLine: false,
                    minVerticalPadding: 0,
                    visualDensity: VisualDensity(vertical: 0, horizontal: -4),
                    horizontalTitleGap: 0,
                    title: Html(
                      data: faqItem.answer,
                    ),
                  ),
                  isExpanded: faqItem.isExpanded,
                );
              }).toList(),
            ),*/
            for(int i=0; i<faqItems.length; i++)
            Container(
              margin: EdgeInsets.fromLTRB(10 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360),
                  10 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360) ),
              child: Column(
                children: [
                  Theme(data: Theme.of(context).copyWith(
                      dividerColor: faqItems[i].isExpanded == false ? Colors.transparent : Colors.transparent,
                      listTileTheme: ListTileTheme.of(context).copyWith(
                        dense: true,
                        minVerticalPadding: 0 * (MediaQuery.of(context).size.height / 360),
                      ),
                  ),
                      child: ExpansionTile(
                        tilePadding: EdgeInsets.symmetric(vertical: 0),
                        childrenPadding: EdgeInsets.all(0),
                        // iconColor: Color(0xffC4CCD0),
                        textColor: Color(0xff0F1316),
                        collapsedIconColor: Color(0xffC4CCD0),
                        // backgroundColor: Color(0xffF3F6F8),
                        onExpansionChanged: (bool expanded) {
                          setState(() {
                            if(faqItems[i].isExpanded){
                              faqItems[i].isExpanded = false;
                            } else {
                              faqItems[i].isExpanded = true;
                            }
                          });
                        },
                        trailing: Icon(
                          faqItems[i].isExpanded == true
                              ? Icons.keyboard_arrow_up_rounded
                              : Icons.keyboard_arrow_down_rounded,
                          // color: faqItems[i].isExpanded == true ? Color(0xffFFFFF) :Color(0xffC4CCD0),
                          color: Color(0xffC4CCD0),
                        ),
                        title: Container(
                          width: 350 * (MediaQuery.of(context).size.width / 360),
                          child: Row(
                            children: [
                              Container(
                                padding: EdgeInsets.fromLTRB(0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360),
                                    0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360) ),
                                margin: EdgeInsets.fromLTRB(0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360),
                                    0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360) ),
                                width: 30 * (MediaQuery.of(context).size.width / 360),
                                child:Icon(My_icons.my_05, size: 20 * (MediaQuery.of(context).size.width / 360),  color: Color(0xffE47421),),
                              ),
                              Container(
                                width: 260 * (MediaQuery.of(context).size.width / 360),
                                child: Text(
                                  '${faqItems[i].question}',
                                  style: TextStyle(
                                    color: faqItems[i].isExpanded == true ? Color(0xffE47421) : Color(0xff151515),
                                    fontSize: 14 * (MediaQuery.of(context).size.width / 360),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        initiallyExpanded: false,
                        children: [
                          Container(
                            width: 350 * (MediaQuery.of(context).size.width / 360),
                            margin: EdgeInsets.fromLTRB(8 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360),
                                0 * (MediaQuery.of(context).size.width / 360), 5 * (MediaQuery.of(context).size.height / 360) ),
                            child: Row(
                              children: [
                                Container(
                                  width: 280 * (MediaQuery.of(context).size.width / 360),
                                  child: /*Html(
                                    data: '${faqItems[i].answer}',
                                  ),*/
                                  Text(
                                    '${faqItems[i].answer}',
                                    style: TextStyle(
                                      color: Color(0xff151515),
                                      fontSize: 14 * (MediaQuery.of(context).size.width / 360),
                                    ),
                                  ),
                                ),
                                /*Container(
                                  width: 280 * (MediaQuery.of(context).size.width / 360),
                                  child: Text(
                                    '${faqItems[i].answer}',
                                  ),
                                ),*/
                                /*   GestureDetector(
                              onTap: (){
                                setState(() {
                                  if(faqItems[i].isExpanded){
                                    faqItems[i].isExpanded = false;
                                  } else {
                                    faqItems[i].isExpanded = true;
                                  }
                                });
                              },
                              child: Container(
                                padding: EdgeInsets.fromLTRB(0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360),
                                    0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360) ),
                                margin: EdgeInsets.fromLTRB(0 * (MediaQuery.of(context).size.width / 360), 3 * (MediaQuery.of(context).size.height / 360),
                                    0 * (MediaQuery.of(context).size.width / 360), 3 * (MediaQuery.of(context).size.height / 360) ),
                                width: 30 * (MediaQuery.of(context).size.width / 360),
                                child:Icon(
                                  Icons.keyboard_arrow_up_rounded, size: 24 * (MediaQuery.of(context).size.width / 360),
                                  color: faqItems[i].isExpanded == false ? Color(0xffFFFFF) :Color(0xffC4CCD0),
                                ),
                              ),
                            ),*/

                              ],
                            ),
                          )
                        ],
                      ),
                  ),

                  if(faqItems.length != i+1)
                    Container(
                      width: 350 * (MediaQuery.of(context).size.width / 360),
                      child: Divider(thickness: 1, height: 1 * (MediaQuery.of(context).size.height / 360),
                          // color: faqItems[i].isExpanded == true ? Color(0xffFFFFFF) : Color(0xffF3F6F8),
                          color: Color(0xffF3F6F8)
                      ),
                    ),

                ],
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
        )
      ),
      extendBody: true,
      bottomNavigationBar: Footer(nowPage: 'My_page'),
    );
  }
}