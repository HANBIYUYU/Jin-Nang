import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

import 'theme/app_theme.dart';
import 'features/shell/main_shell.dart';
import 'features/home/home_screen.dart';
import 'features/toolbox/toolbox_screen.dart';
import 'features/profile/profile_screen.dart';
import 'features/vocab/vocab_learning_screen.dart';
import 'features/vocab/vocab_card_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(const MyApp());
}

final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorStudyKey = GlobalKey<NavigatorState>(debugLabel: 'study');
final _shellNavigatorToolboxKey = GlobalKey<NavigatorState>(debugLabel: 'toolbox');
final _shellNavigatorMeKey = GlobalKey<NavigatorState>(debugLabel: 'me');

final GoRouter _router = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: '/study',
  routes: [
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        return MainShell(navigationShell: navigationShell);
      },
      branches: [
        StatefulShellBranch(
          navigatorKey: _shellNavigatorStudyKey,
          routes: [
            GoRoute(
              path: '/study',
              builder: (context, state) => const HomeScreen(),
            ),
          ],
        ),
        StatefulShellBranch(
          navigatorKey: _shellNavigatorToolboxKey,
          routes: [
            GoRoute(
              path: '/toolbox',
              builder: (context, state) => const ToolboxScreen(),
              routes: [
                GoRoute(
                  path: 'vocab-learning',
                  builder: (context, state) => const VocabLearningScreen(),
                ),
                GoRoute(
                  path: 'vocab-card',
                  builder: (context, state) => const VocabCardScreen(),
                ),
              ],
            ),
          ],
        ),
        StatefulShellBranch(
          navigatorKey: _shellNavigatorMeKey,
          routes: [
            GoRoute(
              path: '/me',
              builder: (context, state) => const ProfileScreen(),
            ),
          ],
        ),
      ],
    ),
  ],
);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Jin Nang',
      theme: AppTheme.lightTheme,
      routerConfig: _router,
    );
  }
}