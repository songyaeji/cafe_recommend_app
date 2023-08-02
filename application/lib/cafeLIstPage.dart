import 'package:cafe_recommend/searchBar.dart';
import 'package:cafe_recommend/statusController.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class CafeCard extends StatefulWidget {
  const CafeCard({super.key, required this.idx});
  final int idx;

  @override
  State<CafeCard> createState() => _CafeCardState();
}

class _CafeCardState extends State<CafeCard> {
  List<String> Keywords = <String>[];
  final db = FirebaseFirestore.instance;
  String name = "loading...";
  late String address = "loading ...";
  late List<String> imageUrl = <String>[];

  Future<void> updateState() async {
    var docRef = db.collection('cafeList').doc(widget.idx.toString());
    docRef.get().then((value) {
      Keywords =
          value.data()!['keywords'].map<String>((e) => e.toString()).toList();
      name = value.data()!['name'];
      address = value.data()!['address'];
      imageUrl = value
          .data()!['photoUrlList']
          .map<String>((e) => e.toString())
          .toList();
      setState(() {
        Keywords = Keywords;
        name = name;
        address = address;
        imageUrl = imageUrl;
      });
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: updateState(),
        builder: (context, snap) {
          return Container(
            padding: EdgeInsets.only(
                left: MediaQuery.sizeOf(context).width * 15 / 390,
                right: MediaQuery.sizeOf(context).width * 15 / 390,
                top: 7,
                bottom: 50),
            height: 221,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GoDetail(
                      TitleWidget(
                        title: name,
                        // ignore: prefer_interpolation_to_compose_strings
                        subtitle: address.split(' ')[0] + " " + address.split(' ')[1],
                      ),
                      widget.idx,
                    ),
                    SizedBox(
                      height: 45,
                      width: 250,
                      child: KeywordListView(
                        Keywords: Keywords,
                      ),
                    ),
                  ],
                ),
                Container(
                  height: 11,
                ),
                SizedBox(
                  height: 108,
                  child: Scrollbar(
                    thickness: 5,
                    child: ListView.separated(
                      addRepaintBoundaries: false,
                      scrollDirection: Axis.horizontal,
                      itemCount: imageUrl.length,
                      separatorBuilder: (context, index) {
                        return Container(width: 16);
                      },
                      itemBuilder: (context, index) {
                        return GoDetail(
                            SizedBox(
                              width: 158,
                              height: 108,
                              child: Image.network(
                                imageUrl[index],
                                fit: BoxFit.fill,
                              ),
                            ),
                            widget.idx);
                      },
                    ),
                  ),
                ),
              ],
            ),
          );
        });
  }
}

class TitleWidget extends StatelessWidget {
  const TitleWidget({
    required this.title,
    required this.subtitle,
    super.key,
  });

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          title,
          textAlign: TextAlign.left,
          style: const TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontFamily: 'Inter',
            fontWeight: FontWeight.w600,
          ),
        ),
        Text(
          subtitle,
          textAlign: TextAlign.left,
          style: const TextStyle(
            color: Color(0xFF6F6F6F),
            fontSize: 13,
            fontFamily: 'Inter',
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

class BottomBarHandle extends StatefulWidget {
  const BottomBarHandle({super.key});

  @override
  State<BottomBarHandle> createState() => _BottomBarHandleState();
}

class _BottomBarHandleState extends State<BottomBarHandle> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.topCenter,
      children: [
        Container(
          width: 390,
          height: 25,
          decoration: const ShapeDecoration(
            color: Color(0xFFF7F8FA),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            shadows: [
              BoxShadow(
                color: Color(0x14000000),
                blurRadius: 14,
                offset: Offset(0, -4),
                spreadRadius: 0,
              )
            ],
          ),
        ),
        Positioned(
          top: 19.31,
          child: Container(
            width: 50,
            decoration: const ShapeDecoration(
              shape: RoundedRectangleBorder(
                side: BorderSide(
                  width: 2.50,
                  strokeAlign: BorderSide.strokeAlignCenter,
                  color: Color(0xFFD8D8D8),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class TagWidget extends StatefulWidget {
  const TagWidget({required this.tag, super.key});
  final String tag;

  @override
  State<TagWidget> createState() => _TagWidgetState();
}

class _TagWidgetState extends State<TagWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18),
      height: 35,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 0.1,
            blurRadius: 0.2,
            offset: const Offset(0, 2), // changes position of shadow
          ),
        ],
      ),
      child: Center(
        child: Text(
          widget.tag,
          style: const TextStyle(
            color: Colors.black,
            fontSize: 12,
            fontFamily: 'Inter',
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
