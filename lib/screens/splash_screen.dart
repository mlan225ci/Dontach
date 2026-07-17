import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

import '../theme/app_colors.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with TickerProviderStateMixin {
  late final AnimationController _rippleController;
  late final AnimationController _revealController;
  late final Animation<double> _logoFade;
  late final Animation<double> _logoScale;

  static const _logoSize = 132.0;

  @override
  void initState() {
    super.initState();

    _rippleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2400),
    )..repeat();

    _revealController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..forward();

    _logoFade = CurvedAnimation(parent: _revealController, curve: Curves.easeOut);
    _logoScale = Tween<double>(begin: 0.88, end: 1.0).animate(
      CurvedAnimation(parent: _revealController, curve: Curves.easeOutCubic),
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      FlutterNativeSplash.remove();
    });
  }

  @override
  void dispose() {
    _rippleController.dispose();
    _revealController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.brandGreen,
      body: Center(
        child: SizedBox(
          width: 280,
          height: 280,
          child: Stack(
            alignment: Alignment.center,
            children: [
              AnimatedBuilder(
                animation: _rippleController,
                builder: (context, _) {
                  return Stack(
                    alignment: Alignment.center,
                    children: [
                      _RippleRing(phase: _rippleController.value),
                      _RippleRing(phase: (_rippleController.value + 0.33) % 1.0),
                      _RippleRing(phase: (_rippleController.value + 0.66) % 1.0),
                    ],
                  );
                },
              ),
              FadeTransition(
                opacity: _logoFade,
                child: ScaleTransition(
                  scale: _logoScale,
                  child: Container(
                    width: _logoSize,
                    height: _logoSize,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.28),
                          blurRadius: 20,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: ClipOval(
                      child: Image.asset(
                        'assets/branding/app_icon.png',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _RippleRing extends StatelessWidget {
  const _RippleRing({required this.phase});

  final double phase;

  @override
  Widget build(BuildContext context) {
    final scale = 0.55 + phase * 1.1;
    final opacity = (1.0 - phase) * 0.35;

    return Transform.scale(
      scale: scale,
      child: Container(
        width: 160,
        height: 160,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: Colors.white.withValues(alpha: opacity.clamp(0.0, 1.0)),
            width: 2,
          ),
        ),
      ),
    );
  }
}
