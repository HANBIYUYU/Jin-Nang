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
import 'features/home/vocab_learning/vocab_scene_screen.dart';
import 'features/home/vocab_learning/vocab_learning_screen.dart';
import 'features/toolbox/toolbox_card.dart';
import 'features/home/dialogue/dialogue_practice_screen.dart';
import 'features/home/dialogue/level_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  SystemChannels.textInput.invokeMethod('TextInput.hide');
  runApp(const MyApp());
}

final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorStudyKey = GlobalKey<NavigatorState>(debugLabel: 'study');
final _shellNavigatorToolboxKey = GlobalKey<NavigatorState>(debugLabel: 'toolbox');
final _shellNavigatorMeKey = GlobalKey<NavigatorState>(debugLabel: 'me');

/// 卡片式右滑转场（进入时从右侧滑入，返回时向右滑出）
CustomTransitionPage<T> _slidePage<T>({required Widget child}) {
  return CustomTransitionPage<T>(
    child: child,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      const begin = Offset(1.0, 0.0);
      const end = Offset.zero;
      const curve = Curves.easeInOut;

      final tween = Tween(begin: begin, end: end)
          .chain(CurveTween(curve: curve));
      final offsetAnimation = animation.drive(tween);

      return SlideTransition(
        position: offsetAnimation,
        child: child,
      );
    },
  );
}

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
              routes: [
                // 场景选择页
                GoRoute(
                  path: 'vocab-scene',
                  pageBuilder: (context, state) => _slidePage(child: const VocabSceneScreen()),
                ),
                // 词汇学习页（6张卡片）
                GoRoute(
                  path: 'vocab-learning',
                  pageBuilder: (context, state) => _slidePage(child: const VocabLearningScreen()),
                ),
                // 对话练习（关卡列表）
                GoRoute(
                  path: 'dialogue-practice',
                  pageBuilder: (context, state) => _slidePage(child: const DialoguePracticeScreen()),
                ),
                // 具体关卡（带参数）
                GoRoute(
                  path: 'level/:levelId',
                  pageBuilder: (context, state) {
                    final levelId = int.parse(state.pathParameters['levelId']!);
                    return _slidePage(child: LevelScreen(levelId: levelId));
                  },
                ),
              ],
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
                // 句子页（Toolbox → Restaurant）
                GoRoute(
                  path: 'vocab-card',
                  pageBuilder: (context, state) => _slidePage(child: const ToolboxCard()),
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
