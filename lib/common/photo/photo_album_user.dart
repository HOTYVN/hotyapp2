import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:hoty/main/main_page.dart';


class PhotoAlbum_User extends StatefulWidget {
  final String apptitle;
  final List<dynamic> fileresult;
  final String table_nm;

  const PhotoAlbum_User({super.key, required this.apptitle, required this.fileresult, required this.table_nm});


  @override
  _PhotoAlbum_User createState() => _PhotoAlbum_User();
}

class _PhotoAlbum_User extends State<PhotoAlbum_User> {
  var nowcnt = 1;
  var totalcnt = 0;
  var urlpath = 'http://www.hoty.company';
  var nowImgpath = '';
  List<dynamic> fileresult = [];

  Future<dynamic> setImg() async {
    if(widget.fileresult.length > 0) {
      totalcnt = widget.fileresult.length;
      fileresult.addAll(widget.fileresult);
    }

    if(fileresult.length > 0) {
      for(int i=0; i<widget.fileresult.length; i++) {
        nowImgpath =
            urlpath
                +'/upload/'
                +widget.table_nm
                +'/'
                +fileresult[0]["yyyy"]
                +'/'
                +fileresult[0]["mm"]
                +'/'
                +fileresult[0]["uuid"];
      }
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

  TransformationController _transformationController = TransformationController();

  void imagereset() {
    if (_transformationController.value != Matrix4.identity()) {
      _transformationController.value = Matrix4.identity();
    }
  }





  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        leadingWidth: 27 * (MediaQuery.of(context).size.width / 360),
        backgroundColor: Colors.black,
        elevation: 0,
        automaticallyImplyLeading: true,
        leading: IconButton(
          icon: Icon(Icons.close_rounded),
          iconSize: 26 * (MediaQuery.of(context).size.width / 360),
          color: Colors.white,
          // alignment: Alignment.centerLeft,
          // padding: EdgeInsets.zero,
          visualDensity: VisualDensity(horizontal: -2.0, vertical: -3.0),
          onPressed: (){
            if (Navigator.canPop(context)) {
              Navigator.of(context).pop();
            } else {
              Navigator.push(context, MaterialPageRoute(
                builder: (context) {
                  return MainPage();
                },
              ));
            }
          },
        ),
        centerTitle: true,
        title:
        Container(
          // width: 240 * (MediaQuery.of(context).size.width / 360),
          child: Text(
            widget.apptitle,
            style: TextStyle(
              fontSize: 20 * (MediaQuery.of(context).size.width / 360),
              color: Color(0xffFFFFFF),
              fontWeight: FontWeight.w600,
              overflow: TextOverflow.ellipsis,
            ),maxLines: 1,
          ),
        ),
      ),
      body: SingleChildScrollView(
       child: Column(
         children: [
           Container(
             width: 360 * (MediaQuery.of(context).size.width / 360),
             height: 20 * (MediaQuery.of(context).size.height / 360),
             alignment: Alignment.center,
             // color: Colors.red,
             child: Container(
               child: Text(
                 '${nowcnt} / ${totalcnt}',
                 style: TextStyle(
                   fontSize: 16,
                   color: Colors.white,
                 ),
               ),
             ),
           ),
           Container(
             margin: EdgeInsets.fromLTRB(0, 5, 0, 0),
             child: Column(
               // crossAxisAlignment: CrossAxisAlignment.center,
               children: [
                 InteractiveViewer(
                     // boundaryMargin: const EdgeInsets.all(20.0),
                   // constrained: true,
                   //   scaleEnabled: true,
                     transformationController: _transformationController,
                     minScale: 0.1,
                     maxScale: 10,
                     child: Container(
                       width: 340 * (MediaQuery.of(context).size.width / 360),
                       height: 220 * (MediaQuery.of(context).size.height / 360),
                       decoration: BoxDecoration(
                         image: DecorationImage(
                             image: CachedNetworkImageProvider(nowImgpath),
                             // fit: BoxFit.fill
                             fit: BoxFit.contain,
                             alignment: Alignment.center
                         ),
                         borderRadius: BorderRadius.circular(3 * (MediaQuery.of(context).size.height / 360)),
                       ),
                       // color: Colors.amberAccent,
                     )
                 ),
                 Container(
                   child: SingleChildScrollView(
                     scrollDirection: Axis.horizontal,
                     child: Row(
                       mainAxisAlignment: MainAxisAlignment.start,
                       children: [
                         if(fileresult.length > 0)
                           for(var f = 0; f < fileresult.length; f++)
                             GestureDetector(
                               onTap: (){
                                 nowcnt = f+1;
                                 nowImgpath =   urlpath
                                     +'/upload/'
                                     +widget.table_nm
                                     +'/'
                                     +fileresult[f]["yyyy"]
                                     +'/'
                                     +fileresult[f]["mm"]
                                     +'/'
                                     +fileresult[f]["uuid"];
                                 imagereset();
                                 setState(() {
                                 });
                               },
                               child: Container(
                                 margin : EdgeInsets.fromLTRB(10, 10 * (MediaQuery.of(context).size.height / 360), 0, 0),
                                 // padding: EdgeInsets.fromLTRB(20,30,10,15),
                                 // color: Colors.black,
                                 width: 100 * (MediaQuery.of(context).size.width / 360),
                                 height: 60 * (MediaQuery.of(context).size.height / 360),
                                 child: Column(
                                   children: [
                                     if(nowcnt != f+1)
                                     Container(
                                       width: 100 * (MediaQuery.of(context).size.width / 360),
                                       height: 50 * (MediaQuery.of(context).size.height / 360),
                                       decoration: BoxDecoration(
                                         image: DecorationImage(
                                             image: CachedNetworkImageProvider(urlpath+'/upload/'+widget.table_nm+'/${fileresult[f]["yyyy"]}/${fileresult[f]['mm']}/${fileresult[f]['uuid']}'),
                                             fit: BoxFit.cover
                                             // fit: BoxFit.contain
                                         ),
                                         borderRadius: BorderRadius.circular(3 * (MediaQuery.of(context).size.height / 360)),
                                       ),
                                       // color: Colors.amberAccent,
                                     ),
                                     if(nowcnt == f+1)
                                       Container(
                                         width: 100 * (MediaQuery.of(context).size.width / 360),
                                         height: 50 * (MediaQuery.of(context).size.height / 360),
                                         padding: const EdgeInsets.all(5),
                                         clipBehavior: Clip.antiAlias,
                                         decoration: ShapeDecoration(
                                           shape: RoundedRectangleBorder(
                                             side: BorderSide(width: 1, color: Colors.white),
                                             borderRadius: BorderRadius.circular(4),
                                           ),
                                         ),
                                         child: Row(
                                           mainAxisSize: MainAxisSize.min,
                                           mainAxisAlignment: MainAxisAlignment.center,
                                           crossAxisAlignment: CrossAxisAlignment.center,
                                           children: [
                                             Expanded(
                                               child: Container(
                                                 height: double.infinity,
                                                 clipBehavior: Clip.antiAlias,
                                                 decoration: ShapeDecoration(
                                                   color: Colors.black,
                                                   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                                                 ),
                                                 child: Row(
                                                   mainAxisSize: MainAxisSize.min,
                                                   mainAxisAlignment: MainAxisAlignment.center,
                                                   crossAxisAlignment: CrossAxisAlignment.center,
                                                   children: [
                                                     Container(
                                                       width: 88 * (MediaQuery.of(context).size.width / 360),
                                                       height: 44 * (MediaQuery.of(context).size.height / 360),
                                                       decoration: BoxDecoration(
                                                         borderRadius: BorderRadius.circular(3 * (MediaQuery.of(context).size.height / 360)),
                                                         image: DecorationImage(
                                                           image: CachedNetworkImageProvider(urlpath+'/upload/'+widget.table_nm+'/${fileresult[f]["yyyy"]}/${fileresult[f]['mm']}/${fileresult[f]['uuid']}'),
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
                                       )
                                       /*Container(
                                         // width: 80 * (MediaQuery.of(context).size.width / 360),
                                         // height: 40 * (MediaQuery.of(context).size.height / 360),
                                         // height: double.infinity,
                                         clipBehavior: Clip.antiAlias,
                                         margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
                                         decoration: BoxDecoration(
                                           borderRadius: BorderRadius.circular(3 * (MediaQuery.of(context).size.height / 360)),
                                           color: Color(0xFFF3F6F7),
                                           boxShadow: [
                                             BoxShadow(
                                               color: Colors.black,
                                               spreadRadius: 5,
                                               blurRadius: 0,
                                               offset: Offset(0, 2), // changes position of shadow
                                             ),
                                           ],
                                         ),
                                         child: Row(
                                           mainAxisSize: MainAxisSize.min,
                                           mainAxisAlignment: MainAxisAlignment.center,
                                           crossAxisAlignment: CrossAxisAlignment.center,
                                           children: [
                                             Container(
                                               width: 80 * (MediaQuery.of(context).size.width / 360),
                                               height: 40 * (MediaQuery.of(context).size.height / 360),
                                               decoration: BoxDecoration(
                                                 image: DecorationImage(
                                                     image: NetworkImage(urlpath+'/upload/'+widget.table_nm+'/${fileresult[f]["yyyy"]}/${fileresult[f]['mm']}/${fileresult[f]['uuid']}'),
                                                     fit: BoxFit.fill
                                                 ),
                                               ),
                                               // color: Colors.amberAccent,
                                             ),
                                           ],
                                         ),
                                       ),*/

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