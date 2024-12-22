import 'package:flutter/material.dart';
import 'package:pubmate/auth/auth_service.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final authService = AuthService();
    final currentUserEmail =
        authService.getCurrentUserEmail() ?? "Unknown User";

    // Logout logic
    void logout() async {
      await authService.signOut(); // Sign out the user
      // No need to navigate, `AuthGate` handles routing based on auth state
    }

    return Drawer(
      child: Column(
        children: [
          UserAccountsDrawerHeader(
            decoration: const BoxDecoration(color: Colors.purple),
            accountName: null,
            accountEmail: Text(currentUserEmail),
            currentAccountPicture: CircleAvatar(
              backgroundColor: Colors.white,
              child: Text(
                currentUserEmail[0].toUpperCase(), // Display first letter of email
                style: const TextStyle(fontSize: 40, color: Colors.purple),
              ),
            ),
          ),
          Expanded(
            child: ListView(
              children: [
                ListTile(
                  title: const Text("Conference Deadlines"),
                  onTap: () {
                    Navigator.pop(context); // Close the drawer
                    Navigator.pushNamed(context, '/conference_deadlines');
                  },
                ),
                ListTile(
                  title: const Text("Journals"),
                  onTap: () {
                    Navigator.pop(context); // Close the drawer
                    Navigator.pushNamed(context, '/journals');
                  },
                ),
                ListTile(
                  title: const Text("Guide2Research Conf"),
                  onTap: () {
                    Navigator.pop(context); // Close the drawer
                    Navigator.pushNamed(context, '/g2r_conferences');
                  },
                ),
                ListTile(
                  title: const Text("Guide2Research Jour"),
                  onTap: () {
                    Navigator.pop(context); // Close the drawer
                    Navigator.pushNamed(context, '/g2r_journals');
                  },
                ),
              ],
            ),
          ),
          const Divider(),
          ListTile(
            title: const Text("Logout"),
            trailing: const Icon(Icons.logout),
            onTap: logout, // Call logout logic
          ),
        ],
      ),
    );
  }
}
