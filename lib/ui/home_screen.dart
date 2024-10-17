import 'package:flutter/material.dart';
import '../main.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class MyWidget extends StatefulWidget {
  const MyWidget({super.key});

  @override
  State<MyWidget> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String? _authToken;
  String imageUrl =
      'https://images.dog.ceo/breeds/deerhound-scottish/n02092002_854.jpg';
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(_handleTabSelection);
    _checkAuthToken();
  }

  @override
  void dispose() {
    _tabController.removeListener(_handleTabSelection);
    _tabController.dispose();
    super.dispose();
  }

  void _handleTabSelection() async {
    if (_tabController.indexIsChanging) {
      if (_tabController.index == 2) {
        showDialog(
          context: context,
          builder: (BuildContext context) => AlertDialog(
            title: const Text('Are You sure?'),
            content: const Text('AlertDialog description'),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.pop(context, 'NO'),
                child: const Text('No'),
              ),
              TextButton(
                onPressed: () => Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginPage()),
                ),
                child: const Text('Yes'),
              ),
            ],
          ),
        );
      }
    }
  }

  Future<void> _checkAuthToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _authToken = prefs.getString('auth_token');
    });
  }

  _clickMe() async {
    var url = Uri.parse('https://dog.ceo/api/breeds/image/random');
    var response = await http.get(url);
    var data = jsonDecode(response.body);
    setState(() {
      imageUrl = data['message'];
    });
    print(imageUrl);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            'Welcome to Your Doctor',
            style: TextStyle(color: Color.fromARGB(255, 248, 248, 248)),
          ),
          backgroundColor: const Color.fromARGB(255, 103, 165, 236),
          bottom: TabBar(
            controller: _tabController,
            indicatorColor: const Color.fromARGB(255, 93, 28, 245),
            labelColor: const Color.fromARGB(255, 248, 248, 248),
            unselectedLabelColor: Colors.white,
            tabs: const [
              Tab(icon: Icon(Icons.home), text: 'Home'),
              Tab(icon: Icon(Icons.settings_display_rounded), text: 'Settings'),
              Tab(icon: Icon(Icons.login), text: 'logout'),
            ],
          ),
        ),
        body: TabBarView(
          controller: _tabController,
          children: [
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Home Tab Content'),
                  Text('Token: ${_authToken ?? 'No token found'}'),
                ],
              ),
            ),
            Column(children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 600, // Set the desired width
                      height: 400, // Set the desired height
                      child: Image(
                        image: NetworkImage(imageUrl),
                        fit: BoxFit
                            .cover, // Optional: adjust the fit of the image
                      ),
                    ),
                    const SizedBox(height: 16.0),
                    ElevatedButton(
                      onPressed: _clickMe,
                      child: const Text('Click here'),
                    ),
                  ],
                ),
              )
            ])
          ],
        ));
  }
}
