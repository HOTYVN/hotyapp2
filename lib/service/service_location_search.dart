import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:google_places_autocomplete_text_field/google_places_autocomplete_text_field.dart';
import 'package:hoty/common/footer.dart';
import 'package:hoty/service/service_maps.dart';
import 'package:get_storage/get_storage.dart';

class ServiceLocationSearch extends StatefulWidget {
  @override
  State<ServiceLocationSearch> createState() => _ServiceLocationSearchState();
}

class _ServiceLocationSearchState extends State<ServiceLocationSearch> {

  final locationcontroller = TextEditingController();
  final box = GetStorage();
  List<String> addresslist = [];

  List<dynamic> searchAddressList = [];

  void saveStorageData(List<String> items, String item) {
    final box = GetStorage();
    box.write(item, items);
  }

  List<String> getStorageData(String item) {
    final box = GetStorage();
    addresslist = List<String>.from(box.read(item) ?? []);
    return List<String>.from(box.read(item) ?? []);
  }

  void removeStorageData(String item) {
    final box = GetStorage();
    box.remove(item);
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
          leading: Container(
            // margin: EdgeInsets.fromLTRB(0, 2 * (MediaQuery.of(context).size.height / 360), 0, 0),
            child: IconButton(
              icon: Icon(Icons.arrow_back_rounded),
              iconSize: 12 * (MediaQuery.of(context).size.height / 360),
              color: Colors.black,
              // alignment: Alignment.centerLeft,
              // padding: EdgeInsets.zero,
              visualDensity: VisualDensity(horizontal: -2.0, vertical: -3.0),
              onPressed: (){
                Navigator.pop(context);
              },
            ),
          ),
          titleSpacing: 0,
          leadingWidth: 40,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: [
              Flexible(
                  child: GooglePlacesAutoCompleteTextFormField(
                      textEditingController: locationcontroller,
                      enableInteractiveSelection: true,
                      keyboardType: TextInputType.text,
                      googleAPIKey: "AIzaSyBK7t1Cd8aDa9uUKpty1pfHyE7HSg7Lejs",
                      //proxyURL: "https://your-proxy.com/", // only needed if you build for the web
                      debounceTime: 600, // defaults to 600 ms,
                      //countries: ["ko_KR"], // optional, by default the list is empty (no restrictions)
                      isLatLngRequired: true, // if you require the coordinates from the place details
                      getPlaceDetailWithLatLng: (prediction) {
                        // this method will return latlng with place detail
                        print("placeDetails" + prediction.lng.toString());
                      }, // this callback is called when isLatLngRequired is true
                      style: TextStyle(fontFamily: ''),
                      inputDecoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: "현재 위치",
                        hintStyle: TextStyle(
                          color: Color(0xffC4CCD0),
                          fontSize: 14 * (MediaQuery.of(context).size.width / 360),
                          fontWeight: FontWeight.w300,
                          fontFamily: 'NanumSquare',
                        ),
                      ),
                      itmClick: (prediction) {
                        print(prediction);
                        locationcontroller.text = prediction.description!;
                        print("${locationcontroller.text}");

                        addresslist.add("${locationcontroller.text}");
                        saveStorageData(addresslist, 'userItems');
                        getStorageData('userItems');
                        setState(() {

                        });
                        print("#### 주소 저장 ####");
                        print(getStorageData('userItems'));
                        print(getStorageData('userItems').length);
                        print("#### 주소 불러오기 ####");
                        for(int i = 0; i < getStorageData('userItems').length; i++) {
                          print(getStorageData('userItems')[i]);
                        }
                        Navigator.pop(context, locationcontroller.text);


                        /*locationcontroller.selection = TextSelection.fromPosition(TextPosition(offset: prediction.description.length));*/
                      }
                  )
              ),
              Container(
                // margin: EdgeInsets.fromLTRB(0, 0, 50, 0),
                child: TextButton(
                  onPressed: () {
                    /*Navigator.pop(context, locationcontroller.text);*/
                    FocusManager.instance.primaryFocus?.unfocus();
                    getAddress(locationcontroller.text);
                  },
                  child: Icon(
                    Icons.search_rounded,
                    size: 12 * (MediaQuery.of(context).size.height / 360),

                    color: Color.fromRGBO(15, 19, 22, 1),
                  ),
                ),
              ),
            ],
          ),
          //centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                  decoration : BoxDecoration (
                      border : Border(
                          bottom: BorderSide(color : Color.fromRGBO(243, 246, 248, 1), width: 1 * (MediaQuery.of(context).size.width / 360),)
                      )
                  )
              ),
              Container(
                width: 360 * (MediaQuery.of(context).size.width / 360),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    elevation: 0,
                    primary: Color.fromRGBO(255, 255, 255, 1),
                    padding: EdgeInsets.fromLTRB(15 * (MediaQuery.of(context).size.width / 360), 3 * (MediaQuery.of(context).size.height / 360),
                        0 * (MediaQuery.of(context).size.width / 360), 3 * (MediaQuery.of(context).size.height / 360)),
                  ),
                  child: Row(
                    children: [
                      Image(image: AssetImage("assets/my_location.png"), width: 25 * (MediaQuery.of(context).size.width / 360) ,height: 25 * (MediaQuery.of(context).size.height / 360)),
                      Text('  현재 위치로 주소 찾기', style: TextStyle(fontSize: 18, color: Color.fromRGBO(0,0,0, 1), fontWeight: FontWeight.w600),),
                    ],
                  ),
                  onPressed: () async{

                    final route = MaterialPageRoute(builder: (context) => ServiceMaps());

                    final addResult = await Navigator.push(context, route);
                    print(addResult);
                    if(addResult != null) {
                      Navigator.pop(context, addResult);
                    }
                  },
                ),
              ),
              Container(
                  decoration : BoxDecoration (
                      border : Border(
                          bottom: BorderSide(color : Color.fromRGBO(243, 246, 248, 1), width: 3 * (MediaQuery.of(context).size.width / 360),)
                      )
                  )
              ),
              if(getStorageData('userItems').length > 0 && searchAddressList.length == 0)
                Container(
                  width: 360 * (MediaQuery.of(context).size.width / 360),
                  /*height: 250 * (MediaQuery.of(context).size.height / 360),*/
                  color: Colors.white,
                  child: Column(
                    children: [
                      Container(
                        margin : EdgeInsets.fromLTRB(15 * (MediaQuery.of(context).size.width / 360), 5  * (MediaQuery.of(context).size.height / 360),
                            0  * (MediaQuery.of(context).size.width / 360), 5  * (MediaQuery.of(context).size.height / 360)),
                        height: 20 * (MediaQuery.of(context).size.height / 360),
                        child: Row(
                          children: [
                            Container(
                              width: 250 * (MediaQuery.of(context).size.width / 360),
                              child: Text("최근 검색", style: TextStyle(fontSize: 16 * (MediaQuery.of(context).size.width / 360), color: Color.fromRGBO(0,0,0, 1), fontWeight: FontWeight.w600)),
                            ),
                            Container(
                              width: 90 * (MediaQuery.of(context).size.width / 360),
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  elevation: 0,
                                  primary: Color.fromRGBO(255, 255, 255, 1),
                                  padding: EdgeInsets.fromLTRB(20 * (MediaQuery.of(context).size.width / 360), 3 * (MediaQuery.of(context).size.height / 360),
                                      0 * (MediaQuery.of(context).size.width / 360), 3 * (MediaQuery.of(context).size.height / 360)),
                                ),
                                child: Row(
                                  children: [
                                    /*Image(image: AssetImage("assets/garbage.png"), width: 20 * (MediaQuery.of(context).size.width / 360) ,height: 20 * (MediaQuery.of(context).size.height / 360)),*/
                                    Text('모두 삭제', style: TextStyle(fontSize: 14 * (MediaQuery.of(context).size.width / 360), color: Color.fromRGBO(47, 103, 211, 1),fontWeight: FontWeight.w400) , textAlign: TextAlign.end,),
                                  ],
                                ),
                                onPressed: (){
                                  removeStorageData('userItems');
                                  setState(() {

                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                      if(getStorageData('userItems').length > 0 && searchAddressList.length == 0)
                        for(int i = 0; i < getStorageData('userItems').length; i++)
                          Container(
                            width: 360 * (MediaQuery.of(context).size.width / 360),
                            margin : EdgeInsets.fromLTRB(15 * (MediaQuery.of(context).size.width / 360), 5  * (MediaQuery.of(context).size.height / 360),
                                15  * (MediaQuery.of(context).size.width / 360), 5  * (MediaQuery.of(context).size.height / 360)),
                            /*height: 30 * (MediaQuery.of(context).size.height / 360),*/
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width: 290 * (MediaQuery.of(context).size.width / 360),
                                  child : ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                        padding: EdgeInsets.fromLTRB(5  * (MediaQuery.of(context).size.width / 360), 0  * (MediaQuery.of(context).size.height / 360),
                                            0  * (MediaQuery.of(context).size.width / 360), 0  * (MediaQuery.of(context).size.height / 360)),
                                        primary: Color.fromRGBO(255, 255, 255, 1),
                                        elevation: 0
                                    ),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          width: 290 * (MediaQuery.of(context).size.width / 360),
                                          height: 10 * (MediaQuery.of(context).size.height / 360),
                                          child: Text("SA004", style: TextStyle(fontSize: 16 * (MediaQuery.of(context).size.width / 360), fontWeight: FontWeight.w500, color: Color(0xff0F1316)),),
                                        ),
                                        Container(
                                          width: 290 * (MediaQuery.of(context).size.width / 360),
                                          /*height: 20 * (MediaQuery.of(context).size.height / 360),*/
                                          child: Text("${getStorageData('userItems')[i]}", style: TextStyle(color: Color(0xff0F1316), fontWeight: FontWeight.w400)),
                                        ),
                                      ],
                                    ),
                                    onPressed: (){
                                      Navigator.pop(context, getStorageData('userItems')[i]);
                                    },
                                  ),
                                ),
                                Container(
                                  margin : EdgeInsets.fromLTRB(15 * (MediaQuery.of(context).size.width / 360), 0  * (MediaQuery.of(context).size.height / 360),
                                      5  * (MediaQuery.of(context).size.width / 360), 8  * (MediaQuery.of(context).size.height / 360)),
                                  width: 20 * (MediaQuery.of(context).size.width / 360),
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      elevation: 0,
                                      primary: Color.fromRGBO(255, 255, 255, 1),
                                      padding: EdgeInsets.fromLTRB(3 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360),
                                          0 * (MediaQuery.of(context).size.width / 360), 10 * (MediaQuery.of(context).size.height / 360)),
                                    ),
                                    child: Row(
                                      children: [
                                        Image(image: AssetImage("assets/delete1.png"), width: 15 * (MediaQuery.of(context).size.width / 360) ,height: 15 * (MediaQuery.of(context).size.height / 360)),
                                      ],
                                    ),
                                    onPressed: (){
                                      print("삭제");
                                      addresslist.removeAt(i);
                                      saveStorageData(addresslist, "userItems");
                                      setState(() {
                                        getStorageData('userItems');
                                      });
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),


                    ],
                  ),
                ),
              if(getStorageData('userItems').length == 0 && searchAddressList.length == 0)
                Container(
                    child : Column(
                      children: [
                        Container(
                            margin : EdgeInsets.fromLTRB(0 * (MediaQuery.of(context).size.width / 360), 5 * (MediaQuery.of(context).size.height / 360),
                                0 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360)),
                            child : Image(image: AssetImage("assets/trip_icon.png"),
                              width: 180 * (MediaQuery.of(context).size.width / 360), height: 90 * (MediaQuery.of(context).size.height / 360),)
                        ),
                        Container(
                            margin : EdgeInsets.fromLTRB(0 * (MediaQuery.of(context).size.width / 360), 8 * (MediaQuery.of(context).size.height / 360),
                                0 * (MediaQuery.of(context).size.width / 360), 2 * (MediaQuery.of(context).size.height / 360)),
                            child : Text("아파트 주소를", style: TextStyle(
                                fontFamily: "NanumSquareEB" ,
                                fontSize: 20 * (MediaQuery.of(context).size.width / 360)),)
                        ),
                        Container(
                            child : Text("입력해주세요.", style: TextStyle(fontFamily: "NanumSquareEB" ,fontSize: 20 * (MediaQuery.of(context).size.width / 360)),)
                        ),
                      ],
                    )
                ),
              if(searchAddressList.length > 0)
                for(int i = 0; i < searchAddressList.length; i++)
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context, searchAddressList[i]["description"]);
                  },
                  child : Container(
                    width: 360 * (MediaQuery.of(context).size.width / 360),
                    /*margin : EdgeInsets.fromLTRB(15 * (MediaQuery.of(context).size.width / 360), 5  * (MediaQuery.of(context).size.height / 360),
                      15  * (MediaQuery.of(context).size.width / 360), 0  * (MediaQuery.of(context).size.height / 360)),*/
                    padding : EdgeInsets.fromLTRB(15 * (MediaQuery.of(context).size.width / 360), 5  * (MediaQuery.of(context).size.height / 360),
                        15  * (MediaQuery.of(context).size.width / 360), 5  * (MediaQuery.of(context).size.height / 360)),
                    /*height: 30 * (MediaQuery.of(context).size.height / 360),*/
                    decoration : BoxDecoration (
                        color: Colors.white,
                        border : Border(
                            bottom: BorderSide(color : Color.fromRGBO(243, 246, 248, 1), width: 3 * (MediaQuery.of(context).size.width / 360),)
                        )
                    ),
                    child: Text("${searchAddressList[i]["description"]}", style: TextStyle(color: Color(0xff0F1316), fontWeight: FontWeight.w400)),
                  ),
                )
            ],
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: Container(
          margin : EdgeInsets.fromLTRB(0  * (MediaQuery.of(context).size.width / 360), 0  * (MediaQuery.of(context).size.height / 360),
              0 * (MediaQuery.of(context).size.width / 360), 5 * (MediaQuery.of(context).size.height / 360)),
          width: 160 * (MediaQuery.of(context).size.width / 360),
          height: 26 * (MediaQuery.of(context).size.height / 360),
          child: Container(
            decoration: ShapeDecoration(
              shadows: [
                BoxShadow(
                  color: Color(0x14545B5F),
                  blurRadius: 8,
                  offset: Offset(-1, 1),
                  spreadRadius: 1,
                )
              ],
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(120),
              ),
            ),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                elevation: 0,
                primary: Color.fromRGBO(255, 255, 255, 1),
                padding: EdgeInsets.fromLTRB(20 * (MediaQuery.of(context).size.width / 360), 3 * (MediaQuery.of(context).size.height / 360),
                    0 * (MediaQuery.of(context).size.width / 360), 3 * (MediaQuery.of(context).size.height / 360)),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15 * (MediaQuery.of(context).size.height / 360))
                ),

              ),
              child: Row(
                children: [
                  Image(image: AssetImage("assets/map.png"), width: 25 * (MediaQuery.of(context).size.width / 360) ,height: 25 * (MediaQuery.of(context).size.height / 360)),
                  Container(
                    margin: EdgeInsets.fromLTRB(5 * (MediaQuery.of(context).size.width / 360), 0, 0, 0),
                    child: Text('지도에서 선택', style: TextStyle(fontSize: 16 * (MediaQuery.of(context).size.width / 360), color: Color.fromRGBO(0,0,0, 1), fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,),
                  )
                ],
              ),
              onPressed: () async{

                final route = MaterialPageRoute(builder: (context) => ServiceMaps());

                final addResult = await Navigator.push(context, route);
                print(addResult);
                if(addResult != null) {
                  Navigator.pop(context, addResult);
                }
              },
            ),
          ),
        ),
        extendBody: true,
        bottomNavigationBar: Footer(nowPage: 'Main_menu'),
      ),
    );
  }



  void getAddress (String input) async {
    String kPLACES_API_KEY = "AIzaSyBK7t1Cd8aDa9uUKpty1pfHyE7HSg7Lejs";
    String type = '(regions)';
    String baseURL =
        'https://maps.googleapis.com/maps/api/place/autocomplete/json';
    String request =
        '$baseURL?input=$input&key=$kPLACES_API_KEY';

    print(request);
    var url = Uri.parse(
      request
    );

    var response = await http.get(url);
    if (response.statusCode == 200) {
      setState(() {
        searchAddressList = json.decode(response.body)['predictions'];
        print(searchAddressList);
      });
    } else {
      throw Exception('Failed to load predictions');
    }
  }
}