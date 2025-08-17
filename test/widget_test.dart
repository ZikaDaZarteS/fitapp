// This is a basic Flutter widget test for FitApp.
//
// Simple test to verify basic widget functionality without Firebase dependencies.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fitapp/screens/login_screen.dart';

void main() {
  testWidgets('LoginScreen widget test', (WidgetTester tester) async {
    // Build the LoginScreen widget
    await tester.pumpWidget(
      const MaterialApp(
        home: LoginScreen(),
      ),
    );

    // Verify that the login screen loads
    expect(find.byType(LoginScreen), findsOneWidget);
    
    // Check for basic UI elements
    expect(find.byType(Scaffold), findsOneWidget);
    expect(find.byType(TextFormField), findsAtLeastNWidgets(2)); // Email and password fields
    expect(find.byType(ElevatedButton), findsAtLeastNWidgets(1)); // Login button
  });
  
  testWidgets('Basic widget creation test', (WidgetTester tester) async {
    // Test a simple widget creation
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          appBar: AppBar(title: const Text('Test')),
          body: const Center(
            child: Text('FitApp Test'),
          ),
        ),
      ),
    );

    // Verify the test widget
    expect(find.text('Test'), findsOneWidget);
    expect(find.text('FitApp Test'), findsOneWidget);
  });
}
