import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants/app_colors.dart';

class BrandsSection extends StatelessWidget {
  const BrandsSection({super.key});

  static const List<Map<String, dynamic>> _brands = [
    {'name': 'Dell',   'icon': Icons.laptop_mac},
    {'name': 'HP',     'icon': Icons.laptop},
    {'name': 'Apple',  'icon': Icons.apple},
    {'name': 'Lenovo', 'icon': Icons.laptop_chromebook},
    {'name': 'ASUS',   'icon': Icons.computer},
    {'name': 'Acer',   'icon': Icons.laptop_mac},
    {'name': 'MSI',    'icon': Icons.sports_esports},
  ];

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final isMobile = w < 768;

    return Container(
      color: AppColors.background,
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 24 : 80,
        vertical: 56,
      ),
      child: Column(
        children: [
          Text(
            'Top Brands',
            style: GoogleFonts.poppins(
              color: AppColors.textPrimary,
              fontSize: 28,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Shop from the world\'s leading laptop manufacturers',
            style: GoogleFonts.inter(color: AppColors.textMuted, fontSize: 14),
          ),
          const SizedBox(height: 36),
          isMobile
              ? Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  alignment: WrapAlignment.center,
                  children: _brands.map((b) => _BrandChip(brand: b)).toList(),
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: _brands.map((b) => _BrandChip(brand: b)).toList(),
                ),
        ],
      ),
    );
  }
}

class _BrandChip extends StatefulWidget {
  final Map<String, dynamic> brand;
  const _BrandChip({required this.brand});

  @override
  State<_BrandChip> createState() => _BrandChipState();
}

class _BrandChipState extends State<_BrandChip> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit:  (_) => setState(() => _hovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        decoration: BoxDecoration(
          color: _hovered ? AppColors.accentGlow : AppColors.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: _hovered ? AppColors.accent.withOpacity(0.4) : AppColors.border,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              widget.brand['icon'] as IconData,
              size: 20,
              color: _hovered ? AppColors.accent : AppColors.textMuted,
            ),
            const SizedBox(width: 8),
            Text(
              widget.brand['name'] as String,
              style: GoogleFonts.inter(
                color: _hovered ? AppColors.accent : AppColors.textMuted,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
