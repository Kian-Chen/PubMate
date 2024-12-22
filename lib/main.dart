import 'package:flutter/material.dart';
import 'package:pubmate/auth/auth_gate.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// Import all pages
import 'package:pubmate/pages/home_page.dart';
import 'package:pubmate/pages/conference_deadlines_page.dart';
import 'package:pubmate/pages/journals_page.dart';
import 'package:pubmate/pages/g2r_conferences_page.dart';
import 'package:pubmate/pages/g2r_journals_page.dart';
import 'package:pubmate/pages/conference_details_page.dart';
import 'package:pubmate/pages/journal_details_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Supabase
  await Supabase.initialize(
    url: "https://ryfposkyegzkgyjevyqp.supabase.co",
    anonKey:
    'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InJ5ZnBvc2t5ZWd6a2d5amV2eXFwIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MzQ2MjgyMTIsImV4cCI6MjA1MDIwNDIxMn0.qbnjWnyjhTMDoH3e8c9I5FfhxTk4TbPzyyAMUFgNRn8',
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PubMate',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const AuthGate(),
      // Define named routes
      routes: {
        '/home': (context) => const HomePage(),
        '/conference_deadlines': (context) => const ConferenceDeadlinesPage(),
        '/journals': (context) => const JournalsPage(),
        '/g2r_conferences': (context) => const G2RConferencesPage(),
        '/g2r_journals': (context) => const G2RJournalsPage(),
      },
      // Handle routes with parameters
      onGenerateRoute: (settings) {
        if (settings.name == '/conference_details') {
          if (settings.arguments != null &&
              settings.arguments is Map<String, dynamic> &&
              (settings.arguments as Map<String, dynamic>).containsKey('id')) {
            final args = settings.arguments as Map<String, dynamic>;
            final id = args['id'];
            if (id is int) {
              return MaterialPageRoute(
                builder: (context) => ConferenceDetailsPage(id: id),
              );
            } else {
              // Handle incorrect type
              return _errorRoute('Invalid type for id. Expected int.');
            }
          } else {
            // Handle missing arguments
            return _errorRoute('No id provided for Conference Details.');
          }
        } else if (settings.name == '/journal_details') {
          if (settings.arguments != null &&
              settings.arguments is Map<String, dynamic> &&
              (settings.arguments as Map<String, dynamic>).containsKey('id')) {
            final args = settings.arguments as Map<String, dynamic>;
            final id = args['id'];
            if (id is int) {
              return MaterialPageRoute(
                builder: (context) => JournalDetailsPage(id: id),
              );
            } else {
              // Handle incorrect type
              return _errorRoute('Invalid type for id. Expected int.');
            }
          } else {
            // Handle missing arguments
            return _errorRoute('No id provided for Journal Details.');
          }
        }
        // Unknown route
        return MaterialPageRoute(
          builder: (context) => const Scaffold(
            body: Center(child: Text('Page not found')),
          ),
        );
      },
    );
  }

  // Helper method to create an error route
  Route<dynamic> _errorRoute(String message) {
    return MaterialPageRoute(
      builder: (context) => Scaffold(
        appBar: AppBar(title: const Text('Error')),
        body: Center(
          child: Text(
            message,
            style: const TextStyle(fontSize: 18, color: Colors.red),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
