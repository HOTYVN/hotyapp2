import 'package:flutter/cupertino.dart';

import 'package:go_router/go_router.dart';

import 'package:hoty/categorymenu/living_list.dart';
import 'package:hoty/categorymenu/living_view.dart';
import 'package:hoty/community/dailytalk/community_dailyTalk.dart';
import 'package:hoty/community/dailytalk/community_dailyTalk_view.dart';
import 'package:hoty/community/privatelesson/lesson_list.dart';
import 'package:hoty/community/privatelesson/lesson_view.dart';
import 'package:hoty/community/usedtrade/trade_list.dart';
import 'package:hoty/community/usedtrade/trade_view.dart';
import 'package:hoty/counseling/counseling_guide.dart';
import 'package:hoty/kin/kin_view.dart';
import 'package:hoty/kin/kinlist.dart';
import 'package:hoty/main/main_page.dart';
import 'package:hoty/profile/guide/profile_service_guide_detail.dart';
import 'package:hoty/profile/service/profile_service_detail.dart';
import 'package:hoty/service/service.dart';
import 'package:hoty/service/service_guide.dart';
import 'package:hoty/today/today_advicelist.dart';
import 'package:hoty/today/today_list.dart';
import 'package:hoty/today/today_view.dart';

class RouteName {
  /*late GoRouter router;

  GoRouterClass() {
    router = GoRouter(
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
                return KinList();
              } else if (table_nm == 'LIVING_INFO') {
                return LivingList(title_catcode: 'C1', check_sub_catlist: [], check_detail_catlist: [], check_detail_arealist: []);
              } else if (table_nm == 'ON_SITE') {
                return Service(table_nm : table_nm);
              } else if (table_nm == 'INTRP_SRVC') {
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
                return LivingView(article_seq: article_seq, table_nm: table_nm, title_catcode: category);
              } else if (table_nm == 'ON_SITE') {
                return ProfileServiceHistoryDetail(idx: article_seq);
              } else if (table_nm == 'INTRP_SRVC') {
                return ProfileServiceHistoryDetail(idx: article_seq);
              } else if (table_nm == 'AGENCY_SRVC') {
                return ProfileServiceHistoryDetail(idx: article_seq);
              } else if (table_nm == 'PERSONAL_LESSON') {
                return LessonView(article_seq: article_seq, table_nm: table_nm);
              } else if (table_nm == 'USED_TRNSC') {
                return TradeView(article_seq: article_seq, table_nm: table_nm);
              } else if (table_nm == 'DAILY_TALK') {
                return CommunityDailyTalkView(article_seq: article_seq, table_nm: table_nm, main_catcode: category);
              }
            }

            return MainPage();
          }
        ),
      ]
    );
  }*/
}
