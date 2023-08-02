import 'package:cafe_recommend/searchBar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class DetailPage extends StatefulWidget {
  const DetailPage({required this.idx, super.key});
  final int idx;

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  List<String> Keywords = <String>[];
  final db = FirebaseFirestore.instance;
  String name = "loading...";
  late String address = "loading...";
  late List<String> imageUrl = <String>[];
  late double posRatio = 0.0;

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
      posRatio = value.data()!['positiveReviewRatio'];
      setState(() {
        Keywords = Keywords;
        name = name;
        address = address;
        imageUrl = imageUrl;
        posRatio = posRatio;
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
          return Scaffold(
            appBar: AppBar(),
            body: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CafeImageListView(imageUrl: imageUrl),
                  Container(
                    height: 22,
                  ),
                  Row(
                    children: [
                      Container(
                        width: 26,
                      ),
                      TitleWidgetDetail(title: name, subtitle: address),
                      Expanded(
                        child: Container(),
                      ),
                      const Column(
                        children: [
                          Icon(
                            Icons.bookmark_add_outlined,
                            size: 21,
                          ),
                          Text(
                            '저장',
                            style: TextStyle(
                              color: Color(0xFF6A6A6A),
                              fontSize: 11,
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w500,
                            ),
                          )
                        ],
                      ),
                      Container(
                        width: 30,
                      ),
                      const Column(
                        children: [
                          Icon(
                            Icons.share_outlined,
                            size: 21,
                          ),
                          Text(
                            '공유',
                            style: TextStyle(
                              color: Color(0xFF6A6A6A),
                              fontSize: 11,
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      Container(
                        width: 26,
                      ),
                    ],
                  ),
                  Container(
                    height: 33,
                  ),
                  Row(
                    children: [
                      Container(
                        width: 24,
                      ),
                      const Icon(
                        Icons.location_on,
                        size: 12,
                      ),
                      Container(
                        width: 5,
                      ),
                      Text(
                        address,
                        style: const TextStyle(
                          color: Color(0xFF383838),
                          fontSize: 12,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Container(
                        width: 5,
                      ),
                      const Icon(
                        Icons.copy_outlined,
                        size: 12,
                        color: Color(0xff62A5F1),
                      ),
                      Expanded(
                        child: Container(),
                      ),
                    ],
                  ),
                  Container(
                    height: 19,
                  ),
                  Container(
                    width: MediaQuery.sizeOf(context).width,
                    decoration: const ShapeDecoration(
                      shape: RoundedRectangleBorder(
                        side: BorderSide(
                          width: 0.50,
                          strokeAlign: BorderSide.strokeAlignCenter,
                          color: Color(0xFFDBDBDB),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    height: 20,
                  ),
                  Row(
                    children: [
                      Container(
                        width: 26,
                      ),
                      const Text(
                        '대표 키워드',
                        style: TextStyle(
                          color: Color(0xFF404040),
                          fontSize: 14,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    height: 13,
                  ),
                  KeywordListView(
                    Keywords: Keywords,
                  ),
                  Container(
                    height: 16,
                  ),
                  Container(
                    width: MediaQuery.sizeOf(context).width,
                    decoration: const ShapeDecoration(
                      shape: RoundedRectangleBorder(
                        side: BorderSide(
                          width: 0.50,
                          strokeAlign: BorderSide.strokeAlignCenter,
                          color: Color(0xFFDBDBDB),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    height: 15,
                  ),
                  Row(
                    children: [
                      Container(
                        width: 24,
                      ),
                      Text(
                        '${(100 * posRatio).toInt()}%가 좋아해요!',
                        style: const TextStyle(
                          color: Color(0xFF404040),
                          fontSize: 14,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    height: 15,
                  ),
                  Center(
                    child: Container(
                      alignment: Alignment.center,
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: LinearProgressIndicator(
                        minHeight: 25,
                        value: posRatio,
                        backgroundColor:
                            const Color.fromARGB(255, 232, 232, 232),
                        color: const Color.fromARGB(255, 98, 165, 241),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }
}

class CafeImageListView extends StatelessWidget {
  const CafeImageListView({
    super.key,
    required this.imageUrl,
  });
  final List<String> imageUrl;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 130,
      width: MediaQuery.sizeOf(context).width,
      child: ListView.builder(
        addRepaintBoundaries: false,
        scrollDirection: Axis.horizontal,
        itemCount: imageUrl.length,
        itemBuilder: (context, index) {
          return SizedBox(
            width: 159,
            height: 130,
            child: Image.network(
              imageUrl[index],
              fit: BoxFit.fill,
            ),
          );
        },
      ),
    );
  }
}

class TitleWidgetDetail extends StatelessWidget {
  const TitleWidgetDetail({
    required this.title,
    required this.subtitle,
    super.key,
  });

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
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
