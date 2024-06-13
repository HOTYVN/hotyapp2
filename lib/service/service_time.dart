import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:hoty/common/footer.dart';
import 'package:hoty/service/service_guide.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:time_picker_spinner/time_picker_spinner.dart';

class ServiceTime extends StatefulWidget {
  final dynamic time;
  final dynamic time_type;

  const ServiceTime({Key ? key,
    required this.time,
    required this.time_type,
  }) : super(key:key);

  @override
  State<ServiceTime> createState() => _ServiceTimeState();
}

class _ServiceTimeState extends State<ServiceTime> {


  int pop_check = 1;

  String returnDate = DateTime.now().year.toString() + "-" + DateTime.now().month.toString()  + "-" + DateTime.now().day.toString();
  String returnTime = "";



  DateTime selectedDay = DateTime(
    DateTime.now().year,
    DateTime.now().month,
    DateTime.now().day,
  );

  DateTime focusedDay = DateTime(
    DateTime.now().year,
    DateTime.now().month,
    DateTime.now().day,
  );

  List<String> timeSlots = [];
  var timeSlots_quotient = 0;
  var timeSlots_remainder = 0;
  var timeSlots_length = 0;
  var time_chk = 0;
  void timelist() {
    String startTime = "08:30";
    String closeTime = "22:00";
    String space = "00:10";

    Duration spaceDuration = Duration(minutes: int.parse(space.split(':')[1]), hours: int.parse(space.split(':')[0]));
    TimeOfDay start = TimeOfDay(hour: int.parse(startTime.split(':')[0]), minute: int.parse(startTime.split(':')[1]));
    TimeOfDay close = TimeOfDay(hour: int.parse(closeTime.split(':')[0]), minute: int.parse(closeTime.split(':')[1]));

    while (start.hour < close.hour || (start.hour == close.hour && start.minute <= close.minute)) {
      timeSlots.add(start.hour.toString().padLeft(2, "0") + ":" + start.minute.toString().padLeft(2, "0"));
      final time = DateTime(0, 0, 0, start.hour, start.minute).add(spaceDuration);
      start = TimeOfDay(hour: time.hour, minute: time.minute);
    }

    timeSlots_quotient = timeSlots.length~/12;
    timeSlots_remainder = timeSlots.length%12;
    timeSlots_length = timeSlots_quotient + timeSlots_remainder;

  }

  DateTime dateTime = DateTime.now();

