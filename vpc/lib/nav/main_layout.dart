// lib/nav/main_layout.dart

import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

// Adjust this import based on your new project structure
import 'package:vpc/main.dart'; // Assumed to hold ThemeProvider

class MainLayout extends StatefulWidget {
  const MainLayout({super.key, required this.child});
  final Widget child;

  @override
  MainLayoutState createState() => MainLayoutState();
}

class MainLayoutState extends State<MainLayout> {
  bool _isScrolled = false;

  Future<void> _updateUserTheme(ThemeMode mode) async {
    final themeProvider = ThemeProvider.of(context);
    themeProvider?.changeThemeMode(mode);
    // Add local storage logic here later (e.g., SharedPreferences) if you want to persist it
  }

  @override
  Widget build(BuildContext context) {
    final currentPath = GoRouter.of(context).routeInformationProvider.value.uri.path;
    final bool isLandingPage = currentPath == '/';

    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    
    // Adjust colors dynamically based on scroll position and page
    final Color textColor = (isLandingPage && !_isScrolled) 
        ? Colors.white 
        : colorScheme.onSurface;

    final Color iconColor = (isLandingPage && !_isScrolled)
        ? Colors.white70 
        : colorScheme.onSurface.withValues(alpha: 0.7);

     return Scaffold(
      extendBodyBehindAppBar: true, 
      backgroundColor: theme.scaffoldBackgroundColor, 
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(70),
        child: _buildGlassAppBar(context, theme, textColor, iconColor),
      ),
      // Drawer removed entirely
      
      body: NotificationListener<ScrollNotification>(
        onNotification: (notification) {
          if (notification is ScrollUpdateNotification && notification.metrics.axis == Axis.vertical) {
            final isScrolled = notification.metrics.pixels > 20;
            if (isScrolled != _isScrolled) setState(() => _isScrolled = isScrolled);
          }
          return false;
        },
        child: widget.child, 
      ),
    );
  }

  Widget _buildGlassAppBar(BuildContext context, ThemeData theme, Color textColor, Color iconColor) {
    return ClipRRect(
      child: BackdropFilter(
        filter: ui.ImageFilter.blur(sigmaX: _isScrolled ? 15.0 : 0.0, sigmaY: _isScrolled ? 15.0 : 0.0),
        child: Container(
          decoration: BoxDecoration(
            color: _isScrolled ? theme.colorScheme.surface.withValues(alpha: 0.85) : Colors.transparent,
            border: _isScrolled ? Border(bottom: BorderSide(color: theme.dividerColor.withValues(alpha: 0.1))) : null,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          alignment: Alignment.center,
          child: SafeArea(
            bottom: false,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Left Side: Brand/Logo
                InkWell(
                  onTap: () => context.go('/'),
                  child: Text(
                    'Ojama', 
                    style: GoogleFonts.inter(
                      textStyle: TextStyle(color: textColor, fontSize: 20, fontWeight: FontWeight.bold, letterSpacing: -0.5)
                    ),
                  ),
                ),
                
                // Middle: Always-visible Navigation Links
                Row(
                  children: [
                    _NavTextButton(label: 'Home', route: '/', color: textColor),
                    // Add new routes here as your project grows, they will display side-by-side
                  ],
                ),

                // Right Side: Settings
                Row(
                  children: [
                    _buildSettingsSection(context, theme, textColor),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSettingsSection(BuildContext context, ThemeData theme, Color textColor) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(30),
      child: BackdropFilter(
        filter: ui.ImageFilter.blur(sigmaX: 5, sigmaY: 5),
        child: Container(
          decoration: BoxDecoration(
            color: textColor.withValues(alpha: 0.1), 
            borderRadius: BorderRadius.circular(30),
            border: Border.all(color: textColor.withValues(alpha: 0.2), width: 0.5),
          ),
          child: PopupMenuButton<String>(
            tooltip: 'Settings',
            color: theme.colorScheme.surface,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            offset: const Offset(0, 45),
            itemBuilder: (context) => [
              PopupMenuItem(
                child: const Text('Theme'), 
                onTap: () => Future.delayed(Duration.zero, () { if (context.mounted) _showThemeDialog(context, theme); })
              ),
            ],
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
              child: Icon(Icons.settings, size: 20, color: textColor),
            ),
          ),
        ),
      ),
    );
  }

  void _showThemeDialog(BuildContext context, ThemeData theme) {
    showDialog(context: context, builder: (dialogContext) => AlertDialog(
      backgroundColor: theme.colorScheme.surface,
      title: const Text('Select Theme'),
      content: Column(mainAxisSize: MainAxisSize.min, children: [
        ListTile(title: const Text('Light'), onTap: () { Navigator.pop(dialogContext); _updateUserTheme(ThemeMode.light); }),
        ListTile(title: const Text('Dark'), onTap: () { Navigator.pop(dialogContext); _updateUserTheme(ThemeMode.dark); }),
        ListTile(title: const Text('System'), onTap: () { Navigator.pop(dialogContext); _updateUserTheme(ThemeMode.system); }),
      ]),
    ));
  }
}

class _NavTextButton extends StatelessWidget {
  final String label;
  final String route;
  final Color color;

  const _NavTextButton({required this.label, required this.route, required this.color});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () => context.go(route), 
      child: Text(label, style: TextStyle(color: color, fontWeight: FontWeight.w600))
    );
  }
}