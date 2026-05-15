import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/di.dart';
import '../../theme/app_colors.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  double _opacity = 1.0;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 2), () {
      if (!mounted) return;
      setState(() => _opacity = 0.0);
    });
    Timer(const Duration(seconds: 3), _navigate);
  }

  Future<void> _navigate() async {
    if (!mounted) return;
    final hasToken = await Di.tokenStore.hasToken();
    if (!mounted) return;
    context.go(hasToken ? '/study' : '/login');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: AnimatedOpacity(
        opacity: _opacity,
        duration: const Duration(milliseconds: 800),
        curve: Curves.easeIn,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: AppColors.baliHai30,
                  border: Border.all(color: AppColors.morandiText, width: 3),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: const [
                    BoxShadow(color: AppColors.morandiText, offset: Offset(4, 4), blurRadius: 0),
                  ],
                ),
                child: const Icon(Icons.school, size: 40, color: AppColors.morandiText),
              ),
              const SizedBox(height: 24),
              const Text('JIN NANG',
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.w900,
                      color: AppColors.morandiText, letterSpacing: 2)),
              const SizedBox(height: 8),
              Text('Learn Chinese, the fun way',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700,
                      color: AppColors.morandiText.withValues(alpha: 0.6))),
            ],
          ),
        ),
      ),
    );
  }
}
