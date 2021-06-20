import 'package:flutter/material.dart';
import 'package:nusantara_app/screen/list.dart';
import 'package:nusantara_app/screen/map.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: HomeNavigation());
  }
}

class HomeNavigation extends StatefulWidget {
  const HomeNavigation({Key? key}) : super(key: key);

  @override
  _HomeNavigationState createState() => _HomeNavigationState();
}

class _HomeNavigationState extends State<HomeNavigation> {
  int _currentIndex = 0;
  final List _screens = [
    Scaffold(
        appBar: AppBar(
          title: const Text('Daftar Provinsi'),
        ),
        body: const ListPage()),
    Scaffold(
        appBar: AppBar(
          title: const Text('Peta Provinsi'),
        ),
        body: const MapPage()),
  ];

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _currentIndex,
        backgroundColor: colorScheme.surface,
        selectedItemColor: Colors.redAccent,
        unselectedItemColor: colorScheme.onSurface.withOpacity(.60),
        selectedLabelStyle: textTheme.caption,
        unselectedLabelStyle: textTheme.caption,
        onTap: (value) {
          setState(() => _currentIndex = value);
        },
        items: const [
          BottomNavigationBarItem(
            label: "List",
            icon: Icon(Icons.list),
          ),
          BottomNavigationBarItem(
            label: 'Map',
            icon: Icon(Icons.map),
          ),
        ],
      ),
    );
  }
}
