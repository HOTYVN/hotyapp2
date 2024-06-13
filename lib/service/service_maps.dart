import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hoty/common/footer.dart';
import 'package:hoty/service/service.dart';
import 'package:geocoding/geocoding.dart';
import 'package:location/location.dart'as locations;

class ServiceMaps extends StatefulWidget {

  @override
  State<ServiceMaps> createState() => _ServiceMapsState();
}

class _ServiceMapsState extends State<ServiceMaps> {
  late GoogleMapController mapController;
  String location_name = "지역 이름:";

  late LatLng _center = const LatLng(10.7827583197085, 106.7450681697085);

  CameraPosition? cameraPosition;

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  Future _currentLocation() async {
    locations.LocationData currentLocation;
    var location = new locations.Location();
    currentLocation = await location.getLocation();

    _center = LatLng(currentLocation.latitude!, currentLocation.longitude!);
    print("asdasdasdasd");
    print(_center);
    /*mapController.animateCamera(CameraUpdate.newCameraPosition(
      CameraPosition(
        bearing: 0,
        target: LatLng(currentLocation.latitude!, currentLocation.longitude!),
        zoom: 17.0,
      ),
    ));*/
  }

  Widget googlemap1 = Container();
  Widget footercont1 = Container();

  @override
  void initState() {
    super.initState();
    _currentLocation().then((_) {
      googlemap1 = googlemap(context);
      footercont1 = footercont(context);
      setState(() {

      });
    });

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
          titleSpacing: 5,
          leadingWidth: 40,
          title: Container(
            //width: 80 * (MediaQuery.of(context).size.width / 360),
            //height: 80 * (MediaQuery.of(context).size.height / 360),
            /*child: Image(image: AssetImage('assets/logo.png')),*/
            child: Text("아파트 주소 선택" ,
              style: TextStyle(
                fontSize: 16 * (MediaQuery.of(context).size.width / 360),
              color: Colors.black,
              fontWeight: FontWeight.w600,),
            ),
          ),
          //centerTitle: true,
        ),
        body: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Column(
            children: [
              googlemap1,
              footercont1,
              Container(
                width: 340 * (MediaQuery.of(context).size.width / 360),
                margin: EdgeInsets.fromLTRB(0 * (MediaQuery.of(context).size.width / 360),10  * (MediaQuery.of(context).size.height / 360),
                    0 * (MediaQuery.of(context).size.width / 360),10  * (MediaQuery.of(context).size.height / 360)),
                height: 30 * (MediaQuery.of(context).size.height / 360),
                child:
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Color.fromRGBO(228, 116, 33, 1),
                      padding: EdgeInsets.symmetric(horizontal: 5 * (MediaQuery.of(context).size.width / 360), vertical: 10 * (MediaQuery.of(context).size.height / 360)),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5 * (MediaQuery.of(context).size.height / 360))
                      )
                  ),
                  onPressed: () {
                    Navigator.pop(context, location_name);
                  },
                  child:  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text('이 위치로 주소 설정하기', style: TextStyle(fontSize: 20, color: Colors.white,fontWeight: FontWeight.bold),textAlign: TextAlign.center,),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        /*floatingActionButton: SizedBox(
          width: 360 * (MediaQuery.of(context).size.width / 360),
          child:  Container(
            width: 340 * (MediaQuery.of(context).size.width / 360),
            margin: EdgeInsets.fromLTRB(30 * (MediaQuery.of(context).size.width / 360),0,0 * (MediaQuery.of(context).size.width / 360),5  * (MediaQuery.of(context).size.height / 360)),
            height: 30 * (MediaQuery.of(context).size.height / 360),
            child:
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: Color.fromRGBO(228, 116, 33, 1),
                  padding: EdgeInsets.symmetric(horizontal: 5 * (MediaQuery.of(context).size.width / 360), vertical: 10 * (MediaQuery.of(context).size.height / 360)),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5 * (MediaQuery.of(context).size.height / 360))
                  )
              ),
              onPressed: () {
                Navigator.pop(context, location_name);
              },
              child:  Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text('이 위치로 주소 설정하기', style: TextStyle(fontSize: 20, color: Colors.white,fontWeight: FontWeight.bold),textAlign: TextAlign.center,),
                ],
              ),
            ),
          ),
        ),*/
        extendBody: true,
bottomNavigationBar: Footer(nowPage: 'Main_menu'),
      ),
    );
  }

  Container googlemap (BuildContext context) {
    return Container(
      width: 360 * (MediaQuery.of(context).size.width / 360),
      height: 210 * (MediaQuery.of(context).size.height / 360),
      child : Stack(
        children: [
          GoogleMap(
            onMapCreated: _onMapCreated,
            myLocationButtonEnabled: true,
            myLocationEnabled: true,
            /*markers: _markers,*/
            initialCameraPosition: CameraPosition(
              target: _center,
              zoom: 18,
            ),
            /*onTap: ()=> _currentLocation(),*/
            onCameraMove: (CameraPosition cameraPositiona) {
              cameraPosition = cameraPositiona; //when map is dragging
            },
            onCameraIdle: () async { //when map drag stops
              List<Placemark> placemarks = await placemarkFromCoordinates(cameraPosition!.target.latitude, cameraPosition!.target.longitude);
              location_name = placemarks.first.administrativeArea.toString() + ", " +  placemarks.first.street.toString();
              setState(() { //get place name from lat and lang
                location_name = placemarks.first.administrativeArea.toString() + ", " +  placemarks.first.street.toString();
                print(location_name);
                footercont1 = footercont(context);
              });
            },
          ),

          Center(
              child : Icon(Icons.place)
          ),

        ],
      ),
    );
  }

  Container footercont (BuildContext context) {
    return Container(
      width: 360 * (MediaQuery.of(context).size.width / 360),
      // height: 80 * (MediaQuery.of(context).size.height / 360),
      padding : EdgeInsets.fromLTRB(15 * (MediaQuery.of(context).size.width / 360), 10 * (MediaQuery.of(context).size.height / 360),
          15 * (MediaQuery.of(context).size.width / 360), 0 * (MediaQuery.of(context).size.height / 360)),
      decoration: ShapeDecoration(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(72),
            topRight: Radius.circular(72),
          ),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 10 * (MediaQuery.of(context).size.height / 360),
            child : Text("주소",
              style: TextStyle(
                fontFamily: "NanumSquareEB",
                fontSize: 15 * (MediaQuery.of(context).size.width / 360),
              ),
            ),
          ),
          Container(
            margin : EdgeInsets.fromLTRB(0 * (MediaQuery.of(context).size.width / 360),
                1 * (MediaQuery.of(context).size.height / 360),
                0 * (MediaQuery.of(context).size.width / 360),
                0 * (MediaQuery.of(context).size.height / 360)),
            // height: 25 * (MediaQuery.of(context).size.height / 360),
            child : Text("${location_name}",
              style: TextStyle(
                /*fontFamily: "NanumSquareEB",*/
                  fontSize: 13 * (MediaQuery.of(context).size.width / 360),
                  fontWeight: FontWeight.w400
              ),
            ),
          ),
        ],
      ),
    );
  }

}