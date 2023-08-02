import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'detailPage.dart';

Widget GoDetail(Widget child, int idx) {
  return GestureDetector(
    onTap: () {
      Get.to(
          () => DetailPage(
                idx: idx,
              ),
          transition: Transition.rightToLeft);
    },
    child: child,
  );
}

// simple getx controller class
class FilterController extends GetxController {
  var idList = <String>[];
  var db = FirebaseFirestore.instance;
  var markers = <Marker>{};

  init() async {
    await db.collection('cafeList').get().then((value) async {
      idList = value.docs.map((e) => e.id).toList();
    });
    await updateMarkers();
    update();
  }

  // string을 입력으로 받아서 cafeList의 컬렉션에서 모든 문서의 keywords 필드가 입력받은 string을 포함하고 있는지 확인
  // 포함하고 있는 문서의 이름을 idList에 저장
  applyFilter(String keyword) {
    idList.clear();
    db.collection('cafeList').get().then((value) {
      for (var element in value.docs) {
        if (element.data()['keywords'].contains(keyword)) {
          idList.add(element.id.toString());
        }
      }
      update();
    });
  }

  Future<void> updateMarkers() async {
    var buf = <Marker>{};
    for (var id in idList) {
      final docRef = db.collection('cafeList').doc(id);
      docRef.get().then((value) {
        final cafe = value.data();
        final marker = Marker(
            consumeTapEvents: false,
            markerId: MarkerId(id),
            position: LatLng(cafe!['lat'], cafe['lng']),
            infoWindow: InfoWindow(title: cafe['name']),
            onTap: () {
              Get.to(
                  () => DetailPage(
                        idx: int.parse(id),
                      ),
                  transition: Transition.rightToLeft);
            });
        buf.add(marker);
        markers = buf;
      });
      update();
    }
  }
}
