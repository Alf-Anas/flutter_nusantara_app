import 'package:flutter/services.dart' show rootBundle;
import 'dart:convert';

class Provinsi {
  int no;
  String name;
  int code;
  String detail;
  String photo;
  String website;
  String wikipedia;

  Provinsi({
    required this.no,
    required this.name,
    required this.code,
    required this.detail,
    required this.photo,
    required this.website,
    required this.wikipedia,
  });
}

var provinsiShort = [
  "aceh",
  "sumut",
  "sumbar",
  "riau",
  "jambi",
  "sumsel",
  "bengkulu",
  "lampung",
  "bangka",
  "kepri",
  "jakarta",
  "jabar",
  "jateng",
  "jogja",
  "jatim",
  "banten",
  "bali",
  "ntb",
  "ntt",
  "kalbar",
  "kalteng",
  "kalsel",
  "kaltim",
  "kalut",
  "sulut",
  "sulteng",
  "sulsel",
  "sultra",
  "gorontalo",
  "sulbar",
  "maluku",
  "malut",
  "papua",
  "papuabarat"
];

Future loadJson() async {
  Future<String> data = rootBundle.loadString('json/data.json');
  return json.decode(await data);
}

Future<List<Provinsi>> listProvinsi() async {
  var jsonResult = await loadJson();

  List<Provinsi> _provinsiList = [];

  for (var provinsi in jsonResult) {
    String desk = provinsi['Deskripsi'].toString();
    var _provinsi = Provinsi(
        no: provinsi['No'],
        name: provinsi['Nama'],
        code: provinsi['Kode Wilayah'],
        detail: desk.substring(0, 100) + '...',
        photo:
            'images/lambang/lambang_${provinsiShort[provinsi['No'] - 1]}.png',
        website: provinsi['Situs web resmi'],
        wikipedia: provinsi['Link']);
    _provinsiList.add(_provinsi);
  }

  return _provinsiList;
}

Future listImagesDetail() async {
  final manifestContent = await rootBundle.loadString('AssetManifest.json');
  final Map<String, dynamic> manifestMap = json.decode(manifestContent);
  final imagePaths = manifestMap.keys
      .where((String key) => key.contains('images/detail/'))
      .toList();
  return imagePaths;
}