import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../categorymenu/common/photo_view.dart';


class ViewInfo_Photo extends StatefulWidget {
  final String mainfile;
  final List<dynamic> fileresult;
  final String table_nm;
  final String code_nm;
  final String apptitle;


  const ViewInfo_Photo({super.key, required this.mainfile, required this.fileresult,  required this.table_nm, required this.code_nm, required this.apptitle});


  @override
  _ViewInfo_Photo createState() => _ViewInfo_Photo();
}

// 뷰페이지 포토 리스트
class _ViewInfo_Photo extends State<ViewInfo_Photo> {
  var nowcnt = 1;
  var totalcnt = 0;
  var urlpath = 'http://www.hoty.company';
  var nowImgpath = '';
  List<dynamic> fileresult = []; // 파일리스트
  List<dynamic> myfileresult = []; // 우선순위 변경 파일리스트

  Future<dynamic> setImg() async {
    if(widget.fileresult.length > 0) {
      totalcnt = widget.fileresult.length;
      fileresult.addAll(widget.fileresult);

      widget.fileresult.forEach((element) {
        if(element['uuid'] == widget.mainfile) {
          myfileresult.add(element);
          fileresult.remove(element);
        }
      });

      myfileresult.addAll(fileresult);
      // print('################');
      // print(myfileresult);
    }



    if(myfileresult.length > 0) {
      for(int i=0; i<myfileresult.length; i++) {
        if(myfileresult[i]["uuid"]== widget.mainfile) {
          nowImgpath =
              urlpath
                  + '/upload/'
                  + widget.table_nm
                  + '/'
                  + myfileresult[i]["yyyy"]
                  + '/'
                  + myfileresult[i]["mm"]
                  + '/'
                  + myfileresult[i]["uuid"];
          nowcnt = i+1;
        }
      }
    } else{
      nowImgpath = 'assets/noimage.png';
    }

  }

  @override
  void initState() {
    super.initState();
    setImg().then((_) {
      setState(() {

      });
    });
  }