  @override
  void initState() {

    if(widget.time_type == 'start_time' || widget.time_type == 'end_time') {
      if(widget.time_type == 'start_time') {
        if (DateTime.now().month.toString().length == 1) {
          returnDate = DateTime.now().year.toString() + "-0" + DateTime.now().month.toString() + "-" + DateTime.now().day.toString();
        }

        if (DateTime.now().day.toString().length == 1) {
          returnDate = DateTime.now().year.toString() + "-" + DateTime.now().month.toString() + "-0" + DateTime.now().day.toString();
        }

        if (DateTime.now().day.toString().length == 1 && DateTime.now().month.toString().length == 1) {
          returnDate = DateTime.now().year.toString() + "-0" + DateTime.now().month.toString() + "-0" + DateTime.now().day.toString();
        }

        dateTime = dateTime.add(Duration(hours: 2));
        if(dateTime.minute % 10 == 0) {

        } else {
          dateTime = dateTime.add(Duration(minutes: 10));
        }
        selectedDay = dateTime;
        returnDate =  DateFormat("yyyy-MM-dd").format(dateTime).toString();
        print(dateTime);
        print("시간 확인");
      } else if (widget.time_type == 'end_time') {
        if(widget.time != null && widget.time != '') {
          dateTime = DateTime.parse(widget.time).add(Duration(hours: 4));
          selectedDay = dateTime;
          returnDate =  DateFormat("yyyy-MM-dd").format(dateTime).toString();
        }
      }
    }






    super.initState();
    timelist();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap : () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
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
                Navigator.pop(context);
              },
            ),
            titleSpacing: 5,
            leadingWidth: 40,
            title: Container(
              //width: 80 * (MediaQuery.of(context).size.width / 360),
              //height: 80 * (MediaQuery.of(context).size.height / 360),
              /*child: Image(image: AssetImage('assets/logo.png')),*/
              child: Text("출장 일정 선택" , style: TextStyle(fontSize: 18,  color: Colors.black, fontWeight: FontWeight.bold,),
              ),
            ),
            //centerTitle: true,
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                    width: 360 * (MediaQuery.of(context).size.width / 360),
                    margin : EdgeInsets.fromLTRB(15 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360),
                        15 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360)),
                    decoration: BoxDecoration(
                        color: Color(0xffFFFFFF),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.2),
                            blurRadius: 5.0,
                            spreadRadius: 0.0,
                            offset: const Offset(0,7),
                          )
                        ]
                    ),
                    child : TableCalendar(
                      rowHeight: 18 * (MediaQuery.of(context).size.height / 360),
                      focusedDay: focusedDay,
                      firstDay: DateTime.now(),
                      lastDay: DateTime(DateTime.now().year + 1, 12, 31),
                      locale: 'ko_KR',
                      headerStyle: HeaderStyle(
                        formatButtonVisible: false,
                      ),
                      calendarStyle: const CalendarStyle(
                        isTodayHighlighted: false,
                        selectedDecoration: BoxDecoration(
                          color: Color(0xffE47421),
                          shape: BoxShape.circle,
                        ),
                      ),
                      onDaySelected: (DateTime selectedDay, DateTime focusedDay) {
                        // 선택된 날짜의 상태를 갱신합니다.
                        setState((){
                          this.selectedDay = selectedDay;
                          this.focusedDay = focusedDay;
                          returnDate = DateFormat("yyyy-MM-dd").format(selectedDay).toString();
                        });
                      },
                      selectedDayPredicate: (DateTime day) {
                        // selectedDay 와 동일한 날짜의 모양을 바꿔줍니다.
                        return isSameDay(selectedDay, day);
                      },
                    )
                ),
                Container(
                    width: 360 * (MediaQuery.of(context).size.width / 360),
                    margin : EdgeInsets.fromLTRB(15 * (MediaQuery.of(context).size.width / 360), 7 * (MediaQuery.of(context).size.height / 360),
                        15 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360)),
                    padding : EdgeInsets.fromLTRB(0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360),
                        0 * (MediaQuery.of(context).size.width / 360), 5 * (MediaQuery.of(context).size.height / 360)),
                    decoration: BoxDecoration(
                        color: Color(0xffFFFFFF),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.2),
                            blurRadius: 5.0,
                            spreadRadius: 0.0,
                            offset: const Offset(0,3),
                          )
                        ]
                    ),
                    child :
                    Column(
                      children: [
                        Container(
                          width: 360 * (MediaQuery.of(context).size.width / 360),
                          margin : EdgeInsets.fromLTRB(15 * (MediaQuery.of(context).size.width / 360), 5 * (MediaQuery.of(context).size.height / 360),
                              15 * (MediaQuery.of(context).size.width / 360), 5 * (MediaQuery.of(context).size.height / 360)),
                          child : Text("시간을 선택하세요", style: TextStyle(fontFamily: "NanumSquareEB", fontSize: 18),),
                        ),
                        TimePickerSpinner(
                          locale: const Locale('en', 'ko'),
                          time : dateTime,
                          itemHeight : 17 * (MediaQuery.of(context).size.height / 360),
                          is24HourMode: false,
                          isForce2Digits: true,
                          minutesInterval: 10,
                          isShowSeconds: false,
                          normalTextStyle: TextStyle(
                            fontSize: 18 * (MediaQuery.of(context).size.width / 360),
                          ),
                          highlightedTextStyle: TextStyle(
                            fontSize: 18 * (MediaQuery.of(context).size.width / 360),
                            color: Color(0xffE47421)
                          ),
                          onTimeChange: (time) {
                            setState(() {
                              dateTime = time;
                              returnTime = DateFormat.Hm().format(time).toString();
                            });
                          },
                        )
                      ],
                    )
                ),
                Container(
                    width: 360 * (MediaQuery.of(context).size.width / 360),
                    height: 20 * (MediaQuery.of(context).size.height / 360),
                    padding : EdgeInsets.fromLTRB(15 * (MediaQuery.of(context).size.width / 360), 7 * (MediaQuery.of(context).size.height / 360),
                        15 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360)),
                    child : Text("주말 및 공휴일은 신청이 불가능 합니다.", style: TextStyle(color: Color(0xffC4CCD0)),)
                ),
                Container(
                  width: 360 * (MediaQuery.of(context).size.width / 360),
                  height: 30 * (MediaQuery.of(context).size.height / 360),
                  padding : EdgeInsets.fromLTRB(15 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360),
                      15 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360)),
                  margin : EdgeInsets.fromLTRB(0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360),
                      0 * (MediaQuery.of(context).size.width / 360), 5 * (MediaQuery.of(context).size.height / 360)),
                  child: Row(
                    children: [
                      Container(
                        width: 330 * (MediaQuery.of(context).size.width / 360),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Color.fromRGBO(228, 116, 33, 1),
                              padding: EdgeInsets.symmetric(horizontal: 5 * (MediaQuery.of(context).size.width / 360), vertical: 7 * (MediaQuery.of(context).size.height / 360)),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5 * (MediaQuery.of(context).size.height / 360))
                              )
                          ),
                          onPressed: () {
                            print(returnDate  + " " + returnTime);
                            
                            int diffrence = int.parse(DateTime.parse(returnDate  + " " + returnTime).difference(DateTime.now()).inHours.toString());
                            print(diffrence < 2);
                            if(diffrence < 2 && widget.time_type == 'start_time') {
                              if(pop_check == 1) {
                                pop_check = 0;
                                showDialog(context: context,
                                    builder: (BuildContext context) {
                                      return Twohouralert(context);
                                    }
                                );
                              }
                            } else if (diffrence >= 2 && widget.time_type == 'start_time') {
                              print(diffrence >= 2);
                              if(widget.time_type == "start_time") {
                                if(widget.time != "") {
                                  final bool a = DateTime.parse(returnDate  + " " + returnTime).isAfter(DateTime.parse(widget.time ?? ""));

                                  if(a == true) {
                                    if(pop_check == 1) {
                                      pop_check = 0;
                                      showDialog(context: context,
                                          builder: (BuildContext context) {
                                            return startTimealert(context);
                                          }
                                      );
                                    }
                                  } else if(a == false) {
                                    Navigator.pop(context, (returnDate  + " " + returnTime));
                                  }
                                } else if(widget.time == "") {
                                  Navigator.pop(context, (returnDate  + " " + returnTime));
                                }
                              }
                            } else if (widget.time_type == 'end_time') {
                                if(widget.time != "") {
                                  print(widget.time);
                                  final bool a = DateTime.parse(returnDate  + " " + returnTime).isBefore(DateTime.parse(widget.time ?? ""));

                                  int diffrencee = int.parse(DateTime.parse(returnDate  + " " + returnTime).difference(DateTime.parse(widget.time ?? "")).inHours.toString());
                                  print(diffrencee);
                                  if(diffrencee < 4) {
                                    if(pop_check == 1) {
                                      pop_check = 0;
                                      showDialog(context: context,
                                          builder: (BuildContext context) {
                                            return Fourhouralert(context);
                                          }
                                      );
                                    }
                                  } else if (diffrencee >= 4) {
                                    if (a == true) {
                                      if (pop_check == 1) {
                                        pop_check = 0;
                                        showDialog(context: context,
                                            builder: (BuildContext context) {
                                              return endTimealert(context);
                                            }
                                        );
                                      }
                                    } else if (a == false) {
                                      Navigator.pop(context,(returnDate + " " + returnTime));
                                    }
                                  }
                                } else if(widget.time == "") {
                                  Navigator.pop(context, (returnDate  + " " + returnTime));
                                }
                            }
                          },
                          child:  Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text('적용하기', style: TextStyle(fontSize: 20, color: Colors.white),textAlign: TextAlign.center,),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                )
                ,
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
          bottomNavigationBar: Footer(nowPage: 'Main_menu'),
      ),
    );
  }

  AlertDialog startTimealert(BuildContext context) {
    return AlertDialog(
      // RoundedRectangleBorder - Dialog 화면 모서리 둥글게 조절
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0)),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            "종료 시간보다 늦게 설정할 수 없습니다.",
          ),
        ],
      ),
      actions: <Widget>[
        TextButton(
          child: new Text("확인"),
          onPressed: () {
            pop_check = 1;
            Navigator.pop(context);
          },
        ),
      ],
    );
  }

  AlertDialog endTimealert(BuildContext context) {
    return AlertDialog(
      // RoundedRectangleBorder - Dialog 화면 모서리 둥글게 조절
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0)),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            "시작 시간보다 일찍 설정할 수 없습니다.",
          ),
        ],
      ),
      actions: <Widget>[
        TextButton(
          child: new Text("확인"),
          onPressed: () {
            pop_check = 1;
            Navigator.pop(context);
          },
        ),
      ],
    );
  }

  AlertDialog Twohouralert(BuildContext context) {
    return AlertDialog(
      // RoundedRectangleBorder - Dialog 화면 모서리 둥글게 조절
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0)),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            "요청시간은 현재 시간 대비 2시간 이후 부터 신청하실수 있습니다.",
          ),
        ],
      ),
      actions: <Widget>[
        TextButton(
          child: new Text("확인"),
          onPressed: () {
            pop_check = 1;
            Navigator.pop(context);
          },
        ),
      ],
    );
  }

  AlertDialog Fourhouralert(BuildContext context) {
    return AlertDialog(
      // RoundedRectangleBorder - Dialog 화면 모서리 둥글게 조절
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0)),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            "종료시간은 시작시간 대비 최소 4시간 이상 부터 신청하실수 있습니다.",
          ),
        ],
      ),
      actions: <Widget>[
        TextButton(
          child: new Text("확인"),
          onPressed: () {
            pop_check = 1;
            Navigator.pop(context);
          },
        ),
      ],
    );
  }
}