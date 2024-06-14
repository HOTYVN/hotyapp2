import 'dart:html';

import 'package:google_maps/google_maps.dart';

void main() async {
  await importLibrary("maps");
  GMap(
    document.getElementById("map") as HtmlElement,
    MapOptions()
      ..center = LatLng(-34.397, 150.644)
      ..zoom = 8,
  );
}
