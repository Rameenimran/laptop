import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants/app_colors.dart';

class Footer extends StatelessWidget {
  const Footer({super.key});

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final isMobile = w < 768;

    return Container(
      color: const Color(0xFF060912),
      child: Column(
        children: [
          // ── Main footer ──────────────────────────
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: isMobile ? 24 : 80,
              vertical: 56,
            ),
            child: isMobile
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _FooterBrand(),
                      const SizedBox(height: 36),
                      _FooterLinks(title: 'Quick Links', links: ['Home', 'Products', 'Brands', 'Deals', 'About Us']),
                      const SizedBox(height: 36),
                      _FooterLinks(title: 'Categories', links: ['Gaming', 'Business', 'Student', 'Ultra-thin', 'Budget']),
                      const SizedBox(height: 36),
                      _FooterContact(),
                    ],
                  )
                : Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(flex: 3, child: _FooterBrand()),
                      const SizedBox(width: 40),
                      Expanded(flex: 2, child: _FooterLinks(title: 'Quick Links', links: ['Home', 'Products', 'Brands', 'Deals', 'About Us'])),
                      const SizedBox(width: 40),
                      Expanded(flex: 2, child: _FooterLinks(title: 'Categories', links: ['Gaming', 'Business', 'Student', 'Ultra-thin', 'Budget'])),
                      const SizedBox(width: 40),
                      Expanded(flex: 2, child: _FooterContact()),
                    ],
                  ),
          ),

          // ── Divider ──────────────────────────────
          Container(height: 1, color: AppColors.border),

          // ── Bottom bar ───────────────────────────
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: isMobile ? 24 : 80,
              vertical: 20,
            ),
            child: isMobile
                ? Column(
                    children: [
                      Text(
                        '© 2025 LaptopHarbor. All rights reserved.',
                        style: GoogleFonts.inter(color: AppColors.textMuted, fontSize: 12),
                      ),
                      const SizedBox(height: 12),
                      _SocialIcons(),
                    ],
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '© 2025 LaptopHarbor. All rights reserved.',
                        style: GoogleFonts.inter(color: AppColors.textMuted, fontSize: 12),
                      ),
                      _SocialIcons(),
                    ],
                  ),
          ),
        ],
      ),
    );
  }
}

class _FooterBrand extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 32, height: 32,
              decoration: BoxDecoration(
                color: AppColors.accent,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.laptop_mac, color: Colors.white, size: 18),
            ),
            const SizedBox(width: 10),
            Text(
              'LaptopHarbor',
              style: GoogleFonts.poppins(
                color: AppColors.textPrimary,
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),
        Text(
          'Your trusted destination for laptops.\nBest prices, top brands, fast delivery.',
          style: GoogleFonts.inter(
            color: AppColors.textMuted,
            fontSize: 13,
            height: 1.7,
          ),
        ),
      ],
    );
  }
}

class _FooterLinks extends StatelessWidget {
  final String title;
  final List<String> links;
  const _FooterLinks({required this.title, required this.links});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: GoogleFonts.poppins(
            color: AppColors.textPrimary,
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 16),
        ...links.map((l) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: _FooterLink(label: l),
            )),
      ],
    );
  }
}

class _FooterLink extends StatefulWidget {
  final String label;
  const _FooterLink({required this.label});

  @override
  State<_FooterLink> createState() => _FooterLinkState();
}

class _FooterLinkState extends State<_FooterLink> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit:  (_) => setState(() => _hovered = false),
      child: Text(
        widget.label,
        style: GoogleFonts.inter(
          color: _hovered ? AppColors.accent : AppColors.textMuted,
          fontSize: 13,
        ),
      ),
    );
  }
}

class _FooterContact extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Contact Info',
          style: GoogleFonts.poppins(
            color: AppColors.textPrimary,
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 16),
        _ContactRow(icon: Icons.email_outlined,    text: 'support@laptopharbor.com'),
        const SizedBox(height: 10),
        _ContactRow(icon: Icons.phone_outlined,    text: '+1 (800) 123-4567'),
        const SizedBox(height: 10),
        _ContactRow(icon: Icons.location_on_outlined, text: 'New York, USA'),
      ],
    );
  }
}

class _ContactRow extends StatelessWidget {
  final IconData icon;
  final String   text;
  const _ContactRow({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: AppColors.accent, size: 15),
        const SizedBox(width: 8),
        Flexible(
          child: Text(
            text,
            style: GoogleFonts.inter(color: AppColors.textMuted, fontSize: 13),
          ),
        ),
      ],
    );
  }
}

class _SocialIcons extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _SocialIcon(icon: Icons.facebook),
        const SizedBox(width: 8),
        _SocialIcon(icon: Icons.camera_alt_outlined),
        const SizedBox(width: 8),
        _SocialIcon(icon: Icons.alternate_email),
        const SizedBox(width: 8),
        _SocialIcon(icon: Icons.play_circle_outline),
      ],
    );
  }
}

class _SocialIcon extends StatefulWidget {
  final IconData icon;
  const _SocialIcon({required this.icon});

  @override
  State<_SocialIcon> createState() => _SocialIconState();
}

class _SocialIconState extends State<_SocialIcon> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit:  (_) => setState(() => _hovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        width: 34, height: 34,
        decoration: BoxDecoration(
          color: _hovered ? AppColors.accent : AppColors.surface,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: _hovered ? AppColors.accent : AppColors.border),
        ),
        child: Icon(widget.icon, size: 16,
            color: _hovered ? Colors.white : AppColors.textMuted),
      ),
    );
  }
}
