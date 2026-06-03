import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants/app_colors.dart';

class FeaturedProducts extends StatelessWidget {
  const FeaturedProducts({super.key});

  static const List<Map<String, dynamic>> _products = [
    {
      'name':   'Dell XPS 15',
      'brand':  'Dell',
      'price':  1299,
      'rating': 4.8,
      'reviews': 120,
      'badge':  'HOT',
      'badgeColor': AppColors.badgeRed,
      'image':  'https://images.unsplash.com/photo-1593642632559-0c6d3fc62b89?w=400',
    },
    {
      'name':   'MacBook Pro M3',
      'brand':  'Apple',
      'price':  1999,
      'rating': 4.9,
      'reviews': 89,
      'badge':  null,
      'image':  'https://images.unsplash.com/photo-1517336714731-489689fd1ca8?w=400',
    },
    {
      'name':   'ASUS ROG Strix',
      'brand':  'ASUS',
      'price':  1799,
      'rating': 4.9,
      'reviews': 74,
      'badge':  'SALE',
      'badgeColor': AppColors.badgeGreen,
      'image':  'https://images.unsplash.com/photo-1603302576837-37561b2e2302?w=400',
    },
    {
      'name':   'Lenovo ThinkPad X1',
      'brand':  'Lenovo',
      'price':  1099,
      'rating': 4.7,
      'reviews': 95,
      'badge':  null,
      'image':  'https://images.unsplash.com/photo-1496181133206-80ce9b88a853?w=400',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final isMobile = w < 768;
    final isTablet = w < 1100;
    final cols = isMobile ? 2 : (isTablet ? 2 : 4);

    return Container(
      color: AppColors.surfaceAlt,
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 24 : 80,
        vertical: 64,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SectionHeader(
            title: 'Featured Laptops',
            actionLabel: 'View All →',
            onAction: () {},
          ),
          const SizedBox(height: 36),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _products.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: cols,
              mainAxisSpacing: 20,
              crossAxisSpacing: 20,
              childAspectRatio: isMobile ? 0.62 : 0.68,
            ),
            itemBuilder: (_, i) => _ProductCard(product: _products[i]),
          ),
        ],
      ),
    );
  }
}

class _ProductCard extends StatefulWidget {
  final Map<String, dynamic> product;
  const _ProductCard({required this.product});

  @override
  State<_ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<_ProductCard> {
  bool _hovered    = false;
  bool _wishlisted = false;

  @override
  Widget build(BuildContext context) {
    final p = widget.product;
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit:  (_) => setState(() => _hovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: _hovered ? AppColors.accent.withOpacity(0.4) : AppColors.border,
          ),
          boxShadow: _hovered
              ? [BoxShadow(color: AppColors.accent.withOpacity(0.12), blurRadius: 24, offset: const Offset(0, 8))]
              : [],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Image ──────────────────────────────
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(16), topRight: Radius.circular(16),
                  ),
                  child: Image.network(
                    p['image'] as String,
                    height: 180,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      height: 180,
                      color: AppColors.surfaceAlt,
                      child: const Center(
                        child: Icon(Icons.laptop_mac, size: 60, color: AppColors.accent),
                      ),
                    ),
                    loadingBuilder: (_, child, progress) {
                      if (progress == null) return child;
                      return Container(
                        height: 180,
                        color: AppColors.surfaceAlt,
                        child: const Center(
                          child: CircularProgressIndicator(color: AppColors.accent, strokeWidth: 2),
                        ),
                      );
                    },
                  ),
                ),
                // Badge
                if (p['badge'] != null)
                  Positioned(
                    top: 10, left: 10,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: p['badgeColor'] as Color,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        p['badge'] as String,
                        style: GoogleFonts.inter(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                  ),
                // Wishlist
                Positioned(
                  top: 8, right: 8,
                  child: GestureDetector(
                    onTap: () => setState(() => _wishlisted = !_wishlisted),
                    child: Container(
                      width: 32, height: 32,
                      decoration: BoxDecoration(
                        color: AppColors.surface.withOpacity(0.9),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        _wishlisted ? Icons.favorite : Icons.favorite_outline,
                        size: 16,
                        color: _wishlisted ? Colors.red : AppColors.textMuted,
                      ),
                    ),
                  ),
                ),
              ],
            ),

            // ── Info ───────────────────────────────
            Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    p['brand'] as String,
                    style: GoogleFonts.inter(color: AppColors.textMuted, fontSize: 11),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    p['name'] as String,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.inter(
                      color: AppColors.textPrimary,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  // Stars
                  Row(
                    children: [
                      ...List.generate(5, (i) => Icon(
                        i < (p['rating'] as double).floor()
                            ? Icons.star
                            : Icons.star_border,
                        size: 13,
                        color: AppColors.star,
                      )),
                      const SizedBox(width: 6),
                      Text(
                        '${p['rating']} (${p['reviews']})',
                        style: GoogleFonts.inter(color: AppColors.textMuted, fontSize: 11),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '\$${p['price']}',
                        style: GoogleFonts.poppins(
                          color: AppColors.accent,
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.accent,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                          minimumSize: Size.zero,
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          elevation: 0,
                        ),
                        child: Text(
                          'Add to Cart',
                          style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Shared section header (reused) ───────────────
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
