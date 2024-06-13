import 'dart:convert';

import 'package:http/http.dart' as http;

import '../model/mainCategoryVO.dart';


class MainCategoryProvider {
  Uri uri = Uri.parse("http://www.hoty.company/mf/common/commonCode.do");


  Future<List<mainCategoryVO>> getCategory() async {
    List<mainCategoryVO> list = [];
    Map data = {"pidx" : "F1"};

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

}