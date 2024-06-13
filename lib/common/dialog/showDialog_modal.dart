import 'package:flutter/material.dart';
import 'package:hoty/common/dialog/loginAlert.dart';
import 'package:hoty/main/main_page.dart';

import '../../login/login.dart';
import 'commonAlert.dart';

// 공통, 깨짐방지용 showDialog
void showModal(BuildContext context, val, info) {

  showDialog(
    context: context,
    barrierColor: Color(0xffE47421).withOpacity(0.4),
    barrierDismissible: false,
    builder: (BuildContext context) {
      return MediaQuery(
          data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
          child: showalert(context, val, info),
      );
    },
  );
}

// 공통, 깨짐방지용 showDialog 처리 링크
MaterialApp AlertPageRoute(BuildContext context,val,info) {
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
    home:goroute(val,info),
  );
}

dynamic showalert(BuildContext context, val, info) {

  if(val == 'loginalert') {
    return loginalert(context,info);
  }
  if(val == 'listalert') {
    return listalert(context);
  }
  if(val == 'delalert') {
    return delalert(context);
  }


  return ;
}

StatefulWidget goroute(val,info) {
  if(val == 'loginalert'){
    return Login(subtitle: info);
  } else if(info == 1){
    return info(main_catcode: 'F101');
  } else {
    return info;
  }
}

