class Cafe {
  final String name;
  final int lat;
  final int lng;
  final List<String> keywords;
  final double positiveReviewRatio;
  final List<String> photoUrlList;
  final String address;

  Cafe({
    required this.name,
    required this.lat,
    required this.lng,
    required this.keywords,
    required this.positiveReviewRatio,
    required this.address,
    required this.photoUrlList,
  });

  Cafe.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        lat = json['lat'],
        lng = json['lng'],
        keywords = json['keywords'],
        positiveReviewRatio = json['positiveReviewRatio'],
        address = json['address'],
        photoUrlList = json['photoUrlList'];

  Map<String, dynamic> toJson() => {
        'name': name,
        'lat': lat,
        'lng': lng,
        'keywords': keywords,
        'positiveReviewRatio': positiveReviewRatio,
        'address': address,
        'photoUrlList': photoUrlList,
      };
}
