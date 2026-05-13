import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

import 'theme/app_theme.dart';
import 'features/shell/main_shell.dart';
import 'features/auth/splash_screen.dart';
import 'features/auth/login_screen.dart';
import 'features/auth/register_screen.dart';
import 'features/home/home_screen.dart';
import 'features/toolbox/toolbox_screen.dart';
import 'features/profile/profile_screen.dart';
import 'features/vocab/vocab_learning_screen.dart';
import 'features/vocab/vocab_card_screen.dart';
import 'features/dialogue/dialogue_practice_screen.dart';
import 'features/dialogue/level_screen.dart';

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
  initialLocation: '/splash',
  routes: [
    // 启动页（全屏，无底部导航）
    GoRoute(
      path: '/splash',
      builder: (context, state) => const SplashScreen(),
    ),
    // 登录页（全屏，无底部导航）
    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginScreen(),
    ),
    // 注册页（全屏，无底部导航）
    GoRoute(
      path: '/register',
      builder: (context, state) => const RegisterScreen(),
    ),
    // 主壳（底部导航 Tab）
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        return MainShell(navigationShell: navigationShell);
      },
      branches: [
        // Study Tab
        StatefulShellBranch(
          navigatorKey: _shellNavigatorStudyKey,
          routes: [
            GoRoute(
              path: '/study',
              builder: (context, state) => const HomeScreen(),
            ),
          ],
        ),
        // Toolbox Tab
        StatefulShellBranch(
          navigatorKey: _shellNavigatorToolboxKey,
          routes: [
            GoRoute(
              path: '/toolbox',
              builder: (context, state) => const ToolboxScreen(),
              routes: [
                // 词汇学习场景选择
                GoRoute(
                  path: 'vocab-learning',
                  builder: (context, state) => const VocabLearningScreen(),
                ),
                // 词汇卡片详情
                GoRoute(
                  path: 'vocab-card',
                  builder: (context, state) => const VocabCardScreen(),
                ),
                // 对话练习（关卡列表）
                GoRoute(
                  path: 'dialogue-practice',
                  builder: (context, state) => const DialoguePracticeScreen(),
                ),
                // 具体关卡（带参数）
                GoRoute(
                  path: 'level/:levelId',
                  builder: (context, state) {
                    final levelId = int.parse(state.pathParameters['levelId']!);
                    return LevelScreen(levelId: levelId);
                  },
                ),
              ],
            ),
          ],
        ),
        // My Tab
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
