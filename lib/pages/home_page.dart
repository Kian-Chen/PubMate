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
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      drawer: const SizedBox(
        width: 240,
        child: CustomDrawer(),
      ),
      body: Container(
        color: Colors.white,
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Welcome Text with Gradient Animation
            _buildWelcomeText(),

            const SizedBox(height: 20),

            // Description Text
            const Text(
              'Explore academic resources and stay on top of deadlines with ease.',
              style: TextStyle(
                fontSize: 16,
                color: Colors.black54,
                fontFamily: 'Poppins',  // More modern font style
              ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 40),

            // Grid of buttons
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                children: [
                  _buildButton(
                    context,
                    'Conference Deadlines',
                    Colors.deepPurple,
                    '/conference_deadlines',
                  ),
                  _buildButton(
                    context,
                    'Journals',
                    Colors.teal,
                    '/journals',
                  ),
                  _buildButton(
                    context,
                    'Guide2Research Conferences',
                    Colors.blueAccent,
                    '/g2r_conferences',
                  ),
                  _buildButton(
                    context,
                    'Guide2Research Journals',
                    Colors.orangeAccent,
                    '/g2r_journals',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Welcome Text with Gradient Animation
  Widget _buildWelcomeText() {
    return AnimatedOpacity(
      opacity: 1.0,  // Fade in animation
      duration: const Duration(seconds: 1),
      child: ShaderMask(
        shaderCallback: (bounds) {
          return const LinearGradient(
            colors: [Colors.black, Colors.grey],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ).createShader(bounds);
        },
        child: const Text(
          'Welcome to Your Academic Helper!',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontFamily: 'Poppins',  // Use modern font for better appeal
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  // Helper function to create buttons with gradient and hover effect
  Widget _buildButton(BuildContext context, String label, Color color, String route) {
    return GestureDetector(
      onTap: () => navigateTo(context, route),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [color.withOpacity(0.7), color],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              spreadRadius: 2,
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 24.0),
          child: Center(
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.white,
                fontFamily: 'Poppins',  // Consistent modern font
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }
}
