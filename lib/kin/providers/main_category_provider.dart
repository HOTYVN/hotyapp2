import 'dart:convert';

import 'package:http/http.dart' as http;

import '../model/mainCategoryVO.dart';


class MainCategoryProvider {
  Uri uri = Uri.parse("http://www.hoty.company/mf/common/commonCode.do");


  Future<List<mainCategoryVO>> getCategory() async {
    List<mainCategoryVO> list = [];
    List<mainCategoryVO> list2 = [];
    Map data = {"pidx" : "KIN"};

    var body = json.encode(data);

    final response = await http.post(
        uri,
        headers: {"Content-Type" : "application/json"},
        body : body
    );
    /*print(jsonDecode(response.body)['result']);*/

    if(response.statusCode == 200) {
      list = jsonDecode(response.body)['result'].map<mainCategoryVO>( (data) {
        return mainCategoryVO.fromMap(data);
      }).toList();
    }

    if(list != null && list.length > 0) {
      for(int i = 0; i< list.length; i++) {
        if(list[i].idx == 'B06') {

        } else {
          list2.add(list[i]);
        }
      }
    }


    /*print("###############################");
    print(list);*/
    return list2;
  }

  Future<List<mainCategoryVO>> getCat02() async {
    List<mainCategoryVO> list = [];
    Map data = {"pidx" : "D2"};

    var body = json.encode(data);

    final response = await http.post(
        uri,
        headers: {"Content-Type" : "application/json"},
        body : body
    );
    /*print(jsonDecode(response.body)['result']);*/

    if(response.statusCode == 200) {
      list = jsonDecode(response.body)['result'].map<mainCategoryVO>( (data) {
        return mainCategoryVO.fromMap(data);
      }).toList();
    }

    /*print("###############################");
    print(list);*/
    return list;
  }

  Future<String> writeApi (Map rst) async {
    Uri uri2 = Uri.parse("http://www.hoty.company/mf/community/write.do");
    var body = json.encode(rst);
    var result = "";

    final response = await http.post(
        uri2,
        headers: {"Content-Type" : "application/json"},
        body : body
    );

    if(response.statusCode == 200) {
      result = "success";
    }

    /*print("###############################");
    print(result);*/
    return result;
  }

  Future<Map> getview(seq,table_nm) async {
    Map rst = {};
    Map data2 = {"table_nm" : table_nm, "article_seq" : seq};
    Uri uri2 = Uri.parse("http://www.hoty.company/mf/community/view.do");

    var body = json.encode(data2);

    final response = await http.post(
        uri2,
        headers: {"Content-Type" : "application/json"},
        body : body
    );
    /*print(jsonDecode(response.body)['result']);*/

    if(response.statusCode == 200) {
      rst = jsonDecode(response.body)['result'];
    }

    print("#############viewview##################");
    print(rst);
    return rst;
  }

  Future<int> getpointview(member_id) async {
    int rst = 0;
    Map data2 = {"member_id" : member_id};
    Uri uri2 = Uri.parse("http://www.hoty.company/mf/common/point_view.do");

    var body = json.encode(data2);

    final response = await http.post(
        uri2,
        headers: {"Content-Type" : "application/json"},
        body : body
    );
    /*print(jsonDecode(response.body)['result']);*/

    if(response.statusCode == 200) {
      rst = jsonDecode(response.body)['result']['rtn_point'];
      print("#############viewview##################");
      print(rst);
    }


    return rst;
  }


  Future<Map> getCommentview(seq, table_nm) async {
    Map rst = {};
    Map data2 = {"comment_seq" : seq, "table_nm" : table_nm};
    Uri uri2 = Uri.parse("http://www.hoty.company/mf/comment/view.do");

    var body = json.encode(data2);

    final response = await http.post(
        uri2,
        headers: {"Content-Type" : "application/json"},
        body : body
    );
    /*print(jsonDecode(response.body)['result']);*/

    if(response.statusCode == 200) {
      rst = jsonDecode(response.body)['result'];
    }

    print("#############viewview##################");
    print(rst);
    return rst;
  }
}