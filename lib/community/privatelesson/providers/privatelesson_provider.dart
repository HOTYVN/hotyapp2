import 'dart:convert';

import 'package:http/http.dart' as http;

import '../model/privatelessonVO.dart';


class privatelessonProvider {
  Uri uri = Uri.parse("http://www.hoty.company/mf/common/commonCode.do");


  Future<List<privatelessonVO>> getCategory() async {
    List<privatelessonVO> list = [];
    Map data = {"pidx" : "E1"};

    var body = json.encode(data);

    final response = await http.post(
        uri,
        headers: {"Content-Type" : "application/json"},
        body : body
    );
    /*print(jsonDecode(response.body)['result']);*/

    if(response.statusCode == 200) {
      list = jsonDecode(response.body)['result'].map<privatelessonVO>( (data) {
        return privatelessonVO.fromMap(data);
      }).toList();
    }

    /*print("###############################");
    print(list);*/
    return list;
  }

  Future<List<privatelessonVO>> getCat02() async {
    List<privatelessonVO> list = [];
    Map data = {"pidx" : "D2"};

    var body = json.encode(data);

    final response = await http.post(
        uri,
        headers: {"Content-Type" : "application/json"},
        body : body
    );
    /*print(jsonDecode(response.body)['result']);*/

    if(response.statusCode == 200) {
      list = jsonDecode(response.body)['result'].map<privatelessonVO>( (data) {
        return privatelessonVO.fromMap(data);
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

  Future<Map> getview(article_seq) async {
    Map rst = {};
    Map data2 = {"table_nm" : "PERSONAL_LESSON", "article_seq" : article_seq};
    Uri uri2 = Uri.parse("http://www.hoty.company/mf/community/view.do");
    /*Uri uri2 = Uri.parse("http://www.hoty.company/mf/community/view.do");*/

    var body = json.encode(data2);

    final response = await http.post(
        uri2,
        headers: {"Content-Type" : "application/json"},
        body : body
    );
   /* print(jsonDecode(response.body)['result']);*/

    if(response.statusCode == 200) {
      rst = jsonDecode(response.body)['result'];
    }

    /*print("#############viewview##################");
    print(rst);*/
    return rst;
  }

}