import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nusantara_app/model/provinsi.dart';
import 'package:nusantara_app/screen/detail.dart';

class ListPage extends StatelessWidget {
  const ListPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        if (constraints.maxWidth <= 600) {
          return const ProvinsiList();
        } else if (constraints.maxWidth <= 1200) {
          return const ProvinsiGrid(gridCount: 4);
        } else {
          return const ProvinsiGrid(gridCount: 6);
        }
      },
    );
  }
}

class ProvinsiList extends StatefulWidget {
  const ProvinsiList({Key? key}) : super(key: key);

  @override
  State<ProvinsiList> createState() => _ProvinsiListState();
}

class _ProvinsiListState extends State<ProvinsiList> {
  List<Provinsi> _provinsiList = [];

  _ProvinsiListState() {
    listProvinsi().then((val) => setState(() {
          _provinsiList = val;
        }));
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemBuilder: (context, index) {
        final Provinsi provinsi = _provinsiList[index];
        return InkWell(
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return DetailPage(provinsi: provinsi);
            }));
          },
          child: Card(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Expanded(
                  flex: 1,
                  child: Hero(
                    tag: 'tag_${provinsi.code}',
                    child: CircleAvatar(
                      backgroundColor: Colors.transparent,
                      radius: 48.0,
                      child: Image.asset(provinsi.photo),
                    ),
                  ),
                ),
                Expanded(
                  flex: 4,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              provinsi.name,
                              style: const TextStyle(
                                  fontSize: 16.0, fontWeight: FontWeight.bold),
                            ),
                            Text(provinsi.code.toString(),
                                style: const TextStyle(fontSize: 12.0)),
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Text(provinsi.detail),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        );
      },
      itemCount: _provinsiList.length,
    );
  }
}

class ProvinsiGrid extends StatefulWidget {
  final int gridCount;

  const ProvinsiGrid({Key? key, required this.gridCount}) : super(key: key);

  @override
  State<ProvinsiGrid> createState() => _ProvinsiGridState();
}

class _ProvinsiGridState extends State<ProvinsiGrid> {
  List<Provinsi> _provinsiList = [];

  _ProvinsiGridState() {
    listProvinsi().then((val) => setState(() {
          _provinsiList = val;
        }));
  }

  @override
  Widget build(BuildContext context) {
    return Scrollbar(
      isAlwaysShown: true,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.count(
          crossAxisCount: widget.gridCount,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          children: _provinsiList.map((provinsi) {
            return InkWell(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return DetailPage(provinsi: provinsi);
                }));
              },
              child: Card(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(
                      child: Image.asset(
                        provinsi.photo,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Text(
                        provinsi.name,
                        style: const TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0, bottom: 8.0),
                      child: Text(
                        provinsi.detail,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
