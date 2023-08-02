import 'package:cafe_recommend/cafeLIstPage.dart';
import 'package:flutter/material.dart';

class CustomSearchBar extends StatefulWidget {
  const CustomSearchBar({super.key});

  @override
  State<CustomSearchBar> createState() => _CustomSearchBarState();
}

class _CustomSearchBarState extends State<CustomSearchBar> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: MediaQuery.of(context).size.width * 354 / 390,
          height: 44,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(25),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 0.5,
                blurRadius: 1,
                offset: const Offset(0, 3), // changes position of shadow
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                width: 20,
              ),
              const Icon(Icons.search),
              Container(width: 11),
              const TextField(
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: '강남역 카페',
                  hintStyle: TextStyle(
                    color: Color(0xFFBBBBBB),
                    fontSize: 14,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
        Container(
          height: 11,
          color: Colors.transparent,
        ),
        const KeywordListView(Keywords: [
          "내 주변",
          "필터",
          "반려",
          "집중하기 좋은",
          "분위기 좋은",
          "자연",
          "커피가 맛있는",
          "가까운"
        ]),
      ],
    );
  }
}

class KeywordListView extends StatelessWidget {
  const KeywordListView({super.key, required this.Keywords});

  final Keywords;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 45,
      width: MediaQuery.of(context).size.width, //*354/390,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(vertical: 5),
        physics: const BouncingScrollPhysics(),
        scrollDirection: Axis.horizontal,
        itemCount: Keywords.length + 2,
        itemBuilder: (BuildContext context, int index) {
          if (index == 0 || index == Keywords.length + 1) {
            return Container(width: 8);
          } else {
            return TagWidget(tag: Keywords[index - 1]);
          }
        },
        separatorBuilder: (BuildContext context, int index) {
          return Container(width: 8);
        },
      ),
    );
  }
}
