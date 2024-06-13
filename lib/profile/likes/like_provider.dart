import 'dart:collection';
import 'dart:convert';

import 'package:http/http.dart' as http;




class likeProvider {
  Uri uri = Uri.parse("http://www.hoty.company/mf/common/commonCode.do");
  var Baseurl = "http://www.hoty.company/mf";
   // var Baseurl = "http://192.168.0.109/mf";


  // list 호출
  Future<dynamic> getlistdata(params) async {
    Map<String, dynamic> rst = {};
    List<dynamic> getresult = []; // get리스트
    Map paging = {}; // 페이징
    var totalpage = '';

    var url = Uri.parse(
      // 'http://www.hoty.company/mf/community/list.do',
      // 'http://www.hoty.company/mf/community/list.do',
        Baseurl + "/mypage/getMemberLikes.do"
    );
    print('######');
    try {
      /*Map data = {
        "board_seq": "15",
        "cpage": "1",
        "rows": "10",
        "table_nm" : "DAILY_TALK",
        "reg_id" : "admin",
        "sort_nm" : "",
        "keyword" : "",
        "condition" : "",
        "main_category" : "",
      };*/
      var body = json.encode(params);
      // print(body);
      var response = await http.post(
          url,
          headers: {"Content-Type": "application/json"},
          body: body
      );
      // print('Response status: ${response.statusCode}');
      // print('Response body: ${response.body}');
      if(response.statusCode == 200) {
        var resultstatus = json.decode(response.body)['resultstatus'];

        // print(resultstatus);
        // print(json.decode(response.body)['result']);
        getresult = json.decode(response.body)['result'];
        // getresult.addAll(json.decode(response.body)['result']);
        // getresult.addAll(json.decode(response.body)['pagination']);

        /*for(int i=0; i<getresult.length; i++){
          result.add(getresult[i]);
        }*/

        // Map paging = json.decode(response.body)['pagination'];
        paging = json.decode(response.body)['pagination'];

        // totalpage = paging['totalpage']; // totalpage

        rst.putIfAbsent("list", () => getresult);
        rst.putIfAbsent("pagination", () => paging);
        rst.putIfAbsent("likecat", () => json.decode(response.body)['likecat']);

        // print("asdasdasdasdasd");
        // print(result.length);
      }
      // print(result.length);
    }
    catch(e){
      print(e);
    }

    return rst;
  }

  // 공통코드 호출
  Future<dynamic> getcodedata() async {
    List<dynamic> coderesult = []; // 공통코드 리스트
    var url = Uri.parse(
      'http://www.hoty.company/mf/common/commonCode.do',
    );
    try {
      Map data = {
        // "pidx": widget.subtitle,
      };
      var body = json.encode(data);
      var response = await http.post(
          url,
          headers: {"Content-Type": "application/json"},
          body: body
      );
      // print('Response status: ${response.statusCode}');
      // print('Response body: ${response.body}');
      if(response.statusCode == 200) {
        var resultstatus = json.decode(response.body)['resultstatus'];
        // 전체코드
        coderesult = json.decode(response.body)['result'];
      }
    }
    catch(e){
      print(e);
    }
    return coderesult;

  }

  // 뷰데이터 호출
  Future<dynamic> getviewdata(params) async {
    Map<String, dynamic> rst = {};
    Map<String, dynamic> getresult = {};
    Map viewresult = {};
    Map previewresult = {};
    Map nextviewresult = {};
    List<dynamic> pnlistresult = [];
    List<dynamic> fileresult = [];

    List<dynamic> iconresult = [];
    List<dynamic> phoneresult = [];
    var url = Uri.parse(
      // "http://192.168.0.109/mf/living/view.do",
      Baseurl + "/living/view.do",
    );

    try {

      var body = json.encode(params);
      // print(body);
      var response = await http.post(
          url,
          headers: {"Content-Type": "application/json"},
          body: body
      );
      // print('Response status: ${response.statusCode}');
      // print('Response body: ${response.body}');
      if(response.statusCode == 200) {
        var resultstatus = json.decode(response.body)['resultstatus'];

        getresult = json.decode(response.body)['result'];

        getresult.forEach((key, value) {
          if(key == 'data'){
            viewresult.addAll(value);
          }
          if(key == 'files'){
            fileresult.addAll(value);
          }
          if(key == 'prev'){
            previewresult.addAll(value);
          }
          if(key == 'next'){
            nextviewresult.addAll(value);
          }
          if(key == 'icon_list'){
            iconresult.addAll(value);
          }
          if(key == 'phone_list'){
            phoneresult.addAll(value);
          }
          if(key == 'pnlist'){
            pnlistresult.addAll(value);
          }
        });

        rst.putIfAbsent("result", () => viewresult);
        rst.putIfAbsent("files", () => fileresult);
        rst.putIfAbsent("pre_view", () => previewresult);
        rst.putIfAbsent("next_view", () => nextviewresult);
        rst.putIfAbsent("icon_list", () => iconresult);
        rst.putIfAbsent("phone_list", () => phoneresult);
        rst.putIfAbsent("pnlist", () => pnlistresult);

      }

    }
    catch(e){
      print(e);
    }
    return rst;
  }

  // 좋아요
  Future<dynamic> updatelike(params) async {
    String like_status = "N";
    var url = Uri.parse(
      'http://www.hoty.company/mf/common/islike.do',
    );
    try {
/*      Map data = {
        "article_seq" : widget.article_seq,
        "table_nm" : widget.table_nm,
        "title" : apptitle,
        "likes_yn" : likes_yn,
        "reg_id" : reg_id,
      };*/
      var body = json.encode(params);
      // print(body);
      var response = await http.post(
          url,
          headers: {"Content-Type": "application/json"},
          body: body
      );
      // print('Response status: ${response.statusCode}');
      // print('Response body: ${response.body}');
      if(response.statusCode == 200) {
        like_status = "Y";
      }
    }
    catch(e){
      print(e);
    }
    return like_status;

  }

}