import 'dart:convert';

import 'package:http/http.dart' as http;

import '../model/serviceVO.dart';


class serviceProvider {
  Uri uri = Uri.parse("http://www.hoty.company/mf/common/commonCode.do");
  //Uri uri = Uri.parse("http://www.hoty.company/mf/common/commonCode.do");


  Future<List<serviceVO>> getCategory(table_nm) async {
    List<serviceVO> list = [];
    Map data = {"pidx" : table_nm};

    var body = json.encode(data);

    final response = await http.post(
        uri,
        headers: {"Content-Type" : "application/json"},
        body : body
    );
    /*print(jsonDecode(response.body)['result']);*/

    if(response.statusCode == 200) {
      list = jsonDecode(response.body)['result'].map<serviceVO>( (data) {
        return serviceVO.fromMap(data);
      }).toList();
    }

    /*print("###############################");
    print(list);*/
    return list;
  }

  Future<List<serviceVO>> getCat02() async {
    List<serviceVO> list = [];
    Map data = {"pidx" : "PCS_TRANSLATE"};

    var body = json.encode(data);

    final response = await http.post(
        uri,
        headers: {"Content-Type" : "application/json"},
        body : body
    );
    /*print(jsonDecode(response.body)['result']);*/

    if(response.statusCode == 200) {
      list = jsonDecode(response.body)['result'].map<serviceVO>( (data) {
        return serviceVO.fromMap(data);
      }).toList();
    }

    /*print("###############################");
    print(list);*/
    return list;
  }

  Future<List<serviceVO>> getphoneNumberCategory() async {
    List<serviceVO> list = [];
    Map data = {"pidx" : "PHONE"};

    var body = json.encode(data);

    final response = await http.post(
        uri,
        headers: {"Content-Type" : "application/json"},
        body : body
    );
    /*print(jsonDecode(response.body)['result']);*/

    if(response.statusCode == 200) {
      list = jsonDecode(response.body)['result'].map<serviceVO>( (data) {
        return serviceVO.fromMap(data);
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

  Future<Map> getview() async {
    Map rst = {};
    Map data2 = {"table_nm" : "PERSONAL_LESSON", "article_seq" : "159"};
    Uri uri2 = Uri.parse("http://www.hoty.company/mf/community/view.do");

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

  Future<int> getserviceFee(service) async {
    int rst = 0;
    Map data2 = {"main_category" : service};
    Uri uri2 = Uri.parse("http://www.hoty.company/mf/common/servicefee.do");

    var body = json.encode(data2);

    final response = await http.post(
        uri2,
        headers: {"Content-Type" : "application/json"},
        body : body
    );
    /*print(jsonDecode(response.body)['result']);*/

    if(response.statusCode == 200) {
      rst = int.parse(jsonDecode(response.body)['result']["service_cost"].toString());
      print("#############viewview##################");
      print(rst);
    }

    return rst;
  }

  Future<dynamic> getdiscountfee(category) async {
    List<dynamic> result = []; // 전체 리스트
    Map data2 = {"main_category" : category};
    Uri uri2 = Uri.parse("http://www.hoty.company/mf/common/discountfee.do");
    //Uri uri2 = Uri.parse("http://www.hoty.company/mf/common/discountfee.do");

    var body = json.encode(data2);

    final response = await http.post(
        uri2,
        headers: {"Content-Type" : "application/json"},
        body : body
    );
    print("#######################232#######################");
     print(jsonDecode(response.body)['result']);

    if(response.statusCode == 200) {
      result = jsonDecode(response.body)['result'];
    }

    /*print("#############viewview##################");
    print(rst);*/
    return result;
  }
}