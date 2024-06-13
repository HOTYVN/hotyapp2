import 'dart:async';
import 'dart:developer';

import 'package:app_links/app_links.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:go_router/go_router.dart';
import 'package:hoty/categorymenu/living_list.dart';
import 'package:hoty/categorymenu/living_view.dart';
import 'package:hoty/common/route_manage.dart';
import 'package:hoty/community/dailytalk/community_dailyTalk.dart';
import 'package:hoty/community/dailytalk/community_dailyTalk_view.dart';
import 'package:hoty/community/privatelesson/lesson_list.dart';
import 'package:hoty/community/privatelesson/lesson_view.dart';
import 'package:hoty/community/usedtrade/trade_list.dart';
import 'package:hoty/community/usedtrade/trade_view.dart';
//import 'package:hoty/firebase_options.dart_20240518';
import 'package:hoty/guide/guide.dart';
import 'package:hoty/intro/intro_one.dart';
import 'package:hoty/intro/Intro.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:hoty/generated/app_localizations.dart';
import 'package:hoty/kin/kin_view.dart';
import 'package:hoty/kin/kinlist.dart';
import 'package:hoty/profile/service/profile_service_detail.dart';
import 'package:hoty/service/service_guide.dart';
import 'package:hoty/splash.dart';
import 'package:hoty/today/today_advicelist.dart';
import 'package:hoty/today/today_list.dart';
import 'package:hoty/service/service.dart';
import 'package:hoty/today/today_view.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:intl/intl.dart';
import 'dart:io';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';

import 'package:permission_handler/permission_handler.dart';

import 'package:uni_links/uni_links.dart';

import 'common/dataManager.dart';
import 'common/dialog/commonAlert.dart';
import 'firebase_options.dart';
import 'intro/intro_two.dart';
import 'main/main_page.dart';

final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  RemoteNotification? notification = message.notification;
  AndroidNotification? android = message.notification?.android;
  var androidNotiDetails = AndroidNotificationDetails(
    channel.id,
    channel.name,
    channelDescription: channel.description,
  );
  var details = NotificationDetails(android: androidNotiDetails, iOS: DarwinNotificationDetails());
  print("notification : ${notification}");
  if (notification != null) {
    flutterLocalNotificationsPlugin.show(
      notification.hashCode,
      notification.title,
      notification.body,
      details,
    );
  }


  print('Handling a background message ${message.messageId}');
}

class GlobalVariable {
  static final GlobalKey<NavigatorState> navState = GlobalKey<NavigatorState>();
}

late AndroidNotificationChannel channel;
late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

Future<void> _initNotiSetting() async {
  //Notification 플러그인 객체 생성
  final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  //안드로이드 초기 설정
  final AndroidInitializationSettings initSettingsAndroid = AndroidInitializationSettings('@mipmap/ic_launcher');


  // IOS 초기 설정
  final DarwinInitializationSettings initSettingIOS = DarwinInitializationSettings(requestAlertPermission: true, requestBadgePermission: true, requestSoundPermission: true);

  // Notification에 위에서 설정한 안드로이드 IOS 초기 설정 값 삽입
  final InitializationSettings initSettings = InitializationSettings(
    android: initSettingsAndroid,
    iOS: initSettingIOS
  );

  await flutterLocalNotificationsPlugin.initialize(initSettings);
}

PermissionCheck() async {
  Map<Permission, PermissionStatus> statuses = await [
    Permission.location,
    Permission.notification,
  ].request();

  print("지역 권한 확인");
  print(statuses[Permission.location]?.isGranted);
  print("알림 권한 확인");
  print(statuses[Permission.notification]?.isGranted);
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (Platform.isAndroid) {
    await Firebase.initializeApp(/*options: DefaultFirebaseOptions.currentPlatform*/);
  } else if (Platform.isIOS) {
    print("파이어베이스 앱 셋팅 시작 !!!!! : ${DefaultFirebaseOptions.currentPlatform}");
    await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  }
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  channel = const AndroidNotificationChannel('high_importance_channel', 'High Importance Notifications',
    description: 'This channel is used for important notifications.',
    importance: Importance.high,
  );

  var initialzationSettingsAndroid =
  AndroidInitializationSettings('@mipmap/ic_launcher');


  flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  await flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()?.createNotificationChannel(channel);

  // IOS 초기 설정
  final DarwinInitializationSettings initSettingIOS = DarwinInitializationSettings(requestAlertPermission: true, requestBadgePermission: true, requestSoundPermission: true);

  var initializationSettings = InitializationSettings(
      android: initialzationSettingsAndroid,
      iOS: initSettingIOS
  );

  await flutterLocalNotificationsPlugin.initialize(
    initializationSettings,
  );

  NotificationSettings settings = await FirebaseMessaging.instance.requestPermission(
    alert: true,
    badge: true,
    provisional: false,
    sound: true,
  );

  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );

  

  final status = await Geolocator.checkPermission();
  if (status == LocationPermission.denied) {
    await Geolocator.requestPermission();
  }

  await GetStorage.init();
  KakaoSdk.init(
    nativeAppKey: '1ffb4f72ee4d65130f6a1d52f203aa57',
    javaScriptAppKey: '3819b77d441d4df3e94d9ed77d8c66a2',
  );
  //KakaoSdk.init(nativeAppKey: '92b7acb1acd464e4cb4c8c513697c0e1');

  _initNotiSetting();

  PermissionCheck();

  WidgetsFlutterBinding.ensureInitialized();
  uriLinkStream.listen((Uri? uri) {
    log("uri: $uri");
  }, onError: (Object err) {
    log("err: $err");
  });

  final _appLinks = AppLinks();

// Subscribe to all events when app is started.
// (Use allStringLinkStream to get it as [String])
  _appLinks.allUriLinkStream.listen((uri) {
    // Do something (navigation, ...)
  });



  final dataManager = DataManager();
  await dataManager.deleteData();

  runApp(const VideoApp());
  // runApp(const MyApp());
}

void selectNotification(String? payload) {

}

// 앱 버전 체크
Future<void> checkAppVersion(BuildContext context) async {
  final remoteConfig = FirebaseRemoteConfig.instance;

  /* ##### 파이어베이스 매개변수 값 호출 ##### */
  // 데이터 가져오기 시간 간격 : 12시간
  await remoteConfig.setConfigSettings(RemoteConfigSettings(
    /*fetchTimeout: const Duration(minutes: 1),
    minimumFetchInterval: const Duration(hours: 12),*/
    fetchTimeout: const Duration(minutes: 1),
    minimumFetchInterval: const Duration(minutes: 5),
  ));
  await remoteConfig.fetchAndActivate();


  /* ##### 버전 정보 가져오기 ##### */
  // 파이어베이스 버전 정보 가져오기 : 매개변수명 latest_version
  String firebaseVersion = remoteConfig.getString("latest_version");

  // 앱 버전 정보 가져오기
  PackageInfo packageInfo = await PackageInfo.fromPlatform();
  String appVersion = packageInfo.version;

  remoteConfig.onConfigUpdated.listen((event) async {
    await remoteConfig.activate();

    // Use the new config values here.
  });

  print("파이어베이스 버전 : " + firebaseVersion);
  print("앱 버전 : " + appVersion);

  /* ##### 버전 체크 ##### */
  // 최신 버전이 존재하면 버전 업데이트 화면으로 이동
  if (firebaseVersion != appVersion) {
    showDialog(
      context: context,
      barrierColor: Color(0xffE47421).withOpacity(0.4),
      barrierDismissible: false,
      builder: (BuildContext context) {
        return WillPopScope(
            onWillPop: () async => false,
            child: versionAlert(context),
        );
      },
    );
    print("최신버전이 존재@@");
  }
  // 앱이 최신 버전이면 앱 메인 화면으로 이동
  else {
    print("최신버전");
  }
}



class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {


  //const MyApp({Key? key}) : super(key: key);


  // 최초실행체크
/*  late SharedPreferences prefs;
  bool firstRun = true;
  void initPrefs() async {
    prefs = await SharedPreferences.getInstance();
    final isFirstRun = prefs.getBool('isFirstRun');
    if (isFirstRun == false) {
      setState(
            () {
          firstRun = false;
        },
      );
    }
  }*/

