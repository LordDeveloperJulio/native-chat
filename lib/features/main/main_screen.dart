import 'package:flutter/material.dart';

import '../chat/chat_screen.dart';
import '../flashcards/flashcard_screen.dart';
import '../home/home_screen.dart';
import '../paywall/paywall_screen.dart';
import '../progress/progress_screen.dart';
import '../../shared/widgets/app_bottom_nav.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  static const List<Widget> _screens = [
    HomeScreen(),
    ChatScreen(),
    FlashcardScreen(),
    ProgressScreen(),
    PaywallScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: AppBottomNav(
        currentIndex: _currentIndex,
        onTap: (i) => setState(() => _currentIndex = i),
      ),
    );
  }
}
