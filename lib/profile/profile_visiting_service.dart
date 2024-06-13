import 'package:flutter/material.dart';
import 'package:hoty/common/footer.dart';

class Profile_visiting_service extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap : () => FocusManager.instance.primaryFocus?.unfocus(),
      child : Scaffold(
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
          titleSpacing: 5,
          leadingWidth: 40,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: [
              Flexible(
                child: TextField(
                  style: TextStyle(fontFamily: ''),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Search location',
                    hintStyle: TextStyle(color:Color(0xffC4CCD0),),
                  ),
                ),
              ),
              TextButton(
                onPressed: () {},
                child: Icon(
                  Icons.search_rounded,
                  color: Color.fromRGBO(15, 19, 22, 1),
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
                          bottom: BorderSide(color : Color.fromRGBO(243, 246, 248, 1), width: 3 * (MediaQuery.of(context).size.width / 360),)
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
                      Text('  Your Current Location', style: TextStyle(fontSize: 18, color: Color.fromRGBO(0,0,0, 1), fontWeight: FontWeight.w600),),
                    ],
                  ),
                  onPressed: (){
                    Navigator.push(context, MaterialPageRoute(
                      builder: (context) {
                        return Profile_visiting_service();
                      },
                    ));
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
              Container(
                width: 360 * (MediaQuery.of(context).size.width / 360),
                height: 250 * (MediaQuery.of(context).size.height / 360),
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
                            width: 230 * (MediaQuery.of(context).size.width / 360),
                            child: Text("Search History", style: TextStyle(fontSize: 16 * (MediaQuery.of(context).size.width / 360), color: Color.fromRGBO(0,0,0, 1), fontWeight: FontWeight.w600)),
                          ),
                          Container(
                            width: 110 * (MediaQuery.of(context).size.width / 360),
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                elevation: 0,
                                primary: Color.fromRGBO(255, 255, 255, 1),
                                padding: EdgeInsets.fromLTRB(20 * (MediaQuery.of(context).size.width / 360), 3 * (MediaQuery.of(context).size.height / 360),
                                    0 * (MediaQuery.of(context).size.width / 360), 3 * (MediaQuery.of(context).size.height / 360)),
                              ),
                              child: Row(
                                children: [
                                  Image(image: AssetImage("assets/garbage.png"), width: 20 * (MediaQuery.of(context).size.width / 360) ,height: 20 * (MediaQuery.of(context).size.height / 360)),
                                  Text('Delete All', style: TextStyle(fontSize: 14 * (MediaQuery.of(context).size.width / 360), color: Color.fromRGBO(47, 103, 211, 1),fontWeight: FontWeight.w400) ,),
                                ],
                              ),
                              onPressed: (){
                                Navigator.push(context, MaterialPageRoute(
                                  builder: (context) {
                                    return Profile_visiting_service();
                                  },
                                ));
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      margin : EdgeInsets.fromLTRB(10 * (MediaQuery.of(context).size.width / 360), 5  * (MediaQuery.of(context).size.height / 360),
                          0  * (MediaQuery.of(context).size.width / 360), 5  * (MediaQuery.of(context).size.height / 360)),
                      height: 30 * (MediaQuery.of(context).size.height / 360),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 300 * (MediaQuery.of(context).size.width / 360),
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
                                    height: 10 * (MediaQuery.of(context).size.height / 360),
                                    child: Text("SA004", style: TextStyle(fontSize: 16 * (MediaQuery.of(context).size.width / 360), fontWeight: FontWeight.w500, color: Color(0xff0F1316)),),
                                  ),
                                  Container(
                                    height: 20 * (MediaQuery.of(context).size.height / 360),
                                    child: Text("Sala Sarimi Apartment Block B1, D9 Street, An Loi Dong, Thu Duc, Ho Chi Minh City", style: TextStyle(color: Color(0xff0F1316), fontWeight: FontWeight.w400)),
                                  ),
                                ],
                              ),
                              onPressed: (){
                                Navigator.push(context, MaterialPageRoute(
                                  builder: (context) {
                                    return Profile_visiting_service();
                                  },
                                ));
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
                                Navigator.push(context, MaterialPageRoute(
                                  builder: (context) {
                                    return Profile_visiting_service();
                                  },
                                ));
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      margin : EdgeInsets.fromLTRB(10 * (MediaQuery.of(context).size.width / 360), 5  * (MediaQuery.of(context).size.height / 360),
                          0  * (MediaQuery.of(context).size.width / 360), 5  * (MediaQuery.of(context).size.height / 360)),
                      height: 30 * (MediaQuery.of(context).size.height / 360),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 300 * (MediaQuery.of(context).size.width / 360),
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
                                    height: 10 * (MediaQuery.of(context).size.height / 360),
                                    child: Text("SA004", style: TextStyle(fontSize: 16 * (MediaQuery.of(context).size.width / 360), fontWeight: FontWeight.w500, color: Color(0xff0F1316)),),
                                  ),
                                  Container(
                                    height: 20 * (MediaQuery.of(context).size.height / 360),
                                    child: Text("Sala Sarimi Apartment Block B1, D9 Street, An Loi Dong, Thu Duc, Ho Chi Minh City", style: TextStyle(color: Color(0xff0F1316), fontWeight: FontWeight.w400)),
                                  ),
                                ],
                              ),
                              onPressed: (){
                                Navigator.push(context, MaterialPageRoute(
                                  builder: (context) {
                                    return Profile_visiting_service();
                                  },
                                ));
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
                                /*Navigator.push(context, MaterialPageRoute(
                                builder: (context) {
                                  return Profile_visiting_service();
                                },
                              ));*/
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      margin : EdgeInsets.fromLTRB(10 * (MediaQuery.of(context).size.width / 360), 5  * (MediaQuery.of(context).size.height / 360),
                          0  * (MediaQuery.of(context).size.width / 360), 5  * (MediaQuery.of(context).size.height / 360)),
                      height: 30 * (MediaQuery.of(context).size.height / 360),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 300 * (MediaQuery.of(context).size.width / 360),
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
                                    height: 10 * (MediaQuery.of(context).size.height / 360),
                                    child: Text("SA004", style: TextStyle(fontSize: 16 * (MediaQuery.of(context).size.width / 360), fontWeight: FontWeight.w500, color: Color(0xff0F1316)),),
                                  ),
                                  Container(
                                    height: 20 * (MediaQuery.of(context).size.height / 360),
                                    child: Text("Sala Sarimi Apartment Block B1, D9 Street, An Loi Dong, Thu Duc, Ho Chi Minh City", style: TextStyle(color: Color(0xff0F1316), fontWeight: FontWeight.w400)),
                                  ),
                                ],
                              ),
                              onPressed: (){
                                /*Navigator.push(context, MaterialPageRoute(
                                builder: (context) {
                                  return Profile_visiting_service();
                                },
                              ));*/
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
                                /*Navigator.push(context, MaterialPageRoute(
                                builder: (context) {
                                  return Profile_visiting_service();
                                },
                              ));*/
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      margin : EdgeInsets.fromLTRB(1  * (MediaQuery.of(context).size.width / 360), 55  * (MediaQuery.of(context).size.height / 360),
                          1 * (MediaQuery.of(context).size.width / 360), 3  * (MediaQuery.of(context).size.height / 360)),
                      width: 250 * (MediaQuery.of(context).size.width / 360),
                      height: 30 * (MediaQuery.of(context).size.height / 360),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            elevation: 1,
                            primary: Color.fromRGBO(255, 255, 255, 1),
                            padding: EdgeInsets.fromLTRB(20 * (MediaQuery.of(context).size.width / 360), 3 * (MediaQuery.of(context).size.height / 360),
                                0 * (MediaQuery.of(context).size.width / 360), 3 * (MediaQuery.of(context).size.height / 360)),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15 * (MediaQuery.of(context).size.height / 360))
                            )
                        ),
                        child: Row(
                          children: [
                            Image(image: AssetImage("assets/map.png"), width: 25 * (MediaQuery.of(context).size.width / 360) ,height: 25 * (MediaQuery.of(context).size.height / 360)),
                            Text('  Select From A Map', style: TextStyle(fontSize: 20, color: Color.fromRGBO(0,0,0, 1), fontWeight: FontWeight.bold),),
                          ],
                        ),
                        onPressed: (){
                          /*Navigator.push(context, MaterialPageRoute(
                          builder: (context) {
                            return Profile_visiting_service();
                          },
                        ));*/
                        },
                      ),
                    ),
                  ],
                ),
              ),

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
        bottomNavigationBar: Footer(nowPage: 'My_page'),
      )
    );
  }
}