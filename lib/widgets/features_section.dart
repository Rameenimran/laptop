import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants/app_colors.dart';

class FeaturesSection extends StatelessWidget {
  const FeaturesSection({super.key});

  static const List<Map<String, dynamic>> _features = [
    {
      'icon':  Icons.local_shipping_outlined,
      'color': Color(0xFF3B82F6),
      'title': 'Free Shipping',
      'desc':  'Free delivery on all orders above \$500. Fast and reliable.',
    },
    {
      'icon':  Icons.lock_outline,
      'color': Color(0xFF22C55E),
      'title': 'Secure Payment',
      'desc':  '100% secure transactions with SSL encryption and fraud protection.',
    },
    {
      'icon':  Icons.replay_outlined,
      'color': Color(0xFFF59E0B),
      'title': 'Easy Returns',
      'desc':  '30-day hassle-free return policy. No questions asked.',
    },
    {
      'icon':  Icons.headset_mic_outlined,
      'color': Color(0xFFA855F7),
      'title': '24/7 Support',
      'desc':  'Round-the-clock customer support via chat, email, and phone.',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final isMobile = w < 768;

    return Container(
      color: AppColors.surfaceAlt,
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 24 : 80,
        vertical: 64,
      ),
      child: Column(
        children: [
          Text(
            'Why Choose Us?',
            style: GoogleFonts.poppins(
              color: AppColors.textPrimary,
              fontSize: 28,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'We make laptop shopping easy, safe, and affordable',
            style: GoogleFonts.inter(color: AppColors.textMuted, fontSize: 14),
          ),
          const SizedBox(height: 40),
          isMobile
              ? Column(
                  children: _features
                      .map((f) => Padding(
                            padding: const EdgeInsets.only(bottom: 16),
                            child: _FeatureCard(feature: f),
                          ))
                      .toList(),
                )
              : Row(
                  children: _features
                      .map((f) => Expanded(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 8),
                              child: _FeatureCard(feature: f),
                            ),
                          ))
                      .toList(),
                ),
        ],
      ),
    );
  }
}

class _FeatureCard extends StatefulWidget {
  final Map<String, dynamic> feature;
  const _FeatureCard({required this.feature});

  @override
  State<_FeatureCard> createState() => _FeatureCardState();
}

class _FeatureCardState extends State<_FeatureCard> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final color = widget.feature['color'] as Color;
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit:  (_) => setState(() => _hovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: _hovered ? AppColors.surface : AppColors.background,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: _hovered ? color.withOpacity(0.4) : AppColors.border,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 52, height: 52,
              decoration: BoxDecoration(
                color: color.withOpacity(0.12),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(widget.feature['icon'] as IconData, color: color, size: 26),
            ),
            const SizedBox(height: 18),
            Text(
              widget.feature['title'] as String,
              style: GoogleFonts.poppins(
                color: AppColors.textPrimary,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              widget.feature['desc'] as String,
              style: GoogleFonts.inter(
                color: AppColors.textMuted,
                fontSize: 13,
                height: 1.6,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
