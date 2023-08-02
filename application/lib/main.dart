import 'dart:async';

import 'package:cafe_recommend/cafeLIstPage.dart';
import 'package:cafe_recommend/searchBar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:get/get.dart';
import 'package:expandable_bottom_sheet/expandable_bottom_sheet.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'widgetsForFuture.dart';
import 'statusController.dart';

// ...

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: Firebase.initializeApp(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const SomethingWentWrong();
          }
          if (snapshot.connectionState == ConnectionState.done) {
            return GetMaterialApp(
              title: 'Flutter Demo',
              debugShowCheckedModeBanner: false,
              theme: ThemeData(
                colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
                useMaterial3: true,
              ),
              home: const MyHomePage(),
            );
          }
          return const Loading();
        });
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  GlobalKey<ExpandableBottomSheetState> key = GlobalKey();
  final ScrollController _controller = ScrollController();
  bool _scrollable = false;

  final Completer<GoogleMapController> _mapController =
      Completer<GoogleMapController>();
  final double lng = 127.129472;
  final double lat = 37.53563015429177;

  dynamic db = FirebaseFirestore.instance;
  final controller = Get.put(FilterController());
  List<int> idxList = [];

  void contract() {
    key.currentState?.contract();
  }

  void expand() {
    key.currentState?.expand();
  }

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      /// 스크롤을 할 때 마다 호출
      if (_controller.offset <= 0.1) {
        setState(() {
          _scrollable = false;
        });
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Get.put(FilterController());
    return GetBuilder(
        init: FilterController(),
        builder: (c) {
          c.init();
          c.update();
          return Scaffold(
            bottomNavigationBar: BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              showSelectedLabels: false,
              showUnselectedLabels: false,
              items: [
                BottomNavigationBarItem(
                    icon: Image.asset(
                      'C:\\Users\\jdk82\\Desktop\\cafe_recommend\\lib\\assets\\home2.png',
                    ),
                    label: ""),
                BottomNavigationBarItem(
                  icon: Image.asset(
                      'C:\\Users\\jdk82\\Desktop\\cafe_recommend\\lib\\assets\\locationtick.png'),
                  label: "",
                ),
                BottomNavigationBarItem(
                  icon: Image.asset(
                      'C:\\Users\\jdk82\\Desktop\\cafe_recommend\\lib\\assets\\save2.png'),
                  label: "",
                ),
                BottomNavigationBarItem(
                  icon: Image.asset(
                      'C:\\Users\\jdk82\\Desktop\\cafe_recommend\\lib\\assets\\user.png'),
                  label: "h",
                ),
              ],
            ),
            body: ExpandableBottomSheet(
              onIsExtendedCallback: () {
                setState(() {
                  _scrollable = true;
                });
              },
              onIsContractedCallback: () {
                setState(() {
                  _scrollable = false;
                  _controller.animateTo(0,
                      duration: const Duration(milliseconds: 1),
                      curve: Curves.linear);
                });
              },
              key: key,
              persistentContentHeight:
                  MediaQuery.sizeOf(context).height * 150 / 844,
              background: Stack(
                alignment: Alignment.topCenter,
                children: [
                  GoogleMap(
                    onCameraMove: (p) {
                      contract();
                    },
                    initialCameraPosition:
                        CameraPosition(target: LatLng(lat, lng), zoom: 16),
                    onMapCreated: (mapController) {},
                    zoomControlsEnabled: false,
                    mapType: MapType.normal,
                    markers: c.markers,
                  ),
                  Positioned(
                      top: MediaQuery.sizeOf(context).height * 51 / 844,
                      child: const CustomSearchBar()),
                ],
              ),
              persistentHeader: const BottomBarHandle(),
              expandableContent: Container(
                  height: 450,
                  color: const Color(0xFFF7F8FA),
                  child: Scrollbar(
                    thickness: 6,
                    radius: const Radius.circular(10),
                    child: ListView.builder(
                      physics: _scrollable
                          ? const BouncingScrollPhysics()
                          : const NeverScrollableScrollPhysics(),
                      controller: _controller,
                      itemCount: c.idList.length,
                      itemBuilder: (context, index) {
                        return CafeCard(idx: int.parse(c.idList[index]));
                      },
                    ),
                  )),
            ),
          );
        });
  }
}
