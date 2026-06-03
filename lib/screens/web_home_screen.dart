// ════════════════════════════════════════════════════
// FILE: lib/screens/web_home_screen.dart
// LaptopHarbor — Flutter Web Home Page
// ════════════════════════════════════════════════════
import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../widgets/navbar.dart';
import '../widgets/hero_section.dart';
import '../widgets/category_section.dart';
import '../widgets/featured_products.dart';
import '../widgets/brands_section.dart';
import '../widgets/features_section.dart';
import '../widgets/newsletter_section.dart';
import '../widgets/footer.dart';

class WebHomeScreen extends StatefulWidget {
  const WebHomeScreen({super.key});

  @override
  State<WebHomeScreen> createState() => _WebHomeScreenState();
}

class _WebHomeScreenState extends State<WebHomeScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          // ── Sticky NavBar ──────────────────────────
          NavBar(scrollController: _scrollController),

          // ── Scrollable content ─────────────────────
          Expanded(
            child: SingleChildScrollView(
              controller: _scrollController,
              child: Column(
                children: const [
                  HeroSection(),
                  CategorySection(),
                  FeaturedProducts(),
                  BrandsSection(),
                  FeaturesSection(),
                  NewsletterSection(),
                  Footer(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
