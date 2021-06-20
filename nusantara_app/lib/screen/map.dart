import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// ignore: import_of_legacy_library_into_null_safe
import 'package:mapbox_gl/mapbox_gl.dart';
import 'package:nusantara_app/model/provinsi.dart';
import 'package:nusantara_app/screen/detail.dart';

abstract class MapBoxPage extends StatelessWidget {
  // ignore: use_key_in_widget_constructors
  const MapBoxPage(this.leading, this.title);

  final Widget leading;
  final String title;
}

class MapPage extends MapBoxPage {
  const MapPage() : super(const Icon(Icons.map), 'Peta Provinsi');

  @override
  Widget build(BuildContext context) {
    return const FullMap();
  }
}

class FullMap extends StatefulWidget {
  const FullMap({Key? key}) : super(key: key);

  @override
  State createState() => FullMapState();
}

class FullMapState extends State<FullMap> {
  MapboxMapController? mapController;
  List<Provinsi> _provinsiList = [];

  void _onMapCreated(MapboxMapController controller) {
    mapController = controller;
    listProvinsi().then((val) => setState(() {
          _provinsiList = val;
        }));
    mapController?.onSymbolTapped.add(_onSymbolTapped);
  }

  @override
  void dispose() {
    mapController?.onSymbolTapped.remove(_onSymbolTapped);
    super.dispose();
  }

  void _onSymbolTapped(Symbol symbol) {
    if (_provinsiList.isNotEmpty) {
      for (Provinsi provinsi in _provinsiList) {
        if (symbol.data['code'] == provinsi.code.toString()) {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return DetailPage(provinsi: provinsi);
          }));
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MapboxMap(
        accessToken:
            'pk.eyJ1Ijoic2lwcm9ib3dhbmdpIiwiYSI6ImNraGFuZm5pajFkZHEycm84a2Y1dzVpb3AifQ.LQlq89fypKTdWqUOdXmHdw',
        onMapCreated: _onMapCreated,
        styleString: MapboxStyles.SATELLITE,
        initialCameraPosition: const CameraPosition(
          target: LatLng(-2.0, 118.0),
          zoom: 2.2,
        ),
        onStyleLoadedCallback: onStyleLoadedCallback,
      ),
    );
  }

  void onStyleLoadedCallback() {
    mapController?.animateCamera(
      CameraUpdate.newLatLngBounds(
        LatLngBounds(
          southwest: const LatLng(-11.007615000, 95.009707000),
          northeast: const LatLng(6.076940000, 141.019400000),
        ),
        left: 25,
        top: 25,
        bottom: 25,
        right: 25,
      ),
    );

    SymbolOptions _setProvinsiPoint(
        LatLng geometry, String provinsi, String code) {
      return SymbolOptions(
        geometry: geometry,
        iconImage: 'star-15',
        fontNames: ['DIN Offc Pro Bold', 'Arial Unicode MS Regular'],
        textField: provinsi,
        textSize: 11.0,
        textOffset: const Offset(0, 0.8),
        textAnchor: 'top',
        textColor: '#000000',
        textHaloColor: '#ffffff',
        textHaloWidth: 2,
      );
    }

    loadGeoJson('json/geo/indonesia_pt.geojson').then((val) => setState(() {
          var features = val['features'];
          for (var feature in features) {
            var coordinates = feature['geometry']['coordinates'];
            LatLng geometry = LatLng(
              coordinates[1],
              coordinates[0],
            );
            String provinsi = feature['properties']['Provinsi'];
            String code = feature['properties']['Kode_Prov'];
            mapController?.addSymbol(
                _setProvinsiPoint(geometry, provinsi, code), {'code': code});
          }
        }));
  }
}

Future loadGeoJson(String src) async {
  Future<String> data = rootBundle.loadString(src);
  return json.decode(await data);
}
