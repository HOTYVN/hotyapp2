import 'package:flutter/material.dart';



String getCodename(getcode,coderesult) {
  var Codename = '';

  coderesult.forEach((element) {
    if(element['idx'] == getcode) {
      Codename = element['name'];
    }
  });

  return Codename;
}