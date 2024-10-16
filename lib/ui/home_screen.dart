import 'package:flutter/material.dart';
import '../main.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyWidget extends StatefulWidget {
  const MyWidget({super.key});

  @override
  State<MyWidget> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String? _authToken;

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
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoginPage()),
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

  _clickMe(int value) {
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('AlertDialog Title'),
        content: const Text('AlertDialog description'),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(context, 'Cancel'),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, 'OK'),
            child: const Text('OK'),
          ),
        ],
      ),
    );
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
            GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, // Number of columns in the grid
                crossAxisSpacing: 8.0, // Spacing between columns
                mainAxisSpacing: 8.0, // Spacing between rows
                childAspectRatio: 3 / 2, // Aspect ratio of each grid item
              ),
              itemCount: 20,
              itemBuilder: (context, index) {
                return Card(
                  elevation: 4.0, // Elevation of the card
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Block $index',
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                        const SizedBox(height: 20),
                        Image.asset(
                          '../assets/Patient-Care.jpg',
                          fit: BoxFit.contain,
                        ),
                        const SizedBox(height: 20),
                        MouseRegion(
                          cursor: SystemMouseCursors.click,
                          child: ElevatedButton(
                            onPressed: () => _clickMe(index),
                            style: ElevatedButton.styleFrom(
                                backgroundColor: const Color.fromARGB(
                                    255, 52, 141, 243) // Set background color
                                ),
                            child: const Text(
                              'click Me',
                              style: TextStyle(
                                color: Color.fromARGB(255, 9, 9, 233),
                              ),
                            ),
                          ),
                        ),
                      ]),
                );
              },
            ),
          ],
        ));
  }
}