  @override
  void initState() {
    super.initState();
    // VideoApp();
    /*initDynamicLinks();*/
    // initPrefs();
  }

/*
  Future<void> main() async {
    WidgetsFlutterBinding.ensureInitialized();
    await DesktopWindow.setWindowSize(Size(1000, 800)); // 가로 사이즈, 세로 사이즈 기본 사이즈 부여
    await DesktopWindow.setMinWindowSize(Size(1200, 900)); // 최소 사이즈 부여
    await DesktopWindow.setMaxWindowSize(Size(1500, 1200)); // 최대 사이즈 부여
  }
*/

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,


    ]);

    return MaterialApp(
      initialRoute: '/localization',
      routes: {
        '/localization': (context) => const LocalizationScreen()

      },
      supportedLocales: [Locale("en"), Locale("ko")],
      localizationsDelegates: [
        AppLocalizationDelegate(),
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate
      ],
    );
  }


  Future<void> initDynamicLinks() async {
    final PendingDynamicLinkData? initialLink = await FirebaseDynamicLinks.instance.getInitialLink();
    if (initialLink != null) {
      final Uri deepLink = initialLink.link;
      print("#################### flutter firebase link ####################");
      print(deepLink.path);
      Get.toNamed(deepLink.path, arguments: deepLink.path);
    }
    FirebaseDynamicLinks.instance.onLink.listen((dynamicLinkData) {
      /*GetX를 사용하므로 path 로 인자값을 묶어서 이동하도록 처리*/
      print("#################### flutter firebase link2 ####################");
      print(dynamicLinkData.link);

      List<dynamic> param = [];
      String table_nm = "";
      String type = "";
      String category = "";
      int article_seq = 0;
      if(dynamicLinkData.link != null) {
        param = dynamicLinkData.link.toString().replaceAll("%3D", "=").split("@@");

        print("외부에서 연결된 링크입니다.");
        print(param);

        for (int i = 0; i < param.length; i++) {
          if(param[i] != null) {
            if (param[i].toString().contains("table_nm")) {
              if(param[i].toString().split("=") != null) {
                table_nm = param[i].toString().split("=")[1];
              }
            }
            if (param[i].toString().contains("type")) {
              type = param[i].toString().split("=")[1];
            }
            if (param[i].toString().contains("main_category")) {
              category = param[i].toString().split("=")[1];
            }
            if (param[i].toString().contains("article_seq")) {
              article_seq = int.parse(param[i].toString().split("=")[1]);
            }
          }
        }
      }

      print(table_nm);
      print(type);
      print(category);
      print(article_seq);


      final Uri deepLink = dynamicLinkData.link;
      print("딥 링크 알아보기");
      print(mounted);
      print(deepLink.queryParameters['category']);
      print(dynamicLinkData.link.path);
      //print("/" + type + "/" + table_nm + "/" + category + "/" + article_seq);

      /*if(mounted) {*/
      if(type == "list") {

        if(table_nm == 'TODAY_INFO') {
          SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
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
                  home:TodayList(main_catcode: '', table_nm: table_nm)
              );
            },
            ));
          });
        } else if (table_nm == 'HOTY_PICK') {
          SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
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
                  home:TodayAdvicelist()
              );
            },
            ));
          });
        } else if (table_nm == 'KIN') {
          SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
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
                  home:KinList(success: false, failed: false,main_catcode: '',)
              );
            },
            ));
          });
        } else if (table_nm == 'LIVING_INFO') {
          SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
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
                  home:LivingList(title_catcode: 'C1',
                      check_sub_catlist: [],
                      check_detail_catlist: [],
                      check_detail_arealist: [])
              );
            },
            ));
          });
        } else if (table_nm == 'ON_SITE') {
          SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
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
                  home:Service(table_nm: table_nm)
              );
            },
            ));
          });
        } else if (table_nm == 'INTRP_SRVC') {
          SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
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
                  home:Service(table_nm: table_nm)
              );
            },
            ));
          });
        } else if (table_nm == 'REAL_ESTATE_INTRP_SRVC') {
          SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
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
                  home:Service(table_nm: table_nm)
              );
            },
            ));
          });
        } else if (table_nm == 'AGENCY_SRVC') {
          SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
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
                  home:Service(table_nm: table_nm)
              );
            },
            ));
          });
        } else if (table_nm == 'PERSONAL_LESSON') {
          SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
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
                  home:LessonList(checkList: [])
              );
            },
            ));
          });
        } else if (table_nm == 'USED_TRNSC') {
          SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
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
                  home:TradeList(checkList: [])
              );
            },
            ));
          });
        } else if (table_nm == 'DAILY_TALK') {
          SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
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
                  home:CommunityDailyTalk(main_catcode: 'F101')
              );
            },
            ));
          });
        }

      } else if(type == "view") {
        if(table_nm == 'TODAY_INFO') {
          String cat_name = '';
          if(category == 'TD_001') {
            cat_name = '공지사항';
          } else if (category == 'TD_002') {
            cat_name = '뉴스';
          } else if (category == 'TD_003') {
            cat_name = '환율';
          } else if (category == 'TD_004') {
            cat_name = '영화';
          }
          SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
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
                  home:todayView(article_seq: article_seq,
                      title_catcode: category,
                      cat_name: cat_name,
                      table_nm: table_nm)
              );
            },
            ));
          });
        } else if (table_nm == 'HOTY_PICK') {
          String cat_name = '';
          if(category == 'HP_001') {
            cat_name = '오늘뭐먹지?';
          } else if (category == 'HP_002') {
            cat_name = '오늘뭐하지?';
          } else if (category == 'HP_003') {
            cat_name = '호치민 정착가이드';
          }

          SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
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
                  home:todayView(article_seq: article_seq,
                      title_catcode: category,
                      cat_name: cat_name,
                      table_nm: table_nm)
              );
            },
            ));
          });
        } else if (table_nm == 'KIN') {
          SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
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
                  home:KinView(article_seq: article_seq,
                      table_nm: table_nm,
                      adopt_chk: '')
              );
            },
            ));
          });
        } else if (table_nm == 'LIVING_INFO') {
          SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
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
                  home:LivingView(article_seq: article_seq,
                    table_nm: table_nm,
                    title_catcode: category, params: {},)
              );
            },
            ));
          });
        } else if (table_nm == 'ON_SITE') {
          SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
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
                  home:ProfileServiceHistoryDetail(idx: article_seq)
              );
            },
            ));
          });
        } else if (table_nm == 'INTRP_SRVC') {
          SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
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
                  home:ProfileServiceHistoryDetail(idx: article_seq)
              );
            },
            ));
          });
        } else if (table_nm == 'REAL_ESTATE_INTRP_SRVC') {
          SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
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
                  home:ProfileServiceHistoryDetail(idx: article_seq)
              );
            },
            ));
          });
        } else if (table_nm == 'AGENCY_SRVC') {
          SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
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
                  home:ProfileServiceHistoryDetail(idx: article_seq)
              );
            },
            ));
          });
        } else if (table_nm == 'PERSONAL_LESSON') {
          SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
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
                  home:LessonView(article_seq: article_seq, table_nm: table_nm, params: {},checkList: [],)
              );
            },
            ));
          });
        } else if (table_nm == 'USED_TRNSC') {
          SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
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
                  home:TradeView(article_seq: article_seq, table_nm: table_nm, params: {},checkList: [],)
              );
            },
            ));
          });
        } else if (table_nm == 'DAILY_TALK') {
          SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
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
                  home:CommunityDailyTalkView(article_seq: article_seq,
                    table_nm: table_nm,
                    main_catcode: category, params: {},)
              );
            },
            ));
          });
        }
      }
      /*}*/


      /* Get.toNamed("/" + type + "/" + table_nm + "/" + category + "/" + article_seq);*/
    }).onError((error) {
      // Handle errors
    });

    final String? deepLink = await getInitialLink();
    print("딥링크 추가 수정1");
    print(deepLink);
  }
}




class LocalizationScreen extends StatefulWidget {
  const LocalizationScreen({Key? key}) : super(key: key);

  @override
  State<LocalizationScreen> createState() => FirstScreen();
}

enum LocaleSet {KO, EN}
class FirstScreen extends State<LocalizationScreen> {
  Timer? _timer;

  // 최초실행체크
  late SharedPreferences prefs;
  bool firstRun = true;

  void initPrefs() async {
    prefs = await SharedPreferences.getInstance();
    print('@@@@@@@@@@@');
    print(prefs);
    final isFirstRun = prefs.getBool('isFirstRun');
    print(isFirstRun);
    if (isFirstRun == false) {
      firstRun = false;
      setState(
            () {
          firstRun = false;
        },
      );
    }
  }

  void getMyDeviceToken() async {

    String? token;
    /*if(defaultTargetPlatform == TargetPlatform.iOS ||defaultTargetPlatform == TargetPlatform.macOS) {
      token = await FirebaseMessaging.instance.getAPNSToken();
    } else {*/
      token = await FirebaseMessaging.instance.getToken();
    /*}*/

    print("내 디바이스 토큰: $token");
  }

