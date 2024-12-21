import 'package:flutter/material.dart';
import 'package:pubmate/auth/auth_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  // get auth service
  final authService = AuthService();

  // logout button pressed
  void logout() async {
    await authService.signOut();
  }

  @override
  Widget build(BuildContext context) {

    // get user email
    final currentUserEmail = authService.getCurrentUserEmail();

    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text('Home Page')),
        actions: [
          // logout button
          IconButton(
            onPressed: logout,
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: Center(child: Text(currentUserEmail.toString())),
    );
  }
}
