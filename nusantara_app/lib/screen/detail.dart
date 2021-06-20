import 'package:flutter/material.dart';
import 'package:link_text/link_text.dart';
import 'package:nusantara_app/model/provinsi.dart';

class DetailPage extends StatelessWidget {
  final Provinsi provinsi;

  const DetailPage({Key? key, required this.provinsi}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(provinsi.name),
      ),
      body: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          if (constraints.maxWidth > 800) {
            return DetailWebPage(provinsi: provinsi);
          } else {
            return DetailMobilePage(provinsi: provinsi);
          }
        },
      ),
    );
  }
}

class DetailWebPage extends StatefulWidget {
  final Provinsi provinsi;

  const DetailWebPage({Key? key, required this.provinsi}) : super(key: key);

  @override
  State<DetailWebPage> createState() => _DetailWebPageState();
}

class _DetailWebPageState extends State<DetailWebPage> {
  final _scrollController = ScrollController();
  // ignore: prefer_typing_uninitialized_variables
  var _provinsiJson;
  final List<DataRow> _dataRows = [];
  final List<String> _imageList = [];

  _DetailWebPageState() {
    loadJson().then((val) => setState(() {
          for (var provinsi in val) {
            if (provinsi['Kode Wilayah'] == widget.provinsi.code) {
              _provinsiJson = provinsi;
              break;
            }
          }
          for (final key in _provinsiJson.keys) {
            final value = _provinsiJson[key].toString();
            if (key == 'Deskripsi' || key == 'Nama') {
              continue;
            }
            Widget textValue;
            if (key == 'Link' ||
                key == 'Situs web resmi' ||
                key == 'Situs web BPS') {
              textValue = LinkText(
                value.contains("https") ? value : "https://" + value,
                textAlign: TextAlign.start,
              );
            } else {
              textValue = Text(value);
            }
            final row = DataRow(cells: [
              DataCell(Text(key)),
              DataCell(textValue),
            ]);
            _dataRows.add(row);
          }
        }));

    listImagesDetail().then((val) => setState(() {
          for (String path in val) {
            if (path.contains((provinsiShort[widget.provinsi.no - 1]) + '_')) {
              _imageList.add(path);
            }
          }
        }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SizedBox(
                  height: 150,
                  child: Hero(
                    tag: 'tag_${widget.provinsi.code}',
                    child: Image.asset(
                        'images/lambang/lambang_${provinsiShort[widget.provinsi.no - 1]}.png'),
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(
                      height: 150,
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (_) {
                            return FullScreenImage(
                                path:
                                    'images/bendera/bendera_${provinsiShort[widget.provinsi.no - 1]}.png');
                          }));
                        },
                        child: Center(
                          child: Hero(
                            tag:
                                'images/bendera/bendera_${provinsiShort[widget.provinsi.no - 1]}.png',
                            child: Image.asset(
                                'images/bendera/bendera_${provinsiShort[widget.provinsi.no - 1]}.png',
                                errorBuilder: (BuildContext context,
                                    Object exception, StackTrace? stackTrace) {
                              return Image.asset(
                                  'images/bendera/bendera_null.png');
                            }),
                          ),
                        ),
                      ),
                    ),
                    const Text(
                      'Bendera',
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                DataTable(
                  columns: [
                    const DataColumn(
                        label: Text('Nama',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold))),
                    DataColumn(
                        label: Text(widget.provinsi.name,
                            style: const TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold))),
                  ],
                  rows: _dataRows,
                ),
                Flexible(
                  child: Container(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      _provinsiJson == null ? '' : _provinsiJson['Deskripsi'],
                      textAlign: TextAlign.justify,
                      style: const TextStyle(
                        fontSize: 16.0,
                        fontFamily: 'Oxygen',
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Container(
              height: 200,
              padding: const EdgeInsets.only(bottom: 16),
              child: Scrollbar(
                isAlwaysShown: true,
                controller: _scrollController,
                child: ListView(
                  controller: _scrollController,
                  padding: const EdgeInsets.only(bottom: 16),
                  scrollDirection: Axis.horizontal,
                  children: _imageList.map((path) {
                    return Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(context,
                                MaterialPageRoute(builder: (_) {
                              return FullScreenImage(path: path);
                            }));
                          },
                          child: Center(
                            child: Hero(
                              tag: path,
                              child: Image.asset(path),
                            ),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}

class DetailMobilePage extends StatefulWidget {
  final Provinsi provinsi;

  const DetailMobilePage({Key? key, required this.provinsi}) : super(key: key);

  @override
  State<DetailMobilePage> createState() => _DetailMobilePageState();
}

class _DetailMobilePageState extends State<DetailMobilePage> {
  final _scrollController = ScrollController();
  // ignore: prefer_typing_uninitialized_variables
  var _provinsiJson;
  final List<DataRow> _dataRows = [];
  final List<String> _imageList = [];

  _DetailMobilePageState() {
    loadJson().then((val) => setState(() {
          for (var provinsi in val) {
            if (provinsi['Kode Wilayah'] == widget.provinsi.code) {
              _provinsiJson = provinsi;
              break;
            }
          }
          for (final key in _provinsiJson.keys) {
            final value = _provinsiJson[key].toString();
            if (key == 'Deskripsi' || key == 'Nama') {
              continue;
            }
            Widget textValue;
            if (key == 'Link' ||
                key == 'Situs web resmi' ||
                key == 'Situs web BPS') {
              textValue = LinkText(
                value.contains("https") ? value : "https://" + value,
                textAlign: TextAlign.start,
              );
            } else {
              textValue = Text(value);
            }
            final row = DataRow(cells: [
              DataCell(Text(key)),
              DataCell(textValue),
            ]);
            _dataRows.add(row);
          }
        }));

    listImagesDetail().then((val) => setState(() {
          for (String path in val) {
            if (path.contains((provinsiShort[widget.provinsi.no - 1]) + '_')) {
              _imageList.add(path);
            }
          }
        }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            SizedBox(
              height: 150,
              child: Hero(
                tag: 'tag_${widget.provinsi.code}',
                child: Image.asset(
                    'images/lambang/lambang_${provinsiShort[widget.provinsi.no - 1]}.png'),
              ),
            ),
            DataTable(
              columns: [
                const DataColumn(
                    label: Text('Nama',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold))),
                DataColumn(
                    label: Text(widget.provinsi.name,
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold))),
              ],
              rows: _dataRows,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  height: 100,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (_) {
                        return FullScreenImage(
                            path:
                                'images/bendera/bendera_${provinsiShort[widget.provinsi.no - 1]}.png');
                      }));
                    },
                    child: Center(
                      child: Hero(
                        tag:
                            'images/bendera/bendera_${provinsiShort[widget.provinsi.no - 1]}.png',
                        child: Image.asset(
                            'images/bendera/bendera_${provinsiShort[widget.provinsi.no - 1]}.png',
                            errorBuilder: (BuildContext context,
                                Object exception, StackTrace? stackTrace) {
                          return Image.asset('images/bendera/bendera_null.png');
                        }),
                      ),
                    ),
                  ),
                ),
                const Text(
                  'Bendera',
                  textAlign: TextAlign.center,
                ),
              ],
            ),
            Container(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                _provinsiJson == null ? '' : _provinsiJson['Deskripsi'],
                textAlign: TextAlign.justify,
                style: const TextStyle(
                  fontSize: 16.0,
                  fontFamily: 'Oxygen',
                ),
              ),
            ),
            Container(
              height: 200,
              padding: const EdgeInsets.only(bottom: 16),
              child: Scrollbar(
                isAlwaysShown: true,
                controller: _scrollController,
                child: ListView(
                  controller: _scrollController,
                  padding: const EdgeInsets.only(bottom: 16),
                  scrollDirection: Axis.horizontal,
                  children: _imageList.map((path) {
                    return Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(context,
                                MaterialPageRoute(builder: (_) {
                              return FullScreenImage(path: path);
                            }));
                          },
                          child: Center(
                            child: Hero(
                              tag: path,
                              child: Image.asset(path),
                            ),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}

class FullScreenImage extends StatelessWidget {
  final String path;

  const FullScreenImage({Key? key, required this.path}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: () {
          Navigator.pop(context);
        },
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Hero(
            tag: path,
            child: Image.asset(path, fit: BoxFit.contain, errorBuilder:
                (BuildContext context, Object exception,
                    StackTrace? stackTrace) {
              return Image.asset('images/bendera/bendera_null.png');
            }),
          ),
        ),
      ),
    );
  }
}
