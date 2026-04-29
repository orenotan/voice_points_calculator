// lib/nav/nav.dart

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

// Layout and Screens
import 'package:vpc/nav/main_layout.dart';
// Adjust the import path and class name for your root screen as needed for the new project
import 'package:vpc/screens/landing/landing_screen.dart'; 

// --- HELPER FOR INSTANT TRANSITION ---
Page<void> _buildInstantPage(BuildContext context, GoRouterState state, Widget child) {
  return CustomTransitionPage<void>(
    key: state.pageKey,
    child: child,
    transitionDuration: Duration.zero, 
    reverseTransitionDuration: Duration.zero,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      return child; 
    },
  );
}

final goRouter = GoRouter(
  initialLocation: '/',
  // Error builder removed to keep it barebones, GoRouter will provide a default one
  routes: [
    // SHELL ROUTE (Persistent Layout)
    ShellRoute(
      builder: (context, state, child) {
        return SelectionArea(child: MainLayout(child: child));
      },
      routes: [
        GoRoute(
          path: '/',
          pageBuilder: (context, state) => _buildInstantPage(
            context, 
            state, 
            const LandingPage() // Replace with your actual home/landing widget
          ),
        ),
        // Add your new screens here later
      ],
    ),
  ],
);