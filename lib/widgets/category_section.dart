import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants/app_colors.dart';

class CategorySection extends StatelessWidget {
  const CategorySection({super.key});

  static const List<Map<String, dynamic>> _cats = [
    {'label': 'Gaming',      'icon': Icons.sports_esports,    'color': Color(0xFFEF4444)},
    {'label': 'Business',    'icon': Icons.business_center,   'color': Color(0xFF3B82F6)},
    {'label': 'Student',     'icon': Icons.school,            'color': Color(0xFF22C55E)},
    {'label': 'Ultra-thin',  'icon': Icons.devices_other,     'color': Color(0xFFA855F7)},
    {'label': 'Workstation', 'icon': Icons.computer,          'color': Color(0xFFF59E0B)},
    {'label': 'Budget',      'icon': Icons.savings,           'color': Color(0xFF06B6D4)},
  ];

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final isMobile = w < 768;

    return Container(
      color: AppColors.background,
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 24 : 80,
        vertical: 64,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SectionHeader(title: 'Shop by Category'),
          const SizedBox(height: 36),
          isMobile
              ? GridView.count(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: 3,
                  mainAxisSpacing: 14,
                  crossAxisSpacing: 14,
                  childAspectRatio: 1.0,
                  children: _cats.map((c) => _CategoryCard(cat: c)).toList(),
                )
              : Row(
                  children: _cats
                      .map((c) => Expanded(child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 7),
                            child: _CategoryCard(cat: c),
                          )))
                      .toList(),
                ),
        ],
      ),
    );
  }
}

class _CategoryCard extends StatefulWidget {
  final Map<String, dynamic> cat;
  const _CategoryCard({required this.cat});

  @override
  State<_CategoryCard> createState() => _CategoryCardState();
}

class _CategoryCardState extends State<_CategoryCard> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final color = widget.cat['color'] as Color;
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit:  (_) => setState(() => _hovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 16),
        decoration: BoxDecoration(
          color: _hovered ? color.withOpacity(0.12) : AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: _hovered ? color.withOpacity(0.5) : AppColors.border,
            width: 1.5,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 52, height: 52,
              decoration: BoxDecoration(
                color: color.withOpacity(0.15),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(widget.cat['icon'] as IconData, color: color, size: 26),
            ),
            const SizedBox(height: 14),
            Text(
              widget.cat['label'] as String,
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                color: _hovered ? AppColors.textPrimary : AppColors.textMuted,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Shared section header ─────────────────────────
class _SectionHeader extends StatelessWidget {
  final String title;
  final String? actionLabel;
  final VoidCallback? onAction;

  const _SectionHeader({required this.title, this.actionLabel, this.onAction});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: GoogleFonts.poppins(
                color: AppColors.textPrimary,
                fontSize: 28,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 6),
            Container(
              width: 48, height: 3,
              decoration: BoxDecoration(
                color: AppColors.accent,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ],
        ),
        if (actionLabel != null)
          TextButton(
            onPressed: onAction,
            child: Text(
              actionLabel!,
              style: GoogleFonts.inter(
                color: AppColors.accent,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
      ],
    );
  }
}
