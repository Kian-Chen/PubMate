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
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.grey.shade100, Colors.grey.shade300],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          children: [
            // User Account Header
            UserAccountsDrawerHeader(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.purple.shade700, Colors.purple.shade300],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              accountName: null,
              accountEmail: Text(
                currentUserEmail,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              currentAccountPicture: CircleAvatar(
                backgroundColor: Colors.white,
                child: Text(
                  currentUserEmail[0].toUpperCase(), // Display first letter of email
                  style: const TextStyle(fontSize: 40, color: Colors.purple),
                ),
              ),
            ),

            // Expanded List for Menu Items
            Expanded(
              child: ListView(
                children: [
                  _buildListTile(context, "Conference Deadlines", '/conference_deadlines'),
                  _buildListTile(context, "Journals", '/journals'),
                  _buildListTile(context, "Guide2Research Conf", '/g2r_conferences'),
                  _buildListTile(context, "Guide2Research Jour", '/g2r_journals'),
                ],
              ),
            ),

            // Divider with custom styling
            const Divider(
              color: Colors.grey,
              thickness: 1,
              indent: 20,
              endIndent: 20,
            ),

            // Logout Button
            ListTile(
              title: const Text(
                "Logout",
                style: TextStyle(
                  color: Colors.redAccent,
                  fontWeight: FontWeight.bold,
                ),
              ),
              trailing: const Icon(Icons.logout, color: Colors.redAccent),
              onTap: logout, // Call logout logic
            ),
          ],
        ),
      ),
    );
  }

  // Helper function to create a ListTile without extra background for menu items
  Widget _buildListTile(BuildContext context, String title, String routeName) {
    return ListTile(
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: Colors.black87,
        ),
      ),
      contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
      onTap: () {
        Navigator.pop(context); // Close the drawer
        Navigator.pushNamed(context, routeName);
      },
    );
  }
}
