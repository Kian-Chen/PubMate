import 'package:flutter/material.dart';
import 'package:pubmate/widgets/custom_drawer.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  // Helper method to navigate to a named route
  void navigateTo(BuildContext context, String routeName) {
    Navigator.pushNamed(context, routeName);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Page'),
      ),
      drawer: const SizedBox(
        width: 240,
        child: CustomDrawer()
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          children: [
            ElevatedButton(
              onPressed: () => navigateTo(context, '/conference_deadlines'),
              child: const Text('Conference Deadlines'),
            ),
            ElevatedButton(
              onPressed: () => navigateTo(context, '/journals'),
              child: const Text('Journals'),
            ),
            ElevatedButton(
              onPressed: () => navigateTo(context, '/g2r_conferences'),
              child: const Text('Guide2Research Conferences'),
            ),
            ElevatedButton(
              onPressed: () => navigateTo(context, '/g2r_journals'),
              child: const Text('Guide2Research Journals'),
            ),
          ],
        ),
      ),
    );
  }
}
