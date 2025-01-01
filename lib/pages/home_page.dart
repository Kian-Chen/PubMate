import 'dart:async';
import 'package:flutter/material.dart';
import 'package:pubmate/widgets/custom_drawer.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Timer for updating the progress every second
  late Timer _timer;

  // Current progress value (between 0 and 1)
  double _progress = 0.0;

  @override
  void initState() {
    super.initState();

    // Start the timer that updates the progress every second
    _startProgressTimer();
  }

  @override
  void dispose() {
    // Don't forget to cancel the timer when the widget is disposed
    _timer.cancel();
    super.dispose();
  }

  // Helper method to navigate to a named route
  void navigateTo(BuildContext context, String routeName) {
    Navigator.pushNamed(context, routeName);
  }

  // Start the timer to update the progress every second
  void _startProgressTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      setState(() {
        _progress = _getYearProgress();
      });
    });
  }

  // Helper method to calculate the progress of the current year in seconds
  double _getYearProgress() {
    DateTime now = DateTime.now().toLocal(); // Local time with time zone
    DateTime startOfYear = DateTime(now.year, 1, 1); // Start of the year in local time
    DateTime endOfYear = DateTime(now.year + 1, 1, 1); // Start of next year in local time

    // Calculate the total number of seconds in the year
    int totalSecondsInYear = endOfYear.difference(startOfYear).inSeconds;

    // Calculate the number of seconds passed in the current year
    int secondsPassed = now.difference(startOfYear).inSeconds;

    // Return the ratio of seconds passed to total seconds, with 5 decimal precision
    return secondsPassed / totalSecondsInYear;
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
            const SizedBox(height: 30),

            // Year Progress Bar
            _buildYearProgressBar(context),
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

  // Year Progress Bar Widget
  Widget _buildYearProgressBar(BuildContext context) {
    // We will calculate the progress for the current year and format it to 5 decimal places
    double progress = _progress;

    return Column(
      children: [
        const Text(
          'Progress of the Year:',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black54,
            fontFamily: 'Poppins',
          ),
        ),
        const SizedBox(height: 10),
        Stack(
          children: [
            Container(
              height: 10,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: Colors.grey.shade300,
              ),
            ),
            AnimatedContainer(
              duration: const Duration(milliseconds: 500),
              height: 10,
              width: MediaQuery.of(context).size.width * progress, // Dynamic width
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                gradient: const LinearGradient(
                  colors: [Colors.blue, Colors.green],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Text(
          '${(progress * 100).toStringAsFixed(5)}% of the year has passed.',
          style: const TextStyle(
            fontSize: 14,
            color: Colors.black54,
            fontFamily: 'Poppins',
          ),
        ),
      ],
    );
  }
}
