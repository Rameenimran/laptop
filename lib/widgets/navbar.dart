import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants/app_colors.dart';

class NavBar extends StatefulWidget {
  final ScrollController scrollController;
  const NavBar({super.key, required this.scrollController});

  @override
  State<NavBar> createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  int _cartCount  = 2;
  int _hoveredNav = -1;

  final List<String> _navLinks = ['Home', 'Products', 'Brands', 'Deals', 'About'];

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final isMobile = w < 768;

    return Container(
      height: 70,
      decoration: const BoxDecoration(
        color: AppColors.background,
        border: Border(
          bottom: BorderSide(color: AppColors.navBorder, width: 1),
        ),
      ),
      padding: EdgeInsets.symmetric(horizontal: isMobile ? 20 : 60),
      child: Row(
        children: [
          // ── Logo ──────────────────────────────────
          Row(
            children: [
              Container(
                width: 36, height: 36,
                decoration: BoxDecoration(
                  color: AppColors.accent,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.laptop_mac, color: Colors.white, size: 20),
              ),
              const SizedBox(width: 10),
              Text(
                'LaptopHarbor',
                style: GoogleFonts.poppins(
                  color: AppColors.textPrimary,
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),

          const Spacer(),

          // ── Nav links (desktop only) ──────────────
          if (!isMobile)
            Row(
              children: List.generate(_navLinks.length, (i) {
                return MouseRegion(
                  onEnter: (_) => setState(() => _hoveredNav = i),
                  onExit:  (_) => setState(() => _hoveredNav = -1),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      _navLinks[i],
                      style: GoogleFonts.inter(
                        color: _hoveredNav == i
                            ? AppColors.accent
                            : AppColors.textMuted,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                );
              }),
            ),

          const Spacer(),

          // ── Right icons ───────────────────────────
          Row(
            children: [
              _NavIcon(icon: Icons.search, onTap: () {}),
              const SizedBox(width: 4),
              _NavIcon(icon: Icons.favorite_outline, onTap: () {}),
              const SizedBox(width: 4),
              // Cart with badge
              Stack(
                children: [
                  _NavIcon(icon: Icons.shopping_cart_outlined, onTap: () {}),
                  if (_cartCount > 0)
                    Positioned(
                      top: 2, right: 2,
                      child: Container(
                        width: 16, height: 16,
                        decoration: const BoxDecoration(
                          color: AppColors.accent,
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Text(
                            '$_cartCount',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 9,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(width: 12),
              // Login button
              if (!isMobile)
                OutlinedButton(
                  onPressed: () {},
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.accent,
                    side: const BorderSide(color: AppColors.accent),
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    'Login',
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _NavIcon extends StatefulWidget {
  final IconData icon;
  final VoidCallback onTap;
  const _NavIcon({required this.icon, required this.onTap});

  @override
  State<_NavIcon> createState() => _NavIconState();
}

class _NavIconState extends State<_NavIcon> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit:  (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: Container(
          width: 38, height: 38,
          decoration: BoxDecoration(
            color: _hovered ? AppColors.accentGlow : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            widget.icon,
            color: _hovered ? AppColors.accent : AppColors.textMuted,
            size: 20,
          ),
        ),
      ),
    );
  }
}