  Future<void> initDynamicLinks() async {
    final PendingDynamicLinkData? initialLink = await FirebaseDynamicLinks.instance.getInitialLink();
    print("다이나믹 링크222");
    print(initialLink);
    if (initialLink != null) {
      final Uri deepLink = initialLink.link;
      print("#################### flutter firebase link ####################");
      print(deepLink.path);
      Get.toNamed(deepLink.path, arguments: deepLink.path);
    }
    FirebaseDynamicLinks.instance.onLink.listen((dynamicLinkData) {
      /*GetX를 사용하므로 path 로 인자값을 묶어서 이동하도록 처리*/
      print("#################### flutter firebase link2 ####################");
      print(dynamicLinkData.link);

      List<dynamic> param = [];
      String table_nm = "";
      String type = "";
      String category = "";
      int article_seq = 0;
      if(dynamicLinkData.link != null) {
        param = dynamicLinkData.link.toString().replaceAll("%3D", "=").split("@@");

        print("외부에서 연결된 링크입니다.");
        print(param);

        for (int i = 0; i < param.length; i++) {
          if(param[i] != null) {
            if (param[i].toString().contains("table_nm")) {
              if(param[i].toString().split("=") != null) {
                table_nm = param[i].toString().split("=")[1];
              }
            }
            if (param[i].toString().contains("type")) {
              type = param[i].toString().split("=")[1];
            }
            if (param[i].toString().contains("main_category")) {
              category = param[i].toString().split("=")[1];
            }
            if (param[i].toString().contains("article_seq")) {
              article_seq = int.parse(param[i].toString().split("=")[1]);
            }
          }
        }
      }

      print(table_nm);
      print(type);
      print(category);
      print(article_seq);


      final Uri deepLink = dynamicLinkData.link;
      print("딥 링크 알아보기");
      print(mounted);
      print(deepLink.queryParameters['category']);
      print(dynamicLinkData.link.path);
      //print("/" + type + "/" + table_nm + "/" + category + "/" + article_seq);

      /*if(mounted) {*/
      if(type == "list") {

        if(table_nm == 'TODAY_INFO') {
          SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
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
                  home:TodayList(main_catcode: '', table_nm: table_nm)
                );
              },
            ));
          });
        } else if (table_nm == 'HOTY_PICK') {
          SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
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
                  home:TodayAdvicelist()
              );
            },
            ));
          });
        } else if (table_nm == 'KIN') {
          SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
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
                  home:KinList(success: false, failed: false,main_catcode: '',)
              );
            },
            ));
          });
        } else if (table_nm == 'LIVING_INFO') {
          SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
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
                  home:LivingList(title_catcode: 'C1',
                      check_sub_catlist: [],
                      check_detail_catlist: [],
                      check_detail_arealist: [])
              );
              },
            ));
          });
        } else if (table_nm == 'ON_SITE') {
          SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
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
                  home:Service(table_nm: table_nm)
              );
            },
            ));
          });
        } else if (table_nm == 'INTRP_SRVC') {
          SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
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
                  home:Service(table_nm: table_nm)
              );
            },
            ));
          });
        } else if (table_nm == 'REAL_ESTATE_INTRP_SRVC') {
          SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
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
                  home:Service(table_nm: table_nm)
              );
            },
            ));
          });
        } else if (table_nm == 'AGENCY_SRVC') {
          SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
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
                  home:Service(table_nm: table_nm)
              );
            },
            ));
          });
        } else if (table_nm == 'PERSONAL_LESSON') {
          SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
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
                  home:LessonList(checkList: [])
              );
            },
            ));
          });
        } else if (table_nm == 'USED_TRNSC') {
          SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
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
                  home:TradeList(checkList: [])
              );
            },
            ));
          });
        } else if (table_nm == 'DAILY_TALK') {
          SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
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
                  home:CommunityDailyTalk(main_catcode: 'F101')
              );
            },
            ));
          });
        }

      } else if(type == "view") {
        if(table_nm == 'TODAY_INFO') {
          String cat_name = '';
          if(category == 'TD_001') {
            cat_name = '공지사항';
          } else if (category == 'TD_002') {
            cat_name = '뉴스';
          } else if (category == 'TD_003') {
            cat_name = '환율';
          } else if (category == 'TD_004') {
            cat_name = '영화';
          }
          SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
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
                  home:todayView(article_seq: article_seq,
                      title_catcode: category,
                      cat_name: cat_name,
                      table_nm: table_nm)
              );
            },
            ));
          });
        } else if (table_nm == 'HOTY_PICK') {
          String cat_name = '';
          if(category == 'HP_001') {
            cat_name = '오늘뭐먹지?';
          } else if (category == 'HP_002') {
            cat_name = '오늘뭐하지?';
          } else if (category == 'HP_003') {
            cat_name = '호치민 정착가이드';
          }

          SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
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
                  home:todayView(article_seq: article_seq,
                      title_catcode: category,
                      cat_name: cat_name,
                      table_nm: table_nm)
              );
            },
            ));
          });
        } else if (table_nm == 'KIN') {
          SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
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
                  home:KinView(article_seq: article_seq,
                      table_nm: table_nm,
                      adopt_chk: '')
              );
            },
            ));
          });
        } else if (table_nm == 'LIVING_INFO') {
          SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
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
                  home:LivingView(article_seq: article_seq,
                    table_nm: table_nm,
                    title_catcode: category, params: {},)
              );
            },
            ));
          });
        } else if (table_nm == 'ON_SITE') {
          SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
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
                  home:ProfileServiceHistoryDetail(idx: article_seq)
              );
            },
            ));
          });
        } else if (table_nm == 'INTRP_SRVC') {
          SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
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
                  home:ProfileServiceHistoryDetail(idx: article_seq)
              );
            },
            ));
          });
        } else if (table_nm == 'REAL_ESTATE_INTRP_SRVC') {
          SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
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
                  home:ProfileServiceHistoryDetail(idx: article_seq)
              );
            },
            ));
          });
        } else if (table_nm == 'AGENCY_SRVC') {
          SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
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
                  home:ProfileServiceHistoryDetail(idx: article_seq)
              );
            },
            ));
          });
        } else if (table_nm == 'PERSONAL_LESSON') {
          SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
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
                  home:LessonView(article_seq: article_seq, table_nm: table_nm, params: {},checkList: [],)
              );
            },
            ));
          });
        } else if (table_nm == 'USED_TRNSC') {
          SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
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
                  home:TradeView(article_seq: article_seq, table_nm: table_nm, params: {},checkList: [],)
              );
            },
            ));
          });
        } else if (table_nm == 'DAILY_TALK') {
          SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
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
                  home:CommunityDailyTalkView(article_seq: article_seq,
                    table_nm: table_nm,
                    main_catcode: category, params: {},)
              );
            },
            ));
          });
        }
      }
      /*}*/


      /* Get.toNamed("/" + type + "/" + table_nm + "/" + category + "/" + article_seq);*/
    }).onError((error) {
      // Handle errors
    });

    final String? deepLink = await getInitialLink();
    if (deepLink != null && deepLink.isNotEmpty) {
            print("딥링크 확인용");
            print(deepLink);
        List<dynamic> param = [];
        String table_nm = "";
        String type = "";
        String category = "";
        int article_seq = 0;
        if(deepLink != null) {
          param = deepLink.toString().replaceAll("%3D", "=").split("@@");

          print("외부에서 연결된 링크입니다.333");
          print(param);

          for (int i = 0; i < param.length; i++) {
            if(param[i] != null) {
              if (param[i].toString().contains("table_nm")) {
                if(param[i].toString().split("=") != null) {
                  table_nm = param[i].toString().split("=")[1];
                }
              }
              if (param[i].toString().contains("type")) {
                type = param[i].toString().split("=")[1];
              }
              if (param[i].toString().contains("main_category")) {
                category = param[i].toString().split("=")[1];
              }
              if (param[i].toString().contains("article_seq")) {
                article_seq = int.parse(param[i].toString().split("=")[1]);
              }
            }
          }
        }

        print(table_nm);
        print(type);
        print(category);
        print(article_seq);



        //print("/" + type + "/" + table_nm + "/" + category + "/" + article_seq);

        /*if(mounted) {*/
        if(type == "list") {

          if(table_nm == 'TODAY_INFO') {
            SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
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
                    home:TodayList(main_catcode: '', table_nm: table_nm)
                );
              },
              ));
            });
          } else if (table_nm == 'HOTY_PICK') {
            SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
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
                    home:TodayAdvicelist()
                );
              },
              ));
            });
          } else if (table_nm == 'KIN') {
            SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
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
                    home:KinList(success: false, failed: false,main_catcode: '',)
                );
              },
              ));
            });
          } else if (table_nm == 'LIVING_INFO') {
            SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
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
                    home:LivingList(title_catcode: 'C1',
                        check_sub_catlist: [],
                        check_detail_catlist: [],
                        check_detail_arealist: [])
                );
              },
              ));
            });
          } else if (table_nm == 'ON_SITE') {
            SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
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
                    home:Service(table_nm: table_nm)
                );
              },
              ));
            });
          } else if (table_nm == 'INTRP_SRVC') {
            SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
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
                    home:Service(table_nm: table_nm)
                );
              },
              ));
            });
          } else if (table_nm == 'REAL_ESTATE_INTRP_SRVC') {
            SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
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
                    home:Service(table_nm: table_nm)
                );
              },
              ));
            });
          } else if (table_nm == 'AGENCY_SRVC') {
            SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
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
                    home:Service(table_nm: table_nm)
                );
              },
              ));
            });
          } else if (table_nm == 'PERSONAL_LESSON') {
            SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
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
                    home:LessonList(checkList: [])
                );
              },
              ));
            });
          } else if (table_nm == 'USED_TRNSC') {
            SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
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
                    home:TradeList(checkList: [])
                );
              },
              ));
            });
          } else if (table_nm == 'DAILY_TALK') {
            SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
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
                    home:CommunityDailyTalk(main_catcode: 'F101')
                );
              },
              ));
            });
          }

        } else if(type == "view") {
          if(table_nm == 'TODAY_INFO') {
            String cat_name = '';
            if(category == 'TD_001') {
              cat_name = '공지사항';
            } else if (category == 'TD_002') {
              cat_name = '뉴스';
            } else if (category == 'TD_003') {
              cat_name = '환율';
            } else if (category == 'TD_004') {
              cat_name = '영화';
            }
            SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
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
                    home:todayView(article_seq: article_seq,
                        title_catcode: category,
                        cat_name: cat_name,
                        table_nm: table_nm)
                );
              },
              ));
            });
          } else if (table_nm == 'HOTY_PICK') {
            String cat_name = '';
            if(category == 'HP_001') {
              cat_name = '오늘뭐먹지?';
            } else if (category == 'HP_002') {
              cat_name = '오늘뭐하지?';
            } else if (category == 'HP_003') {
              cat_name = '호치민 정착가이드';
            }

            SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
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
                    home:todayView(article_seq: article_seq,
                        title_catcode: category,
                        cat_name: cat_name,
                        table_nm: table_nm)
                );
              },
              ));
            });
          } else if (table_nm == 'KIN') {
            SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
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
                    home:KinView(article_seq: article_seq,
                        table_nm: table_nm,
                        adopt_chk: '')
                );
              },
              ));
            });
          } else if (table_nm == 'LIVING_INFO') {
            SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
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
                    home:LivingView(article_seq: article_seq,
                      table_nm: table_nm,
                      title_catcode: category, params: {},)
                );
              },
              ));
            });
          } else if (table_nm == 'ON_SITE') {
            SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
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
                    home:ProfileServiceHistoryDetail(idx: article_seq)
                );
              },
              ));
            });
          } else if (table_nm == 'INTRP_SRVC') {
            SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
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
                    home:ProfileServiceHistoryDetail(idx: article_seq)
                );
              },
              ));
            });
          } else if (table_nm == 'REAL_ESTATE_INTRP_SRVC') {
            SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
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
                    home:ProfileServiceHistoryDetail(idx: article_seq)
                );
              },
              ));
            });
          } else if (table_nm == 'AGENCY_SRVC') {
            SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
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
                    home:ProfileServiceHistoryDetail(idx: article_seq)
                );
              },
              ));
            });
          } else if (table_nm == 'PERSONAL_LESSON') {
            SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
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
                    home:LessonView(article_seq: article_seq, table_nm: table_nm, params: {},checkList: [],)
                );
              },
              ));
            });
          } else if (table_nm == 'USED_TRNSC') {
            SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
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
                    home:TradeView(article_seq: article_seq, table_nm: table_nm, params: {},checkList: [],)
                );
              },
              ));
            });
          } else if (table_nm == 'DAILY_TALK') {
            SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
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
                    home:CommunityDailyTalkView(article_seq: article_seq,
                      table_nm: table_nm,
                      main_catcode: category, params: {},)
                );
              },
              ));
            });
          }
        }
    }
  }

  // 클릭 이벤트를 처리하는 메서드입니다.
  void _handleClickAction(RemoteMessage message) {
     print("앱 푸시 클릭 ");
      print(message);
      var title_living = ['M01','M02','M03','M04','M05'];

        if(message.data["type"] == "list") {
          if(title_living.contains(message.data["table_nm"])) {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return LivingList(title_catcode: message.data["main_category"],
                  check_sub_catlist: [],
                  check_detail_catlist: [],
                  check_detail_arealist: []);
            },
            ));
          }
          if(message.data["table_nm"] == 'M06'){
            Navigator.push(context, MaterialPageRoute(
              builder: (context) {
                return Service_guide(table_nm : message.data["main_category"]);
              },
            ));
          }
          if(message.data["table_nm"] == 'M07'){
            Navigator.push(context, MaterialPageRoute(
              builder: (context) {
                if(message.data["main_category"] == 'USED_TRNSC') {
                  return TradeList(checkList: [],);
                } else if(message.data["main_category"] == 'PERSONAL_LESSON'){
                  return LessonList(checkList: [],);
                } else {
                  return CommunityDailyTalk(main_catcode: message.data["main_category"]);
                }
              },
            ));
          }
          if(message.data["table_nm"] == 'M08'){
            Navigator.push(context, MaterialPageRoute(
              builder: (context) {
                return TodayList(main_catcode: '',table_nm : message.data["main_category"]);
              },
            ));
          }
          // 지식인
          if(message.data["table_nm"] == 'M09'){
            Navigator.push(context, MaterialPageRoute(
              builder: (context) {
                return KinList(success: false, failed: false,main_catcode: '',);
              },
            ));
          }

          if(message.data["table_nm"] == "TODAY_INFO") {
            SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
              Navigator.push(context, MaterialPageRoute(
                  builder: (context) {
                    return TodayList(main_catcode: '', table_nm: 'TODAY_INFO',);
                  }
              ));
            });
          }
          if(message.data["table_nm"] == "HOTY_PICK") {
            SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
              Navigator.push(context, MaterialPageRoute(
                  builder: (context) {
                    return TodayList(main_catcode: '', table_nm: 'HOTY_PICK',);
                  }
              ));
            });
          }

          if(message.data["table_nm"] == "KIN") {
            SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
              Navigator.push(context, MaterialPageRoute(
                  builder: (context) {
                    return KinList(success: false, failed: false,main_catcode: '',);
                  }
              ));
            });
          }

          if(message.data["table_nm"] == "LIVING_INFO") {
            SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
              Navigator.push(context, MaterialPageRoute(
                  builder: (context) {
                    return LivingList(title_catcode: message.data["main_category"], check_sub_catlist: [], check_detail_catlist: [], check_detail_arealist: [],);
                  }
              ));
            });
          }

          if(message.data["table_nm"] == "ON_SITE") {
            SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
              Navigator.push(context, MaterialPageRoute(
                  builder: (context) {
                    return Service(table_nm : 'ON_SITE');
                  }
              ));
            });
          }

          if(message.data["table_nm"] == "INTRP_SRVC") {
            SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
              Navigator.push(context, MaterialPageRoute(
                  builder: (context) {
                    return Service(table_nm : 'INTRP_SRVC');
                  }
              ));
            });
          }

          if(message.data["table_nm"] == "REAL_ESTATE_INTRP_SRVC") {
            SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
              Navigator.push(context, MaterialPageRoute(
                  builder: (context) {
                    return Service(table_nm : 'REAL_ESTATE_INTRP_SRVC');
                  }
              ));
            });
          }

          if(message.data["table_nm"] == "AGENCY_SRVC") {
            SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
              Navigator.push(context, MaterialPageRoute(
                  builder: (context) {
                    return Service(table_nm : 'AGENCY_SRVC');
                  }
              ));
            });
          }

          if(message.data["table_nm"] == "PERSONAL_LESSON") {
            SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
              Navigator.push(context, MaterialPageRoute(
                  builder: (context) {
                    return LessonList(checkList: []);
                  }
              ));
            });
          }

          if(message.data["table_nm"] == "USED_TRNSC") {
            SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
              Navigator.push(context, MaterialPageRoute(
                  builder: (context) {
                    return TradeList(checkList: []);
                  }
              ));
            });
          }

          if(message.data["table_nm"] == "DAILY_TALK") {
            SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
              Navigator.push(context, MaterialPageRoute(
                  builder: (context) {
                    return CommunityDailyTalk(main_catcode: message.data["main_category"]);
                  }
              ));
            });
          }

        }
        if(message.data["type"].toString() == "view") {

          if(title_living.contains(message.data["table_nm"])){
            Navigator.push(context, MaterialPageRoute(builder: (context) {
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
                  home:LivingView(article_seq: message.data["article_seq"], table_nm: message.data["table_nm"], title_catcode: message.data["main_category"], params: {})
              );
            },
            ));
          }
          if(message.data["table_nm"] == 'M06'){
            Navigator.push(context, MaterialPageRoute(
              builder: (context) {
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
                    home:Service_guide(table_nm : message.data["main_category"])
                );
              },
            ));
          }
          if(message.data["table_nm"] == 'M07'){
            Navigator.push(context, MaterialPageRoute(
              builder: (context) {
                if(message.data["main_category"] == 'USED_TRNSC') {
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
                      home:TradeView(article_seq: message.data["article_seq"], table_nm: message.data["table_nm"], params: {}, checkList: [])
                  );
                } else if(message.data["main_category"] == 'PERSONAL_LESSON'){
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
                      home:LessonView(article_seq: message.data["article_seq"], table_nm: message.data["table_nm"], params: {}, checkList: [])
                  );
                } else {
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
                      home:CommunityDailyTalkView(article_seq: message.data["article_seq"], table_nm: message.data["table_nm"], main_catcode: message.data["main_category"], params: {})
                  );
                }
              },
            ));
          }
          if(message.data["table_nm"] == 'M08'){

            Navigator.push(context, MaterialPageRoute(
              builder: (context) {
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
                    home:todayView(article_seq: message.data["article_seq"], title_catcode: message.data["main_category"], cat_name: '', table_nm: message.data["table_nm"])
                );
              },
            ));
          }
          // 지식인
          if(message.data["table_nm"] == 'M09'){
            Navigator.push(context, MaterialPageRoute(
              builder: (context) {
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
                    home:KinView(article_seq: message.data["article_seq"], table_nm: message.data["table_nm"], adopt_chk: '')
                );
              },
            ));
          }

          if(message.data["table_nm"] == "TODAY_INFO") {
            SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
              Navigator.push(context, MaterialPageRoute(
                  builder: (context) {
                    var cat_name;
                    if(message.data["main_category"] == 'TD_001') {
                      cat_name = '공지사항';
                    } else if (message.data["main_category"] == 'TD_002') {
                      cat_name = '뉴스';
                    } else if (message.data["main_category"] == 'TD_003') {
                      cat_name = '환율';
                    } else if (message.data["main_category"] == 'TD_004') {
                      cat_name = '영화';
                    }

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
                        home:todayView(article_seq: int.parse(message.data["article_seq"]), title_catcode: message.data["main_category"], cat_name: cat_name, table_nm: message.data["table_nm"])
                    );
                  }
              ));
            });
          }

          if(message.data["table_nm"] == "HOTY_PICK") {
            SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
              Navigator.push(context, MaterialPageRoute(
                  builder: (context) {
                    var cat_name;
                    if(message.data["main_category"] == 'HP_001') {
                      cat_name = '오늘뭐먹지?';
                    } else if (message.data["main_category"] == 'HP_002') {
                      cat_name = '오늘뭐하지?';
                    } else if (message.data["main_category"] == 'HP_003') {
                      cat_name = '호치민 정착가이드';
                    }

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
                        home:todayView(article_seq: int.parse(message.data["article_seq"]), title_catcode: message.data["main_category"], cat_name: cat_name, table_nm: message.data["table_nm"])
                    );
                  }
              ));
            });
          }

          if(message.data["table_nm"] == "KIN") {
            SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
              Navigator.push(context, MaterialPageRoute(
                  builder: (context) {
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
                        home:KinView(article_seq: int.parse(message.data["article_seq"]), table_nm: message.data["table_nm"], adopt_chk: '')
                    );
                  }
              ));
            });
          }

          if(message.data["table_nm"] == "LIVING_INFO") {
            SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
              Navigator.push(context, MaterialPageRoute(
                  builder: (context) {
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
                        home:LivingView(article_seq: int.parse(message.data["article_seq"]), table_nm: message.data["table_nm"], title_catcode: message.data["main_category"], params: {},)
                    );
                  }
              ));
            });
          }

          if(message.data["table_nm"] == "ON_SITE") {
            SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
              Navigator.push(context, MaterialPageRoute(
                  builder: (context) {
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
                        home:ProfileServiceHistoryDetail(idx : int.parse(message.data["article_seq"]))
                    );
                  }
              ));
            });
          }

          if(message.data["table_nm"] == "INTRP_SRVC") {
            SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
              Navigator.push(context, MaterialPageRoute(
                  builder: (context) {
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
                        home:ProfileServiceHistoryDetail(idx : int.parse(message.data["article_seq"]))
                    );
                  }
              ));
            });
          }

          if(message.data["table_nm"] == "REAL_ESTATE_INTRP_SRVC") {
            SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
              Navigator.push(context, MaterialPageRoute(
                  builder: (context) {
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
                        home:ProfileServiceHistoryDetail(idx : int.parse(message.data["article_seq"]))
                    );
                  }
              ));
            });
          }

          if(message.data["table_nm"] == "AGENCY_SRVC") {
            SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
              Navigator.push(context, MaterialPageRoute(
                  builder: (context) {
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
                        home:ProfileServiceHistoryDetail(idx : int.parse(message.data["article_seq"]))
                    );
                  }
              ));
            });
          }

          if(message.data["table_nm"] == "PERSONAL_LESSON") {
            SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
              Navigator.push(context, MaterialPageRoute(
                  builder: (context) {
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
                        home:LessonView(article_seq: int.parse(message.data["article_seq"]), table_nm: message.data["table_nm"], params: {},checkList: [],)
                    );
                  }
              ));
            });
          }

          if(message.data["table_nm"] == "USED_TRNSC") {
            SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
              Navigator.push(context, MaterialPageRoute(
                  builder: (context) {
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
                        home:TradeView(article_seq: int.parse(message.data["article_seq"]), table_nm: message.data["table_nm"], params: {},checkList: [],)
                    );
                  }
              ));
            });
          }

          if(message.data["table_nm"] == "DAILY_TALK") {
            SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
              Navigator.push(context, MaterialPageRoute(
                  builder: (context) {
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
                        home:CommunityDailyTalkView(article_seq: int.parse(message.data["article_seq"]), table_nm: message.data["table_nm"], main_catcode: message.data["main_category"], params: {},)
                    );
                  }
              ));
            });
          }
        }
  }

  @override
  void initState() {
    checkAppVersion(context);
    getMyDeviceToken();

    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      print("##### 앱 메시지 체크 :::: ${message}");
      print("##### 앱 메시지 체크 :::: ${message.notification}");

      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;
      var androidNotiDetails = AndroidNotificationDetails(
        channel.id,
        channel.name,
        channelDescription: channel.description,
      );
      var details = NotificationDetails(android: androidNotiDetails, iOS: DarwinNotificationDetails());
      if (notification != null) {
        flutterLocalNotificationsPlugin.show(
          notification.hashCode,
          notification.title,
          notification.body,
          details,
        );
      }

      print("메시지 ::::: ${notification}");

      _handleClickAction(message);
      /*if(message.data["url"] == "IntroOne") {
        SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
          Navigator.push(context, MaterialPageRoute(
              builder: (context) {
                return IntroOne();
              }
          ));
        });
      }*/



    });



    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      print("외부 클릭 테스트입니다.");
      print(message);

      var title_living = ['M01','M02','M03','M04','M05'];

      if(message.data["type"] == "list") {
        if(title_living.contains(message.data["table_nm"])) {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
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
                home:LivingList(title_catcode: message.data["main_category"],
                    check_sub_catlist: [],
                    check_detail_catlist: [],
                    check_detail_arealist: [])
            );
          },
          ));
        }
        if(message.data["table_nm"] == 'M06'){
          Navigator.push(context, MaterialPageRoute(
            builder: (context) {
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
                  home:Service_guide(table_nm : message.data["main_category"])
              );
            },
          ));
        }
        if(message.data["table_nm"] == 'M07'){
          Navigator.push(context, MaterialPageRoute(
            builder: (context) {
              if(message.data["main_category"] == 'USED_TRNSC') {
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
                    home:TradeList(checkList: [],)
                );
              } else if(message.data["main_category"] == 'PERSONAL_LESSON'){
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
                    home:LessonList(checkList: [],)
                );
              } else {
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
                    home:CommunityDailyTalk(main_catcode: message.data["main_category"])
                );
              }
            },
          ));
        }
        if(message.data["table_nm"] == 'M08'){
          Navigator.push(context, MaterialPageRoute(
            builder: (context) {
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
                  home:TodayList(main_catcode: '',table_nm : message.data["main_category"])
              );
            },
          ));
        }
        // 지식인
        if(message.data["table_nm"] == 'M09'){
          Navigator.push(context, MaterialPageRoute(
            builder: (context) {
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
                  home:KinList(success: false, failed: false,main_catcode: '',)
              );
            },
          ));
        }
        if(message.data["table_nm"] == "KIN") {
          SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
            Navigator.push(context, MaterialPageRoute(
                builder: (context) {
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
                      home:KinList(success: false, failed: false,main_catcode: '',)
                  );
                }
            ));
          });
        }

        if(message.data["table_nm"] == "LIVING_INFO") {
          SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
            Navigator.push(context, MaterialPageRoute(
                builder: (context) {
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
                      home:LivingList(title_catcode: message.data["main_category"], check_sub_catlist: [], check_detail_catlist: [], check_detail_arealist: [],)
                  );
                }
            ));
          });
        }

        if(message.data["table_nm"] == "ON_SITE") {
          SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
            Navigator.push(context, MaterialPageRoute(
                builder: (context) {
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
                      home:Service(table_nm : 'ON_SITE')
                  );
                }
            ));
          });
        }

        if(message.data["table_nm"] == "INTRP_SRVC") {
          SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
            Navigator.push(context, MaterialPageRoute(
                builder: (context) {
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
                      home:Service(table_nm : 'INTRP_SRVC')
                  );
                }
            ));
          });
        }

        if(message.data["table_nm"] == "REAL_ESTATE_INTRP_SRVC") {
          SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
            Navigator.push(context, MaterialPageRoute(
                builder: (context) {
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
                      home:Service(table_nm : 'REAL_ESTATE_INTRP_SRVC')
                  );
                }
            ));
          });
        }

        if(message.data["table_nm"] == "AGENCY_SRVC") {
          SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
            Navigator.push(context, MaterialPageRoute(
                builder: (context) {
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
                      home:Service(table_nm : 'AGENCY_SRVC')
                  );
                }
            ));
          });
        }

        if(message.data["table_nm"] == "PERSONAL_LESSON") {
          SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
            Navigator.push(context, MaterialPageRoute(
                builder: (context) {
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
                      home:LessonList(checkList: [])
                  );
                }
            ));
          });
        }

        if(message.data["table_nm"] == "USED_TRNSC") {
          SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
            Navigator.push(context, MaterialPageRoute(
                builder: (context) {
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
                      home:TradeList(checkList: [])
                  );
                }
            ));
          });
        }

        if(message.data["table_nm"] == "DAILY_TALK") {
          SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
            Navigator.push(context, MaterialPageRoute(
                builder: (context) {
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
                      home:CommunityDailyTalk(main_catcode: message.data["main_category"])
                  );
                }
            ));
          });
        }
      }
      if(message.data["type"].toString() == "view") {

        if(title_living.contains(message.data["table_nm"])){
          Navigator.push(context, MaterialPageRoute(builder: (context) {
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
                home:LivingView(article_seq: message.data["article_seq"], table_nm: message.data["table_nm"], title_catcode: message.data["main_category"], params: {})
            );
          },
          ));
        }
        if(message.data["table_nm"] == 'M06'){
          Navigator.push(context, MaterialPageRoute(
            builder: (context) {
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
                  home:Service_guide(table_nm : message.data["main_category"])
              );
            },
          ));
        }
        if(message.data["table_nm"] == 'M07'){
          Navigator.push(context, MaterialPageRoute(
            builder: (context) {
              if(message.data["main_category"] == 'USED_TRNSC') {
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
                    home:TradeView(article_seq: message.data["article_seq"], table_nm: message.data["table_nm"], params: {}, checkList: [])
                );
              } else if(message.data["main_category"] == 'PERSONAL_LESSON'){
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
                    home:LessonView(article_seq: message.data["article_seq"], table_nm: message.data["table_nm"], params: {}, checkList: [])
                );
              } else {
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
                    home:CommunityDailyTalkView(article_seq: message.data["article_seq"], table_nm: message.data["table_nm"], main_catcode: message.data["main_category"], params: {})
                );
              }
            },
          ));
        }
        if(message.data["table_nm"] == 'M08'){

          Navigator.push(context, MaterialPageRoute(
            builder: (context) {
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
                  home:todayView(article_seq: message.data["article_seq"], title_catcode: message.data["main_category"], cat_name: '', table_nm: message.data["table_nm"])
              );
            },
          ));
        }
        // 지식인
        if(message.data["table_nm"] == 'M09'){
          Navigator.push(context, MaterialPageRoute(
            builder: (context) {
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
                  home:KinView(article_seq: message.data["article_seq"], table_nm: message.data["table_nm"], adopt_chk: '')
              );
            },
          ));
        }

        if(message.data["table_nm"] == "TODAY_INFO") {
          SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
            Navigator.push(context, MaterialPageRoute(
                builder: (context) {
                  var cat_name;
                  if(message.data["main_category"] == 'TD_001') {
                    cat_name = '공지사항';
                  } else if (message.data["main_category"] == 'TD_002') {
                    cat_name = '뉴스';
                  } else if (message.data["main_category"] == 'TD_003') {
                    cat_name = '환율';
                  } else if (message.data["main_category"] == 'TD_004') {
                    cat_name = '영화';
                  }

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
                      home:todayView(article_seq: int.parse(message.data["article_seq"]), title_catcode: message.data["main_category"], cat_name: cat_name, table_nm: message.data["table_nm"])
                  );
                }
            ));
          });
        }

        if(message.data["table_nm"] == "HOTY_PICK") {
          SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
            Navigator.push(context, MaterialPageRoute(
                builder: (context) {
                  var cat_name;
                  if(message.data["main_category"] == 'HP_001') {
                    cat_name = '오늘뭐먹지?';
                  } else if (message.data["main_category"] == 'HP_002') {
                    cat_name = '오늘뭐하지?';
                  } else if (message.data["main_category"] == 'HP_003') {
                    cat_name = '호치민 정착가이드';
                  }

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
                      home:todayView(article_seq: int.parse(message.data["article_seq"]), title_catcode: message.data["main_category"], cat_name: cat_name, table_nm: message.data["table_nm"])
                  );
                }
            ));
          });
        }

        if(message.data["table_nm"] == "KIN") {
          SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
            Navigator.push(context, MaterialPageRoute(
                builder: (context) {
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
                      home:KinView(article_seq: int.parse(message.data["article_seq"]), table_nm: message.data["table_nm"], adopt_chk: '')
                  );
                }
            ));
          });
        }

        if(message.data["table_nm"] == "LIVING_INFO") {
          SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
            Navigator.push(context, MaterialPageRoute(
                builder: (context) {
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
                      home:LivingView(article_seq: int.parse(message.data["article_seq"]), table_nm: message.data["table_nm"], title_catcode: message.data["main_category"], params: {},)
                  );
                }
            ));
          });
        }

        if(message.data["table_nm"] == "ON_SITE") {
          SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
            Navigator.push(context, MaterialPageRoute(
                builder: (context) {
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
                      home:ProfileServiceHistoryDetail(idx : int.parse(message.data["article_seq"]))
                  );
                }
            ));
          });
        }

        if(message.data["table_nm"] == "INTRP_SRVC") {
          SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
            Navigator.push(context, MaterialPageRoute(
                builder: (context) {
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
                      home:ProfileServiceHistoryDetail(idx : int.parse(message.data["article_seq"]))
                  );
                }
            ));
          });
        }

        if(message.data["table_nm"] == "REAL_ESTATE_INTRP_SRVC") {
          SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
            Navigator.push(context, MaterialPageRoute(
                builder: (context) {
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
                      home:ProfileServiceHistoryDetail(idx : int.parse(message.data["article_seq"]))
                  );
                }
            ));
          });
        }

        if(message.data["table_nm"] == "AGENCY_SRVC") {
          SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
            Navigator.push(context, MaterialPageRoute(
                builder: (context) {
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
                      home:ProfileServiceHistoryDetail(idx : int.parse(message.data["article_seq"]))
                  );
                }
            ));
          });
        }

        if(message.data["table_nm"] == "PERSONAL_LESSON") {
          SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
            Navigator.push(context, MaterialPageRoute(
                builder: (context) {
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
                      home:LessonView(article_seq: int.parse(message.data["article_seq"]), table_nm: message.data["table_nm"], params: {},checkList: [],)
                  );
                }
            ));
          });
        }

        if(message.data["table_nm"] == "USED_TRNSC") {
          SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
            Navigator.push(context, MaterialPageRoute(
                builder: (context) {
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
                      home:TradeView(article_seq: int.parse(message.data["article_seq"]), table_nm: message.data["table_nm"], params: {},checkList: [],)
                  );
                }
            ));
          });
        }

        if(message.data["table_nm"] == "DAILY_TALK") {
          SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
            Navigator.push(context, MaterialPageRoute(
                builder: (context) {
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
                      home:CommunityDailyTalkView(article_seq: int.parse(message.data["article_seq"]), table_nm: message.data["table_nm"], main_catcode: message.data["main_category"], params: {},)
                  );
                }
            ));
          });
        }
      }

    });

    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    FirebaseMessaging.instance.getInitialMessage().then((RemoteMessage? message) {
      if (message != null) {
        var title_living = ['M01','M02','M03','M04','M05'];

        if(message.data["type"] == "list") {
          if(title_living.contains(message.data["table_nm"])) {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
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
                  home:LivingList(title_catcode: message.data["main_category"],
                      check_sub_catlist: [],
                      check_detail_catlist: [],
                      check_detail_arealist: [])
              );
            },
            ));
          }
          if(message.data["table_nm"] == 'M06'){
            Navigator.push(context, MaterialPageRoute(
              builder: (context) {
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
                    home:Service_guide(table_nm : message.data["main_category"])
                );
              },
            ));
          }
          if(message.data["table_nm"] == 'M07'){
            Navigator.push(context, MaterialPageRoute(
              builder: (context) {
                if(message.data["main_category"] == 'USED_TRNSC') {
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
                      home:TradeList(checkList: [],)
                  );
                } else if(message.data["main_category"] == 'PERSONAL_LESSON'){
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
                      home:LessonList(checkList: [],)
                  );
                } else {
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
                      home:CommunityDailyTalk(main_catcode: message.data["main_category"])
                  );
                }
              },
            ));
          }
          if(message.data["table_nm"] == 'M08'){
            Navigator.push(context, MaterialPageRoute(
              builder: (context) {
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
                    home:TodayList(main_catcode: '',table_nm : message.data["main_category"])
                );
              },
            ));
          }
          // 지식인
          if(message.data["table_nm"] == 'M09'){
            Navigator.push(context, MaterialPageRoute(
              builder: (context) {
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
                    home:KinList(success: false, failed: false,main_catcode: '',)
                );
              },
            ));
          }

          if(message.data["table_nm"] == "KIN") {
            SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
              Navigator.push(context, MaterialPageRoute(
                  builder: (context) {
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
                        home:KinList(success: false, failed: false,main_catcode: '',)
                    );
                  }
              ));
            });
          }

          if(message.data["table_nm"] == "LIVING_INFO") {
            SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
              Navigator.push(context, MaterialPageRoute(
                  builder: (context) {
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
                        home:LivingList(title_catcode: message.data["main_category"], check_sub_catlist: [], check_detail_catlist: [], check_detail_arealist: [],)
                    );
                  }
              ));
            });
          }

          if(message.data["table_nm"] == "ON_SITE") {
            SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
              Navigator.push(context, MaterialPageRoute(
                  builder: (context) {
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
                        home:Service(table_nm : 'ON_SITE')
                    );
                  }
              ));
            });
          }

          if(message.data["table_nm"] == "INTRP_SRVC") {
            SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
              Navigator.push(context, MaterialPageRoute(
                  builder: (context) {
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
                        home:Service(table_nm : 'INTRP_SRVC')
                    );
                  }
              ));
            });
          }

          if(message.data["table_nm"] == "REAL_ESTATE_INTRP_SRVC") {
            SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
              Navigator.push(context, MaterialPageRoute(
                  builder: (context) {
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
                        home:Service(table_nm : 'REAL_ESTATE_INTRP_SRVC')
                    );
                  }
              ));
            });
          }

          if(message.data["table_nm"] == "AGENCY_SRVC") {
            SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
              Navigator.push(context, MaterialPageRoute(
                  builder: (context) {
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
                        home:Service(table_nm : 'AGENCY_SRVC')
                    );
                  }
              ));
            });
          }

          if(message.data["table_nm"] == "PERSONAL_LESSON") {
            SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
              Navigator.push(context, MaterialPageRoute(
                  builder: (context) {
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
                        home:LessonList(checkList: [])
                    );
                  }
              ));
            });
          }

          if(message.data["table_nm"] == "USED_TRNSC") {
            SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
              Navigator.push(context, MaterialPageRoute(
                  builder: (context) {
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
                        home:TradeList(checkList: [])
                    );
                  }
              ));
            });
          }

          if(message.data["table_nm"] == "DAILY_TALK") {
            SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
              Navigator.push(context, MaterialPageRoute(
                  builder: (context) {
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
                        home:CommunityDailyTalk(main_catcode: message.data["main_category"])
                    );
                  }
              ));
            });
          }
        }
        if(message.data["type"].toString() == "view") {

          if(title_living.contains(message.data["table_nm"])){
            Navigator.push(context, MaterialPageRoute(builder: (context) {
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
                  home:LivingView(article_seq: message.data["article_seq"], table_nm: message.data["table_nm"], title_catcode: message.data["main_category"], params: {})
              );
            },
            ));
          }
          if(message.data["table_nm"] == 'M06'){
            Navigator.push(context, MaterialPageRoute(
              builder: (context) {
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
                    home:Service_guide(table_nm : message.data["main_category"])
                );
              },
            ));
          }
          if(message.data["table_nm"] == 'M07'){
            Navigator.push(context, MaterialPageRoute(
              builder: (context) {
                if(message.data["main_category"] == 'USED_TRNSC') {
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
                      home:TradeView(article_seq: message.data["article_seq"], table_nm: message.data["table_nm"], params: {}, checkList: [])
                  );
                } else if(message.data["main_category"] == 'PERSONAL_LESSON'){
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
                      home:LessonView(article_seq: message.data["article_seq"], table_nm: message.data["table_nm"], params: {}, checkList: [])
                  );
                } else {
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
                      home:CommunityDailyTalkView(article_seq: message.data["article_seq"], table_nm: message.data["table_nm"], main_catcode: message.data["main_category"], params: {})
                  );
                }
              },
            ));
          }
          if(message.data["table_nm"] == 'M08'){

            Navigator.push(context, MaterialPageRoute(
              builder: (context) {
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
                    home:todayView(article_seq: message.data["article_seq"], title_catcode: message.data["main_category"], cat_name: '', table_nm: message.data["table_nm"])
                );
              },
            ));
          }
          // 지식인
          if(message.data["table_nm"] == 'M09'){
            Navigator.push(context, MaterialPageRoute(
              builder: (context) {
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
                    home:KinView(article_seq: message.data["article_seq"], table_nm: message.data["table_nm"], adopt_chk: '')
                );
              },
            ));
          }

          if(message.data["table_nm"] == "TODAY_INFO") {
            SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
              Navigator.push(context, MaterialPageRoute(
                  builder: (context) {
                    var cat_name;
                    if(message.data["main_category"] == 'TD_001') {
                      cat_name = '공지사항';
                    } else if (message.data["main_category"] == 'TD_002') {
                      cat_name = '뉴스';
                    } else if (message.data["main_category"] == 'TD_003') {
                      cat_name = '환율';
                    } else if (message.data["main_category"] == 'TD_004') {
                      cat_name = '영화';
                    }

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
                        home:todayView(article_seq: int.parse(message.data["article_seq"]), title_catcode: message.data["main_category"], cat_name: cat_name, table_nm: message.data["table_nm"])
                    );
                  }
              ));
            });
          }

          if(message.data["table_nm"] == "HOTY_PICK") {
            SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
              Navigator.push(context, MaterialPageRoute(
                  builder: (context) {
                    var cat_name;
                    if(message.data["main_category"] == 'HP_001') {
                      cat_name = '오늘뭐먹지?';
                    } else if (message.data["main_category"] == 'HP_002') {
                      cat_name = '오늘뭐하지?';
                    } else if (message.data["main_category"] == 'HP_003') {
                      cat_name = '호치민 정착가이드';
                    }

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
                        home:todayView(article_seq: int.parse(message.data["article_seq"]), title_catcode: message.data["main_category"], cat_name: cat_name, table_nm: message.data["table_nm"])
                    );
                  }
              ));
            });
          }

          if(message.data["table_nm"] == "KIN") {
            SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
              Navigator.push(context, MaterialPageRoute(
                  builder: (context) {
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
                        home:KinView(article_seq: int.parse(message.data["article_seq"]), table_nm: message.data["table_nm"], adopt_chk: '')
                    );
                  }
              ));
            });
          }

          if(message.data["table_nm"] == "LIVING_INFO") {
            SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
              Navigator.push(context, MaterialPageRoute(
                  builder: (context) {
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
                        home:LivingView(article_seq: int.parse(message.data["article_seq"]), table_nm: message.data["table_nm"], title_catcode: message.data["main_category"], params: {},)
                    );
                  }
              ));
            });
          }

          if(message.data["table_nm"] == "ON_SITE") {
            SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
              Navigator.push(context, MaterialPageRoute(
                  builder: (context) {
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
                        home:ProfileServiceHistoryDetail(idx : int.parse(message.data["article_seq"]))
                    );
                  }
              ));
            });
          }

          if(message.data["table_nm"] == "INTRP_SRVC") {
            SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
              Navigator.push(context, MaterialPageRoute(
                  builder: (context) {
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
                        home:ProfileServiceHistoryDetail(idx : int.parse(message.data["article_seq"]))
                    );
                  }
              ));
            });
          }

          if(message.data["table_nm"] == "REAL_ESTATE_INTRP_SRVC") {
            SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
              Navigator.push(context, MaterialPageRoute(
                  builder: (context) {
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
                        home:ProfileServiceHistoryDetail(idx : int.parse(message.data["article_seq"]))
                    );
                  }
              ));
            });
          }

          if(message.data["table_nm"] == "AGENCY_SRVC") {
            SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
              Navigator.push(context, MaterialPageRoute(
                  builder: (context) {
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
                        home:ProfileServiceHistoryDetail(idx : int.parse(message.data["article_seq"]))
                    );
                  }
              ));
            });
          }

          if(message.data["table_nm"] == "PERSONAL_LESSON") {
            SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
              Navigator.push(context, MaterialPageRoute(
                  builder: (context) {
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
                        home:LessonView(article_seq: int.parse(message.data["article_seq"]), table_nm: message.data["table_nm"], params: {},checkList: [],)
                    );
                  }
              ));
            });
          }

          if(message.data["table_nm"] == "USED_TRNSC") {
            SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
              Navigator.push(context, MaterialPageRoute(
                  builder: (context) {
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
                        home:TradeView(article_seq: int.parse(message.data["article_seq"]), table_nm: message.data["table_nm"], params: {},checkList: [],)
                    );
                  }
              ));
            });
          }

          if(message.data["table_nm"] == "DAILY_TALK") {
            SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
              Navigator.push(context, MaterialPageRoute(
                  builder: (context) {
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
                        home:CommunityDailyTalkView(article_seq: int.parse(message.data["article_seq"]), table_nm: message.data["table_nm"], main_catcode: message.data["main_category"], params: {},)
                    );
                  }
              ));
            });
          }
        }
      }
    });

    print("다이나믹 링크");
    initDynamicLinks();
    super.initState();

    _startTimer().then((_) {
      initPrefs();
    });

    print('######################');
    print(firstRun);
  }

  @override
  void dispose() {
    _stopTimer();
    super.dispose();
  }

  /*void _startTimer() { //타이머 확인용
    _timer = Timer.periodic(Duration(minutes: 1), (timer) {
      _clearSharedPreferences();
      // print('1분타이머');
    });
  }*/

  Future<void> _startTimer() async{ //자정 타이머
    SharedPreferences prefs = await SharedPreferences.getInstance();

    var isFirstRun = prefs.getBool('isFirstRun');

    DateTime now = DateTime.now();
    DateTime midnight = DateTime(now.year, now.month, now.day + 1);

    Duration durationUntilMidnight = midnight.difference(now);
    print('xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx');
    print(isFirstRun);
    print('xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx');

    _timer = Timer(durationUntilMidnight, () {
      _clearSharedPreferences();
      _startTimer();
    });
  }

  void _stopTimer() {
    _timer?.cancel();
  }

  Future<void> _clearSharedPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var isFirstRun = prefs.getBool('isFirstRun');
    final myMenu = prefs.getStringList('myMenu');
    print(isFirstRun);
    if(isFirstRun == true) {
      await prefs.clear();
    } else {
      await prefs.clear();
      prefs.setBool('isFirstRun', false);
      prefs.setStringList('myMenu', myMenu!);
    }
  }

  final GoRouter _router = GoRouter(
      routes: <RouteBase>[
        GoRoute(
          name: "home",
          path: "/",
          builder: (context, state) => MainPage(),
        ),
        GoRoute(
            name: "url",
            path: "/:type/:table_nm/:category/:article_seq",
            builder: (BuildContext context, GoRouterState state) {

              String type = state.pathParameters["type"] ?? "";
              String table_nm = state.pathParameters["table_nm"] ?? "";
              String category = state.pathParameters["category"] ?? "";
              int article_seq = (state.pathParameters["article_seq"] ?? "") as int;

              if(type == "list") {

                if(table_nm == 'TODAY_INFO') {
                  return TodayList(main_catcode: '', table_nm: table_nm);
                } else if (table_nm == 'HOTY_PICK') {
                  return TodayAdvicelist();
                } else if (table_nm == 'KIN') {
                  return KinList(success: false, failed: false,main_catcode: '',);
                } else if (table_nm == 'LIVING_INFO') {
                  return LivingList(title_catcode: 'C1', check_sub_catlist: [], check_detail_catlist: [], check_detail_arealist: []);
                } else if (table_nm == 'ON_SITE') {
                  return Service(table_nm : table_nm);
                } else if (table_nm == 'INTRP_SRVC') {
                  return Service(table_nm : table_nm);
                } else if (table_nm == 'REAL_ESTATE_INTRP_SRVC') {
                  return Service(table_nm : table_nm);
                } else if (table_nm == 'AGENCY_SRVC') {
                  return Service(table_nm : table_nm);
                } else if (table_nm == 'PERSONAL_LESSON') {
                  return LessonList(checkList: []);
                } else if (table_nm == 'USED_TRNSC') {
                  return TradeList(checkList: []);
                } else if (table_nm == 'DAILY_TALK') {
                  return CommunityDailyTalk(main_catcode: 'F101');
                }

              } else if(type == "view") {
                if(table_nm == 'TODAY_INFO') {
                  String cat_name = '';
                  if(category == 'TD_001') {
                    cat_name = '공지사항';
                  } else if (category == 'TD_002') {
                    cat_name = '뉴스';
                  } else if (category == 'TD_003') {
                    cat_name = '환율';
                  } else if (category == 'TD_004') {
                    cat_name = '영화';
                  }
                  return todayView(article_seq: article_seq, title_catcode: category, cat_name: cat_name, table_nm: table_nm);
                } else if (table_nm == 'HOTY_PICK') {
                  return TodayAdvicelist();
                } else if (table_nm == 'KIN') {
                  return KinView(article_seq: article_seq, table_nm: table_nm, adopt_chk: '');
                } else if (table_nm == 'LIVING_INFO') {
                  return LivingView(article_seq: article_seq, table_nm: table_nm, title_catcode: category, params: {},);
                } else if (table_nm == 'ON_SITE') {
                  return ProfileServiceHistoryDetail(idx: article_seq);
                } else if (table_nm == 'INTRP_SRVC') {
                  return ProfileServiceHistoryDetail(idx: article_seq);
                } else if (table_nm == 'REAL_ESTATE_INTRP_SRVC') {
                  return ProfileServiceHistoryDetail(idx: article_seq);
                } else if (table_nm == 'AGENCY_SRVC') {
                  return ProfileServiceHistoryDetail(idx: article_seq);
                } else if (table_nm == 'PERSONAL_LESSON') {
                  return LessonView(article_seq: article_seq, table_nm: table_nm, params: {},checkList: [],);
                } else if (table_nm == 'USED_TRNSC') {
                  return TradeView(article_seq: article_seq, table_nm: table_nm, params: {},checkList: [],);
                } else if (table_nm == 'DAILY_TALK') {
                  return CommunityDailyTalkView(article_seq: article_seq, table_nm: table_nm, main_catcode: category, params: {},);
                }
              }

              return MainPage();
            }
        ),
      ]
  );

  LocaleSet _localeSet = LocaleSet.KO;
  @override
  Widget build(BuildContext context) {

    /*return MainPage();*/
    return MaterialApp(
      theme: ThemeData(
          unselectedWidgetColor: Color(0xffC4CCD0), // 언셀렉트
          scaffoldBackgroundColor: Colors.white,
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          fontFamily: 'NanumSquareR',
          appBarTheme: AppBarTheme(
              color: Colors.white
          )
      ),
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(textScaleFactor: MediaQuery.of(context).size.width > 500 ? 0.6 : 1),
          child: child!,
        );
      },
      home: firstRun ? Intro() :  MainPage(), // added

    );
    /*return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight( 50 * (MediaQuery.of(context).size.height / 360)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              width: 115 * (MediaQuery.of(context).size.width / 360),
              height: 130 * (MediaQuery.of(context).size.height / 360),
              margin: EdgeInsets.fromLTRB(0, 0, 35 * (MediaQuery.of(context).size.height / 360), 0),
              child: Image(image: AssetImage('assets/logo.png')),
            ),
            TextButton(
              onPressed: (){
                Navigator.push(context, MaterialPageRoute(
                  builder: (context) {
                    return MainPage();
                  },
                ));
              },
              child: Text('건너뛰기'),
            )
          ],
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
            color: Colors.white,
            image: DecorationImage(
                image: AssetImage('assets/intro1.png'),
                fit: BoxFit.cover
            )
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              margin: EdgeInsets.fromLTRB(0, 170 * (MediaQuery.of(context).size.height / 360), 0, 0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("호치민의 모든 정보", style: TextStyle(
                    fontSize: 25 * (MediaQuery.of(context).size.width / 360),
                    fontWeight: FontWeight.bold,
                    fontFamily: 'NanumSquareEB',
                  ), textAlign: TextAlign.center),
                  Text("HOTY에서 확인하세요", style: TextStyle(
                    fontSize: 25 * (MediaQuery.of(context).size.width / 360),
                    fontWeight: FontWeight.bold,
                    fontFamily: 'NanumSquareEB',
                  ), textAlign: TextAlign.center),
                  Container(
                    margin: EdgeInsets.fromLTRB(0, 10 * (MediaQuery.of(context).size.height / 360), 0, 0),
                  ),
                  Text("생활에 필요한 정보 찾기", style: TextStyle(
                    fontSize: 15 * (MediaQuery.of(context).size.width / 360),
                    color: Color.fromRGBO(228, 116, 33, 1),
                    fontWeight: FontWeight.bold,
                    fontFamily: 'NanumSquareEB',
                  ), textAlign: TextAlign.center)
                ],
              ),
            ),
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    margin: EdgeInsets.fromLTRB(0, 10 * (MediaQuery.of(context).size.height / 360), 0, 0),
                    width: 70 * (MediaQuery.of(context).size.width / 360),
                    height: 5 * (MediaQuery.of(context).size.height / 360),
                    child: Image(image: AssetImage('assets/intro_page.png')),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        elevation: 0,
        child: Row(
          children: [
            Container(
              width: (MediaQuery.of(context).size.width / 2),
              child: Row(
                children: [

                ],
              ),
            ),
            Container(
              width: (MediaQuery.of(context).size.width / 2),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    margin: EdgeInsets.fromLTRB(0, 0, 20 * (MediaQuery.of(context).size.width / 360), 10 * (MediaQuery.of(context).size.height / 360)),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Color.fromRGBO(228, 116, 33, 1),
                          padding: EdgeInsets.symmetric(horizontal: 10 * (MediaQuery.of(context).size.height / 360), vertical: 6 * (MediaQuery.of(context).size.height / 360)),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(180 * (MediaQuery.of(context).size.height / 360))
                          )
                      ),
                      onPressed: (){
                        Navigator.push(context, MaterialPageRoute(
                          builder: (context) {
                            return IntroTwo();
                          },
                        ));
                      },
                      child:  Row(
                        children: [
                          Text('다음', style: TextStyle(fontSize: 18, fontFamily: 'NanumSquareR', fontWeight: FontWeight.bold,),),
                          Container(
                            margin: EdgeInsets.fromLTRB(0, 0, 3 * (MediaQuery.of(context).size.height / 360), 0),
                            child: Text(""),
                          ),
                          Icon(Icons.arrow_forward)
                        ],
                      ),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );*/
  }

/*  AlertDialog loginalert(BuildContext context) {
    return AlertDialog(
      // RoundedRectangleBorder - Dialog 화면 모서리 둥글게 조절
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0)),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            "준비중입니다.",
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
  }*/

}