  @override
  Widget build(BuildContext context) {


    return Container(
      child: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              child: Column(
                // crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  if(myfileresult.length > 0)
                  GestureDetector(
                      onTap: (){
                        showDialog(context: context,
                            barrierDismissible: false,
                            barrierColor: Colors.black,
                            builder: (BuildContext context) {
                              return photoView(apptitle: widget.apptitle,fileresult: myfileresult, table_nm: widget.table_nm,);
                            }
                        );
                      },
                    child: Container(
                      width: 340 * (MediaQuery.of(context).size.width / 360),
                      child: AspectRatio(
                        aspectRatio: 16 / 9,
                        child:  Container(
                          // height: 100 * (MediaQuery.of(context).size.height / 360),
                          decoration: BoxDecoration(
                            image: DecorationImage(
                                image: CachedNetworkImageProvider(nowImgpath),
                                fit: BoxFit.cover
                              // fit: BoxFit.contain
                            ),
                            borderRadius: BorderRadius.circular(3 * (MediaQuery.of(context).size.height / 360)),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                margin : EdgeInsets.fromLTRB(3 * (MediaQuery.of(context).size.height / 360), 4 * (MediaQuery.of(context).size.height / 360),
                                    0 , 0 ),
                                decoration: BoxDecoration(
                                  color: Color(0xff2F67D3),
                                  borderRadius: BorderRadius.circular(3 * (MediaQuery.of(context).size.height / 360)),
                                ),
                                child:Row(
                                  children: [
                                    if(widget.code_nm != null && widget.code_nm != '')
                                      Container(
                                        padding : EdgeInsets.fromLTRB(5 * (MediaQuery.of(context).size.width / 360), 2 * (MediaQuery.of(context).size.height / 360),
                                          5 * (MediaQuery.of(context).size.width / 360) , 2 * (MediaQuery.of(context).size.height / 360),),
                                        child: Text(widget.code_nm,
                                          style: TextStyle(
                                            fontSize: 14 * (MediaQuery.of(context).size.width / 360),
                                            color: Colors.white,
                                            // fontWeight: FontWeight.bold,
                                            // height: 0.6 * (MediaQuery.of(context).size.height / 360),
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                  ],
                                ),

                              ),
                            ],
                          ),
                          // color: Colors.amberAccent,
                        ),
                      ),
                    ) ,

                  ),
                  if(myfileresult.length == 0)
                    GestureDetector(
                      child: Container(
                        child: AspectRatio(
                          aspectRatio: 16 / 9,
                          child:  Container(
                            width: 340 * (MediaQuery.of(context).size.width / 360),
                            // height: 100 * (MediaQuery.of(context).size.height / 360),
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: AssetImage(nowImgpath),
                                  fit: BoxFit.cover
                                // fit: BoxFit.contain
                              ),
                              borderRadius: BorderRadius.circular(3 * (MediaQuery.of(context).size.height / 360)),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  margin : EdgeInsets.fromLTRB(3 * (MediaQuery.of(context).size.height / 360), 4 * (MediaQuery.of(context).size.height / 360),
                                      0 , 0 ),
                                  decoration: BoxDecoration(
                                    color: Color(0xff2F67D3),
                                    borderRadius: BorderRadius.circular(3 * (MediaQuery.of(context).size.height / 360)),
                                  ),
                                  child:Row(
                                    children: [
                                      if(widget.code_nm != null && widget.code_nm != '')
                                        Container(
                                          padding : EdgeInsets.fromLTRB(5 * (MediaQuery.of(context).size.width / 360), 2 * (MediaQuery.of(context).size.height / 360),
                                            5 * (MediaQuery.of(context).size.width / 360) , 2 * (MediaQuery.of(context).size.height / 360),),
                                          child: Text(widget.code_nm,
                                            style: TextStyle(
                                              fontSize: 14 * (MediaQuery.of(context).size.width / 360),
                                              color: Colors.white,
                                              // fontWeight: FontWeight.bold,
                                              // height: 0.6 * (MediaQuery.of(context).size.height / 360),
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                    ],
                                  ),

                                ),
                              ],
                            ),
                            // color: Colors.amberAccent,
                          ),
                        ),
                      ) ,
                    ),
                  if(myfileresult.length > 0)
                  Container(
                    width: 360 * (MediaQuery.of(context).size.width / 360),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                            for(var f = 0; f < myfileresult.length; f++)
                              GestureDetector(
                                onTap: (){
                                  nowcnt = f+1;
                                  nowImgpath =   urlpath
                                      +'/upload/'
                                      +widget.table_nm
                                      +'/'
                                      +myfileresult[f]["yyyy"]
                                      +'/'
                                      +myfileresult[f]["mm"]
                                      +'/'
                                      +myfileresult[f]["uuid"];
                                  setState(() {
                                  });
                                },
                                child: Container(
                                  margin : EdgeInsets.fromLTRB(10 * (MediaQuery.of(context).size.width / 360), 5 * (MediaQuery.of(context).size.height / 360), 0, 0),
                                  // padding: EdgeInsets.fromLTRB(20,30,10,15),
                                  // color: Colors.black,
                                  width: 100 * (MediaQuery.of(context).size.width / 360),
                                  child: Column(
                                    children: [
                                      if(nowcnt != f+1)
                                        Container(
                                          width: 100 * (MediaQuery.of(context).size.width / 360),
                                          child: AspectRatio(
                                            aspectRatio: 16 / 9,
                                            child: Container(
                                              decoration: BoxDecoration(
                                                image: DecorationImage(
                                                    image: CachedNetworkImageProvider(urlpath+'/upload/'+widget.table_nm+'/${myfileresult[f]["yyyy"]}/${myfileresult[f]['mm']}/${myfileresult[f]['uuid']}'),
                                                    fit: BoxFit.cover
                                                  // fit: BoxFit.contain
                                                ),
                                                borderRadius: BorderRadius.circular(3 * (MediaQuery.of(context).size.height / 360)),
                                              ),
                                              // color: Colors.amberAccent,
                                            ),
                                          ),
                                        ),
                                      if(nowcnt == f+1)
                                        Container(
                                          width: 95 * (MediaQuery.of(context).size.width / 360),
                                          child: AspectRatio(
                                            aspectRatio: 16 / 9,
                                            child:  Container(
                                              alignment: Alignment.center,
                                              padding: EdgeInsets.fromLTRB(1 * (MediaQuery.of(context).size.width / 360), 1 * (MediaQuery.of(context).size.height / 360),
                                                  1 * (MediaQuery.of(context).size.width / 360), 1 * (MediaQuery.of(context).size.height / 360)),
                                              // clipBehavior: Clip.antiAlias,
                                              decoration: ShapeDecoration(
                                                shape: RoundedRectangleBorder(
                                                  side: BorderSide(width: 1, color: Color(0xffE47421)),
                                                  borderRadius: BorderRadius.circular(3 * (MediaQuery.of(context).size.height / 360)),
                                                ),
                                              ),
                                              child: Row(
                                                mainAxisSize: MainAxisSize.min,
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Expanded(
                                                    child: Container(
                                                      // margin: EdgeInsets.all(5* (MediaQuery.of(context).size.width / 360),),
                                                      height: double.infinity,
                                                      // width: 90 * (MediaQuery.of(context).size.width / 360),
                                                      clipBehavior: Clip.antiAlias,
                                                      decoration: ShapeDecoration(
                                                        color: Colors.transparent,
                                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                                                      ),
                                                      child: Row(
                                                        // mainAxisSize: MainAxisSize.min,
                                                        mainAxisAlignment: MainAxisAlignment.center,
                                                        crossAxisAlignment: CrossAxisAlignment.center,
                                                        children: [
                                                          Container(
                                                            width: 88 * (MediaQuery.of(context).size.width / 360),
                                                            // height: 42 * (MediaQuery.of(context).size.height / 360),
                                                            decoration: BoxDecoration(
                                                              borderRadius: BorderRadius.circular(3 * (MediaQuery.of(context).size.height / 360)),
                                                              image: DecorationImage(
                                                                image: CachedNetworkImageProvider(urlpath+'/upload/'+widget.table_nm+'/${myfileresult[f]["yyyy"]}/${myfileresult[f]['mm']}/${myfileresult[f]['uuid']}'),
                                                                fit: BoxFit.cover,
                                                                // fit: BoxFit.contain,
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                              ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

}