import 'package:flutter/material.dart';
import '../pages/counter_page.dart';
import '../pages/todo_page.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  static const List<Widget> _pages = <Widget>[
	CounterPage(),
	TodoPage(),
  ];

  void _onItemTapped(int index) {
	setState(() {
	  _selectedIndex = index;
	});
  }

  @override
  Widget build(BuildContext context) {
	return Scaffold(
	  appBar: AppBar(
		title: const Text('State & Persistence Demo'),
	  ),
	  body: _pages.elementAt(_selectedIndex),
	  bottomNavigationBar: BottomNavigationBar(
		currentIndex: _selectedIndex,
		onTap: _onItemTapped,
		items: const [
		  BottomNavigationBarItem(icon: Icon(Icons.exposure_plus_1), label: 'Counter'),
		  BottomNavigationBarItem(icon: Icon(Icons.list), label: 'To-Do'),
		],
	  ),
	);
  }
}


