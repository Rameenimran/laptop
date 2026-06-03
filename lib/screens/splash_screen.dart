// ════════════════════════════════════════════════════
// FILE: lib/screens/splash_screen.dart
// ════════════════════════════════════════════════════
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  late Animation<double> _screenFade;
  late Animation<double> _logoScale;
  late Animation<double> _textFade;
  late Animation<Offset> _textSlide;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    // Full screen fade in: 0.0 → 1.0
    _screenFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.6, curve: Curves.easeIn),
      ),
    );

    // Logo elastic scale: 0.3 → 1.0
    _logoScale = Tween<double>(begin: 0.3, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.65, curve: Curves.elasticOut),
      ),
    );

    // Text fade in
    _textFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.4, 0.85, curve: Curves.easeIn),
      ),
    );

    // Text slide up: Offset(0, 0.5) → Offset.zero
    _textSlide = Tween<Offset>(
      begin: const Offset(0, 0.5),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.4, 0.85, curve: Curves.easeOut),
      ),
    );

    _controller.forward();

    // Auto navigate after 3 seconds
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        Navigator.pushReplacementNamed(context, '/home');
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A237E),
      body: SafeArea(
        child: FadeTransition(
          opacity: _screenFade,
          child: Column(
            children: [
              // ── Center content ─────────────────────────
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // ── Logo circle ──────────────────────
                      ScaleTransition(
                        scale: _logoScale,
                        child: Container(
                          width: 130,
                          height: 130,
                          decoration: BoxDecoration(
                            color: const Color(0xFFFF6D00),
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFFFF6D00).withOpacity(0.55),
                                blurRadius: 35,
                                spreadRadius: 6,
                              ),
                              BoxShadow(
                                color: const Color(0xFFFF6D00).withOpacity(0.2),
                                blurRadius: 70,
                                spreadRadius: 18,
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.laptop_mac,
                            size: 64,
                            color: Colors.white,
                          ),
                        ),
                      ),

                      const SizedBox(height: 36),

                      // ── App name + underline + tagline ───
                      FadeTransition(
                        opacity: _textFade,
                        child: SlideTransition(
                          position: _textSlide,
                          child: Column(
                            children: [
                              // App name
                              const Text(
                                'LaptopHarbor',
                                style: TextStyle(
                                  fontSize: 36,
                                  fontWeight: FontWeight.w800,
                                  color: Colors.white,
                                  letterSpacing: 1.5,
                                ),
                              ),

                              // Orange underline decoration
                              const SizedBox(height: 6),
                              Container(
                                width: 60,
                                height: 3,
                                decoration: BoxDecoration(
                                  color: const Color(0xFFFF6D00),
                                  borderRadius: BorderRadius.circular(2),
                                ),
                              ),

                              const SizedBox(height: 14),

                              // Tagline
                              Text(
                                'Your laptop destination',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.white.withOpacity(0.6),
                                  letterSpacing: 0.4,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // ── Bottom section ──────────────────────────
              Padding(
                padding: const EdgeInsets.only(bottom: 32),
                child: FadeTransition(
                  opacity: _textFade,
                  child: Column(
                    children: [
                      // Bouncing dots
                      _BouncingDotsRow(parentController: _controller),

                      const SizedBox(height: 16),

                      // Loading text
                      Text(
                        'Loading...',
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.white.withOpacity(0.38),
                          letterSpacing: 0.5,
                        ),
                      ),

                      const SizedBox(height: 8),

                      // Version
                      Text(
                        'v1.0.0',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.white.withOpacity(0.24),
                          letterSpacing: 0.3,
                        ),
                      ),
                    ],
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

// ════════════════════════════════════════════════════
// BOUNCING DOTS ROW
// ════════════════════════════════════════════════════
class _BouncingDotsRow extends StatefulWidget {
  final AnimationController parentController;

  const _BouncingDotsRow({required this.parentController});

  @override
  State<_BouncingDotsRow> createState() => _BouncingDotsRowState();
}

class _BouncingDotsRowState extends State<_BouncingDotsRow>
    with SingleTickerProviderStateMixin {
  late AnimationController _bounceController;

  late Animation<double> _bounce1;
  late Animation<double> _bounce2;
  late Animation<double> _bounce3;

  @override
  void initState() {
    super.initState();

    _bounceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );

    // Staggered bounce offsets
    _bounce1 = Tween<double>(begin: 0.0, end: -10.0).animate(
      CurvedAnimation(
        parent: _bounceController,
        curve: const Interval(0.0, 0.6, curve: Curves.easeInOut),
      ),
    );
    _bounce2 = Tween<double>(begin: 0.0, end: -10.0).animate(
      CurvedAnimation(
        parent: _bounceController,
        curve: const Interval(0.2, 0.8, curve: Curves.easeInOut),
      ),
    );
    _bounce3 = Tween<double>(begin: 0.0, end: -10.0).animate(
      CurvedAnimation(
        parent: _bounceController,
        curve: const Interval(0.4, 1.0, curve: Curves.easeInOut),
      ),
    );

    // Start bouncing after parent animation completes
    widget.parentController.addStatusListener((status) {
      if (status == AnimationStatus.completed && mounted) {
        _bounceController.repeat(reverse: true);
      }
    });
  }

  @override
  void dispose() {
    _bounceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _bounceController,
      builder: (_, __) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _dot(_bounce1.value, const Color(0xFFFF6D00)),
            const SizedBox(width: 10),
            _dot(_bounce2.value, Colors.white),
            const SizedBox(width: 10),
            _dot(_bounce3.value, const Color(0xFFFF6D00)),
          ],
        );
      },
    );
  }

  Widget _dot(double offsetY, Color color) {
    return Transform.translate(
      offset: Offset(0, offsetY),
      child: Container(
        width: 10,
        height: 10,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.5),
              blurRadius: 6,
              spreadRadius: 1,
            ),
          ],
        ),
      ),
    );
  }
}
