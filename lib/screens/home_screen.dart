// ════════════════════════════════════════════════════
// LaptopHarbor — Professional E-Commerce App
// All pages: Home, Cart, Wishlist, Profile, Orders,
//            Notifications, Product Detail, Search
// ════════════════════════════════════════════════════
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

// ─── Colors ──────────────────────────────────────────
const Color _navy    = Color(0xFF0D1B2A);
const Color _navyL   = Color(0xFF1A3A5C);
const Color _orange  = Color(0xFFFF6B35);
const Color _orangeD = Color(0xFFE55A25);
const Color _bg      = Color(0xFFF4F6FA);
const Color _green   = Color(0xFF27AE60);
const Color _card    = Color(0xFFFFFFFF);
const Color _red     = Color(0xFFE53935);

// ─── Global cart state ───────────────────────────────
final List<Map<String, dynamic>> _globalCart = [];
final Set<String> _globalWishlist = {};

// ─── Snackbar helper ─────────────────────────────────
void _snack(BuildContext ctx, String msg, {Color color = _navy}) {
  ScaffoldMessenger.of(ctx).clearSnackBars();
  ScaffoldMessenger.of(ctx).showSnackBar(SnackBar(
    content: Text(msg, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
    backgroundColor: color,
    behavior: SnackBarBehavior.floating,
    margin: const EdgeInsets.all(16),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    duration: const Duration(seconds: 2),
  ));
}

// ─── Hover wrapper ───────────────────────────────────
class _Hover extends StatefulWidget {
  final Widget Function(bool hovered) builder;
  const _Hover({required this.builder});
  @override
  State<_Hover> createState() => _HoverState();
}
class _HoverState extends State<_Hover> {
  bool _h = false;
  @override
  Widget build(BuildContext context) => MouseRegion(
    onEnter: (_) => setState(() => _h = true),
    onExit:  (_) => setState(() => _h = false),
    child: widget.builder(_h),
  );
}

// ════════════════════════════════════════════════════
// PRODUCT MODEL
// ════════════════════════════════════════════════════
class _Product {
  final String name, brand, category, badge, image, specs, description;
  final double price, oldPrice, rating;
  final int reviews;
  final Color badgeColor;
  final List<String> images;

  const _Product({
    required this.name, required this.brand, required this.category,
    required this.price, required this.oldPrice, required this.rating,
    required this.reviews, required this.badge, required this.badgeColor,
    required this.image, required this.specs, required this.description,
    required this.images,
  });
}

// ── Animated page route helper ───────────────────────
Route _slideRoute(Widget page, {bool fromRight = true}) {
  return PageRouteBuilder(
    pageBuilder: (_, __, ___) => page,
    transitionDuration: const Duration(milliseconds: 350),
    reverseTransitionDuration: const Duration(milliseconds: 300),
    transitionsBuilder: (_, animation, __, child) {
      final offset = Tween<Offset>(
        begin: Offset(fromRight ? 1.0 : -1.0, 0),
        end: Offset.zero,
      ).animate(CurvedAnimation(parent: animation, curve: Curves.easeOutCubic));
      return SlideTransition(position: offset,
          child: FadeTransition(opacity: animation, child: child));
    },
  );
}

Route _fadeRoute(Widget page) {
  return PageRouteBuilder(
    pageBuilder: (_, __, ___) => page,
    transitionDuration: const Duration(milliseconds: 400),
    transitionsBuilder: (_, animation, __, child) =>
        FadeTransition(opacity: animation, child: child),
  );
}

Route _scaleRoute(Widget page) {
  return PageRouteBuilder(
    pageBuilder: (_, __, ___) => page,
    transitionDuration: const Duration(milliseconds: 350),
    transitionsBuilder: (_, animation, __, child) {
      final scale = Tween<double>(begin: 0.92, end: 1.0).animate(
          CurvedAnimation(parent: animation, curve: Curves.easeOutBack));
      return ScaleTransition(scale: scale,
          child: FadeTransition(opacity: animation, child: child));
    },
  );
}
const List<_Product> _allProducts = [
  _Product(
    name: 'Dell XPS 15 9530', brand: 'Dell', category: 'Business',
    price: 1299, oldPrice: 1499, rating: 4.8, reviews: 320,
    badge: 'Best Seller', badgeColor: _orange,
    image: 'https://images.unsplash.com/photo-1593642632559-0c6d3fc62b89?w=600&q=80',
    specs: 'Intel i7-13700H • 16GB RAM • 512GB SSD • 15.6" OLED',
    description: 'The Dell XPS 15 is the ultimate professional laptop. Its stunning InfinityEdge OLED display, combined with Intel i7 performance and premium aluminium chassis, makes it the go-to choice for creators and business professionals.',
    images: [
      'https://images.unsplash.com/photo-1593642632559-0c6d3fc62b89?w=800&q=80',
      'https://images.unsplash.com/photo-1593642634367-d91a135587b5?w=800&q=80',
      'https://images.unsplash.com/photo-1496181133206-80ce9b88a853?w=800&q=80',
    ],
  ),
  _Product(
    name: 'MacBook Pro 14" M3', brand: 'Apple', category: 'Apple',
    price: 1999, oldPrice: 0, rating: 4.9, reviews: 540,
    badge: 'New', badgeColor: Color(0xFF1565C0),
    image: 'https://images.unsplash.com/photo-1517336714731-489689fd1ca8?w=600&q=80',
    specs: 'Apple M3 Pro • 18GB RAM • 512GB SSD • 14.2" Liquid Retina XDR',
    description: 'MacBook Pro with M3 Pro chip shatters performance expectations. Featuring the stunning Liquid Retina XDR display, up to 22 hours battery, and the power to run pro apps effortlessly.',
    images: [
      'https://images.unsplash.com/photo-1517336714731-489689fd1ca8?w=800&q=80',
      'https://images.unsplash.com/photo-1611186871525-9b1a7e8a5a1e?w=800&q=80',
      'https://images.unsplash.com/photo-1526570207772-784d36084510?w=800&q=80',
    ],
  ),
  _Product(
    name: 'ASUS ROG Strix G16', brand: 'ASUS', category: 'Gaming',
    price: 2299, oldPrice: 2599, rating: 4.9, reviews: 280,
    badge: '🎮 Gaming', badgeColor: Color(0xFFD32F2F),
    image: 'https://images.unsplash.com/photo-1603302576837-37561b2e2302?w=600&q=80',
    specs: 'RTX 4080 • 32GB RAM • 1TB SSD • 16" 240Hz QHD',
    description: 'ASUS ROG Strix G16 is engineered for elite gaming. The RTX 4080, 32GB DDR5 RAM, and 240Hz display ensure smooth gameplay at the highest settings. Built for champions.',
    images: [
      'https://images.unsplash.com/photo-1603302576837-37561b2e2302?w=800&q=80',
      'https://images.unsplash.com/photo-1542751371-adc38448a05e?w=800&q=80',
      'https://images.unsplash.com/photo-1612287230202-1ff1d85d1bdf?w=800&q=80',
    ],
  ),
  _Product(
    name: 'HP Pavilion 15', brand: 'HP', category: 'Student',
    price: 699, oldPrice: 899, rating: 4.4, reviews: 190,
    badge: 'Budget Pick', badgeColor: Color(0xFF2E7D32),
    image: 'https://images.unsplash.com/photo-1588872657578-7efd1f1555ed?w=600&q=80',
    specs: 'Intel i5-12th Gen • 8GB RAM • 256GB SSD • 15.6" FHD',
    description: 'HP Pavilion 15 delivers everyday performance at a student-friendly price. Lightweight design, reliable performance, and a full day battery make it perfect for campus life.',
    images: [
      'https://images.unsplash.com/photo-1588872657578-7efd1f1555ed?w=800&q=80',
      'https://images.unsplash.com/photo-1585771724684-38269d6639fd?w=800&q=80',
      'https://images.unsplash.com/photo-1525547719571-a2d4ac8945e2?w=800&q=80',
    ],
  ),
  _Product(
    name: 'Lenovo ThinkPad X1 Carbon', brand: 'Lenovo', category: 'Business',
    price: 1349, oldPrice: 1599, rating: 4.8, reviews: 420,
    badge: '🏆 Popular', badgeColor: _orange,
    image: 'https://images.unsplash.com/photo-1496181133206-80ce9b88a853?w=600&q=80',
    specs: 'Intel i7-1365U • 16GB RAM • 512GB SSD • 14" IPS 2.8K',
    description: 'ThinkPad X1 Carbon is the pinnacle of business laptops. Military-grade certified, ultra-light at 1.12kg, and built with best-in-class keyboard — it defines enterprise excellence.',
    images: [
      'https://images.unsplash.com/photo-1496181133206-80ce9b88a853?w=800&q=80',
      'https://images.unsplash.com/photo-1593642632559-0c6d3fc62b89?w=800&q=80',
      'https://images.unsplash.com/photo-1588702547923-7093a6c3ba33?w=800&q=80',
    ],
  ),
  _Product(
    name: 'Acer Nitro 5 Gaming', brand: 'Acer', category: 'Gaming',
    price: 999, oldPrice: 1199, rating: 4.6, reviews: 175,
    badge: '🔥 Sale', badgeColor: Color(0xFFD32F2F),
    image: 'https://images.unsplash.com/photo-1525547719571-a2d4ac8945e2?w=600&q=80',
    specs: 'RTX 3060 • 16GB RAM • 512GB SSD • 15.6" 144Hz FHD',
    description: 'Acer Nitro 5 is the perfect gateway into gaming. With RTX 3060 and 144Hz display, every game looks spectacular without breaking the bank.',
    images: [
      'https://images.unsplash.com/photo-1525547719571-a2d4ac8945e2?w=800&q=80',
      'https://images.unsplash.com/photo-1603302576837-37561b2e2302?w=800&q=80',
      'https://images.unsplash.com/photo-1542751371-adc38448a05e?w=800&q=80',
    ],
  ),
  _Product(
    name: 'Microsoft Surface Pro 9', brand: 'Microsoft', category: 'Business',
    price: 1399, oldPrice: 1599, rating: 4.6, reviews: 140,
    badge: '2-in-1', badgeColor: Color(0xFF0078D4),
    image: 'https://images.unsplash.com/photo-1551818255-e6e10975bc17?w=600&q=80',
    specs: 'Intel i7-1255U • 16GB RAM • 256GB SSD • 13" PixelSense',
    description: 'Surface Pro 9 is the versatile tablet-laptop hybrid that does it all. Detach the keyboard and sketch ideas or attach it and get serious work done — your choice.',
    images: [
      'https://images.unsplash.com/photo-1551818255-e6e10975bc17?w=800&q=80',
      'https://images.unsplash.com/photo-1593642632559-0c6d3fc62b89?w=800&q=80',
      'https://images.unsplash.com/photo-1496181133206-80ce9b88a853?w=800&q=80',
    ],
  ),
  _Product(
    name: 'Razer Blade 15 Advanced', brand: 'Razer', category: 'Gaming',
    price: 2799, oldPrice: 3199, rating: 4.8, reviews: 210,
    badge: '💎 Premium', badgeColor: Color(0xFF1B5E20),
    image: 'https://images.unsplash.com/photo-1542751371-adc38448a05e?w=600&q=80',
    specs: 'RTX 4090 • 32GB RAM • 1TB SSD • 15.6" 240Hz OLED',
    description: 'Razer Blade 15 is the pinnacle of gaming laptops. Slim CNC aluminium body, RTX 4090, and a breathtaking 240Hz OLED display — it is a status symbol for gamers.',
    images: [
      'https://images.unsplash.com/photo-1542751371-adc38448a05e?w=800&q=80',
      'https://images.unsplash.com/photo-1603302576837-37561b2e2302?w=800&q=80',
      'https://images.unsplash.com/photo-1612287230202-1ff1d85d1bdf?w=800&q=80',
    ],
  ),
  _Product(
    name: 'HP Spectre x360 14"', brand: 'HP', category: 'Business',
    price: 1599, oldPrice: 1799, rating: 4.7, reviews: 230,
    badge: '✨ Trending', badgeColor: _orange,
    image: 'https://images.unsplash.com/photo-1588702547923-7093a6c3ba33?w=600&q=80',
    specs: 'Intel i7 Evo • 16GB RAM • 512GB SSD • 13.5" 3K2K OLED',
    description: 'HP Spectre x360 is elegance personified. Its gem-cut design, 3K2K OLED touch display, and Intel Evo platform certification deliver beauty and brains in one stunning package.',
    images: [
      'https://images.unsplash.com/photo-1588702547923-7093a6c3ba33?w=800&q=80',
      'https://images.unsplash.com/photo-1551818255-e6e10975bc17?w=800&q=80',
      'https://images.unsplash.com/photo-1593642632559-0c6d3fc62b89?w=800&q=80',
    ],
  ),
  _Product(
    name: 'ASUS ZenBook 14 OLED', brand: 'ASUS', category: 'Student',
    price: 899, oldPrice: 1099, rating: 4.5, reviews: 160,
    badge: 'Ultra-Slim', badgeColor: Color(0xFF6A1B9A),
    image: 'https://images.unsplash.com/photo-1611186871525-9b1a7e8a5a1e?w=600&q=80',
    specs: 'AMD Ryzen 7 7730U • 16GB RAM • 512GB SSD • 14" OLED',
    description: 'ASUS ZenBook 14 OLED is the ultra-slim powerhouse every student dreams of. Stunning OLED display, AMD Ryzen 7, and an all-day battery in a feather-light chassis.',
    images: [
      'https://images.unsplash.com/photo-1611186871525-9b1a7e8a5a1e?w=800&q=80',
      'https://images.unsplash.com/photo-1588872657578-7efd1f1555ed?w=800&q=80',
      'https://images.unsplash.com/photo-1496181133206-80ce9b88a853?w=800&q=80',
    ],
  ),
  _Product(
    name: 'MacBook Air 15" M2', brand: 'Apple', category: 'Apple',
    price: 1299, oldPrice: 1499, rating: 4.8, reviews: 380,
    badge: '🍎 Hot', badgeColor: Color(0xFFD32F2F),
    image: 'https://images.unsplash.com/photo-1526570207772-784d36084510?w=600&q=80',
    specs: 'Apple M2 • 8GB RAM • 256GB SSD • 15.3" Liquid Retina',
    description: 'MacBook Air 15 inch is Apple\'s largest and most powerful Air ever. Fanless, silent, stunning 15.3" display, and M2 chip delivering 18 hours of battery life.',
    images: [
      'https://images.unsplash.com/photo-1526570207772-784d36084510?w=800&q=80',
      'https://images.unsplash.com/photo-1517336714731-489689fd1ca8?w=800&q=80',
      'https://images.unsplash.com/photo-1611186871525-9b1a7e8a5a1e?w=800&q=80',
    ],
  ),
  _Product(
    name: 'Lenovo IdeaPad Gaming 3', brand: 'Lenovo', category: 'Gaming',
    price: 749, oldPrice: 899, rating: 4.3, reviews: 125,
    badge: '💰 Value', badgeColor: Color(0xFF2E7D32),
    image: 'https://images.unsplash.com/photo-1612287230202-1ff1d85d1bdf?w=600&q=80',
    specs: 'RTX 3050 • 8GB RAM • 512GB SSD • 15.6" 120Hz FHD',
    description: 'Lenovo IdeaPad Gaming 3 is the budget gamer\'s best friend. RTX 3050 graphics, 120Hz smooth display, and solid build quality without the premium price tag.',
    images: [
      'https://images.unsplash.com/photo-1612287230202-1ff1d85d1bdf?w=800&q=80',
      'https://images.unsplash.com/photo-1525547719571-a2d4ac8945e2?w=800&q=80',
      'https://images.unsplash.com/photo-1542751371-adc38448a05e?w=800&q=80',
    ],
  ),
  _Product(
    name: 'Samsung Galaxy Book3 Pro', brand: 'Samsung', category: 'Business',
    price: 1449, oldPrice: 1699, rating: 4.6, reviews: 98,
    badge: '⚡ New', badgeColor: Color(0xFF1565C0),
    image: 'https://images.unsplash.com/photo-1585771724684-38269d6639fd?w=600&q=80',
    specs: 'Intel i7-1360P • 16GB RAM • 512GB SSD • 14" 3K AMOLED',
    description: 'Samsung Galaxy Book3 Pro features a gorgeous 3K AMOLED display and Intel Evo platform. Incredibly thin and light, it is built for professionals who demand premium performance.',
    images: [
      'https://images.unsplash.com/photo-1585771724684-38269d6639fd?w=800&q=80',
      'https://images.unsplash.com/photo-1496181133206-80ce9b88a853?w=800&q=80',
      'https://images.unsplash.com/photo-1588702547923-7093a6c3ba33?w=800&q=80',
    ],
  ),
  _Product(
    name: 'Gigabyte AORUS 17X', brand: 'Gigabyte', category: 'Gaming',
    price: 3199, oldPrice: 3599, rating: 4.7, reviews: 87,
    badge: '👑 Flagship', badgeColor: Color(0xFF880E4F),
    image: 'https://images.unsplash.com/photo-1593642634524-b40b5baae6bb?w=600&q=80',
    specs: 'RTX 4090 • 64GB RAM • 2TB SSD • 17.3" 360Hz UHD',
    description: 'AORUS 17X is the ultimate gaming powerhouse — RTX 4090, 64GB DDR5, and a blazing 360Hz 4K display. This beast handles 4K gaming, 3D rendering, and AI workloads simultaneously.',
    images: [
      'https://images.unsplash.com/photo-1593642634524-b40b5baae6bb?w=800&q=80',
      'https://images.unsplash.com/photo-1542751371-adc38448a05e?w=800&q=80',
      'https://images.unsplash.com/photo-1603302576837-37561b2e2302?w=800&q=80',
    ],
  ),
];

const List<Map<String, dynamic>> _cats = [
  {'name': 'All',      'icon': Icons.apps,            'color': Color(0xFF0D1B2A), 'img': 'https://images.unsplash.com/photo-1593642632559-0c6d3fc62b89?w=300&q=80'},
  {'name': 'Gaming',   'icon': Icons.sports_esports,  'color': Color(0xFFD32F2F), 'img': 'https://images.unsplash.com/photo-1603302576837-37561b2e2302?w=300&q=80'},
  {'name': 'Business', 'icon': Icons.business_center, 'color': Color(0xFF1565C0), 'img': 'https://images.unsplash.com/photo-1496181133206-80ce9b88a853?w=300&q=80'},
  {'name': 'Student',  'icon': Icons.school,          'color': Color(0xFF2E7D32), 'img': 'https://images.unsplash.com/photo-1588872657578-7efd1f1555ed?w=300&q=80'},
  {'name': 'Apple',    'icon': Icons.apple,           'color': Color(0xFF424242), 'img': 'https://images.unsplash.com/photo-1517336714731-489689fd1ca8?w=300&q=80'},
];

// ════════════════════════════════════════════════════
// HOME SCREEN
// ════════════════════════════════════════════════════
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  int _navIndex = 0;
  String _selectedCat = 'All';
  final TextEditingController _searchCtrl = TextEditingController();
  final FocusNode _searchFocus = FocusNode();
  late AnimationController _fadeCtrl;
  late Animation<double> _fadeAnim;

  List<_Product> get _filtered => _allProducts.where((p) {
    final q = _searchCtrl.text.trim().toLowerCase();
    final catOk = _selectedCat == 'All' || p.category == _selectedCat;
    final qOk = q.isEmpty || p.name.toLowerCase().contains(q) ||
        p.brand.toLowerCase().contains(q) || p.specs.toLowerCase().contains(q);
    return catOk && qOk;
  }).toList();

  bool get _isSearching => _searchCtrl.text.trim().isNotEmpty;

  @override
  void initState() {
    super.initState();
    _fadeCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 500));
    _fadeAnim = CurvedAnimation(parent: _fadeCtrl, curve: Curves.easeIn);
    _fadeCtrl.forward();
    _searchCtrl.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _fadeCtrl.dispose();
    _searchCtrl.dispose();
    _searchFocus.dispose();
    super.dispose();
  }

  void _goDetail(_Product p) => Navigator.push(context, _scaleRoute(_ProductDetailPage(product: p)));
  void _goCart()     => Navigator.push(context, _slideRoute(const _CartPage())).then((_) => setState(() {}));
  void _goWishlist() => Navigator.push(context, _slideRoute(const _WishlistPage())).then((_) => setState(() {}));
  void _goProfile()  => Navigator.push(context, _slideRoute(const _ProfilePage()));

  void _addToCart(_Product p) {
    final idx = _globalCart.indexWhere((c) => c['product'] == p);
    if (idx >= 0) {
      _globalCart[idx]['qty'] = (_globalCart[idx]['qty'] as int) + 1;
    } else {
      _globalCart.add({'product': p, 'qty': 1});
    }
    setState(() {});
    _snack(context, '${p.name} added to cart! 🛒', color: _green);
  }

  void _toggleWishlist(_Product p) {
    setState(() {
      if (_globalWishlist.contains(p.name)) {
        _globalWishlist.remove(p.name);
        _snack(context, 'Removed from wishlist', color: _navy);
      } else {
        _globalWishlist.add(p.name);
        _snack(context, '${p.name} saved to wishlist ❤️', color: _red);
      }
    });
  }

  int get _cartCount => _globalCart.fold(0, (s, c) => s + (c['qty'] as int));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      drawer: _buildDrawer(context),
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            _buildSearchBar(),
            Expanded(
              child: FadeTransition(
                opacity: _fadeAnim,
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (!_isSearching) ...[
                        const _BannerSection(),
                        const SizedBox(height: 12),
                        _buildServicesRow(),
                        const SizedBox(height: 12),
                        _buildCategoryVisual(),
                        const SizedBox(height: 12),
                        _buildTrendingSection(),
                        const SizedBox(height: 12),
                        _buildPromoRow(),
                        const SizedBox(height: 12),
                      ],
                      _buildCategoryChips(),
                      if (_isSearching)
                        Padding(
                          padding: const EdgeInsets.fromLTRB(16, 10, 16, 0),
                          child: Text('${_filtered.length} results for "${_searchCtrl.text.trim()}"',
                              style: TextStyle(color: Colors.grey[600], fontSize: 13)),
                        ),
                      _buildProductGrid(_filtered),
                      if (!_isSearching) ...[
                        const SizedBox(height: 16),
                        _buildBestSellers(),
                        const SizedBox(height: 16),
                        _buildBrandsRow(),
                        const SizedBox(height: 16),
                        _buildOffersSection(),
                        const SizedBox(height: 16),
                        _buildWhyUsSection(),
                        const SizedBox(height: 16),
                        _buildTestimonialsSection(),
                        const SizedBox(height: 16),
                        const _FooterSection(),
                      ],
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  // ── Header ─────────────────────────────────────────
  Widget _buildHeader() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(colors: [_navy, _navyL],
            begin: Alignment.topLeft, end: Alignment.bottomRight),
      ),
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
      child: Row(children: [
        // Hamburger menu button
        _Hover(builder: (h) => GestureDetector(
          onTap: () => Scaffold.of(context).openDrawer(),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: h ? _orange.withValues(alpha: 0.3) : _orange.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.menu_rounded, color: _orange, size: 24),
          ),
        )),
        const SizedBox(width: 10),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Text('Good Day 👋', style: TextStyle(color: Colors.white60, fontSize: 11)),
          const Text('LaptopHarbor', style: TextStyle(color: Colors.white,
              fontSize: 18, fontWeight: FontWeight.bold, letterSpacing: 0.5)),
        ])),
        // Notifications
        _Hover(builder: (h) => GestureDetector(
          onTap: () => Navigator.push(context, MaterialPageRoute(
              builder: (_) => const _NotificationPage())),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: h ? _orange.withValues(alpha: 0.3) : Colors.white.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10)),
            child: Stack(clipBehavior: Clip.none, children: [
              const Icon(Icons.notifications_outlined, color: Colors.white, size: 22),
              Positioned(top: -2, right: -2,
                child: Container(width: 8, height: 8,
                    decoration: const BoxDecoration(color: _orange, shape: BoxShape.circle))),
            ]),
          ),
        )),
        const SizedBox(width: 8),
        // Cart with count badge
        _Hover(builder: (h) => GestureDetector(
          onTap: _goCart,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: h ? _orange.withValues(alpha: 0.3) : Colors.white.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10)),
            child: Stack(clipBehavior: Clip.none, children: [
              const Icon(Icons.shopping_cart_outlined, color: Colors.white, size: 22),
              if (_cartCount > 0)
                Positioned(top: -4, right: -4,
                  child: Container(
                    padding: const EdgeInsets.all(3),
                    decoration: const BoxDecoration(color: _orange, shape: BoxShape.circle),
                    child: Text('$_cartCount', style: const TextStyle(
                        color: Colors.white, fontSize: 9, fontWeight: FontWeight.bold)),
                  )),
            ]),
          ),
        )),
      ]),
    );
  }

  // ── Search Bar ─────────────────────────────────────
  Widget _buildSearchBar() {
    return Container(
      color: _navy,
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 14),
      child: Row(children: [
        Expanded(
          child: Container(
            height: 46,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 8, offset: const Offset(0, 2))],
            ),
            child: TextField(
              controller: _searchCtrl,
              focusNode: _searchFocus,
              textAlignVertical: TextAlignVertical.center,
              style: const TextStyle(fontSize: 14),
              decoration: InputDecoration(
                hintText: 'Search laptops, brands, specs...',
                hintStyle: TextStyle(color: Colors.grey[400], fontSize: 13),
                prefixIcon: const Icon(Icons.search, color: Colors.grey, size: 20),
                suffixIcon: _searchCtrl.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear, size: 18, color: Colors.grey),
                        onPressed: () { _searchCtrl.clear(); _searchFocus.unfocus(); })
                    : null,
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                filled: false,
                contentPadding: const EdgeInsets.symmetric(vertical: 13),
              ),
            ),
          ),
        ),
        const SizedBox(width: 10),
        _Hover(builder: (h) => GestureDetector(
          onTap: () => Navigator.push(context, _slideRoute(const _FilterPage())),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            height: 46,
            padding: const EdgeInsets.symmetric(horizontal: 14),
            decoration: BoxDecoration(
              color: h ? _orangeD : _orange,
              borderRadius: BorderRadius.circular(12)),
            child: const Row(children: [
              Icon(Icons.tune, color: Colors.white, size: 18),
              SizedBox(width: 5),
              Text('Filter', style: TextStyle(color: Colors.white,
                  fontWeight: FontWeight.bold, fontSize: 13)),
            ]),
          ),
        )),
      ]),
    );
  }

  // ── Services Row ───────────────────────────────────
  Widget _buildServicesRow() {
    final s = [
      {'icon': Icons.local_shipping_outlined, 'label': 'Free Delivery', 'color': const Color(0xFF1565C0)},
      {'icon': Icons.replay_outlined,         'label': '30-Day Return',  'color': const Color(0xFF2E7D32)},
      {'icon': Icons.lock_outline,            'label': 'Secure Pay',    'color': const Color(0xFF6A1B9A)},
      {'icon': Icons.headset_mic_outlined,    'label': '24/7 Support',  'color': const Color(0xFFD32F2F)},
    ];
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(children: List.generate(4, (i) => Expanded(
        child: _Hover(builder: (h) => AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          margin: EdgeInsets.only(right: i < 3 ? 8 : 0),
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: h ? (s[i]['color'] as Color).withValues(alpha: 0.08) : _card,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 6, offset: const Offset(0, 2))],
          ),
          child: Column(children: [
            Container(width: 34, height: 34,
              decoration: BoxDecoration(
                color: (s[i]['color'] as Color).withValues(alpha: 0.1),
                shape: BoxShape.circle),
              child: Icon(s[i]['icon'] as IconData, color: s[i]['color'] as Color, size: 16)),
            const SizedBox(height: 5),
            Text(s[i]['label'] as String, textAlign: TextAlign.center,
                style: TextStyle(fontSize: 9, color: Colors.grey[700], fontWeight: FontWeight.w500)),
          ]),
        )),
      ))),
    );
  }

  // ── Visual Category Cards ──────────────────────────
  Widget _buildCategoryVisual() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        _sectionHeader('Browse Categories', onSeeAll: null),
        const SizedBox(height: 10),
        SizedBox(
          height: 90,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: _cats.length,
            separatorBuilder: (_, __) => const SizedBox(width: 10),
            itemBuilder: (_, i) {
              final c = _cats[i];
              final selected = c['name'] == _selectedCat;
              return _Hover(builder: (h) => GestureDetector(
                onTap: () => setState(() => _selectedCat = c['name'] as String),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: 80,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: selected ? (c['color'] as Color) : Colors.transparent,
                      width: 2.5),
                    boxShadow: [BoxShadow(
                      color: (selected || h) ? (c['color'] as Color).withValues(alpha: 0.25) : Colors.transparent,
                      blurRadius: 10, offset: const Offset(0, 4))],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Stack(fit: StackFit.expand, children: [
                      CachedNetworkImage(imageUrl: c['img'] as String, fit: BoxFit.cover,
                          placeholder: (_, __) => Container(color: c['color'] as Color),
                          errorWidget: (_, __, ___) => Container(color: c['color'] as Color)),
                      Container(color: Colors.black.withValues(alpha: selected ? 0.3 : 0.45)),
                      Center(child: Column(mainAxisSize: MainAxisSize.min, children: [
                        Icon(c['icon'] as IconData, color: Colors.white, size: 20),
                        const SizedBox(height: 4),
                        Text(c['name'] as String,
                            style: const TextStyle(color: Colors.white,
                                fontSize: 10, fontWeight: FontWeight.bold)),
                      ])),
                    ]),
                  ),
                ),
              ));
            },
          ),
        ),
      ]),
    );
  }

  // ── Trending Section ───────────────────────────────
  Widget _buildTrendingSection() {
    final items = _allProducts.where((p) => p.rating >= 4.7).toList();
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        _sectionHeader('🔥 Trending Now',
            onSeeAll: () => _snack(context, 'Showing top rated laptops!')),
        const SizedBox(height: 10),
        SizedBox(
          height: 150,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: items.length,
            separatorBuilder: (_, __) => const SizedBox(width: 12),
            itemBuilder: (_, i) {
              final p = items[i];
              return _Hover(builder: (h) => GestureDetector(
                onTap: () => _goDetail(p),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: 220,
                  decoration: BoxDecoration(
                    color: _card,
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: [BoxShadow(
                      color: h ? _orange.withValues(alpha: 0.2) : Colors.black.withValues(alpha: 0.07),
                      blurRadius: h ? 16 : 8, offset: const Offset(0, 4))],
                  ),
                  child: Row(children: [
                    ClipRRect(
                      borderRadius: const BorderRadius.horizontal(left: Radius.circular(14)),
                      child: CachedNetworkImage(imageUrl: p.image,
                        width: 95, height: 150, fit: BoxFit.cover,
                        placeholder: (_, __) => Container(width: 95, height: 150, color: Colors.grey[100]),
                        errorWidget: (_, __, ___) => Container(width: 95, height: 150,
                            color: Colors.grey[100], child: const Icon(Icons.laptop_mac, color: _navy, size: 32)),
                      ),
                    ),
                    Expanded(child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center, children: [
                        Container(padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(color: p.badgeColor, borderRadius: BorderRadius.circular(4)),
                          child: Text(p.badge, style: const TextStyle(
                              color: Colors.white, fontSize: 8, fontWeight: FontWeight.bold))),
                        const SizedBox(height: 5),
                        Text(p.name, maxLines: 2, overflow: TextOverflow.ellipsis,
                            style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: _navy)),
                        const SizedBox(height: 4),
                        Text(p.brand, style: TextStyle(fontSize: 10, color: Colors.grey[500])),
                        const SizedBox(height: 4),
                        Text('\$${p.price.toStringAsFixed(0)}',
                            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: _orange)),
                        const SizedBox(height: 3),
                        Row(children: [
                          const Icon(Icons.star_rounded, size: 12, color: Colors.amber),
                          const SizedBox(width: 2),
                          Text('${p.rating} (${p.reviews})',
                              style: TextStyle(fontSize: 10, color: Colors.grey[600])),
                        ]),
                      ]),
                    )),
                  ]),
                ),
              ));
            },
          ),
        ),
      ]),
    );
  }

  // ── Promo Banner Row ───────────────────────────────
  Widget _buildPromoRow() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(children: [
        // Main wide banner
        _Hover(builder: (h) => GestureDetector(
          onTap: () => setState(() => _selectedCat = 'Gaming'),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            height: 155,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              boxShadow: [BoxShadow(
                color: h ? _red.withValues(alpha: 0.3) : Colors.black.withValues(alpha: 0.1),
                blurRadius: h ? 20 : 8, offset: const Offset(0, 4))],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Stack(fit: StackFit.expand, children: [
                CachedNetworkImage(
                  imageUrl: 'https://images.unsplash.com/photo-1603302576837-37561b2e2302?w=800&q=80',
                  fit: BoxFit.cover,
                  placeholder: (_, __) => Container(color: const Color(0xFF880E4F)),
                  errorWidget: (_, __, ___) => Container(color: const Color(0xFF880E4F)),
                ),
                Container(decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  gradient: LinearGradient(
                    colors: [Colors.black.withValues(alpha: 0.75), Colors.transparent],
                    begin: Alignment.centerLeft, end: Alignment.centerRight))),
                Padding(
                  padding: const EdgeInsets.all(18),
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center, children: [
                    Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(color: _red, borderRadius: BorderRadius.circular(6)),
                      child: const Text('GAMING WEEK', style: TextStyle(
                          color: Colors.white, fontSize: 9, fontWeight: FontWeight.bold, letterSpacing: 1))),
                    const SizedBox(height: 8),
                    const Text('🎮 Up to 40% Off\nGaming Laptops',
                        style: TextStyle(color: Colors.white, fontSize: 18,
                            fontWeight: FontWeight.bold, height: 1.3)),
                    const SizedBox(height: 10),
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                      decoration: BoxDecoration(
                        color: h ? _orangeD : _orange,
                        borderRadius: BorderRadius.circular(8)),
                      child: const Text('Shop Gaming →', style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12)),
                    ),
                  ]),
                ),
              ]),
            ),
          ),
        )),
        const SizedBox(height: 10),
        Row(children: [
          // Apple banner
          Expanded(child: _Hover(builder: (h) => GestureDetector(
            onTap: () => setState(() => _selectedCat = 'Apple'),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              height: 115,
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(14),
                boxShadow: [BoxShadow(
                  color: h ? Colors.black.withValues(alpha: 0.2) : Colors.black.withValues(alpha: 0.08),
                  blurRadius: h ? 14 : 6, offset: const Offset(0, 3))]),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(14),
                child: Stack(fit: StackFit.expand, children: [
                  CachedNetworkImage(
                    imageUrl: 'https://images.unsplash.com/photo-1517336714731-489689fd1ca8?w=400&q=80',
                    fit: BoxFit.cover,
                    placeholder: (_, __) => Container(color: const Color(0xFF1A237E)),
                    errorWidget: (_, __, ___) => Container(color: const Color(0xFF1A237E)),
                  ),
                  Container(decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(14),
                    color: Colors.black.withValues(alpha: h ? 0.35 : 0.50))),
                  const Padding(padding: EdgeInsets.all(12),
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.end, children: [
                      Icon(Icons.apple, color: Colors.white, size: 22),
                      SizedBox(height: 2),
                      Text('MacBooks', style: TextStyle(color: Colors.white,
                          fontWeight: FontWeight.bold, fontSize: 14)),
                      Text('Official deals', style: TextStyle(color: Colors.white70, fontSize: 10)),
                    ])),
                ]),
              ),
            ),
          ))),
          const SizedBox(width: 10),
          // Business banner
          Expanded(child: _Hover(builder: (h) => GestureDetector(
            onTap: () => setState(() => _selectedCat = 'Business'),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              height: 115,
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(14),
                boxShadow: [BoxShadow(
                  color: h ? Colors.black.withValues(alpha: 0.2) : Colors.black.withValues(alpha: 0.08),
                  blurRadius: h ? 14 : 6, offset: const Offset(0, 3))]),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(14),
                child: Stack(fit: StackFit.expand, children: [
                  CachedNetworkImage(
                    imageUrl: 'https://images.unsplash.com/photo-1496181133206-80ce9b88a853?w=400&q=80',
                    fit: BoxFit.cover,
                    placeholder: (_, __) => Container(color: const Color(0xFF1565C0)),
                    errorWidget: (_, __, ___) => Container(color: const Color(0xFF1565C0)),
                  ),
                  Container(decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(14),
                    color: Colors.black.withValues(alpha: h ? 0.35 : 0.50))),
                  const Padding(padding: EdgeInsets.all(12),
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.end, children: [
                      Icon(Icons.business_center, color: Colors.white, size: 20),
                      SizedBox(height: 2),
                      Text('Business', style: TextStyle(color: Colors.white,
                          fontWeight: FontWeight.bold, fontSize: 14)),
                      Text('Pro laptops', style: TextStyle(color: Colors.white70, fontSize: 10)),
                    ])),
                ]),
              ),
            ),
          ))),
          const SizedBox(width: 10),
          // Student banner
          Expanded(child: _Hover(builder: (h) => GestureDetector(
            onTap: () => setState(() => _selectedCat = 'Student'),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              height: 115,
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(14),
                boxShadow: [BoxShadow(
                  color: h ? Colors.black.withValues(alpha: 0.2) : Colors.black.withValues(alpha: 0.08),
                  blurRadius: h ? 14 : 6, offset: const Offset(0, 3))]),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(14),
                child: Stack(fit: StackFit.expand, children: [
                  CachedNetworkImage(
                    imageUrl: 'https://images.unsplash.com/photo-1588872657578-7efd1f1555ed?w=400&q=80',
                    fit: BoxFit.cover,
                    placeholder: (_, __) => Container(color: const Color(0xFF2E7D32)),
                    errorWidget: (_, __, ___) => Container(color: const Color(0xFF2E7D32)),
                  ),
                  Container(decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(14),
                    color: Colors.black.withValues(alpha: h ? 0.35 : 0.50))),
                  const Padding(padding: EdgeInsets.all(12),
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.end, children: [
                      Icon(Icons.school, color: Colors.white, size: 20),
                      SizedBox(height: 2),
                      Text('Students', style: TextStyle(color: Colors.white,
                          fontWeight: FontWeight.bold, fontSize: 14)),
                      Text('Budget picks', style: TextStyle(color: Colors.white70, fontSize: 10)),
                    ])),
                ]),
              ),
            ),
          ))),
        ]),
      ]),
    );
  }

  // ── Category Chips ─────────────────────────────────
  Widget _buildCategoryChips() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
      child: SizedBox(
        height: 36,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          itemCount: _cats.length,
          separatorBuilder: (_, __) => const SizedBox(width: 8),
          itemBuilder: (_, i) {
            final c = _cats[i];
            final sel = c['name'] == _selectedCat;
            final color = c['color'] as Color;
            return _Hover(builder: (h) => GestureDetector(
              onTap: () => setState(() => _selectedCat = c['name'] as String),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  color: sel ? color : (h ? color.withValues(alpha: 0.1) : Colors.white),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: sel || h ? color : Colors.grey.shade300),
                  boxShadow: (sel || h)
                      ? [BoxShadow(color: color.withValues(alpha: 0.25), blurRadius: 8, offset: const Offset(0, 2))]
                      : [],
                ),
                child: Row(mainAxisSize: MainAxisSize.min, children: [
                  Icon(c['icon'] as IconData, size: 13, color: sel ? Colors.white : color),
                  const SizedBox(width: 5),
                  Text(c['name'] as String,
                      style: TextStyle(
                        color: sel ? Colors.white : (h ? color : Colors.grey[700]),
                        fontWeight: sel || h ? FontWeight.bold : FontWeight.normal,
                        fontSize: 12)),
                ]),
              ),
            ));
          },
        ),
      ),
    );
  }

  // ── Products Grid ──────────────────────────────────
  Widget _buildProductGrid(List<_Product> items) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 0),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        _sectionHeader('Featured Laptops',
            onSeeAll: () => setState(() => _selectedCat = 'All')),
        const SizedBox(height: 12),
        if (items.isEmpty)
          Center(child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 40),
            child: Column(children: [
              Icon(Icons.search_off, size: 64, color: Colors.grey[300]),
              const SizedBox(height: 12),
              const Text('No laptops found', style: TextStyle(
                  fontSize: 16, fontWeight: FontWeight.bold, color: Colors.grey)),
              const SizedBox(height: 6),
              Text('Try a different keyword or category',
                  style: TextStyle(fontSize: 13, color: Colors.grey[500])),
            ]),
          ))
        else
          Column(
            children: List.generate((items.length / 2).ceil(), (row) {
              final a = items[row * 2];
              final b = row * 2 + 1 < items.length ? items[row * 2 + 1] : null;
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Expanded(child: _ProductCard(
                    product: a,
                    onTap: () => _goDetail(a),
                    onCart: () => _addToCart(a),
                    onWishlist: () => _toggleWishlist(a),
                  )),
                  const SizedBox(width: 12),
                  Expanded(child: b != null ? _ProductCard(
                    product: b,
                    onTap: () => _goDetail(b),
                    onCart: () => _addToCart(b),
                    onWishlist: () => _toggleWishlist(b),
                  ) : const SizedBox()),
                ]),
              );
            }),
          ),
      ]),
    );
  }

  // ── Best Sellers ───────────────────────────────────
  Widget _buildBestSellers() {
    final items = _allProducts.where((p) => p.reviews >= 200).toList();
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        _sectionHeader('⭐ Best Sellers',
            onSeeAll: () => _snack(context, 'Showing all bestsellers!')),
        const SizedBox(height: 10),
        ...items.map((p) => _Hover(builder: (h) => GestureDetector(
          onTap: () => _goDetail(p),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            margin: const EdgeInsets.only(bottom: 10),
            decoration: BoxDecoration(
              color: _card,
              borderRadius: BorderRadius.circular(14),
              boxShadow: [BoxShadow(
                color: h ? _orange.withValues(alpha: 0.15) : Colors.black.withValues(alpha: 0.05),
                blurRadius: h ? 14 : 6, offset: const Offset(0, 3))],
            ),
            child: Row(children: [
              ClipRRect(
                borderRadius: const BorderRadius.horizontal(left: Radius.circular(14)),
                child: CachedNetworkImage(imageUrl: p.image,
                  width: 105, height: 95, fit: BoxFit.cover,
                  placeholder: (_, __) => Container(width: 105, height: 95,
                      color: Colors.grey[100], child: const Icon(Icons.laptop_mac, color: _navy, size: 32)),
                  errorWidget: (_, __, ___) => Container(width: 105, height: 95,
                      color: Colors.grey[100], child: const Icon(Icons.laptop_mac, color: _navy, size: 32)),
                ),
              ),
              Expanded(child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Row(children: [
                    Container(padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(color: p.badgeColor, borderRadius: BorderRadius.circular(4)),
                      child: Text(p.badge, style: const TextStyle(
                          color: Colors.white, fontSize: 9, fontWeight: FontWeight.bold))),
                  ]),
                  const SizedBox(height: 4),
                  Text(p.name, maxLines: 1, overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: _navy)),
                  const SizedBox(height: 2),
                  Text(p.specs, maxLines: 1, overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontSize: 10, color: Colors.grey[500])),
                  const SizedBox(height: 6),
                  Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                    Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text('\$${p.price.toStringAsFixed(0)}',
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: _orange)),
                      if (p.oldPrice > 0)
                        Text('\$${p.oldPrice.toStringAsFixed(0)}',
                            style: TextStyle(fontSize: 11, color: Colors.grey[400],
                                decoration: TextDecoration.lineThrough)),
                    ]),
                    Row(children: [
                      const Icon(Icons.star_rounded, size: 13, color: Colors.amber),
                      const SizedBox(width: 2),
                      Text('${p.rating} (${p.reviews})',
                          style: TextStyle(fontSize: 10, color: Colors.grey[600])),
                    ]),
                  ]),
                ]),
              )),
              Padding(
                padding: const EdgeInsets.only(right: 12),
                child: _Hover(builder: (hb) => GestureDetector(
                  onTap: () => _addToCart(p),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: hb ? _orangeD : _orange,
                      borderRadius: BorderRadius.circular(10)),
                    child: const Icon(Icons.add_shopping_cart, color: Colors.white, size: 18),
                  ),
                )),
              ),
            ]),
          ),
        ))),
      ]),
    );
  }

  // ── Brands Row ─────────────────────────────────────
  Widget _buildBrandsRow() {
    const brands = [
      {'name': 'Dell',      'icon': Icons.laptop,            'color': Color(0xFF007DB8)},
      {'name': 'Apple',     'icon': Icons.apple,             'color': Color(0xFF555555)},
      {'name': 'ASUS',      'icon': Icons.computer,          'color': Color(0xFF00539B)},
      {'name': 'HP',        'icon': Icons.laptop_chromebook, 'color': Color(0xFF0096D6)},
      {'name': 'Lenovo',    'icon': Icons.laptop_windows,    'color': Color(0xFFE2231A)},
      {'name': 'Acer',      'icon': Icons.devices,           'color': Color(0xFF83B81A)},
      {'name': 'Razer',     'icon': Icons.sports_esports,    'color': Color(0xFF1B5E20)},
      {'name': 'Samsung',   'icon': Icons.phone_android,     'color': Color(0xFF1565C0)},
    ];
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        _sectionHeader('Top Brands', onSeeAll: () => _snack(context, 'All brands available!')),
        const SizedBox(height: 10),
        SizedBox(
          height: 86,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: brands.length,
            separatorBuilder: (_, __) => const SizedBox(width: 10),
            itemBuilder: (_, i) {
              final b = brands[i];
              return _Hover(builder: (h) => GestureDetector(
                onTap: () {
                  final name = b['name'] as String;
                  _searchCtrl.text = name;
                  _snack(context, 'Showing ${name} laptops!');
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: 76,
                  decoration: BoxDecoration(
                    color: h ? (b['color'] as Color).withValues(alpha: 0.08) : _card,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: h ? (b['color'] as Color) : Colors.grey.shade200),
                    boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: h ? 0.08 : 0.04),
                        blurRadius: h ? 10 : 5, offset: const Offset(0, 2))],
                  ),
                  child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                    Icon(b['icon'] as IconData, color: b['color'] as Color, size: 26),
                    const SizedBox(height: 5),
                    Text(b['name'] as String, style: const TextStyle(
                        fontSize: 10, fontWeight: FontWeight.w600, color: _navy)),
                  ]),
                ),
              ));
            },
          ),
        ),
      ]),
    );
  }

  // ── Offers Section ─────────────────────────────────
  Widget _buildOffersSection() {
    final offers = _allProducts.where((p) => p.oldPrice > 0).toList();
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        _sectionHeader('🏷️ Special Offers', onSeeAll: () => _snack(context, 'All offers!')),
        const SizedBox(height: 10),
        SizedBox(
          height: 185,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: offers.length,
            separatorBuilder: (_, __) => const SizedBox(width: 12),
            itemBuilder: (_, i) {
              final p = offers[i];
              final disc = (((p.oldPrice - p.price) / p.oldPrice) * 100).round();
              return _Hover(builder: (h) => GestureDetector(
                onTap: () => _goDetail(p),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: 155,
                  decoration: BoxDecoration(
                    color: _card,
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: [BoxShadow(
                      color: h ? _orange.withValues(alpha: 0.2) : Colors.black.withValues(alpha: 0.06),
                      blurRadius: h ? 16 : 8, offset: const Offset(0, 4))],
                  ),
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Stack(children: [
                      ClipRRect(
                        borderRadius: const BorderRadius.vertical(top: Radius.circular(14)),
                        child: CachedNetworkImage(imageUrl: p.image,
                          height: 105, width: double.infinity, fit: BoxFit.cover,
                          placeholder: (_, __) => Container(height: 105, color: Colors.grey[100]),
                          errorWidget: (_, __, ___) => Container(height: 105, color: Colors.grey[100],
                              child: const Icon(Icons.laptop_mac, size: 40, color: _navy)),
                        ),
                      ),
                      Positioned(top: 8, left: 8,
                        child: Container(padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                          decoration: BoxDecoration(color: _orange, borderRadius: BorderRadius.circular(6)),
                          child: Text('-$disc%', style: const TextStyle(
                              color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold)))),
                    ]),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(10, 7, 10, 8),
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Text(p.name, maxLines: 1, overflow: TextOverflow.ellipsis,
                            style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: _navy)),
                        const SizedBox(height: 2),
                        Text(p.brand, style: TextStyle(fontSize: 10, color: Colors.grey[500])),
                        const SizedBox(height: 4),
                        Row(children: [
                          Text('\$${p.price.toStringAsFixed(0)}',
                              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: _orange)),
                          const SizedBox(width: 5),
                          Text('\$${p.oldPrice.toStringAsFixed(0)}',
                              style: TextStyle(fontSize: 10, color: Colors.grey[400],
                                  decoration: TextDecoration.lineThrough)),
                        ]),
                      ]),
                    ),
                  ]),
                ),
              ));
            },
          ),
        ),
      ]),
    );
  }

  // ── Why Us ─────────────────────────────────────────
  Widget _buildWhyUsSection() {
    const f = [
      {'icon': Icons.verified_outlined,      'title': 'Genuine Products', 'sub': '100% authentic, authorized',   'color': Color(0xFF4CAF50)},
      {'icon': Icons.support_agent_outlined, 'title': 'Expert Support',   'sub': 'Available 24/7 for help',      'color': Color(0xFF2196F3)},
      {'icon': Icons.price_check_outlined,   'title': 'Best Prices',      'sub': 'Price match guarantee',        'color': Color(0xFFFF9800)},
      {'icon': Icons.swap_horiz_outlined,    'title': 'Easy Returns',     'sub': 'Hassle-free 30 days',          'color': Color(0xFF9C27B0)},
    ];
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        _sectionHeader('Why Choose LaptopHarbor?', onSeeAll: null),
        const SizedBox(height: 10),
        GridView.count(shrinkWrap: true, physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 2, crossAxisSpacing: 10, mainAxisSpacing: 10, childAspectRatio: 1.6,
          children: f.map((item) => _Hover(builder: (h) => AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: h ? (item['color'] as Color).withValues(alpha: 0.07) : _card,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: h ? (item['color'] as Color).withValues(alpha: 0.3) : Colors.grey.shade100),
              boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 6, offset: const Offset(0, 2))],
            ),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center, children: [
              Icon(item['icon'] as IconData, color: item['color'] as Color, size: 28),
              const SizedBox(height: 6),
              Text(item['title'] as String,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: _navy)),
              const SizedBox(height: 3),
              Text(item['sub'] as String,
                  style: TextStyle(fontSize: 10, color: Colors.grey[600], height: 1.3),
                  maxLines: 2, overflow: TextOverflow.ellipsis),
            ]),
          ))).toList(),
        ),
      ]),
    );
  }

  // ── Testimonials ───────────────────────────────────
  Widget _buildTestimonialsSection() {
    const reviews = [
      {'name': 'Alex Mitchell', 'avatar': 'https://i.pravatar.cc/100?img=11', 'rating': 5,
       'review': 'Got my Dell XPS 15 delivered in 2 days. Packaging was perfect, price was unbeatable!'},
      {'name': 'Sarah Khan',    'avatar': 'https://i.pravatar.cc/100?img=5',  'rating': 5,
       'review': 'The MacBook Pro M3 was exactly as described. Best online laptop store hands down.'},
      {'name': 'James Rivera',  'avatar': 'https://i.pravatar.cc/100?img=12', 'rating': 4,
       'review': 'Great support team. They helped me choose the right gaming laptop for my budget.'},
    ];
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        _sectionHeader('💬 Customer Reviews', onSeeAll: null),
        const SizedBox(height: 10),
        ...reviews.map((r) => _Hover(builder: (h) => AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          margin: const EdgeInsets.only(bottom: 10),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: h ? const Color(0xFFFFF8F5) : _card,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: h ? _orange.withValues(alpha: 0.2) : Colors.grey.shade100),
            boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 6, offset: const Offset(0, 2))],
          ),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [
              ClipOval(child: CachedNetworkImage(
                imageUrl: r['avatar'] as String, width: 42, height: 42, fit: BoxFit.cover,
                placeholder: (_, __) => CircleAvatar(radius: 21,
                    backgroundColor: _orange.withValues(alpha: 0.15),
                    child: Text((r['name'] as String)[0],
                        style: const TextStyle(color: _orange, fontWeight: FontWeight.bold))),
                errorWidget: (_, __, ___) => CircleAvatar(radius: 21,
                    backgroundColor: _orange.withValues(alpha: 0.15),
                    child: Text((r['name'] as String)[0],
                        style: const TextStyle(color: _orange, fontWeight: FontWeight.bold))),
              )),
              const SizedBox(width: 10),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(r['name'] as String, style: const TextStyle(
                    fontWeight: FontWeight.bold, fontSize: 13, color: _navy)),
                Row(children: [
                  ...List.generate(r['rating'] as int,
                      (i) => const Icon(Icons.star_rounded, size: 13, color: Colors.amber)),
                  const SizedBox(width: 4),
                  Text('Verified Buyer', style: TextStyle(fontSize: 10, color: Colors.grey[500])),
                ]),
              ])),
              const Icon(Icons.format_quote, color: _orange, size: 22),
            ]),
            const SizedBox(height: 8),
            Text(r['review'] as String,
                style: TextStyle(fontSize: 12, color: Colors.grey[700], height: 1.5)),
          ]),
        ))),
      ]),
    );
  }

  // ── Side Drawer ────────────────────────────────────
  Widget _buildDrawer(BuildContext context) {
    return Drawer(
      width: 300,
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF0A0E1A), _navy],
            begin: Alignment.topLeft, end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Column(children: [
            // ── Drawer Header ─────────────────────────
            Container(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                  // Logo
                  Row(children: [
                    Container(
                      padding: const EdgeInsets.all(9),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                            colors: [_orange, Color(0xFFFF8C42)],
                            begin: Alignment.topLeft, end: Alignment.bottomRight),
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [BoxShadow(color: _orange.withValues(alpha: 0.4),
                            blurRadius: 12, spreadRadius: 1)],
                      ),
                      child: const Icon(Icons.laptop_mac, color: Colors.white, size: 22),
                    ),
                    const SizedBox(width: 10),
                    const Text('LaptopHarbor', style: TextStyle(
                        color: Colors.white, fontSize: 17, fontWeight: FontWeight.bold)),
                  ]),
                  // Close button
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.08),
                        borderRadius: BorderRadius.circular(8)),
                      child: const Icon(Icons.close, color: Colors.white70, size: 18)),
                  ),
                ]),
                const SizedBox(height: 20),
                // User card
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                    _goProfile();
                  },
                  child: Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.06),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
                    ),
                    child: Row(children: [
                      Container(
                        width: 44, height: 44,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: const LinearGradient(
                              colors: [_orange, Color(0xFFFF8C42)],
                              begin: Alignment.topLeft, end: Alignment.bottomRight),
                          boxShadow: [BoxShadow(color: _orange.withValues(alpha: 0.35),
                              blurRadius: 10)],
                        ),
                        child: const Icon(Icons.person_rounded, color: Colors.white, size: 24),
                      ),
                      const SizedBox(width: 12),
                      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        const Text('Guest User', style: TextStyle(
                            color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold)),
                        Text('Tap to view profile',
                            style: TextStyle(color: Colors.white.withValues(alpha: 0.5),
                                fontSize: 11)),
                      ])),
                      Icon(Icons.arrow_forward_ios_rounded,
                          color: Colors.white.withValues(alpha: 0.4), size: 14),
                    ]),
                  ),
                ),
                const SizedBox(height: 14),
                // Cart + Wishlist mini stats
                Row(children: [
                  Expanded(child: _drawerStat(
                    Icons.shopping_cart_outlined, '${_globalCart.length}', 'Cart', _orange,
                    onTap: () { Navigator.pop(context); _goCart(); })),
                  const SizedBox(width: 10),
                  Expanded(child: _drawerStat(
                    Icons.favorite_outline, '${_globalWishlist.length}', 'Wishlist', _red,
                    onTap: () { Navigator.pop(context); _goWishlist(); })),
                ]),
              ]),
            ),
            Divider(color: Colors.white.withValues(alpha: 0.08), height: 1),
            // ── Nav Items ─────────────────────────────
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Column(children: [
                  _drawerSection('MAIN', [
                    _DrawerItem(Icons.home_rounded,         'Home',           _orange,         () { Navigator.pop(context); }),
                    _DrawerItem(Icons.search_rounded,       'Search',         const Color(0xFF1565C0), () { Navigator.pop(context); _searchFocus.requestFocus(); }),
                    _DrawerItem(Icons.laptop_mac_rounded,   'All Laptops',    const Color(0xFF2E7D32), () { Navigator.pop(context); setState(() => _selectedCat = 'All'); }),
                    _DrawerItem(Icons.local_offer_outlined, 'Deals & Offers', const Color(0xFFD32F2F), () { Navigator.pop(context); setState(() => _selectedCat = 'All'); }),
                  ]),
                  _drawerSection('CATEGORIES', [
                    _DrawerItem(Icons.sports_esports_rounded,  'Gaming Laptops',    const Color(0xFFD32F2F), () { Navigator.pop(context); setState(() => _selectedCat = 'Gaming'); }),
                    _DrawerItem(Icons.business_center_rounded, 'Business Laptops',  const Color(0xFF1565C0), () { Navigator.pop(context); setState(() => _selectedCat = 'Business'); }),
                    _DrawerItem(Icons.school_rounded,          'Student Laptops',   const Color(0xFF2E7D32), () { Navigator.pop(context); setState(() => _selectedCat = 'Student'); }),
                    _DrawerItem(Icons.apple_rounded,           'Apple / MacBooks',  const Color(0xFF424242), () { Navigator.pop(context); setState(() => _selectedCat = 'Apple'); }),
                  ]),
                  _drawerSection('MY ACCOUNT', [
                    _DrawerItem(Icons.person_outline_rounded,      'My Profile',       const Color(0xFF6A1B9A), () { Navigator.pop(context); _goProfile(); }),
                    _DrawerItem(Icons.shopping_bag_outlined,       'My Orders',        const Color(0xFF2E7D32), () { Navigator.pop(context); Navigator.push(context, _slideRoute(const _OrdersPage())); }),
                    _DrawerItem(Icons.favorite_outline_rounded,    'Wishlist',         _red,                   () { Navigator.pop(context); _goWishlist(); }),
                    _DrawerItem(Icons.shopping_cart_outlined,      'My Cart',          _orange,                () { Navigator.pop(context); _goCart(); }),
                    _DrawerItem(Icons.notifications_outlined,      'Notifications',    const Color(0xFF0097A7), () { Navigator.pop(context); Navigator.push(context, _slideRoute(const _NotificationPage())); }),
                  ]),
                  _drawerSection('SUPPORT', [
                    _DrawerItem(Icons.support_agent_outlined,  'Help & Support', const Color(0xFF455A64), () { Navigator.pop(context); Navigator.push(context, _slideRoute(const _HelpPage())); }),
                    _DrawerItem(Icons.replay_outlined,         'Returns',        const Color(0xFFD32F2F), () { Navigator.pop(context); Navigator.push(context, _slideRoute(const _ReturnsPage())); }),
                    _DrawerItem(Icons.info_outline_rounded,    'About Us',       const Color(0xFF37474F), () { Navigator.pop(context); Navigator.push(context, _fadeRoute(const _AboutPage())); }),
                  ]),
                ]),
              ),
            ),
            // ── Footer ────────────────────────────────
            Divider(color: Colors.white.withValues(alpha: 0.08), height: 1),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Text('© 2025 LaptopHarbor',
                    style: TextStyle(color: Colors.white.withValues(alpha: 0.3),
                        fontSize: 11)),
                GestureDetector(
                  onTap: () { Navigator.pop(context); Navigator.push(context, _slideRoute(const _LoginPage())); },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
                    decoration: BoxDecoration(
                      color: _orange.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: _orange.withValues(alpha: 0.3))),
                    child: const Row(children: [
                      Icon(Icons.login_rounded, color: _orange, size: 14),
                      SizedBox(width: 5),
                      Text('Sign In', style: TextStyle(
                          color: _orange, fontSize: 12, fontWeight: FontWeight.bold)),
                    ]),
                  ),
                ),
              ]),
            ),
          ]),
        ),
      ),
    );
  }

  Widget _drawerStat(IconData icon, String value, String label, Color color,
      {required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: color.withValues(alpha: 0.2))),
        child: Column(children: [
          Icon(icon, color: color, size: 18),
          const SizedBox(height: 3),
          Text(value, style: TextStyle(
              color: color, fontSize: 16, fontWeight: FontWeight.bold)),
          Text(label, style: TextStyle(
              color: Colors.white.withValues(alpha: 0.45), fontSize: 10)),
        ]),
      ),
    );
  }

  Widget _drawerSection(String title, List<_DrawerItem> items) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Padding(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 6),
        child: Text(title, style: TextStyle(
            color: Colors.white.withValues(alpha: 0.3),
            fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1.2)),
      ),
      ...items.map((item) => _DrawerTile(item: item)),
    ]);
  }

  // ── Bottom Nav ─────────────────────────────────────
  Widget _buildBottomNav() {
    return Container(
      decoration: BoxDecoration(color: Colors.white,
          boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 12, offset: const Offset(0, -3))]),
      child: BottomNavigationBar(
        currentIndex: _navIndex,
        selectedItemColor: _orange,
        unselectedItemColor: Colors.grey,
        backgroundColor: Colors.white,
        type: BottomNavigationBarType.fixed,
        elevation: 0,
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 11),
        unselectedLabelStyle: const TextStyle(fontSize: 11),
        onTap: (i) {
          setState(() => _navIndex = i);
          if (i == 1) Future.delayed(const Duration(milliseconds: 100), () => _searchFocus.requestFocus());
          else if (i == 2) _goWishlist();
          else if (i == 3) _goProfile();
        },
        items: [
          const BottomNavigationBarItem(icon: Icon(Icons.home_outlined), activeIcon: Icon(Icons.home), label: 'Home'),
          const BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
          BottomNavigationBarItem(
            icon: Stack(clipBehavior: Clip.none, children: [
              const Icon(Icons.favorite_outline),
              if (_globalWishlist.isNotEmpty)
                Positioned(top: -4, right: -4,
                  child: Container(width: 14, height: 14,
                    decoration: const BoxDecoration(color: _red, shape: BoxShape.circle),
                    child: Center(child: Text('${_globalWishlist.length}',
                        style: const TextStyle(color: Colors.white, fontSize: 8, fontWeight: FontWeight.bold))))),
            ]),
            activeIcon: const Icon(Icons.favorite),
            label: 'Wishlist'),
          const BottomNavigationBarItem(icon: Icon(Icons.person_outline), activeIcon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }

  // ── Section Header helper ──────────────────────────
  Widget _sectionHeader(String title, {VoidCallback? onSeeAll}) {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: _navy)),
      if (onSeeAll != null)
        _Hover(builder: (h) => GestureDetector(
          onTap: onSeeAll,
          child: Text('See All →', style: TextStyle(
              color: h ? _orangeD : _orange, fontSize: 13, fontWeight: FontWeight.w600)),
        )),
    ]);
  }
}

// ════════════════════════════════════════════════════
// DRAWER ITEM DATA + TILE WIDGET
// ════════════════════════════════════════════════════
class _DrawerItem {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;
  const _DrawerItem(this.icon, this.label, this.color, this.onTap);
}

class _DrawerTile extends StatefulWidget {
  final _DrawerItem item;
  const _DrawerTile({required this.item});
  @override
  State<_DrawerTile> createState() => _DrawerTileState();
}

class _DrawerTileState extends State<_DrawerTile> {
  bool _h = false;
  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _h = true),
      onExit:  (_) => setState(() => _h = false),
      child: GestureDetector(
        onTap: widget.item.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
            color: _h
                ? widget.item.color.withValues(alpha: 0.15)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              width: 36, height: 36,
              decoration: BoxDecoration(
                color: _h
                    ? widget.item.color.withValues(alpha: 0.25)
                    : widget.item.color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(widget.item.icon,
                  color: widget.item.color, size: 18),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Text(widget.item.label,
                  style: TextStyle(
                    color: _h ? Colors.white : Colors.white.withValues(alpha: 0.8),
                    fontSize: 13,
                    fontWeight: _h ? FontWeight.bold : FontWeight.w400,
                  )),
            ),
            Icon(Icons.arrow_forward_ios_rounded,
                color: _h
                    ? widget.item.color.withValues(alpha: 0.8)
                    : Colors.white.withValues(alpha: 0.15),
                size: 12),
          ]),
        ),
      ),
    );
  }
}

// ════════════════════════════════════════════════════
// BANNER SECTION — Auto-rotating, 5 slides
// ════════════════════════════════════════════════════
class _BannerSection extends StatefulWidget {
  const _BannerSection();
  @override
  State<_BannerSection> createState() => _BannerSectionState();
}

class _BannerSectionState extends State<_BannerSection> {
  final PageController _pc = PageController();
  int _page = 0;
  static const _banners = [
    {'title': '🔥 Summer Sale',   'sub': 'Up to 40% off on premium laptops', 'cta': 'Shop Now',
     'c1': Color(0xFFFF6B35), 'c2': Color(0xFFFF8C42),
     'img': 'https://images.unsplash.com/photo-1593642632559-0c6d3fc62b89?w=800&q=80'},
    {'title': '🍎 New MacBooks',  'sub': 'MacBook Pro M3 — Now Available',     'cta': 'Buy Now',
     'c1': Color(0xFF263238), 'c2': Color(0xFF37474F),
     'img': 'https://images.unsplash.com/photo-1517336714731-489689fd1ca8?w=800&q=80'},
    {'title': '🎮 Gaming Week',   'sub': 'RTX 4090 laptops from \$999',         'cta': 'View Deals',
     'c1': Color(0xFF880E4F), 'c2': Color(0xFFAD1457),
     'img': 'https://images.unsplash.com/photo-1603302576837-37561b2e2302?w=800&q=80'},
    {'title': '💼 Business Pro',  'sub': 'ThinkPad, Spectre, Surface Pro',      'cta': 'Explore',
     'c1': Color(0xFF0D47A1), 'c2': Color(0xFF1565C0),
     'img': 'https://images.unsplash.com/photo-1496181133206-80ce9b88a853?w=800&q=80'},
    {'title': '🎓 Student Deals', 'sub': 'Budget laptops from \$599',           'cta': 'Get Yours',
     'c1': Color(0xFF1B5E20), 'c2': Color(0xFF2E7D32),
     'img': 'https://images.unsplash.com/photo-1588872657578-7efd1f1555ed?w=800&q=80'},
  ];

  @override
  void initState() {
    super.initState();
    Future.doWhile(() async {
      await Future.delayed(const Duration(seconds: 4));
      if (!mounted) return false;
      final next = (_page + 1) % _banners.length;
      _pc.animateToPage(next,
          duration: const Duration(milliseconds: 500), curve: Curves.easeInOut);
      return true;
    });
  }

  @override
  void dispose() { _pc.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 0),
      child: Column(children: [
        SizedBox(
          height: 185,
          child: PageView.builder(
            controller: _pc,
            itemCount: _banners.length,
            onPageChanged: (i) => setState(() => _page = i),
            itemBuilder: (_, i) {
              final b = _banners[i];
              return _Hover(builder: (h) => ClipRRect(
                borderRadius: BorderRadius.circular(18),
                child: Stack(fit: StackFit.expand, children: [
                  CachedNetworkImage(imageUrl: b['img'] as String, fit: BoxFit.cover,
                    placeholder: (_, __) => Container(
                      decoration: BoxDecoration(gradient: LinearGradient(
                        colors: [b['c1'] as Color, b['c2'] as Color],
                        begin: Alignment.topLeft, end: Alignment.bottomRight))),
                    errorWidget: (_, __, ___) => Container(
                      decoration: BoxDecoration(gradient: LinearGradient(
                        colors: [b['c1'] as Color, b['c2'] as Color],
                        begin: Alignment.topLeft, end: Alignment.bottomRight))),
                  ),
                  Container(decoration: BoxDecoration(gradient: LinearGradient(
                    colors: [Colors.black.withValues(alpha: 0.72), Colors.black.withValues(alpha: 0.1)],
                    begin: Alignment.centerLeft, end: Alignment.centerRight))),
                  Padding(
                    padding: const EdgeInsets.all(22),
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center, children: [
                      Text(b['title'] as String, style: const TextStyle(
                          color: Colors.white, fontSize: 24, fontWeight: FontWeight.w900, height: 1.2)),
                      const SizedBox(height: 6),
                      Text(b['sub'] as String, style: const TextStyle(
                          color: Colors.white70, fontSize: 13)),
                      const SizedBox(height: 14),
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 9),
                        decoration: BoxDecoration(
                          color: h ? _orangeD : _orange,
                          borderRadius: BorderRadius.circular(10)),
                        child: Text(b['cta'] as String, style: const TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),
                      ),
                    ]),
                  ),
                ]),
              ));
            },
          ),
        ),
        const SizedBox(height: 10),
        Row(mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(_banners.length, (i) => AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            margin: const EdgeInsets.symmetric(horizontal: 3),
            width: _page == i ? 22 : 6, height: 6,
            decoration: BoxDecoration(
              color: _page == i ? _orange : Colors.grey.shade300,
              borderRadius: BorderRadius.circular(3)),
          ))),
      ]),
    );
  }
}

// ════════════════════════════════════════════════════
// PRODUCT CARD — with hover effect
// ════════════════════════════════════════════════════
class _ProductCard extends StatelessWidget {
  final _Product product;
  final VoidCallback onTap, onCart, onWishlist;
  const _ProductCard({required this.product, required this.onTap,
      required this.onCart, required this.onWishlist});

  @override
  Widget build(BuildContext context) {
    final wishlisted = _globalWishlist.contains(product.name);
    return _Hover(builder: (h) => GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: _card,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: h ? _orange.withValues(alpha: 0.4) : Colors.transparent),
          boxShadow: [BoxShadow(
            color: h ? _orange.withValues(alpha: 0.15) : Colors.black.withValues(alpha: 0.07),
            blurRadius: h ? 16 : 8, offset: const Offset(0, 3))],
        ),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: [
          // Image
          Stack(children: [
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(14)),
              child: CachedNetworkImage(imageUrl: product.image,
                height: 145, width: double.infinity, fit: BoxFit.cover,
                placeholder: (_, __) => Container(height: 145, color: Colors.grey[100],
                    child: const Center(child: CircularProgressIndicator(strokeWidth: 2, color: _navy))),
                errorWidget: (_, __, ___) => Container(height: 145, color: Colors.grey[100],
                    child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                      const Icon(Icons.laptop_mac, size: 44, color: _navy),
                      const SizedBox(height: 4),
                      Text(product.brand, style: TextStyle(fontSize: 10, color: Colors.grey[500])),
                    ])),
              ),
            ),
            Positioned(top: 8, left: 8,
              child: Container(padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                decoration: BoxDecoration(color: product.badgeColor, borderRadius: BorderRadius.circular(6)),
                child: Text(product.badge, style: const TextStyle(
                    color: Colors.white, fontSize: 8, fontWeight: FontWeight.bold)))),
            Positioned(top: 6, right: 6,
              child: GestureDetector(
                onTap: onWishlist,
                child: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: const BoxDecoration(color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 6)]),
                  child: Icon(wishlisted ? Icons.favorite : Icons.favorite_border,
                      color: wishlisted ? _red : Colors.grey, size: 15),
                ),
              )),
            // Hover overlay "View Details"
            if (h)
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    color: _navy.withValues(alpha: 0.3),
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(14))),
                  child: const Center(child: Text('View Details', style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13))),
                ),
              ),
          ]),
          // Info
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 8, 10, 10),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(product.brand, style: TextStyle(fontSize: 10, color: Colors.grey[500])),
              Text(product.name, maxLines: 1, overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: _navy)),
              const SizedBox(height: 3),
              Text(product.specs, maxLines: 1, overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 9, color: Colors.grey[500])),
              const SizedBox(height: 5),
              Row(children: [
                const Icon(Icons.star_rounded, size: 11, color: Colors.amber),
                const SizedBox(width: 2),
                Text('${product.rating} (${product.reviews})',
                    style: TextStyle(fontSize: 9, color: Colors.grey[600])),
              ]),
              const SizedBox(height: 7),
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text('\$${product.price.toStringAsFixed(0)}', style: const TextStyle(
                      fontSize: 15, fontWeight: FontWeight.bold, color: _orange)),
                  if (product.oldPrice > 0)
                    Text('\$${product.oldPrice.toStringAsFixed(0)}',
                        style: TextStyle(fontSize: 10, color: Colors.grey[400],
                            decoration: TextDecoration.lineThrough)),
                ]),
                GestureDetector(
                  onTap: onCart,
                  child: Container(
                    padding: const EdgeInsets.all(7),
                    decoration: BoxDecoration(color: _navy, borderRadius: BorderRadius.circular(8)),
                    child: const Icon(Icons.add_shopping_cart, color: Colors.white, size: 15),
                  ),
                ),
              ]),
            ]),
          ),
        ]),
      ),
    ));
  }
}

// ════════════════════════════════════════════════════
// FOOTER SECTION — fully clickable links
// ════════════════════════════════════════════════════
class _FooterSection extends StatelessWidget {
  const _FooterSection();
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 20),
      color: _navy,
      padding: const EdgeInsets.all(20),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Container(padding: const EdgeInsets.all(7),
            decoration: BoxDecoration(color: _orange.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(8)),
            child: const Icon(Icons.laptop_mac, color: _orange, size: 20)),
          const SizedBox(width: 8),
          const Text('LaptopHarbor', style: TextStyle(
              color: Colors.white, fontSize: 17, fontWeight: FontWeight.bold)),
        ]),
        const SizedBox(height: 8),
        Text('Your trusted destination for laptops.\nBest prices, top brands, fast delivery.',
            style: TextStyle(color: Colors.white.withValues(alpha: 0.55), fontSize: 12, height: 1.6)),
        const SizedBox(height: 16),
        const Divider(color: Colors.white12),
        const SizedBox(height: 14),
        const Text('Quick Links', style: TextStyle(
            color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold)),
        const SizedBox(height: 10),
        Wrap(spacing: 4, runSpacing: 2, children: [
          'Home', 'Products', 'Brands', 'Deals', 'About Us', 'Contact',
        ].map((l) => _FooterLink(label: l, onTap: () {
          if (l == 'About Us') Navigator.push(context, _fadeRoute(const _AboutPage()));
          else if (l == 'Contact') Navigator.push(context, _slideRoute(const _HelpPage()));
          else _snack(context, '$l page coming soon!');
        })).toList()),
        const SizedBox(height: 16),
        const Divider(color: Colors.white12),
        const SizedBox(height: 14),
        const Text('Contact', style: TextStyle(
            color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold)),
        const SizedBox(height: 10),
        _FooterContactRow(icon: Icons.email_outlined, text: 'support@laptopharbor.com',
            onTap: () => _snack(context, 'Email copied!')),
        const SizedBox(height: 7),
        _FooterContactRow(icon: Icons.phone_outlined, text: '+1 (800) 123-4567',
            onTap: () => _snack(context, 'Phone number copied!')),
        const SizedBox(height: 7),
        _FooterContactRow(icon: Icons.location_on_outlined, text: 'New York, USA',
            onTap: () => _snack(context, 'Location: New York, USA')),
        const SizedBox(height: 16),
        const Divider(color: Colors.white12),
        const SizedBox(height: 12),
        Row(children: [
          Expanded(child: Text('© 2025 LaptopHarbor. All rights reserved.',
              style: TextStyle(color: Colors.white.withValues(alpha: 0.35), fontSize: 11))),
          Row(children: [
            _SocialIconBtn(icon: Icons.facebook,        label: 'Facebook'),
            const SizedBox(width: 8),
            _SocialIconBtn(icon: Icons.camera_alt_outlined, label: 'Instagram'),
            const SizedBox(width: 8),
            _SocialIconBtn(icon: Icons.alternate_email, label: 'Twitter'),
          ]),
        ]),
      ]),
    );
  }
}

class _FooterLink extends StatefulWidget {
  final String label;
  final VoidCallback onTap;
  const _FooterLink({required this.label, required this.onTap});
  @override
  State<_FooterLink> createState() => _FooterLinkState();
}

class _FooterLinkState extends State<_FooterLink> {
  bool _h = false;
  @override
  Widget build(BuildContext context) => MouseRegion(
    onEnter: (_) => setState(() => _h = true),
    onExit: (_) => setState(() => _h = false),
    child: GestureDetector(
      onTap: widget.onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: Text(widget.label, style: TextStyle(
            color: _h ? _orange : Colors.white.withValues(alpha: 0.55),
            fontSize: 12,
            decoration: _h ? TextDecoration.underline : null,
            decorationColor: _orange)),
      ),
    ),
  );
}

class _FooterContactRow extends StatefulWidget {
  final IconData icon;
  final String text;
  final VoidCallback onTap;
  const _FooterContactRow({required this.icon, required this.text, required this.onTap});
  @override
  State<_FooterContactRow> createState() => _FooterContactRowState();
}

class _FooterContactRowState extends State<_FooterContactRow> {
  bool _h = false;
  @override
  Widget build(BuildContext context) => MouseRegion(
    onEnter: (_) => setState(() => _h = true),
    onExit: (_) => setState(() => _h = false),
    child: GestureDetector(
      onTap: widget.onTap,
      child: Row(children: [
        Icon(widget.icon, color: _h ? _orange : _orange.withValues(alpha: 0.7), size: 14),
        const SizedBox(width: 8),
        Text(widget.text, style: TextStyle(
            color: _h ? Colors.white : Colors.white.withValues(alpha: 0.55), fontSize: 12)),
      ]),
    ),
  );
}

class _SocialIconBtn extends StatefulWidget {
  final IconData icon;
  final String label;
  const _SocialIconBtn({required this.icon, required this.label});
  @override
  State<_SocialIconBtn> createState() => _SocialIconBtnState();
}

class _SocialIconBtnState extends State<_SocialIconBtn> {
  bool _h = false;
  @override
  Widget build(BuildContext context) => MouseRegion(
    onEnter: (_) => setState(() => _h = true),
    onExit: (_) => setState(() => _h = false),
    child: GestureDetector(
      onTap: () => Navigator.push(context, _fadeRoute(const _AboutPage())),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 32, height: 32,
        decoration: BoxDecoration(
          color: _h ? _orange : Colors.white.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(8)),
        child: Icon(widget.icon, color: Colors.white.withValues(alpha: _h ? 1 : 0.55), size: 16),
      ),
    ),
  );
}

// ════════════════════════════════════════════════════
// PRODUCT DETAIL PAGE — image gallery, full info
// ════════════════════════════════════════════════════
class _ProductDetailPage extends StatefulWidget {
  final _Product product;
  const _ProductDetailPage({required this.product});
  @override
  State<_ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<_ProductDetailPage> {
  int _imgIdx = 0;
  int _qty = 1;
  bool get _wishlisted => _globalWishlist.contains(widget.product.name);

  void _addCart() {
    final idx = _globalCart.indexWhere((c) => c['product'] == widget.product);
    if (idx >= 0) _globalCart[idx]['qty'] = (_globalCart[idx]['qty'] as int) + _qty;
    else _globalCart.add({'product': widget.product, 'qty': _qty});
    _snack(context, '${widget.product.name} × $_qty added to cart!', color: _green);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final p = widget.product;
    return Scaffold(
      backgroundColor: _bg,
      appBar: AppBar(
        backgroundColor: _navy, foregroundColor: Colors.white,
        title: Text(p.name, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            maxLines: 1, overflow: TextOverflow.ellipsis),
        actions: [
          IconButton(
            icon: Icon(_wishlisted ? Icons.favorite : Icons.favorite_border,
                color: _wishlisted ? _red : Colors.white),
            onPressed: () {
              setState(() {
                _wishlisted ? _globalWishlist.remove(p.name) : _globalWishlist.add(p.name);
              });
            },
          ),
          IconButton(
            icon: const Icon(Icons.share_outlined),
            onPressed: () => _snack(context, 'Share link copied!'),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          // Main image
          Stack(children: [
            CachedNetworkImage(imageUrl: p.images[_imgIdx],
              height: 280, width: double.infinity, fit: BoxFit.cover,
              placeholder: (_, __) => Container(height: 280, color: Colors.grey[100],
                  child: const Center(child: CircularProgressIndicator(color: _navy, strokeWidth: 2))),
              errorWidget: (_, __, ___) => Container(height: 280, color: Colors.grey[100],
                  child: const Center(child: Icon(Icons.laptop_mac, size: 80, color: _navy))),
            ),
            Positioned(bottom: 10, right: 12,
              child: Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(color: Colors.black54, borderRadius: BorderRadius.circular(20)),
                child: Text('${_imgIdx + 1}/${p.images.length}',
                    style: const TextStyle(color: Colors.white, fontSize: 11)))),
          ]),
          // Thumbnail row
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 10, 16, 0),
            child: Row(children: List.generate(p.images.length, (i) =>
              _Hover(builder: (h) => GestureDetector(
                onTap: () => setState(() => _imgIdx = i),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  margin: const EdgeInsets.only(right: 8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: _imgIdx == i ? _orange : (h ? _navy : Colors.grey.shade200),
                      width: _imgIdx == i ? 2.5 : 1.5),
                    boxShadow: [BoxShadow(color: (_imgIdx == i || h) ? _orange.withValues(alpha: 0.2) : Colors.transparent,
                        blurRadius: 8)],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(9),
                    child: CachedNetworkImage(imageUrl: p.images[i],
                      width: 68, height: 54, fit: BoxFit.cover,
                      placeholder: (_, __) => Container(width: 68, height: 54, color: Colors.grey[200]),
                      errorWidget: (_, __, ___) => Container(width: 68, height: 54,
                          color: Colors.grey[200], child: const Icon(Icons.laptop_mac, size: 28, color: _navy)),
                    ),
                  ),
                ),
              ))
            )),
          ),
          // Detail content
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(children: [
                Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(color: p.badgeColor, borderRadius: BorderRadius.circular(6)),
                  child: Text(p.badge, style: const TextStyle(
                      color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold))),
                const SizedBox(width: 8),
                Text(p.brand, style: TextStyle(color: Colors.grey[600], fontSize: 13)),
                const Spacer(),
                const Icon(Icons.verified, color: _green, size: 16),
                const SizedBox(width: 4),
                Text('In Stock', style: TextStyle(color: _green, fontSize: 12, fontWeight: FontWeight.w500)),
              ]),
              const SizedBox(height: 8),
              Text(p.name, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: _navy)),
              const SizedBox(height: 6),
              Text(p.specs, style: TextStyle(fontSize: 13, color: Colors.grey[600])),
              const SizedBox(height: 10),
              Row(children: [
                ...List.generate(5, (i) => Icon(
                  i < p.rating.floor() ? Icons.star_rounded : Icons.star_border_rounded,
                  color: Colors.amber, size: 18)),
                const SizedBox(width: 6),
                Text('${p.rating}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                Text('  (${p.reviews} reviews)', style: TextStyle(color: Colors.grey[600], fontSize: 13)),
              ]),
              const SizedBox(height: 14),
              Row(crossAxisAlignment: CrossAxisAlignment.end, children: [
                Text('\$${p.price.toStringAsFixed(0)}', style: const TextStyle(
                    fontSize: 32, fontWeight: FontWeight.bold, color: _orange)),
                if (p.oldPrice > 0) ...[
                  const SizedBox(width: 12),
                  Text('\$${p.oldPrice.toStringAsFixed(0)}', style: TextStyle(
                      fontSize: 18, color: Colors.grey[400], decoration: TextDecoration.lineThrough)),
                  const SizedBox(width: 8),
                  Container(padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                    decoration: BoxDecoration(color: _green.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(6)),
                    child: Text(
                      '${(((p.oldPrice - p.price) / p.oldPrice) * 100).toStringAsFixed(0)}% OFF',
                      style: const TextStyle(color: _green, fontSize: 11, fontWeight: FontWeight.bold))),
                ],
              ]),
              const SizedBox(height: 20),
              const Divider(),
              const SizedBox(height: 14),
              const Text('About this laptop', style: TextStyle(
                  fontSize: 16, fontWeight: FontWeight.bold, color: _navy)),
              const SizedBox(height: 8),
              Text(p.description, style: TextStyle(
                  fontSize: 13, color: Colors.grey[700], height: 1.7)),
              const SizedBox(height: 16),
              const Text('Key Specifications', style: TextStyle(
                  fontSize: 16, fontWeight: FontWeight.bold, color: _navy)),
              const SizedBox(height: 10),
              _specRow('Processor', p.specs.split('•')[0].trim()),
              _specRow('Memory', p.specs.contains('RAM') ? p.specs.split('•')[1].trim() : '-'),
              _specRow('Storage', p.specs.contains('SSD') ? p.specs.split('•')[2].trim() : '-'),
              _specRow('Display', p.specs.split('•').length > 3 ? p.specs.split('•')[3].trim() : 'Full HD IPS'),
              _specRow('OS', 'Windows 11 Home / macOS Sonoma'),
              _specRow('Battery', 'Up to 12-18 hours'),
              _specRow('Weight', '1.2 - 2.4 kg'),
              _specRow('Warranty', '1-Year Manufacturer Warranty'),
              const SizedBox(height: 20),
              // Quantity
              Row(children: [
                const Text('Quantity:', style: TextStyle(
                    fontSize: 14, fontWeight: FontWeight.w600, color: _navy)),
                const SizedBox(width: 14),
                Container(
                  decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(10)),
                  child: Row(children: [
                    IconButton(icon: const Icon(Icons.remove, size: 16),
                        onPressed: () { if (_qty > 1) setState(() => _qty--); }),
                    Text('$_qty', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    IconButton(icon: const Icon(Icons.add, size: 16),
                        onPressed: () => setState(() => _qty++)),
                  ]),
                ),
                const SizedBox(width: 14),
                Text('Total: \$${(p.price * _qty).toStringAsFixed(0)}',
                    style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: _orange)),
              ]),
              const SizedBox(height: 20),
              Row(children: [
                Expanded(child: _Hover(builder: (h) => OutlinedButton.icon(
                  onPressed: () => setState(() {
                    _wishlisted ? _globalWishlist.remove(p.name) : _globalWishlist.add(p.name);
                  }),
                  icon: Icon(_wishlisted ? Icons.favorite : Icons.favorite_border,
                      color: _wishlisted ? _red : _navy, size: 18),
                  label: Text(_wishlisted ? 'Wishlisted' : 'Wishlist',
                      style: const TextStyle(color: _navy, fontWeight: FontWeight.w600)),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    side: BorderSide(color: h ? _orange : _navy),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ))),
                const SizedBox(width: 12),
                Expanded(flex: 2, child: _Hover(builder: (h) => ElevatedButton.icon(
                  onPressed: _addCart,
                  icon: const Icon(Icons.shopping_cart, size: 18),
                  label: const Text('Add to Cart', style: TextStyle(
                      fontSize: 14, fontWeight: FontWeight.bold)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: h ? _navyL : _navy, foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    minimumSize: Size.zero,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    elevation: 0),
                ))),
              ]),
              const SizedBox(height: 12),
              _Hover(builder: (h) => SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.push(context, _scaleRoute(const _CheckoutPage())),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: h ? _orangeD : _orange, foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    minimumSize: Size.zero,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    elevation: 0),
                  child: const Text('Buy Now', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                ),
              )),
            ]),
          ),
          // Related products
          _buildRelatedSection(context, p),
          const _FooterSection(),
        ]),
      ),
    );
  }

  Widget _specRow(String label, String value) => Padding(
    padding: const EdgeInsets.only(bottom: 8),
    child: Row(children: [
      SizedBox(width: 120, child: Text(label, style: TextStyle(
          fontSize: 12, color: Colors.grey[600], fontWeight: FontWeight.w500))),
      Expanded(child: Text(value, style: const TextStyle(
          fontSize: 12, color: _navy, fontWeight: FontWeight.w500))),
    ]),
  );

  Widget _buildRelatedSection(BuildContext context, _Product current) {
    final related = _allProducts
        .where((p) => p.category == current.category && p.name != current.name)
        .take(4).toList();
    if (related.isEmpty) return const SizedBox();
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Text('You May Also Like', style: TextStyle(
            fontSize: 16, fontWeight: FontWeight.bold, color: _navy)),
        const SizedBox(height: 10),
        SizedBox(
          height: 190,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: related.length,
            separatorBuilder: (_, __) => const SizedBox(width: 12),
            itemBuilder: (_, i) {
              final p = related[i];
              return _Hover(builder: (h) => GestureDetector(
                onTap: () => Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (_) => _ProductDetailPage(product: p))),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: 155,
                  decoration: BoxDecoration(
                    color: _card, borderRadius: BorderRadius.circular(14),
                    boxShadow: [BoxShadow(
                      color: h ? _orange.withValues(alpha: 0.15) : Colors.black.withValues(alpha: 0.06),
                      blurRadius: h ? 14 : 7, offset: const Offset(0, 3))],
                  ),
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    ClipRRect(
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(14)),
                      child: CachedNetworkImage(imageUrl: p.image,
                        height: 110, width: double.infinity, fit: BoxFit.cover,
                        placeholder: (_, __) => Container(height: 110, color: Colors.grey[100]),
                        errorWidget: (_, __, ___) => Container(height: 110, color: Colors.grey[100],
                            child: const Icon(Icons.laptop_mac, size: 40, color: _navy))),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Text(p.name, maxLines: 1, overflow: TextOverflow.ellipsis,
                            style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: _navy)),
                        const SizedBox(height: 3),
                        Text('\$${p.price.toStringAsFixed(0)}',
                            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: _orange)),
                        const SizedBox(height: 2),
                        Row(children: [
                          const Icon(Icons.star_rounded, size: 11, color: Colors.amber),
                          Text(' ${p.rating}', style: TextStyle(fontSize: 10, color: Colors.grey[600])),
                        ]),
                      ]),
                    ),
                  ]),
                ),
              ));
            },
          ),
        ),
      ]),
    );
  }
}

// ════════════════════════════════════════════════════
// CART PAGE — full featured
// ════════════════════════════════════════════════════
class _CartPage extends StatefulWidget {
  const _CartPage();
  @override
  State<_CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<_CartPage> {
  double get _sub => _globalCart.fold(0.0,
      (s, c) => s + (c['product'] as _Product).price * (c['qty'] as int));
  double get _tax => _sub * 0.08;
  double get _total => _sub + _tax;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      appBar: AppBar(
        backgroundColor: _navy, foregroundColor: Colors.white,
        title: Text('My Cart (${_globalCart.length} items)',
            style: const TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          if (_globalCart.isNotEmpty)
            TextButton(
              onPressed: () { setState(() => _globalCart.clear()); },
              child: const Text('Clear', style: TextStyle(color: Colors.white70)),
            ),
        ],
      ),
      body: _globalCart.isEmpty ? _emptyCart() : Column(children: [
        Expanded(
          child: SingleChildScrollView(child: Column(children: [
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.all(16),
              itemCount: _globalCart.length,
              itemBuilder: (_, i) => _cartItem(i),
            ),
            _orderSummary(),
            const _FooterSection(),
          ])),
        ),
        _checkoutBar(),
      ]),
    );
  }

  Widget _emptyCart() => Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
    Icon(Icons.shopping_cart_outlined, size: 90, color: Colors.grey[300]),
    const SizedBox(height: 20),
    const Text('Your cart is empty', style: TextStyle(
        fontSize: 20, fontWeight: FontWeight.bold, color: Colors.grey)),
    const SizedBox(height: 8),
    Text('Add laptops to your cart to see them here',
        style: TextStyle(fontSize: 13, color: Colors.grey[500])),
    const SizedBox(height: 28),
    _Hover(builder: (h) => ElevatedButton.icon(
      onPressed: () => Navigator.pop(context),
      icon: const Icon(Icons.laptop_mac),
      label: const Text('Browse Laptops', style: TextStyle(fontWeight: FontWeight.bold)),
      style: ElevatedButton.styleFrom(
        backgroundColor: h ? _navyL : _navy, foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 0),
    )),
  ]));

  Widget _cartItem(int i) {
    final p = _globalCart[i]['product'] as _Product;
    final qty = _globalCart[i]['qty'] as int;
    return _Hover(builder: (h) => AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: _card,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: h ? _orange.withValues(alpha: 0.3) : Colors.transparent),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 6)],
      ),
      child: Row(children: [
        ClipRRect(
          borderRadius: const BorderRadius.horizontal(left: Radius.circular(14)),
          child: CachedNetworkImage(imageUrl: p.image,
            width: 105, height: 95, fit: BoxFit.cover,
            placeholder: (_, __) => Container(width: 105, height: 95, color: Colors.grey[100]),
            errorWidget: (_, __, ___) => Container(width: 105, height: 95,
                color: Colors.grey[100], child: const Icon(Icons.laptop_mac, color: _navy, size: 36)),
          ),
        ),
        Expanded(child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(p.brand, style: TextStyle(fontSize: 10, color: Colors.grey[500])),
            Text(p.name, maxLines: 1, overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: _navy)),
            const SizedBox(height: 2),
            Text(p.specs, maxLines: 1, overflow: TextOverflow.ellipsis,
                style: TextStyle(fontSize: 10, color: Colors.grey[500])),
            const SizedBox(height: 8),
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Text('\$${(p.price * qty).toStringAsFixed(0)}',
                  style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: _orange)),
              Row(children: [
                _QtyBtn(icon: Icons.remove, onTap: () => setState(() {
                  if (qty > 1) _globalCart[i]['qty'] = qty - 1;
                  else _globalCart.removeAt(i);
                })),
                Padding(padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Text('$qty', style: const TextStyle(
                      fontSize: 15, fontWeight: FontWeight.bold, color: _navy))),
                _QtyBtn(icon: Icons.add, onTap: () => setState(() {
                  _globalCart[i]['qty'] = qty + 1;
                })),
              ]),
            ]),
          ]),
        )),
        IconButton(
          icon: Icon(Icons.delete_outline, color: Colors.red.shade400, size: 20),
          onPressed: () => setState(() => _globalCart.removeAt(i)),
        ),
      ]),
    ));
  }

  Widget _orderSummary() => Container(
    margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
    padding: const EdgeInsets.all(18),
    decoration: BoxDecoration(color: _card, borderRadius: BorderRadius.circular(14),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 6)]),
    child: Column(children: [
      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        const Text('Order Summary', style: TextStyle(
            fontSize: 15, fontWeight: FontWeight.bold, color: _navy)),
        Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
          decoration: BoxDecoration(color: _green.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(6)),
          child: const Text('Free Shipping', style: TextStyle(
              color: _green, fontSize: 11, fontWeight: FontWeight.bold))),
      ]),
      const SizedBox(height: 14),
      _sumRow('Subtotal (${_globalCart.length} items)', '\$${_sub.toStringAsFixed(0)}'),
      const SizedBox(height: 6),
      _sumRow('Shipping', 'FREE', valueColor: _green),
      const SizedBox(height: 6),
      _sumRow('Tax (8%)', '\$${_tax.toStringAsFixed(0)}'),
      const Padding(padding: EdgeInsets.symmetric(vertical: 10), child: Divider()),
      _sumRow('Total', '\$${_total.toStringAsFixed(0)}', bold: true),
    ]),
  );

  Widget _sumRow(String label, String value, {Color? valueColor, bool bold = false}) =>
    Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      Text(label, style: TextStyle(fontSize: 13,
          color: bold ? _navy : Colors.grey[600],
          fontWeight: bold ? FontWeight.bold : FontWeight.normal)),
      Text(value, style: TextStyle(fontSize: 13,
          color: valueColor ?? (bold ? _orange : _navy),
          fontWeight: bold ? FontWeight.bold : FontWeight.w500)),
    ]);

  Widget _checkoutBar() => Container(
    color: Colors.white,
    padding: const EdgeInsets.all(16),
    child: _Hover(builder: (h) => SizedBox(
      width: double.infinity, height: 52,
      child: ElevatedButton(
        onPressed: () => Navigator.push(context, _scaleRoute(const _CheckoutPage())),
        style: ElevatedButton.styleFrom(
          backgroundColor: h ? _orangeD : _orange, foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          elevation: 0),
        child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          const Icon(Icons.lock_outline, size: 18),
          const SizedBox(width: 8),
          Text('Proceed to Checkout — \$${_total.toStringAsFixed(0)}',
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
        ]),
      ),
    )),
  );
}

class _QtyBtn extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const _QtyBtn({required this.icon, required this.onTap});
  @override
  Widget build(BuildContext context) => _Hover(builder: (h) => GestureDetector(
    onTap: onTap,
    child: AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      width: 28, height: 28,
      decoration: BoxDecoration(
        color: h ? _navy : _bg,
        borderRadius: BorderRadius.circular(7),
        border: Border.all(color: h ? _navy : Colors.grey.shade300)),
      child: Icon(icon, size: 14, color: h ? Colors.white : _navy),
    ),
  ));
}

// ════════════════════════════════════════════════════
// WISHLIST PAGE — fully functional
// ════════════════════════════════════════════════════
// WISHLIST PAGE — Beautiful Grid + List Toggle
// ════════════════════════════════════════════════════
class _WishlistPage extends StatefulWidget {
  const _WishlistPage();
  @override
  State<_WishlistPage> createState() => _WishlistPageState();
}

class _WishlistPageState extends State<_WishlistPage> {
  bool _gridView = true;

  List<_Product> get _items =>
      _allProducts.where((p) => _globalWishlist.contains(p.name)).toList();

  void _remove(_Product p) {
    setState(() => _globalWishlist.remove(p.name));
    _snack(context, '${p.name} removed from wishlist ❌');
  }

  void _addCart(_Product p) {
    final idx = _globalCart.indexWhere((c) => c['product'] == p);
    if (idx >= 0) {
      _globalCart[idx]['qty'] = (_globalCart[idx]['qty'] as int) + 1;
    } else {
      _globalCart.add({'product': p, 'qty': 1});
    }
    setState(() => _globalWishlist.remove(p.name));
    _snack(context, '${p.name} moved to cart! 🛒', color: _green);
  }

  @override
  Widget build(BuildContext context) {
    final items = _items;
    return Scaffold(
      backgroundColor: _bg,
      body: CustomScrollView(
        slivers: [
          // ── Beautiful SliverAppBar ─────────────────
          SliverAppBar(
            expandedHeight: 160,
            pinned: true,
            backgroundColor: _navy,
            foregroundColor: Colors.white,
            actions: [
              if (items.isNotEmpty) ...[
                IconButton(
                  icon: Icon(_gridView ? Icons.view_list_rounded : Icons.grid_view_rounded),
                  onPressed: () => setState(() => _gridView = !_gridView),
                  tooltip: _gridView ? 'List View' : 'Grid View',
                ),
                TextButton(
                  onPressed: () { setState(() => _globalWishlist.clear()); _snack(context, 'Wishlist cleared'); },
                  child: const Text('Clear All', style: TextStyle(color: Colors.white60, fontSize: 12)),
                ),
              ],
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF1A0533), _navy],
                    begin: Alignment.topLeft, end: Alignment.bottomRight)),
                child: Stack(children: [
                  // decorative circles
                  Positioned(top: -30, right: -30,
                    child: Container(width: 160, height: 160,
                      decoration: BoxDecoration(shape: BoxShape.circle,
                        color: _red.withValues(alpha: 0.12)))),
                  Positioned(bottom: -20, left: 60,
                    child: Container(width: 100, height: 100,
                      decoration: BoxDecoration(shape: BoxShape.circle,
                        color: _orange.withValues(alpha: 0.08)))),
                  // Content
                  Positioned(left: 20, right: 20, bottom: 20,
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min, children: [
                      Row(children: [
                        Container(padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(color: _red.withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(12)),
                          child: const Icon(Icons.favorite_rounded, color: _red, size: 22)),
                        const SizedBox(width: 12),
                        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          const Text('My Wishlist', style: TextStyle(
                              color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
                          Text('${items.length} saved laptop${items.length == 1 ? '' : 's'}',
                              style: TextStyle(color: Colors.white.withValues(alpha: 0.6), fontSize: 13)),
                        ]),
                      ]),
                    ])),
                ]),
              ),
            ),
          ),

          if (items.isEmpty)
            SliverFillRemaining(child: _emptyState())
          else if (_gridView)
            SliverPadding(
              padding: const EdgeInsets.all(16),
              sliver: SliverGrid(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, mainAxisSpacing: 14,
                  crossAxisSpacing: 14, childAspectRatio: 0.62),
                delegate: SliverChildBuilderDelegate(
                  (_, i) => _gridItem(items[i]),
                  childCount: items.length),
              ),
            )
          else
            SliverPadding(
              padding: const EdgeInsets.all(16),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (_, i) => _listItem(items[i]),
                  childCount: items.length),
              ),
            ),

          const SliverToBoxAdapter(child: _FooterSection()),
        ],
      ),
    );
  }

  // ── Grid Item ──────────────────────────────────────
  Widget _gridItem(_Product p) => _Hover(builder: (h) => GestureDetector(
    onTap: () => Navigator.push(context,
        MaterialPageRoute(builder: (_) => _ProductDetailPage(product: p))),
    child: AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      decoration: BoxDecoration(
        color: _card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: h ? _red.withValues(alpha: 0.4) : Colors.transparent, width: 1.5),
        boxShadow: [BoxShadow(
          color: h ? _red.withValues(alpha: 0.12) : Colors.black.withValues(alpha: 0.06),
          blurRadius: h ? 18 : 8, offset: const Offset(0, 3))],
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        // Image + badges
        Stack(children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            child: CachedNetworkImage(imageUrl: p.image,
              height: 145, width: double.infinity, fit: BoxFit.cover,
              placeholder: (_, __) => Container(height: 145, color: Colors.grey[100],
                  child: const Center(child: CircularProgressIndicator(strokeWidth: 2, color: _navy))),
              errorWidget: (_, __, ___) => Container(height: 145, color: Colors.grey[100],
                  child: const Icon(Icons.laptop_mac, size: 50, color: _navy))),
          ),
          // Badge
          Positioned(top: 8, left: 8,
            child: Container(padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
              decoration: BoxDecoration(color: p.badgeColor, borderRadius: BorderRadius.circular(6)),
              child: Text(p.badge, style: const TextStyle(
                  color: Colors.white, fontSize: 8, fontWeight: FontWeight.bold)))),
          // Remove heart
          Positioned(top: 6, right: 6,
            child: GestureDetector(
              onTap: () => _remove(p),
              child: Container(padding: const EdgeInsets.all(6),
                decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle,
                    boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 6)]),
                child: const Icon(Icons.favorite_rounded, color: _red, size: 16)))),
          // Hover overlay
          if (h)
            Positioned.fill(child: Container(
              decoration: BoxDecoration(
                color: _navy.withValues(alpha: 0.25),
                borderRadius: const BorderRadius.vertical(top: Radius.circular(16))),
              child: const Center(child: Icon(Icons.open_in_new, color: Colors.white, size: 28)))),
        ]),
        // Info
        Padding(
          padding: const EdgeInsets.fromLTRB(10, 9, 10, 0),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(p.brand, style: TextStyle(fontSize: 9, color: Colors.grey[500],
                fontWeight: FontWeight.w500, letterSpacing: 0.5)),
            const SizedBox(height: 3),
            Text(p.name, maxLines: 1, overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: _navy)),
            const SizedBox(height: 3),
            Row(children: [
              const Icon(Icons.star_rounded, size: 11, color: Colors.amber),
              Text(' ${p.rating} (${p.reviews})',
                  style: TextStyle(fontSize: 9, color: Colors.grey[600])),
            ]),
            const SizedBox(height: 6),
            Row(children: [
              Text('\$${p.price.toStringAsFixed(0)}',
                  style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: _orange)),
              if (p.oldPrice > 0) ...[
                const SizedBox(width: 5),
                Text('\$${p.oldPrice.toStringAsFixed(0)}',
                    style: TextStyle(fontSize: 9, color: Colors.grey[400],
                        decoration: TextDecoration.lineThrough)),
              ],
            ]),
            const SizedBox(height: 8),
            // Add to Cart button
            _Hover(builder: (hb) => GestureDetector(
              onTap: () => _addCart(p),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 150),
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 9),
                decoration: BoxDecoration(
                  color: hb ? _navyL : _navy,
                  borderRadius: BorderRadius.circular(10)),
                child: const Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Icon(Icons.shopping_cart, color: Colors.white, size: 14),
                  SizedBox(width: 5),
                  Text('Add to Cart', style: TextStyle(
                      color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold)),
                ]),
              ),
            )),
            const SizedBox(height: 8),
          ]),
        ),
      ]),
    ),
  ));

  // ── List Item ──────────────────────────────────────
  Widget _listItem(_Product p) => _Hover(builder: (h) => GestureDetector(
    onTap: () => Navigator.push(context,
        MaterialPageRoute(builder: (_) => _ProductDetailPage(product: p))),
    child: AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: _card, borderRadius: BorderRadius.circular(16),
        border: Border.all(color: h ? _orange.withValues(alpha: 0.35) : Colors.transparent),
        boxShadow: [BoxShadow(
          color: h ? _orange.withValues(alpha: 0.1) : Colors.black.withValues(alpha: 0.05),
          blurRadius: h ? 14 : 6, offset: const Offset(0, 3))],
      ),
      child: Row(children: [
        // Image
        ClipRRect(
          borderRadius: const BorderRadius.horizontal(left: Radius.circular(16)),
          child: CachedNetworkImage(imageUrl: p.image,
            width: 110, height: 115, fit: BoxFit.cover,
            placeholder: (_, __) => Container(width: 110, height: 115, color: Colors.grey[100],
                child: const Icon(Icons.laptop_mac, color: _navy, size: 36)),
            errorWidget: (_, __, ___) => Container(width: 110, height: 115, color: Colors.grey[100],
                child: const Icon(Icons.laptop_mac, color: _navy, size: 36))),
        ),
        Expanded(child: Padding(
          padding: const EdgeInsets.fromLTRB(13, 12, 10, 12),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [
              Container(padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(color: p.badgeColor, borderRadius: BorderRadius.circular(4)),
                child: Text(p.badge, style: const TextStyle(
                    color: Colors.white, fontSize: 8, fontWeight: FontWeight.bold))),
            ]),
            const SizedBox(height: 4),
            Text(p.name, maxLines: 1, overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: _navy)),
            const SizedBox(height: 2),
            Text(p.specs, maxLines: 1, overflow: TextOverflow.ellipsis,
                style: TextStyle(fontSize: 10, color: Colors.grey[500])),
            const SizedBox(height: 5),
            Row(children: [
              const Icon(Icons.star_rounded, size: 12, color: Colors.amber),
              Text(' ${p.rating} (${p.reviews})',
                  style: TextStyle(fontSize: 10, color: Colors.grey[600])),
            ]),
            const SizedBox(height: 6),
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('\$${p.price.toStringAsFixed(0)}',
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: _orange)),
                if (p.oldPrice > 0)
                  Text('\$${p.oldPrice.toStringAsFixed(0)}',
                      style: TextStyle(fontSize: 10, color: Colors.grey[400],
                          decoration: TextDecoration.lineThrough)),
              ]),
              Row(children: [
                // Remove
                GestureDetector(
                  onTap: () => _remove(p),
                  child: Container(padding: const EdgeInsets.all(7),
                    decoration: BoxDecoration(color: _red.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8)),
                    child: const Icon(Icons.delete_outline, color: _red, size: 17))),
                const SizedBox(width: 8),
                // Cart
                _Hover(builder: (hb) => GestureDetector(
                  onTap: () => _addCart(p),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 150),
                    padding: const EdgeInsets.all(7),
                    decoration: BoxDecoration(
                      color: hb ? _navyL : _navy,
                      borderRadius: BorderRadius.circular(8)),
                    child: const Icon(Icons.shopping_cart, color: Colors.white, size: 17)))),
              ]),
            ]),
          ]),
        )),
      ]),
    ),
  ));

  Widget _emptyState() => Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
    Container(padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(color: _red.withValues(alpha: 0.08), shape: BoxShape.circle),
      child: Icon(Icons.favorite_outline_rounded, size: 72, color: _red.withValues(alpha: 0.5))),
    const SizedBox(height: 24),
    const Text('Your wishlist is empty', style: TextStyle(
        fontSize: 20, fontWeight: FontWeight.bold, color: _navy)),
    const SizedBox(height: 8),
    Text('Save laptops you love by tapping ❤️', style: TextStyle(
        fontSize: 13, color: Colors.grey[500])),
    const SizedBox(height: 28),
    _Hover(builder: (h) => ElevatedButton.icon(
      onPressed: () => Navigator.pop(context),
      icon: const Icon(Icons.laptop_mac, size: 18),
      label: const Text('Browse Laptops', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
      style: ElevatedButton.styleFrom(
        backgroundColor: h ? _navyL : _navy, foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        elevation: 0),
    )),
  ]));
}

// ════════════════════════════════════════════════════
// PROFILE PAGE — Beautiful Design
// ════════════════════════════════════════════════════
class _ProfilePage extends StatelessWidget {
  const _ProfilePage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 280, pinned: true,
            backgroundColor: _navy, foregroundColor: Colors.white,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF0A0E1A), _navy, Color(0xFF1A3A5C)],
                    begin: Alignment.topLeft, end: Alignment.bottomRight)),
                child: Stack(children: [
                  Positioned(top: -40, right: -40,
                    child: Container(width: 200, height: 200,
                      decoration: BoxDecoration(shape: BoxShape.circle,
                          color: _orange.withValues(alpha: 0.08)))),
                  Positioned(bottom: 10, left: -30,
                    child: Container(width: 140, height: 140,
                      decoration: BoxDecoration(shape: BoxShape.circle,
                          color: _orange.withValues(alpha: 0.05)))),
                  SafeArea(child: Padding(
                    padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
                    child: Column(mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Row(crossAxisAlignment: CrossAxisAlignment.end, children: [
                        Stack(clipBehavior: Clip.none, children: [
                          Container(width: 82, height: 82,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: const LinearGradient(
                                  colors: [_orange, Color(0xFFFF8C42)],
                                  begin: Alignment.topLeft, end: Alignment.bottomRight),
                              boxShadow: [BoxShadow(color: _orange.withValues(alpha: 0.45),
                                  blurRadius: 20, spreadRadius: 2)]),
                            child: const Icon(Icons.person_rounded, color: Colors.white, size: 42)),
                          Positioned(bottom: 0, right: 0,
                            child: Container(width: 26, height: 26,
                              decoration: BoxDecoration(color: Colors.white,
                                  shape: BoxShape.circle,
                                  border: Border.all(color: _navy, width: 2)),
                              child: const Icon(Icons.camera_alt, color: _navy, size: 12))),
                        ]),
                        const SizedBox(width: 16),
                        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.end, children: [
                          const Text('Welcome back! 👋',
                              style: TextStyle(color: Colors.white60, fontSize: 12)),
                          const SizedBox(height: 3),
                          const Text('Guest User', style: TextStyle(
                              color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 3),
                          Row(children: [
                            Container(width: 8, height: 8,
                                decoration: const BoxDecoration(
                                    color: Color(0xFF4CAF50), shape: BoxShape.circle)),
                            const SizedBox(width: 5),
                            Text('Active', style: TextStyle(
                                color: Colors.white.withValues(alpha: 0.6), fontSize: 12)),
                          ]),
                        ])),
                        _Hover(builder: (h) => GestureDetector(
                          onTap: () => Navigator.push(context, _slideRoute(const _EditProfilePage())),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            padding: const EdgeInsets.all(9),
                            decoration: BoxDecoration(
                              color: h ? _orange : Colors.white.withValues(alpha: 0.12),
                              borderRadius: BorderRadius.circular(10)),
                            child: const Icon(Icons.edit_rounded, color: Colors.white, size: 18)))),
                      ]),
                      const SizedBox(height: 20),
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.08),
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: Colors.white.withValues(alpha: 0.12))),
                        child: Row(children: [
                          _HeaderStat(value: '${_globalCart.length}', label: 'Cart',
                              icon: Icons.shopping_cart_outlined),
                          _vLine(),
                          _HeaderStat(value: '${_globalWishlist.length}', label: 'Wishlist',
                              icon: Icons.favorite_outline_rounded),
                          _vLine(),
                          const _HeaderStat(value: '3', label: 'Orders',
                              icon: Icons.shopping_bag_outlined),
                          _vLine(),
                          const _HeaderStat(value: '2', label: 'Reviews',
                              icon: Icons.star_outline_rounded),
                        ]),
                      ),
                    ]),
                  )),
                ]),
              ),
            ),
          ),
          SliverToBoxAdapter(child: _buildBody(context)),
        ],
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    return Column(children: [
      const SizedBox(height: 20),
      // Login Banner
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFFFFF3EE), Color(0xFFFFE8DB)],
              begin: Alignment.topLeft, end: Alignment.bottomRight),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: _orange.withValues(alpha: 0.2))),
          child: Row(children: [
            Container(padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(color: _orange.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(12)),
              child: const Icon(Icons.lock_open_rounded, color: _orange, size: 26)),
            const SizedBox(width: 14),
            const Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                children: [
              Text('Sign in for full access', style: TextStyle(
                  color: _navy, fontSize: 14, fontWeight: FontWeight.bold)),
              SizedBox(height: 3),
              Text('Save orders, sync wishlist & get exclusive deals',
                  style: TextStyle(color: Color(0xFF888888), fontSize: 11, height: 1.4)),
            ])),
            const SizedBox(width: 10),
            _Hover(builder: (h) => GestureDetector(
              onTap: () => Navigator.push(context, _slideRoute(const _LoginPage())),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                decoration: BoxDecoration(
                  color: h ? _orangeD : _orange,
                  borderRadius: BorderRadius.circular(12)),
                child: const Text('Login', style: TextStyle(
                    color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold))),
            )),
          ]),
        ),
      ),
      const SizedBox(height: 20),
      // Big Action Cards
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Text('Quick Access', style: TextStyle(
              fontSize: 15, fontWeight: FontWeight.bold, color: _navy)),
          const SizedBox(height: 12),
          Row(children: [
            _BigAction(icon: Icons.shopping_cart_outlined, label: 'My Cart',
              count: _globalCart.length,
              gradient: const [Color(0xFFFFF3EE), Color(0xFFFFE8DB)],
              iconColor: _orange,
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const _CartPage()))),
            const SizedBox(width: 12),
            _BigAction(icon: Icons.favorite_rounded, label: 'Wishlist',
              count: _globalWishlist.length,
              gradient: const [Color(0xFFFFF0F0), Color(0xFFFFE0E0)],
              iconColor: _red,
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const _WishlistPage()))),
            const SizedBox(width: 12),
            _BigAction(icon: Icons.shopping_bag_outlined, label: 'Orders',
              count: 3,
              gradient: const [Color(0xFFEFF8F0), Color(0xFFDDF0DF)],
              iconColor: Color(0xFF2E7D32),
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const _OrdersPage()))),
            const SizedBox(width: 12),
            _BigAction(icon: Icons.notifications_outlined, label: 'Alerts',
              count: 3,
              gradient: const [Color(0xFFEDF3FF), Color(0xFFDDE8FF)],
              iconColor: Color(0xFF1565C0),
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const _NotificationPage()))),
          ]),
        ]),
      ),
      const SizedBox(height: 20),
      _profileSection(context, 'ACCOUNT', [
        _PItem(Icons.person_outline_rounded,   'Edit Profile',      const Color(0xFF1565C0), () => Navigator.push(context, MaterialPageRoute(builder: (_) => const _EditProfilePage()))),
        _PItem(Icons.email_outlined,            'Email Preferences', const Color(0xFF6A1B9A), () => Navigator.push(context, MaterialPageRoute(builder: (_) => const _EmailPrefPage()))),
        _PItem(Icons.location_on_outlined,      'Saved Addresses',  const Color(0xFF2E7D32), () => Navigator.push(context, MaterialPageRoute(builder: (_) => const _AddressesPage()))),
        _PItem(Icons.payment_outlined,          'Payment Methods',  const Color(0xFFFF9800), () => Navigator.push(context, MaterialPageRoute(builder: (_) => const _PaymentPage()))),
      ]),
      const SizedBox(height: 12),
      _profileSection(context, 'ORDERS & SUPPORT', [
        _PItem(Icons.shopping_bag_outlined,     'My Orders',         const Color(0xFF2E7D32), () => Navigator.push(context, MaterialPageRoute(builder: (_) => const _OrdersPage()))),
        _PItem(Icons.track_changes_outlined,    'Track Order',       _orange,                () => Navigator.push(context, MaterialPageRoute(builder: (_) => const _OrdersPage()))),
        _PItem(Icons.replay_outlined,           'Returns & Refunds', _red,                   () => Navigator.push(context, MaterialPageRoute(builder: (_) => const _ReturnsPage()))),
        _PItem(Icons.support_agent_outlined,    'Help & Support',    const Color(0xFF455A64), () => Navigator.push(context, MaterialPageRoute(builder: (_) => const _HelpPage()))),
      ]),
      const SizedBox(height: 12),
      _profileSection(context, 'APP SETTINGS', [
        _PItem(Icons.notifications_outlined,    'Notifications',     const Color(0xFF0097A7), () => Navigator.push(context, MaterialPageRoute(builder: (_) => const _NotificationPage()))),
        _PItem(Icons.dark_mode_outlined,        'Dark Mode',         const Color(0xFF37474F), () => Navigator.push(context, MaterialPageRoute(builder: (_) => const _AboutPage()))),
        _PItem(Icons.info_outline_rounded,      'About LaptopHarbor',const Color(0xFF546E7A), () => Navigator.push(context, MaterialPageRoute(builder: (_) => const _AboutPage()))),
      ]),
      const SizedBox(height: 16),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: _Hover(builder: (h) => GestureDetector(
          onTap: () => _snack(context, 'Signed out! See you soon 👋'),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 15),
            decoration: BoxDecoration(
              color: h ? _red : _red.withValues(alpha: 0.07),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: h ? _red : _red.withValues(alpha: 0.25))),
            child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              Icon(Icons.logout_rounded, color: h ? Colors.white : _red, size: 20),
              const SizedBox(width: 8),
              Text('Sign Out', style: TextStyle(
                  color: h ? Colors.white : _red,
                  fontSize: 15, fontWeight: FontWeight.bold)),
            ]),
          ),
        )),
      ),
      const SizedBox(height: 24),
      const _FooterSection(),
    ]);
  }

  Widget _vLine() => Container(width: 1, height: 32,
      color: Colors.white.withValues(alpha: 0.15));

  Widget _profileSection(BuildContext context, String title, List<_PItem> items) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Padding(padding: const EdgeInsets.only(bottom: 10, left: 4),
          child: Text(title, style: const TextStyle(
              fontSize: 11, fontWeight: FontWeight.bold,
              color: Color(0xFF999999), letterSpacing: 1.0))),
        Container(
          decoration: BoxDecoration(color: _card, borderRadius: BorderRadius.circular(16),
              boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 8)]),
          child: Column(children: List.generate(items.length, (i) => Column(children: [
            _Hover(builder: (h) => GestureDetector(
              onTap: items[i].onTap,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                decoration: BoxDecoration(
                  color: h ? items[i].color.withValues(alpha: 0.04) : Colors.transparent,
                  borderRadius: BorderRadius.circular(16)),
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 3),
                  leading: Container(width: 40, height: 40,
                    decoration: BoxDecoration(
                      color: items[i].color.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(11)),
                    child: Icon(items[i].icon, color: items[i].color, size: 20)),
                  title: Text(items[i].label, style: const TextStyle(
                      fontSize: 14, color: _navy, fontWeight: FontWeight.w500)),
                  trailing: Icon(Icons.arrow_forward_ios_rounded,
                      color: h ? items[i].color : Colors.grey.shade300, size: 14)),
              ),
            )),
            if (i < items.length - 1)
              Divider(height: 1, indent: 70, endIndent: 16, color: Colors.grey.shade100),
          ]))),
        ),
      ]),
    );
  }
}

// ── Profile helper classes ─────────────────────────
class _PItem {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;
  const _PItem(this.icon, this.label, this.color, this.onTap);
}

class _HeaderStat extends StatelessWidget {
  final String value, label;
  final IconData icon;
  const _HeaderStat({required this.value, required this.label, required this.icon});
  @override
  Widget build(BuildContext context) => Expanded(child: Column(
    mainAxisAlignment: MainAxisAlignment.center, children: [
    Icon(icon, color: Colors.white.withValues(alpha: 0.7), size: 16),
    const SizedBox(height: 3),
    Text(value, style: const TextStyle(
        color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
    Text(label, style: TextStyle(
        color: Colors.white.withValues(alpha: 0.55), fontSize: 9)),
  ]));
}

class _BigAction extends StatelessWidget {
  final IconData icon;
  final String label;
  final int count;
  final List<Color> gradient;
  final Color iconColor;
  final VoidCallback onTap;
  const _BigAction({required this.icon, required this.label, required this.count,
      required this.gradient, required this.iconColor, required this.onTap});
  @override
  Widget build(BuildContext context) => Expanded(child: _Hover(builder: (h) => GestureDetector(
    onTap: onTap,
    child: AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 4),
      decoration: BoxDecoration(
        color: h ? iconColor.withValues(alpha: 0.1) : Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: h ? iconColor.withValues(alpha: 0.4) : Colors.grey.shade100),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: h ? 0.06 : 0.03),
            blurRadius: h ? 12 : 5, offset: const Offset(0, 2))]),
      child: Column(children: [
        Stack(clipBehavior: Clip.none, children: [
          Container(padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: gradient,
                  begin: Alignment.topLeft, end: Alignment.bottomRight),
              borderRadius: BorderRadius.circular(10)),
            child: Icon(icon, color: iconColor, size: 20)),
          if (count > 0)
            Positioned(top: -4, right: -4,
              child: Container(padding: const EdgeInsets.all(3),
                decoration: BoxDecoration(color: iconColor, shape: BoxShape.circle),
                child: Text('$count', style: const TextStyle(
                    color: Colors.white, fontSize: 8, fontWeight: FontWeight.bold)))),
        ]),
        const SizedBox(height: 7),
        Text(label, style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600,
            color: h ? iconColor : _navy), textAlign: TextAlign.center),
      ]),
    ),
  )));
}

// ════════════════════════════════════════════════════
// ORDERS PAGE — full UI
// ════════════════════════════════════════════════════
class _OrdersPage extends StatelessWidget {
  const _OrdersPage();

  static const _orders = [
    {'id': '#ORD-2024-001', 'name': 'Dell XPS 15', 'status': 'Delivered',   'date': 'Nov 15, 2024', 'price': 1299, 'color': Color(0xFF2E7D32),
     'img': 'https://images.unsplash.com/photo-1593642632559-0c6d3fc62b89?w=200&q=80'},
    {'id': '#ORD-2024-002', 'name': 'MacBook Air M2', 'status': 'Shipped',   'date': 'Nov 28, 2024', 'price': 1299, 'color': Color(0xFF1565C0),
     'img': 'https://images.unsplash.com/photo-1526570207772-784d36084510?w=200&q=80'},
    {'id': '#ORD-2024-003', 'name': 'ASUS ROG Strix', 'status': 'Processing','date': 'Dec 02, 2024', 'price': 2299, 'color': _orange,
     'img': 'https://images.unsplash.com/photo-1603302576837-37561b2e2302?w=200&q=80'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      appBar: AppBar(
        backgroundColor: _navy, foregroundColor: Colors.white,
        title: const Text('My Orders', style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: SingleChildScrollView(
        child: Column(children: [
          // Status filter
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(children: ['All', 'Processing', 'Shipped', 'Delivered'].map((s) =>
              _Hover(builder: (h) => GestureDetector(
                onTap: () => _snack(context, 'Showing $s orders'),
                child: Container(
                  margin: const EdgeInsets.only(right: 8),
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
                  decoration: BoxDecoration(
                    color: s == 'All' ? _navy : (h ? _navy.withValues(alpha: 0.1) : Colors.white),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: s == 'All' ? _navy : Colors.grey.shade300)),
                  child: Text(s, style: TextStyle(
                      fontSize: 12, fontWeight: FontWeight.w500,
                      color: s == 'All' ? Colors.white : (h ? _navy : Colors.grey[700]))),
                ),
              ))
            ).toList()),
          ),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            itemCount: _orders.length,
            itemBuilder: (_, i) {
              final o = _orders[i];
              return _Hover(builder: (h) => AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                margin: const EdgeInsets.only(bottom: 12),
                decoration: BoxDecoration(
                  color: _card, borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: h ? _orange.withValues(alpha: 0.3) : Colors.transparent),
                  boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 6)]),
                child: Column(children: [
                  Row(children: [
                    ClipRRect(
                      borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(14), bottomLeft: Radius.circular(14)),
                      child: CachedNetworkImage(imageUrl: o['img'] as String,
                        width: 90, height: 85, fit: BoxFit.cover,
                        placeholder: (_, __) => Container(width: 90, height: 85, color: Colors.grey[100]),
                        errorWidget: (_, __, ___) => Container(width: 90, height: 85,
                            color: Colors.grey[100], child: const Icon(Icons.laptop_mac, color: _navy, size: 32))),
                    ),
                    Expanded(child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                          Text(o['id'] as String, style: TextStyle(
                              fontSize: 11, color: Colors.grey[500])),
                          Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: (o['color'] as Color).withValues(alpha: 0.12),
                              borderRadius: BorderRadius.circular(12)),
                            child: Text(o['status'] as String, style: TextStyle(
                                color: o['color'] as Color, fontSize: 10,
                                fontWeight: FontWeight.bold))),
                        ]),
                        const SizedBox(height: 4),
                        Text(o['name'] as String, style: const TextStyle(
                            fontSize: 13, fontWeight: FontWeight.bold, color: _navy)),
                        const SizedBox(height: 2),
                        Text(o['date'] as String, style: TextStyle(
                            fontSize: 11, color: Colors.grey[500])),
                        const SizedBox(height: 4),
                        Text('\$${o['price']}', style: const TextStyle(
                            fontSize: 14, fontWeight: FontWeight.bold, color: _orange)),
                      ]),
                    )),
                  ]),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
                    child: Row(children: [
                      Expanded(child: _Hover(builder: (hb) => OutlinedButton(
                        onPressed: () => Navigator.push(context, _slideRoute(const _OrderTrackingPage())),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 9),
                          side: BorderSide(color: hb ? _navy : Colors.grey.shade300),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                        child: const Text('Track Order', style: TextStyle(
                            color: _navy, fontSize: 12, fontWeight: FontWeight.w600)),
                      ))),
                      const SizedBox(width: 10),
                      Expanded(child: _Hover(builder: (hb) => ElevatedButton(
                        onPressed: () { _snack(context, 'Item added to cart! 🛒', color: _green); },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: hb ? _navyL : _navy, foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 9),
                          minimumSize: Size.zero,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          elevation: 0),
                        child: const Text('Reorder', style: TextStyle(
                            fontSize: 12, fontWeight: FontWeight.bold)),
                      ))),
                    ]),
                  ),
                ]),
              ));
            },
          ),
          const _FooterSection(),
        ]),
      ),
    );
  }
}

// ════════════════════════════════════════════════════
// NOTIFICATIONS PAGE
// ════════════════════════════════════════════════════
class _NotificationPage extends StatefulWidget {
  const _NotificationPage();
  @override
  State<_NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<_NotificationPage> {
  final List<Map<String, dynamic>> _notifs = [
    {'icon': Icons.local_offer_outlined,   'color': _orange,
     'title': '🎉 Flash Sale is LIVE!',
     'msg': 'Up to 40% off on gaming and business laptops. Limited stock — grab yours now!',
     'time': '2 min ago', 'isNew': true},
    {'icon': Icons.local_shipping_outlined,'color': const Color(0xFF2E7D32),
     'title': '📦 Order Shipped',
     'msg': 'Your Dell XPS 15 order #ORD-2024-001 has been shipped. Arrives in 2 days.',
     'time': '1 hour ago', 'isNew': true},
    {'icon': Icons.star_outline,           'color': Colors.amber,
     'title': '⭐ New Arrivals',
     'msg': 'MacBook Pro M3 and ASUS ROG Strix just landed! Be the first to grab them.',
     'time': '3 hours ago', 'isNew': true},
    {'icon': Icons.payment_outlined,       'color': const Color(0xFF1565C0),
     'title': '✅ Payment Confirmed',
     'msg': 'Payment of \$1,299 for MacBook Air M2 has been successfully processed.',
     'time': '1 day ago', 'isNew': false},
    {'icon': Icons.percent_outlined,       'color': _red,
     'title': '💸 Exclusive Offer for You',
     'msg': 'Use code HARBOR10 for 10% off your next purchase. Valid till Dec 31!',
     'time': '2 days ago', 'isNew': false},
    {'icon': Icons.support_agent_outlined, 'color': const Color(0xFF6A1B9A),
     'title': '💬 Support Replied',
     'msg': 'Our team has responded to your query. Check the Help section for details.',
     'time': '3 days ago', 'isNew': false},
  ];

  @override
  Widget build(BuildContext context) {
    final newCount = _notifs.where((n) => n['isNew'] as bool).length;
    return Scaffold(
      backgroundColor: _bg,
      appBar: AppBar(
        backgroundColor: _navy, foregroundColor: Colors.white,
        title: Text('Notifications${newCount > 0 ? " ($newCount)" : ""}',
            style: const TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          TextButton(
            onPressed: () => setState(() {
              for (final n in _notifs) n['isNew'] = false;
            }),
            child: const Text('Mark All Read', style: TextStyle(color: Colors.white70, fontSize: 12)),
          ),
        ],
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: _notifs.length,
        separatorBuilder: (_, __) => const SizedBox(height: 8),
        itemBuilder: (_, i) {
          final n = _notifs[i];
          final isNew = n['isNew'] as bool;
          return _Hover(builder: (h) => GestureDetector(
            onTap: () => setState(() => _notifs[i]['isNew'] = false),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              decoration: BoxDecoration(
                color: isNew
                    ? (n['color'] as Color).withValues(alpha: 0.06)
                    : (h ? Colors.grey.shade50 : _card),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: isNew
                      ? (n['color'] as Color).withValues(alpha: 0.25)
                      : (h ? Colors.grey.shade300 : Colors.grey.shade100)),
                boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 5)],
              ),
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Container(width: 46, height: 46,
                    decoration: BoxDecoration(
                      color: (n['color'] as Color).withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(12)),
                    child: Icon(n['icon'] as IconData,
                        color: n['color'] as Color, size: 22)),
                  const SizedBox(width: 12),
                  Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Row(children: [
                      Expanded(child: Text(n['title'] as String, style: TextStyle(
                          fontSize: 13, fontWeight: FontWeight.bold, color: _navy))),
                      if (isNew)
                        Container(width: 8, height: 8,
                            decoration: const BoxDecoration(color: _orange, shape: BoxShape.circle)),
                    ]),
                    const SizedBox(height: 4),
                    Text(n['msg'] as String, style: TextStyle(
                        fontSize: 12, color: Colors.grey[600], height: 1.5),
                        maxLines: 2, overflow: TextOverflow.ellipsis),
                    const SizedBox(height: 6),
                    Row(children: [
                      Icon(Icons.access_time, size: 11, color: Colors.grey[400]),
                      const SizedBox(width: 4),
                      Text(n['time'] as String, style: TextStyle(
                          fontSize: 11, color: Colors.grey[500])),
                      if (isNew) ...[
                        const Spacer(),
                        Text('NEW', style: TextStyle(fontSize: 10,
                            color: n['color'] as Color, fontWeight: FontWeight.bold)),
                      ],
                    ]),
                  ])),
                ]),
              ),
            ),
          ));
        },
      ),
    );
  }
}

// ════════════════════════════════════════════════════
// EDIT PROFILE PAGE
// ════════════════════════════════════════════════════
class _EditProfilePage extends StatefulWidget {
  const _EditProfilePage();
  @override
  State<_EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<_EditProfilePage> {
  final _nameCtrl    = TextEditingController(text: 'Guest User');
  final _emailCtrl   = TextEditingController(text: 'guest@laptopharbor.com');
  final _phoneCtrl   = TextEditingController(text: '+1 (800) 000-0000');
  final _formKey     = GlobalKey<FormState>();

  @override
  void dispose() {
    _nameCtrl.dispose(); _emailCtrl.dispose(); _phoneCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      appBar: AppBar(
        backgroundColor: _navy, foregroundColor: Colors.white,
        title: const Text('Edit Profile', style: TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          TextButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                _snack(context, 'Profile updated successfully! ✅', color: _green);
                Navigator.pop(context);
              }
            },
            child: const Text('Save', style: TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15)),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(children: [
          // Avatar section
          Container(
            color: _navy,
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
            child: Center(child: Column(children: [
              Stack(children: [
                Container(
                  width: 90, height: 90,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: const LinearGradient(
                        colors: [_orange, Color(0xFFFF8C42)],
                        begin: Alignment.topLeft, end: Alignment.bottomRight),
                    boxShadow: [BoxShadow(color: _orange.withValues(alpha: 0.4),
                        blurRadius: 18, spreadRadius: 2)]),
                  child: const Icon(Icons.person_rounded, color: Colors.white, size: 46)),
                Positioned(bottom: 0, right: 0,
                  child: _Hover(builder: (h) => GestureDetector(
                    onTap: () => _snack(context, 'Camera roll feature requires device permissions'),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      width: 30, height: 30,
                      decoration: BoxDecoration(
                        color: h ? _orangeD : Colors.white,
                        shape: BoxShape.circle,
                        border: Border.all(color: _navy, width: 2),
                        boxShadow: [const BoxShadow(color: Colors.black26, blurRadius: 4)]),
                      child: Icon(Icons.camera_alt_rounded,
                          color: h ? Colors.white : _navy, size: 14)),
                  ))),
              ]),
              const SizedBox(height: 10),
              Text('Tap to change photo',
                  style: TextStyle(color: Colors.white.withValues(alpha: 0.55), fontSize: 12)),
            ])),
          ),
          // Form
          Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                const Text('Personal Information', style: TextStyle(
                    fontSize: 13, fontWeight: FontWeight.bold,
                    color: Color(0xFF999999), letterSpacing: 0.8)),
                const SizedBox(height: 14),
                _buildField('Full Name', Icons.person_outline, _nameCtrl,
                    validator: (v) => (v == null || v.isEmpty) ? 'Name required' : null),
                const SizedBox(height: 14),
                _buildField('Email Address', Icons.email_outlined, _emailCtrl,
                    keyboardType: TextInputType.emailAddress,
                    validator: (v) {
                      if (v == null || v.isEmpty) return 'Email required';
                      if (!v.contains('@')) return 'Invalid email';
                      return null;
                    }),
                const SizedBox(height: 14),
                _buildField('Phone Number', Icons.phone_outlined, _phoneCtrl,
                    keyboardType: TextInputType.phone,
                    validator: (v) => (v == null || v.isEmpty) ? 'Phone required' : null),
                const SizedBox(height: 24),
                const Text('Security', style: TextStyle(
                    fontSize: 13, fontWeight: FontWeight.bold,
                    color: Color(0xFF999999), letterSpacing: 0.8)),
                const SizedBox(height: 14),
                _Hover(builder: (h) => GestureDetector(
                  onTap: () => Navigator.push(context, _slideRoute(const _ChangePasswordPage())),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: h ? const Color(0xFFEDF3FF) : _card,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: h ? const Color(0xFF1565C0) : Colors.grey.shade200),
                      boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 6)]),
                    child: Row(children: [
                      Container(padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(color: const Color(0xFF1565C0).withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(10)),
                        child: const Icon(Icons.lock_outline, color: Color(0xFF1565C0), size: 20)),
                      const SizedBox(width: 14),
                      const Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                        Text('Change Password', style: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.w600, color: _navy)),
                        SizedBox(height: 2),
                        Text('Update your account password',
                            style: TextStyle(fontSize: 11, color: Color(0xFF888888))),
                      ])),
                      const Icon(Icons.arrow_forward_ios_rounded,
                          color: Colors.grey, size: 14),
                    ]),
                  ),
                )),
                const SizedBox(height: 28),
                _Hover(builder: (h) => SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _snack(context, 'Profile saved! ✅', color: _green);
                        Navigator.pop(context);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: h ? _navyL : _navy, foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      elevation: 0),
                    child: const Text('Save Changes',
                        style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                  ),
                )),
              ]),
            ),
          ),
          const _FooterSection(),
        ]),
      ),
    );
  }

  Widget _buildField(String label, IconData icon, TextEditingController ctrl,
      {TextInputType? keyboardType, String? Function(String?)? validator}) {
    return TextFormField(
      controller: ctrl,
      keyboardType: keyboardType,
      validator: validator,
      style: const TextStyle(fontSize: 14, color: _navy),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.grey[600], fontSize: 13),
        prefixIcon: Icon(icon, color: _orange, size: 20),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey.shade200)),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey.shade200)),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: _orange, width: 1.5)),
        errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: _red)),
      ),
    );
  }
}

// ════════════════════════════════════════════════════
// SAVED ADDRESSES PAGE
// ════════════════════════════════════════════════════
class _AddressesPage extends StatefulWidget {
  const _AddressesPage();
  @override
  State<_AddressesPage> createState() => _AddressesPageState();
}

class _AddressesPageState extends State<_AddressesPage> {
  int _selected = 0;
  final List<Map<String, String>> _addresses = [
    {'label': 'Home',   'icon': '🏠', 'name': 'Guest User', 'line1': '123 Main Street, Apt 4B', 'line2': 'New York, NY 10001, USA', 'phone': '+1 (212) 555-0101'},
    {'label': 'Office', 'icon': '🏢', 'name': 'Guest User', 'line1': '456 Business Ave, Floor 3', 'line2': 'Manhattan, NY 10022, USA', 'phone': '+1 (212) 555-0202'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      appBar: AppBar(
        backgroundColor: _navy, foregroundColor: Colors.white,
        title: const Text('Saved Addresses', style: TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          TextButton.icon(
            onPressed: () => Navigator.push(context, _slideRoute(const _AddAddressPage())),
            icon: const Icon(Icons.add, color: Colors.white, size: 18),
            label: const Text('Add', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Text('Delivery Addresses', style: TextStyle(
                  fontSize: 13, fontWeight: FontWeight.bold,
                  color: Color(0xFF999999), letterSpacing: 0.8)),
              const SizedBox(height: 12),
              ...List.generate(_addresses.length, (i) {
                final a = _addresses[i];
                final isSelected = i == _selected;
                return _Hover(builder: (h) => GestureDetector(
                  onTap: () => setState(() => _selected = i),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: isSelected ? _navy.withValues(alpha: 0.04) : _card,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: isSelected ? _navy : (h ? Colors.grey.shade300 : Colors.grey.shade100),
                        width: isSelected ? 2 : 1),
                      boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 6)]),
                    child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Container(
                        width: 44, height: 44,
                        decoration: BoxDecoration(
                          color: isSelected ? _navy.withValues(alpha: 0.08) : Colors.grey.shade50,
                          borderRadius: BorderRadius.circular(12)),
                        child: Center(child: Text(a['icon']!, style: const TextStyle(fontSize: 22)))),
                      const SizedBox(width: 14),
                      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Row(children: [
                          Text(a['label']!, style: const TextStyle(
                              fontSize: 14, fontWeight: FontWeight.bold, color: _navy)),
                          if (isSelected) ...[
                            const SizedBox(width: 8),
                            Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(color: _green.withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(10)),
                              child: const Text('Default', style: TextStyle(
                                  color: _green, fontSize: 10, fontWeight: FontWeight.bold))),
                          ],
                        ]),
                        const SizedBox(height: 4),
                        Text(a['name']!, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
                        Text(a['line1']!, style: const TextStyle(fontSize: 13, color: _navy)),
                        Text(a['line2']!, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
                        const SizedBox(height: 4),
                        Text(a['phone']!, style: TextStyle(fontSize: 11, color: Colors.grey[500])),
                      ])),
                      Column(children: [
                        _Hover(builder: (hb) => GestureDetector(
                          onTap: () => Navigator.push(context, _slideRoute(const _AddAddressPage())),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: hb ? _orange.withValues(alpha: 0.1) : Colors.transparent,
                              borderRadius: BorderRadius.circular(8)),
                            child: Icon(Icons.edit_outlined, size: 16,
                                color: hb ? _orange : Colors.grey[400])),
                        )),
                        const SizedBox(height: 4),
                        _Hover(builder: (hb) => GestureDetector(
                          onTap: () => setState(() => _addresses.removeAt(i)),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: hb ? _red.withValues(alpha: 0.1) : Colors.transparent,
                              borderRadius: BorderRadius.circular(8)),
                            child: Icon(Icons.delete_outline, size: 16,
                                color: hb ? _red : Colors.grey[400])),
                        )),
                      ]),
                    ]),
                  ),
                ));
              }),
              // Add new address card
              _Hover(builder: (h) => GestureDetector(
                onTap: () => _snack(context, 'Add address feature coming soon!'),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: h ? _orange.withValues(alpha: 0.04) : _card,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                        color: h ? _orange.withValues(alpha: 0.4) : Colors.grey.shade200,
                        style: BorderStyle.solid),
                    boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 4)]),
                  child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                    Icon(Icons.add_circle_outline, color: h ? _orange : Colors.grey[400], size: 20),
                    const SizedBox(width: 8),
                    Text('Add New Address', style: TextStyle(
                        color: h ? _orange : Colors.grey[600],
                        fontSize: 14, fontWeight: FontWeight.w500)),
                  ]),
                ),
              )),
            ]),
          ),
          const _FooterSection(),
        ]),
      ),
    );
  }
}

// ════════════════════════════════════════════════════
// PAYMENT METHODS PAGE
// ════════════════════════════════════════════════════
class _PaymentPage extends StatefulWidget {
  const _PaymentPage();
  @override
  State<_PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<_PaymentPage> {
  int _selected = 0;
  final List<Map<String, dynamic>> _cards = [
    {'type': 'Visa', 'number': '**** **** **** 4242', 'expiry': '08/26', 'name': 'Guest User', 'color': const Color(0xFF1565C0), 'icon': Icons.credit_card},
    {'type': 'Mastercard', 'number': '**** **** **** 5353', 'expiry': '12/25', 'name': 'Guest User', 'color': const Color(0xFFD32F2F), 'icon': Icons.credit_card},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      appBar: AppBar(
        backgroundColor: _navy, foregroundColor: Colors.white,
        title: const Text('Payment Methods', style: TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          TextButton.icon(
            onPressed: () => _snack(context, 'Add card coming soon!'),
            icon: const Icon(Icons.add, color: Colors.white, size: 18),
            label: const Text('Add', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Text('Saved Cards', style: TextStyle(
                  fontSize: 13, fontWeight: FontWeight.bold,
                  color: Color(0xFF999999), letterSpacing: 0.8)),
              const SizedBox(height: 12),
              // Card visuals
              SizedBox(
                height: 175,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: _cards.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 14),
                  itemBuilder: (_, i) {
                    final c = _cards[i];
                    final isSelected = i == _selected;
                    return _Hover(builder: (h) => GestureDetector(
                      onTap: () => setState(() => _selected = i),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        width: 280,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [c['color'] as Color,
                                (c['color'] as Color).withValues(alpha: 0.7)],
                            begin: Alignment.topLeft, end: Alignment.bottomRight),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: isSelected ? Colors.white : Colors.transparent,
                            width: 3),
                          boxShadow: [BoxShadow(
                            color: (c['color'] as Color).withValues(alpha: isSelected ? 0.5 : 0.2),
                            blurRadius: isSelected ? 20 : 10, offset: const Offset(0, 6))]),
                        padding: const EdgeInsets.all(20),
                        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                            Text(c['type'] as String, style: const TextStyle(
                                color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold, letterSpacing: 1)),
                            Icon(c['icon'] as IconData, color: Colors.white.withValues(alpha: 0.8), size: 32),
                          ]),
                          const Spacer(),
                          Text(c['number'] as String, style: const TextStyle(
                              color: Colors.white, fontSize: 16, letterSpacing: 2, fontWeight: FontWeight.w500)),
                          const SizedBox(height: 16),
                          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                              Text('CARD HOLDER', style: TextStyle(color: Colors.white.withValues(alpha: 0.6), fontSize: 9)),
                              Text(c['name'] as String, style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600)),
                            ]),
                            Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
                              Text('EXPIRES', style: TextStyle(color: Colors.white.withValues(alpha: 0.6), fontSize: 9)),
                              Text(c['expiry'] as String, style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600)),
                            ]),
                          ]),
                        ]),
                      ),
                    ));
                  },
                ),
              ),
              const SizedBox(height: 20),
              const Text('Payment Options', style: TextStyle(
                  fontSize: 13, fontWeight: FontWeight.bold,
                  color: Color(0xFF999999), letterSpacing: 0.8)),
              const SizedBox(height: 12),
              // Other payment options
              ...[
                {'icon': Icons.account_balance_wallet_outlined, 'label': 'PayPal', 'sub': 'guest@laptopharbor.com', 'color': const Color(0xFF003087)},
                {'icon': Icons.phone_android_outlined, 'label': 'Apple Pay / Google Pay', 'sub': 'Tap & pay instantly', 'color': const Color(0xFF1B5E20)},
                {'icon': Icons.local_atm_outlined, 'label': 'Cash on Delivery', 'sub': 'Pay when you receive', 'color': const Color(0xFF2E7D32)},
              ].map((opt) => _Hover(builder: (h) => GestureDetector(
                onTap: () => _snack(context, '${opt['label']} selected!', color: _green),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  margin: const EdgeInsets.only(bottom: 10),
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: h ? (opt['color'] as Color).withValues(alpha: 0.05) : _card,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: h ? (opt['color'] as Color).withValues(alpha: 0.3) : Colors.grey.shade100),
                    boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 5)]),
                  child: Row(children: [
                    Container(padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: (opt['color'] as Color).withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(10)),
                      child: Icon(opt['icon'] as IconData, color: opt['color'] as Color, size: 20)),
                    const SizedBox(width: 14),
                    Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text(opt['label'] as String, style: const TextStyle(
                          fontSize: 14, fontWeight: FontWeight.w600, color: _navy)),
                      Text(opt['sub'] as String,
                          style: TextStyle(fontSize: 11, color: Colors.grey[500])),
                    ])),
                    Icon(Icons.arrow_forward_ios_rounded, color: Colors.grey.shade300, size: 14),
                  ]),
                ),
              ))),
            ]),
          ),
          const _FooterSection(),
        ]),
      ),
    );
  }
}

// ════════════════════════════════════════════════════
// EMAIL PREFERENCES PAGE
// ════════════════════════════════════════════════════
class _EmailPrefPage extends StatefulWidget {
  const _EmailPrefPage();
  @override
  State<_EmailPrefPage> createState() => _EmailPrefPageState();
}

class _EmailPrefPageState extends State<_EmailPrefPage> {
  bool _deals = true, _orders = true, _wishlist = false, _newsletter = true, _security = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      appBar: AppBar(
        backgroundColor: _navy, foregroundColor: Colors.white,
        title: const Text('Email Preferences', style: TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          TextButton(
            onPressed: () => _snack(context, 'Preferences saved! ✅', color: _green),
            child: const Text('Save', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(children: [
          // Header
          Container(color: _navy,
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
            child: Row(children: [
              Container(padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(color: _orange.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(12)),
                child: const Icon(Icons.email_outlined, color: _orange, size: 24)),
              const SizedBox(width: 14),
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                const Text('guest@laptopharbor.com', style: TextStyle(
                    color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold)),
                Text('Manage what emails you receive',
                    style: TextStyle(color: Colors.white.withValues(alpha: 0.55), fontSize: 11)),
              ]),
            ])),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(children: [
              _toggleSection('Deals & Promotions', 'Flash sales, coupons, exclusive offers',
                  Icons.local_offer_outlined, _orange, _deals, (v) => setState(() => _deals = v)),
              _toggleSection('Order Updates', 'Shipping, delivery, and order status',
                  Icons.local_shipping_outlined, _green, _orders, (v) => setState(() => _orders = v)),
              _toggleSection('Wishlist Alerts', 'Price drops on wishlisted items',
                  Icons.favorite_outline, _red, _wishlist, (v) => setState(() => _wishlist = v)),
              _toggleSection('Newsletter', 'Weekly laptop news and reviews',
                  Icons.newspaper_outlined, const Color(0xFF1565C0), _newsletter,
                  (v) => setState(() => _newsletter = v)),
              _toggleSection('Security Alerts', 'Login attempts and account changes',
                  Icons.security_outlined, const Color(0xFF6A1B9A), _security,
                  (v) => setState(() => _security = v)),
            ]),
          ),
          const _FooterSection(),
        ]),
      ),
    );
  }

  Widget _toggleSection(String title, String sub, IconData icon,
      Color color, bool value, void Function(bool) onChanged) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: _card, borderRadius: BorderRadius.circular(14),
        border: Border.all(color: value ? color.withValues(alpha: 0.2) : Colors.grey.shade100),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 6)]),
      child: Row(children: [
        Container(padding: const EdgeInsets.all(9),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(10)),
          child: Icon(icon, color: color, size: 20)),
        const SizedBox(width: 14),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: _navy)),
          Text(sub, style: TextStyle(fontSize: 11, color: Colors.grey[500])),
        ])),
        Switch.adaptive(
          value: value, onChanged: onChanged,
          activeColor: color,
        ),
      ]),
    );
  }
}

// ════════════════════════════════════════════════════
// RETURNS & REFUNDS PAGE
// ════════════════════════════════════════════════════
class _ReturnsPage extends StatelessWidget {
  const _ReturnsPage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      appBar: AppBar(
        backgroundColor: _navy, foregroundColor: Colors.white,
        title: const Text('Returns & Refunds', style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: SingleChildScrollView(
        child: Column(children: [
          // Header banner
          Container(
            color: _navy,
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 28),
            child: Row(children: [
              Container(padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(color: _green.withValues(alpha: 0.2),
                    shape: BoxShape.circle),
                child: const Icon(Icons.replay_outlined, color: _green, size: 28)),
              const SizedBox(width: 16),
              const Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                Text('30-Day Easy Returns', style: TextStyle(
                    color: Colors.white, fontSize: 17, fontWeight: FontWeight.bold)),
                SizedBox(height: 4),
                Text('Hassle-free returns on all orders',
                    style: TextStyle(color: Colors.white60, fontSize: 12)),
              ])),
            ]),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              // Policy highlights
              const Text('Return Policy', style: TextStyle(
                  fontSize: 13, fontWeight: FontWeight.bold,
                  color: Color(0xFF999999), letterSpacing: 0.8)),
              const SizedBox(height: 12),
              ...[
                {'icon': Icons.check_circle_outline, 'color': _green,
                 'title': '30-Day Return Window',
                 'sub': 'Return any item within 30 days of delivery for a full refund.'},
                {'icon': Icons.local_shipping_outlined, 'color': const Color(0xFF1565C0),
                 'title': 'Free Return Shipping',
                 'sub': 'We cover return shipping costs on all eligible orders.'},
                {'icon': Icons.account_balance_wallet_outlined, 'color': _orange,
                 'title': 'Fast Refunds',
                 'sub': 'Refunds processed within 3-5 business days to original payment.'},
                {'icon': Icons.verified_outlined, 'color': const Color(0xFF6A1B9A),
                 'title': 'Original Condition',
                 'sub': 'Items must be unopened or in original condition with packaging.'},
              ].map((item) => Container(
                margin: const EdgeInsets.only(bottom: 10),
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(color: _card, borderRadius: BorderRadius.circular(14),
                    boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 5)]),
                child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Container(padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: (item['color'] as Color).withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(10)),
                    child: Icon(item['icon'] as IconData, color: item['color'] as Color, size: 20)),
                  const SizedBox(width: 14),
                  Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text(item['title'] as String, style: const TextStyle(
                        fontSize: 14, fontWeight: FontWeight.w600, color: _navy)),
                    const SizedBox(height: 3),
                    Text(item['sub'] as String, style: TextStyle(
                        fontSize: 12, color: Colors.grey[600], height: 1.4)),
                  ])),
                ]),
              )),
              const SizedBox(height: 8),
              // Start return button
              _Hover(builder: (h) => GestureDetector(
                onTap: () => _snack(context, 'Return request submitted! We\'ll contact you within 24 hours.', color: _green),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  decoration: BoxDecoration(
                    color: h ? const Color(0xFF1B5E20) : _green,
                    borderRadius: BorderRadius.circular(14)),
                  child: const Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                    Icon(Icons.replay_outlined, color: Colors.white, size: 20),
                    SizedBox(width: 8),
                    Text('Start a Return', style: TextStyle(
                        color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold)),
                  ]),
                ),
              )),
              const SizedBox(height: 10),
              _Hover(builder: (h) => GestureDetector(
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const _HelpPage())),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  decoration: BoxDecoration(
                    color: h ? _navy.withValues(alpha: 0.08) : _card,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: h ? _navy : Colors.grey.shade200)),
                  child: const Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                    Icon(Icons.support_agent_outlined, color: _navy, size: 20),
                    SizedBox(width: 8),
                    Text('Contact Support', style: TextStyle(
                        color: _navy, fontSize: 15, fontWeight: FontWeight.bold)),
                  ]),
                ),
              )),
            ]),
          ),
          const _FooterSection(),
        ]),
      ),
    );
  }
}

// ════════════════════════════════════════════════════
// HELP & SUPPORT PAGE
// ════════════════════════════════════════════════════
class _HelpPage extends StatefulWidget {
  const _HelpPage();
  @override
  State<_HelpPage> createState() => _HelpPageState();
}

class _HelpPageState extends State<_HelpPage> {
  int? _openFaq;

  static const _faqs = [
    {'q': 'How do I track my order?', 'a': 'Go to Profile → My Orders and tap "Track Order" on any order. You\'ll see real-time tracking updates including shipping status and estimated delivery date.'},
    {'q': 'Can I return a laptop?', 'a': 'Yes! We offer a 30-day hassle-free return policy. The laptop must be in original condition with packaging. Go to Profile → Returns & Refunds to start a return.'},
    {'q': 'What payment methods do you accept?', 'a': 'We accept Visa, Mastercard, American Express, PayPal, Apple Pay, Google Pay, and Cash on Delivery for eligible orders.'},
    {'q': 'How long does delivery take?', 'a': 'Standard delivery takes 2-5 business days. Express delivery (1-2 days) is available for an additional fee. Free shipping on orders over \$500.'},
    {'q': 'Are all products genuine?', 'a': 'Absolutely. LaptopHarbor is an authorized reseller for all major brands including Dell, Apple, ASUS, HP, Lenovo, and more. All products come with official manufacturer warranty.'},
    {'q': 'How do I cancel an order?', 'a': 'Orders can be cancelled within 2 hours of placement. After that, if the order has shipped, you\'ll need to initiate a return. Contact our support team for assistance.'},
    {'q': 'Is my payment information secure?', 'a': 'Yes. We use 256-bit SSL encryption and are PCI DSS compliant. Your payment data is never stored on our servers.'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      appBar: AppBar(
        backgroundColor: _navy, foregroundColor: Colors.white,
        title: const Text('Help & Support', style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: SingleChildScrollView(
        child: Column(children: [
          // Contact options
          Container(
            color: _navy,
            padding: const EdgeInsets.all(20),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('How can we help?', style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.7), fontSize: 12)),
              const SizedBox(height: 4),
              const Text('We\'re here 24/7 for you', style: TextStyle(
                  color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              Row(children: [
                Expanded(child: _contactCard(context, Icons.chat_outlined,
                    'Live Chat', 'Avg 2 min reply', const Color(0xFF4CAF50))),
                const SizedBox(width: 12),
                Expanded(child: _contactCard(context, Icons.email_outlined,
                    'Email Us', 'Within 24 hours', const Color(0xFF1565C0))),
                const SizedBox(width: 12),
                Expanded(child: _contactCard(context, Icons.phone_outlined,
                    'Call Us', '+1 (800) 123-4567', _orange)),
              ]),
            ]),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              // Search bar
              Container(
                height: 46,
                decoration: BoxDecoration(
                  color: _card, borderRadius: BorderRadius.circular(12),
                  boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 6)]),
                child: TextField(
                  style: const TextStyle(fontSize: 13),
                  decoration: InputDecoration(
                    hintText: 'Search help articles...',
                    hintStyle: TextStyle(color: Colors.grey[400], fontSize: 13),
                    prefixIcon: const Icon(Icons.search, color: Colors.grey, size: 20),
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(vertical: 13)),
                ),
              ),
              const SizedBox(height: 20),
              // Quick help topics
              const Text('Popular Topics', style: TextStyle(
                  fontSize: 13, fontWeight: FontWeight.bold,
                  color: Color(0xFF999999), letterSpacing: 0.8)),
              const SizedBox(height: 12),
              Wrap(spacing: 8, runSpacing: 8, children: [
                'Track Order', 'Returns', 'Payments', 'Warranty',
                'Delivery', 'Account', 'Products',
              ].map((t) => _Hover(builder: (h) => GestureDetector(
                onTap: () => _snack(context, '$t help articles'),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  decoration: BoxDecoration(
                    color: h ? _navy : _card,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: h ? _navy : Colors.grey.shade200)),
                  child: Text(t, style: TextStyle(
                      color: h ? Colors.white : _navy,
                      fontSize: 12, fontWeight: FontWeight.w500)),
                ),
              ))).toList()),
              const SizedBox(height: 20),
              // FAQs
              const Text('Frequently Asked Questions', style: TextStyle(
                  fontSize: 13, fontWeight: FontWeight.bold,
                  color: Color(0xFF999999), letterSpacing: 0.8)),
              const SizedBox(height: 12),
              ...List.generate(_faqs.length, (i) {
                final isOpen = _openFaq == i;
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  margin: const EdgeInsets.only(bottom: 8),
                  decoration: BoxDecoration(
                    color: isOpen ? _navy.withValues(alpha: 0.03) : _card,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: isOpen ? _navy.withValues(alpha: 0.2) : Colors.grey.shade100),
                    boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 5)]),
                  child: Column(children: [
                    ListTile(
                      onTap: () => setState(() => _openFaq = isOpen ? null : i),
                      title: Text(_faqs[i]['q']!, style: TextStyle(
                          fontSize: 13, fontWeight: FontWeight.w600,
                          color: isOpen ? _navy : Colors.black87)),
                      trailing: AnimatedRotation(
                        turns: isOpen ? 0.5 : 0,
                        duration: const Duration(milliseconds: 250),
                        child: Icon(Icons.keyboard_arrow_down,
                            color: isOpen ? _orange : Colors.grey, size: 22)),
                    ),
                    if (isOpen)
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 0, 16, 14),
                        child: Text(_faqs[i]['a']!, style: TextStyle(
                            fontSize: 13, color: Colors.grey[600], height: 1.6)),
                      ),
                  ]),
                );
              }),
            ]),
          ),
          const _FooterSection(),
        ]),
      ),
    );
  }

  Widget _contactCard(BuildContext context, IconData icon, String title,
      String sub, Color color) {
    return _Hover(builder: (h) => GestureDetector(
      onTap: () => _snack(context, '$title: We\'ll connect you shortly!', color: color),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
        decoration: BoxDecoration(
          color: h ? color.withValues(alpha: 0.25) : Colors.white.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.white.withValues(alpha: 0.15))),
        child: Column(children: [
          Icon(icon, color: Colors.white, size: 22),
          const SizedBox(height: 6),
          Text(title, style: const TextStyle(color: Colors.white,
              fontSize: 11, fontWeight: FontWeight.bold)),
          const SizedBox(height: 2),
          Text(sub, style: TextStyle(color: Colors.white.withValues(alpha: 0.6),
              fontSize: 9), textAlign: TextAlign.center),
        ]),
      ),
    ));
  }
}

// ════════════════════════════════════════════════════
// ABOUT PAGE
// ════════════════════════════════════════════════════
class _AboutPage extends StatelessWidget {
  const _AboutPage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      appBar: AppBar(
        backgroundColor: _navy, foregroundColor: Colors.white,
        title: const Text('About LaptopHarbor', style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: SingleChildScrollView(
        child: Column(children: [
          // Hero
          Container(
            color: _navy,
            padding: const EdgeInsets.fromLTRB(20, 30, 20, 40),
            child: Column(children: [
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                      colors: [_orange, Color(0xFFFF8C42)],
                      begin: Alignment.topLeft, end: Alignment.bottomRight),
                  shape: BoxShape.circle,
                  boxShadow: [BoxShadow(color: _orange.withValues(alpha: 0.4),
                      blurRadius: 24, spreadRadius: 4)]),
                child: const Icon(Icons.laptop_mac, color: Colors.white, size: 44)),
              const SizedBox(height: 16),
              const Text('LaptopHarbor', style: TextStyle(
                  color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold,
                  letterSpacing: 1)),
              const SizedBox(height: 6),
              Text('Your Laptop Destination', style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.6), fontSize: 14)),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                decoration: BoxDecoration(color: _orange.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(20)),
                child: const Text('Version 1.0.0', style: TextStyle(
                    color: _orange, fontSize: 12, fontWeight: FontWeight.bold))),
            ]),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              // About text
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(color: _card, borderRadius: BorderRadius.circular(16),
                    boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 8)]),
                child: const Text(
                  'LaptopHarbor is your premium destination for laptops from top global brands. '
                  'Founded in 2020, we have served over 10,000+ happy customers across the US and Canada.\n\n'
                  'We are authorized resellers for Dell, Apple, ASUS, HP, Lenovo, Acer, Razer, Microsoft, '
                  'Samsung, and Gigabyte. Every product comes with genuine manufacturer warranty.\n\n'
                  'Our mission is simple: make laptop shopping easy, affordable, and trustworthy for everyone.',
                  style: TextStyle(fontSize: 13, color: Color(0xFF555555), height: 1.7)),
              ),
              const SizedBox(height: 16),
              // Stats
              const Text('By the Numbers', style: TextStyle(
                  fontSize: 13, fontWeight: FontWeight.bold,
                  color: Color(0xFF999999), letterSpacing: 0.8)),
              const SizedBox(height: 12),
              Row(children: [
                _aboutStat('500+', 'Products', _orange),
                const SizedBox(width: 10),
                _aboutStat('15+', 'Brands', const Color(0xFF1565C0)),
                const SizedBox(width: 10),
                _aboutStat('10K+', 'Customers', _green),
                const SizedBox(width: 10),
                _aboutStat('4.8★', 'Rating', Colors.amber),
              ]),
              const SizedBox(height: 16),
              // Links
              const Text('Connect With Us', style: TextStyle(
                  fontSize: 13, fontWeight: FontWeight.bold,
                  color: Color(0xFF999999), letterSpacing: 0.8)),
              const SizedBox(height: 12),
              ...[
                {'icon': Icons.language, 'label': 'Website', 'sub': 'www.laptopharbor.com', 'color': const Color(0xFF1565C0)},
                {'icon': Icons.facebook, 'label': 'Facebook', 'sub': 'facebook.com/laptopharbor', 'color': const Color(0xFF1877F2)},
                {'icon': Icons.camera_alt_outlined, 'label': 'Instagram', 'sub': '@laptopharbor', 'color': const Color(0xFFE1306C)},
                {'icon': Icons.alternate_email, 'label': 'Twitter/X', 'sub': '@laptopharbor', 'color': const Color(0xFF1DA1F2)},
              ].map((link) => _Hover(builder: (h) => GestureDetector(
                onTap: () => _snack(context, 'Opening ${link['label']}...'),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  margin: const EdgeInsets.only(bottom: 10),
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: h ? (link['color'] as Color).withValues(alpha: 0.05) : _card,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: h ? (link['color'] as Color).withValues(alpha: 0.3) : Colors.grey.shade100),
                    boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 5)]),
                  child: Row(children: [
                    Container(padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: (link['color'] as Color).withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(10)),
                      child: Icon(link['icon'] as IconData, color: link['color'] as Color, size: 20)),
                    const SizedBox(width: 14),
                    Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text(link['label'] as String, style: const TextStyle(
                          fontSize: 14, fontWeight: FontWeight.w600, color: _navy)),
                      Text(link['sub'] as String,
                          style: TextStyle(fontSize: 11, color: Colors.grey[500])),
                    ])),
                    Icon(Icons.arrow_forward_ios_rounded,
                        color: h ? (link['color'] as Color) : Colors.grey.shade300, size: 14),
                  ]),
                ),
              ))),
              const SizedBox(height: 16),
              Center(child: Column(children: [
                Text('© 2025 LaptopHarbor. All rights reserved.',
                    style: TextStyle(color: Colors.grey[500], fontSize: 11)),
                const SizedBox(height: 4),
                Text('Made with ❤️ for laptop enthusiasts',
                    style: TextStyle(color: Colors.grey[400], fontSize: 11)),
              ])),
            ]),
          ),
          const _FooterSection(),
        ]),
      ),
    );
  }

  Widget _aboutStat(String value, String label, Color color) => Expanded(
    child: Container(
      padding: const EdgeInsets.symmetric(vertical: 14),
      decoration: BoxDecoration(color: _card, borderRadius: BorderRadius.circular(12),
          boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 5)]),
      child: Column(children: [
        Text(value, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: color)),
        const SizedBox(height: 3),
        Text(label, style: TextStyle(fontSize: 10, color: Colors.grey[600])),
      ]),
    ),
  );
}


// ════════════════════════════════════════════════════
// CHECKOUT PAGE — Full Buy Now / Order Flow
// ════════════════════════════════════════════════════
class _CheckoutPage extends StatefulWidget {
  const _CheckoutPage();
  @override
  State<_CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<_CheckoutPage>
    with TickerProviderStateMixin {
  int _step = 0; // 0=Delivery, 1=Payment, 2=Review
  int _selAddress = 0;
  int _selPayment = 0;
  bool _placed    = false;
  late AnimationController _successCtrl;
  late Animation<double>   _successScale;

  final List<Map<String, String>> _addresses = [
    {'label': '🏠 Home',   'line1': '123 Main Street, Apt 4B', 'line2': 'New York, NY 10001'},
    {'label': '🏢 Office', 'line1': '456 Business Ave, Floor 3', 'line2': 'Manhattan, NY 10022'},
  ];

  final List<Map<String, dynamic>> _payments = [
    {'type': 'Visa',       'num': '**** 4242', 'icon': Icons.credit_card,     'color': Color(0xFF1565C0)},
    {'type': 'Mastercard', 'num': '**** 5353', 'icon': Icons.credit_card,     'color': Color(0xFFD32F2F)},
    {'type': 'PayPal',     'num': 'guest@...',  'icon': Icons.account_balance_wallet, 'color': Color(0xFF003087)},
    {'type': 'COD',        'num': 'Cash',       'icon': Icons.local_atm,      'color': Color(0xFF2E7D32)},
  ];

  double get _sub   => _globalCart.isEmpty
      ? 0
      : _globalCart.fold(0.0, (s, c) => s + (c['product'] as _Product).price * (c['qty'] as int));
  double get _tax   => _sub * 0.08;
  double get _total => _sub + _tax;

  @override
  void initState() {
    super.initState();
    _successCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 800));
    _successScale = CurvedAnimation(
        parent: _successCtrl, curve: Curves.elasticOut);
  }

  @override
  void dispose() { _successCtrl.dispose(); super.dispose(); }

  void _placeOrder() async {
    setState(() => _placed = true);
    _successCtrl.forward();
    await Future.delayed(const Duration(seconds: 3));
    if (!mounted) return;
    _globalCart.clear();
    Navigator.pushAndRemoveUntil(
      context, _fadeRoute(const HomeScreen()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_placed) return _buildSuccess();
    return Scaffold(
      backgroundColor: _bg,
      appBar: AppBar(
        backgroundColor: _navy, foregroundColor: Colors.white,
        title: const Text('Checkout', style: TextStyle(fontWeight: FontWeight.bold)),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(56),
          child: _buildStepper(),
        ),
      ),
      body: Column(children: [
        Expanded(child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 350),
          transitionBuilder: (child, anim) => FadeTransition(
            opacity: anim,
            child: SlideTransition(
              position: Tween<Offset>(begin: const Offset(0.05, 0), end: Offset.zero)
                  .animate(anim),
              child: child,
            ),
          ),
          child: KeyedSubtree(
            key: ValueKey(_step),
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: _step == 0 ? _deliveryStep()
                   : _step == 1 ? _paymentStep()
                   : _reviewStep(),
            ),
          ),
        )),
        _buildBottomBar(),
      ]),
    );
  }

  // ── Step indicator ────────────────────────────────
  Widget _buildStepper() {
    const steps = ['Delivery', 'Payment', 'Review'];
    return Container(
      color: _navy,
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 14),
      child: Row(children: List.generate(steps.length * 2 - 1, (i) {
        if (i.isOdd) {
          final done = _step > i ~/ 2;
          return Expanded(child: AnimatedContainer(
            duration: const Duration(milliseconds: 400),
            height: 2,
            color: done ? _orange : Colors.white24,
          ));
        }
        final idx   = i ~/ 2;
        final done  = _step > idx;
        final active= _step == idx;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          width: active ? 30 : 24, height: active ? 30 : 24,
          decoration: BoxDecoration(
            color: done ? _orange : (active ? _orange : Colors.white24),
            shape: BoxShape.circle,
            boxShadow: active ? [BoxShadow(color: _orange.withValues(alpha: 0.5),
                blurRadius: 10, spreadRadius: 1)] : [],
          ),
          child: Center(child: done
              ? const Icon(Icons.check, color: Colors.white, size: 14)
              : Text('${idx + 1}', style: TextStyle(
                  color: active ? Colors.white : Colors.white54,
                  fontSize: 11, fontWeight: FontWeight.bold))),
        );
      })),
    );
  }

  // ── Step 1: Delivery ──────────────────────────────
  Widget _deliveryStep() {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      const Text('Delivery Address', style: TextStyle(
          fontSize: 16, fontWeight: FontWeight.bold, color: _navy)),
      const SizedBox(height: 14),
      ...List.generate(_addresses.length, (i) {
        final a   = _addresses[i];
        final sel = i == _selAddress;
        return _Hover(builder: (h) => GestureDetector(
          onTap: () => setState(() => _selAddress = i),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 220),
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: sel ? _navy.withValues(alpha: 0.04) : _card,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: sel ? _navy : (h ? Colors.grey.shade400 : Colors.grey.shade200), width: sel ? 2 : 1),
              boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: sel ? 0.06 : 0.03), blurRadius: 8)]),
            child: Row(children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 220),
                width: 22, height: 22,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: sel ? _navy : Colors.grey.shade400, width: 2),
                  color: sel ? _navy : Colors.transparent,
                ),
                child: sel ? const Icon(Icons.check, color: Colors.white, size: 13) : null,
              ),
              const SizedBox(width: 14),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(a['label']!, style: const TextStyle(
                    fontSize: 14, fontWeight: FontWeight.bold, color: _navy)),
                const SizedBox(height: 3),
                Text(a['line1']!, style: TextStyle(fontSize: 13, color: Colors.grey[700])),
                Text(a['line2']!, style: TextStyle(fontSize: 12, color: Colors.grey[500])),
              ])),
            ]),
          ),
        ));
      }),
      _Hover(builder: (h) => GestureDetector(
        onTap: () => Navigator.push(context, _slideRoute(const _AddressesPage())),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: h ? _orange.withValues(alpha: 0.05) : _card,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: h ? _orange.withValues(alpha: 0.4) : Colors.grey.shade200)),
          child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            Icon(Icons.add_circle_outline, color: h ? _orange : Colors.grey[400], size: 18),
            const SizedBox(width: 8),
            Text('Add New Address', style: TextStyle(
                color: h ? _orange : Colors.grey[600],
                fontSize: 13, fontWeight: FontWeight.w500)),
          ]),
        ),
      )),
      const SizedBox(height: 20),
      // Delivery speed
      const Text('Delivery Speed', style: TextStyle(
          fontSize: 16, fontWeight: FontWeight.bold, color: _navy)),
      const SizedBox(height: 12),
      ...[
        {'label': 'Standard Delivery', 'time': '3-5 Business Days', 'price': 'FREE', 'color': _green},
        {'label': 'Express Delivery',  'time': '1-2 Business Days', 'price': '\$9.99', 'color': _orange},
        {'label': 'Same-Day Delivery', 'time': 'Today by 9 PM',    'price': '\$19.99', 'color': _red},
      ].map((d) {
        final free = d['price'] == 'FREE';
        return Container(
          margin: const EdgeInsets.only(bottom: 10),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(color: _card, borderRadius: BorderRadius.circular(14),
              boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 5)]),
          child: Row(children: [
            Container(width: 18, height: 18,
              decoration: BoxDecoration(shape: BoxShape.circle,
                  border: Border.all(color: free ? _green : Colors.grey.shade300, width: 2),
                  color: free ? _green : Colors.transparent),
              child: free ? const Icon(Icons.check, color: Colors.white, size: 11) : null),
            const SizedBox(width: 12),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(d['label'] as String, style: const TextStyle(
                  fontSize: 13, fontWeight: FontWeight.w600, color: _navy)),
              Text(d['time'] as String, style: TextStyle(fontSize: 11, color: Colors.grey[500])),
            ])),
            Text(d['price'] as String, style: TextStyle(
                fontSize: 13, fontWeight: FontWeight.bold,
                color: d['color'] as Color)),
          ]),
        );
      }),
    ]);
  }

  // ── Step 2: Payment ───────────────────────────────
  Widget _paymentStep() {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      const Text('Payment Method', style: TextStyle(
          fontSize: 16, fontWeight: FontWeight.bold, color: _navy)),
      const SizedBox(height: 14),
      ...List.generate(_payments.length, (i) {
        final p   = _payments[i];
        final sel = i == _selPayment;
        return _Hover(builder: (h) => GestureDetector(
          onTap: () => setState(() => _selPayment = i),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 220),
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: sel ? (p['color'] as Color).withValues(alpha: 0.05) : _card,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                  color: sel ? (p['color'] as Color) : (h ? Colors.grey.shade300 : Colors.grey.shade200),
                  width: sel ? 2 : 1),
              boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 6)]),
            child: Row(children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 220),
                width: 22, height: 22,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: sel ? (p['color'] as Color) : Colors.grey.shade400, width: 2),
                  color: sel ? (p['color'] as Color) : Colors.transparent),
                child: sel ? const Icon(Icons.check, color: Colors.white, size: 13) : null,
              ),
              const SizedBox(width: 14),
              Container(padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                    color: (p['color'] as Color).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(10)),
                child: Icon(p['icon'] as IconData, color: p['color'] as Color, size: 20)),
              const SizedBox(width: 12),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(p['type'] as String, style: const TextStyle(
                    fontSize: 14, fontWeight: FontWeight.w600, color: _navy)),
                Text(p['num'] as String, style: TextStyle(fontSize: 11, color: Colors.grey[500])),
              ])),
              if (sel)
                Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                      color: (p['color'] as Color).withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(8)),
                  child: Text('Selected', style: TextStyle(
                      color: p['color'] as Color, fontSize: 10, fontWeight: FontWeight.bold))),
            ]),
          ),
        ));
      }),
      const SizedBox(height: 8),
      // Secure badge
      Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(color: _green.withValues(alpha: 0.06),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: _green.withValues(alpha: 0.2))),
        child: const Row(children: [
          Icon(Icons.lock_outline, color: _green, size: 18),
          SizedBox(width: 10),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('100% Secure Checkout', style: TextStyle(
                fontSize: 13, fontWeight: FontWeight.w600, color: _green)),
            SizedBox(height: 2),
            Text('256-bit SSL encryption • PCI DSS Compliant',
                style: TextStyle(fontSize: 10, color: Color(0xFF2E7D32))),
          ])),
        ]),
      ),
    ]);
  }

  // ── Step 3: Review ────────────────────────────────
  Widget _reviewStep() {
    final items = _globalCart.isEmpty
        ? [{'product': _allProducts[0], 'qty': 1}]
        : _globalCart;
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      const Text('Order Review', style: TextStyle(
          fontSize: 16, fontWeight: FontWeight.bold, color: _navy)),
      const SizedBox(height: 14),
      // Items
      ...items.map((c) {
        final p   = c['product'] as _Product;
        final qty = c['qty']     as int;
        return Container(
          margin: const EdgeInsets.only(bottom: 10),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(color: _card, borderRadius: BorderRadius.circular(14),
              boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 6)]),
          child: Row(children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: CachedNetworkImage(imageUrl: p.image,
                width: 70, height: 60, fit: BoxFit.cover,
                placeholder: (_, __) => Container(width: 70, height: 60, color: Colors.grey[100]),
                errorWidget: (_, __, ___) => Container(width: 70, height: 60, color: Colors.grey[100],
                    child: const Icon(Icons.laptop_mac, color: _navy, size: 28))),
            ),
            const SizedBox(width: 12),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(p.name, maxLines: 1, overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: _navy)),
              Text(p.specs, maxLines: 1, overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 10, color: Colors.grey[500])),
              const SizedBox(height: 4),
              Text('Qty: $qty', style: TextStyle(fontSize: 11, color: Colors.grey[600])),
            ])),
            Text('\$${(p.price * qty).toStringAsFixed(0)}',
                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: _orange)),
          ]),
        );
      }),
      const SizedBox(height: 8),
      // Delivery address
      Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(color: _card, borderRadius: BorderRadius.circular(14),
            boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 6)]),
        child: Row(children: [
          const Icon(Icons.location_on_outlined, color: _orange, size: 20),
          const SizedBox(width: 10),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Text('Delivering to', style: TextStyle(
                fontSize: 11, color: Color(0xFF888888))),
            Text(_addresses[_selAddress]['label']!, style: const TextStyle(
                fontSize: 13, fontWeight: FontWeight.bold, color: _navy)),
            Text(_addresses[_selAddress]['line1']!,
                style: TextStyle(fontSize: 11, color: Colors.grey[600])),
          ])),
          GestureDetector(
            onTap: () => setState(() => _step = 0),
            child: const Text('Change', style: TextStyle(color: _orange,
                fontSize: 12, fontWeight: FontWeight.bold))),
        ]),
      ),
      const SizedBox(height: 10),
      // Payment
      Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(color: _card, borderRadius: BorderRadius.circular(14),
            boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 6)]),
        child: Row(children: [
          Icon(_payments[_selPayment]['icon'] as IconData,
              color: _payments[_selPayment]['color'] as Color, size: 20),
          const SizedBox(width: 10),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Text('Payment', style: TextStyle(fontSize: 11, color: Color(0xFF888888))),
            Text(_payments[_selPayment]['type'] as String, style: const TextStyle(
                fontSize: 13, fontWeight: FontWeight.bold, color: _navy)),
            Text(_payments[_selPayment]['num'] as String,
                style: TextStyle(fontSize: 11, color: Colors.grey[600])),
          ])),
          GestureDetector(
            onTap: () => setState(() => _step = 1),
            child: const Text('Change', style: TextStyle(color: _orange,
                fontSize: 12, fontWeight: FontWeight.bold))),
        ]),
      ),
      const SizedBox(height: 14),
      // Price summary
      Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(color: _card, borderRadius: BorderRadius.circular(14),
            boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 6)]),
        child: Column(children: [
          _priceRow('Subtotal', '\$${_sub.toStringAsFixed(0)}'),
          const SizedBox(height: 8),
          _priceRow('Shipping', 'FREE', valueColor: _green),
          const SizedBox(height: 8),
          _priceRow('Tax (8%)', '\$${_tax.toStringAsFixed(0)}'),
          const Divider(height: 20),
          _priceRow('Total', '\$${_total.toStringAsFixed(0)}', bold: true),
        ]),
      ),
    ]);
  }

  Widget _priceRow(String label, String val, {Color? valueColor, bool bold = false}) =>
    Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      Text(label, style: TextStyle(fontSize: 13,
          color: bold ? _navy : Colors.grey[600],
          fontWeight: bold ? FontWeight.bold : FontWeight.normal)),
      Text(val, style: TextStyle(fontSize: 13,
          color: valueColor ?? (bold ? _orange : _navy),
          fontWeight: bold ? FontWeight.bold : FontWeight.w500)),
    ]);

  // ── Bottom action bar ─────────────────────────────
  Widget _buildBottomBar() {
    final isLast = _step == 2;
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(16),
      child: Row(children: [
        if (_step > 0)
          _Hover(builder: (h) => GestureDetector(
            onTap: () => setState(() => _step--),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
              decoration: BoxDecoration(
                color: h ? Colors.grey.shade200 : Colors.grey.shade100,
                borderRadius: BorderRadius.circular(14)),
              child: const Icon(Icons.arrow_back, color: _navy, size: 20)),
          )),
        if (_step > 0) const SizedBox(width: 12),
        Expanded(child: _Hover(builder: (h) => GestureDetector(
          onTap: () {
            if (isLast) {
              _placeOrder();
            } else {
              setState(() => _step++);
            }
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(vertical: 16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: isLast
                    ? [_green, const Color(0xFF1B5E20)]
                    : [_orange, _orangeD],
                begin: Alignment.topLeft, end: Alignment.bottomRight),
              borderRadius: BorderRadius.circular(14),
              boxShadow: [BoxShadow(
                color: (isLast ? _green : _orange).withValues(alpha: h ? 0.5 : 0.3),
                blurRadius: h ? 18 : 10, offset: const Offset(0, 5))]),
            child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              Icon(isLast ? Icons.check_circle_outline : Icons.arrow_forward,
                  color: Colors.white, size: 20),
              const SizedBox(width: 8),
              Text(
                isLast ? 'Place Order — \$${_total.toStringAsFixed(0)}'
                       : (_step == 0 ? 'Continue to Payment'
                                     : 'Review Order'),
                style: const TextStyle(color: Colors.white,
                    fontSize: 15, fontWeight: FontWeight.bold)),
            ]),
          ),
        ))),
      ]),
    );
  }

  // ── Order success animation ───────────────────────
  Widget _buildSuccess() {
    return Scaffold(
      backgroundColor: _bg,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            ScaleTransition(
              scale: _successScale,
              child: Container(
                width: 120, height: 120,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                      colors: [_green, Color(0xFF1B5E20)],
                      begin: Alignment.topLeft, end: Alignment.bottomRight),
                  shape: BoxShape.circle,
                  boxShadow: [BoxShadow(color: _green.withValues(alpha: 0.4),
                      blurRadius: 30, spreadRadius: 4)]),
                child: const Icon(Icons.check_rounded, color: Colors.white, size: 60),
              ),
            ),
            const SizedBox(height: 32),
            const Text('Order Placed! 🎉', style: TextStyle(
                fontSize: 26, fontWeight: FontWeight.bold, color: _navy)),
            const SizedBox(height: 12),
            Text('Your laptop is on its way!\nExpected delivery in 2-5 business days.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14, color: Colors.grey[600], height: 1.6)),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                  color: _orange.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(20)),
              child: Text('Order #LH-${DateTime.now().millisecond}',
                  style: const TextStyle(
                      color: _orange, fontSize: 13, fontWeight: FontWeight.bold))),
            const SizedBox(height: 40),
            // Steps
            ...[
              {'icon': Icons.receipt_outlined,    'text': 'Order Confirmation Email Sent'},
              {'icon': Icons.inventory_2_outlined, 'text': 'Packaging in Progress'},
              {'icon': Icons.local_shipping_outlined,'text': 'Ships in 24 Hours'},
            ].map((s) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Row(children: [
                Container(padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(color: _green.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(10)),
                  child: Icon(s['icon'] as IconData, color: _green, size: 18)),
                const SizedBox(width: 12),
                Text(s['text'] as String, style: const TextStyle(
                    fontSize: 13, fontWeight: FontWeight.w500, color: _navy)),
              ]),
            )),
            const SizedBox(height: 32),
            const Text('Returning to home...', style: TextStyle(
                color: Color(0xFF888888), fontSize: 12)),
          ]),
        ),
      ),
    );
  }
}

// ════════════════════════════════════════════════════
// FILTER PAGE
// ════════════════════════════════════════════════════
class _FilterPage extends StatefulWidget {
  const _FilterPage();
  @override
  State<_FilterPage> createState() => _FilterPageState();
}

class _FilterPageState extends State<_FilterPage> {
  RangeValues _price = const RangeValues(0, 3500);
  final Set<String> _brands    = {};
  final Set<String> _cats      = {};
  String _sortBy = 'Popular';

  static const _allBrands = ['Dell', 'Apple', 'ASUS', 'HP', 'Lenovo', 'Acer', 'Razer', 'Samsung', 'Microsoft', 'Gigabyte'];
  static const _allCats   = ['Gaming', 'Business', 'Student', 'Apple'];
  static const _sorts     = ['Popular', 'Price: Low to High', 'Price: High to Low', 'Rating', 'Newest'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      appBar: AppBar(
        backgroundColor: _navy, foregroundColor: Colors.white,
        title: const Text('Filter & Sort', style: TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          TextButton(
            onPressed: () => setState(() {
              _price = const RangeValues(0, 3500);
              _brands.clear(); _cats.clear(); _sortBy = 'Popular';
            }),
            child: const Text('Reset', style: TextStyle(color: Colors.white70)),
          ),
        ],
      ),
      body: Column(children: [
        Expanded(child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            // Sort
            _sectionLabel('Sort By'),
            Wrap(spacing: 8, runSpacing: 8, children: _sorts.map((s) {
              final sel = s == _sortBy;
              return _Hover(builder: (h) => GestureDetector(
                onTap: () => setState(() => _sortBy = s),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
                  decoration: BoxDecoration(
                    color: sel ? _navy : (h ? _navy.withValues(alpha: 0.06) : _card),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: sel ? _navy : Colors.grey.shade200)),
                  child: Text(s, style: TextStyle(
                      fontSize: 12, fontWeight: FontWeight.w500,
                      color: sel ? Colors.white : _navy)),
                ),
              ));
            }).toList()),
            const SizedBox(height: 20),
            // Price range
            _sectionLabel('Price Range'),
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Text('\$${_price.start.toInt()}',
                  style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: _orange)),
              Text('\$${_price.end.toInt()}',
                  style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: _orange)),
            ]),
            SliderTheme(
              data: SliderThemeData(
                activeTrackColor: _orange, thumbColor: _orange,
                overlayColor: _orange.withValues(alpha: 0.15),
                inactiveTrackColor: Colors.grey.shade200,
                trackHeight: 4,
              ),
              child: RangeSlider(
                values: _price,
                min: 0, max: 3500, divisions: 35,
                onChanged: (v) => setState(() => _price = v),
              ),
            ),
            const SizedBox(height: 20),
            // Brands
            _sectionLabel('Brand'),
            Wrap(spacing: 8, runSpacing: 8, children: _allBrands.map((b) {
              final sel = _brands.contains(b);
              return _Hover(builder: (h) => GestureDetector(
                onTap: () => setState(() => sel ? _brands.remove(b) : _brands.add(b)),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
                  decoration: BoxDecoration(
                    color: sel ? _orange : (h ? _orange.withValues(alpha: 0.06) : _card),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: sel ? _orange : Colors.grey.shade200)),
                  child: Text(b, style: TextStyle(
                      fontSize: 12, fontWeight: FontWeight.w500,
                      color: sel ? Colors.white : _navy)),
                ),
              ));
            }).toList()),
            const SizedBox(height: 20),
            // Categories
            _sectionLabel('Category'),
            Wrap(spacing: 8, runSpacing: 8, children: _allCats.map((c) {
              final sel = _cats.contains(c);
              return _Hover(builder: (h) => GestureDetector(
                onTap: () => setState(() => sel ? _cats.remove(c) : _cats.add(c)),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
                  decoration: BoxDecoration(
                    color: sel ? const Color(0xFF1565C0) : (h ? const Color(0xFF1565C0).withValues(alpha: 0.06) : _card),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: sel ? const Color(0xFF1565C0) : Colors.grey.shade200)),
                  child: Text(c, style: TextStyle(
                      fontSize: 12, fontWeight: FontWeight.w500,
                      color: sel ? Colors.white : _navy)),
                ),
              ));
            }).toList()),
          ]),
        )),
        // Apply button
        Container(
          color: Colors.white,
          padding: const EdgeInsets.all(16),
          child: _Hover(builder: (h) => GestureDetector(
            onTap: () {
              Navigator.pop(context);
              _snack(context,
                  'Filters applied: ${_brands.isEmpty ? "All brands" : _brands.join(", ")} | \$${_price.start.toInt()}-\$${_price.end.toInt()}',
                  color: _green);
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                    colors: [_orange, h ? _orangeD : _orange],
                    begin: Alignment.topLeft, end: Alignment.bottomRight),
                borderRadius: BorderRadius.circular(14),
                boxShadow: [BoxShadow(color: _orange.withValues(alpha: h ? 0.5 : 0.3),
                    blurRadius: h ? 16 : 8, offset: const Offset(0, 4))]),
              child: const Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                Icon(Icons.check, color: Colors.white, size: 20),
                SizedBox(width: 8),
                Text('Apply Filters', style: TextStyle(
                    color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold)),
              ]),
            ),
          )),
        ),
      ]),
    );
  }

  Widget _sectionLabel(String label) => Padding(
    padding: const EdgeInsets.only(bottom: 10),
    child: Text(label, style: const TextStyle(
        fontSize: 14, fontWeight: FontWeight.bold, color: _navy)),
  );
}

// ════════════════════════════════════════════════════
// LOGIN PAGE
// ════════════════════════════════════════════════════
class _LoginPage extends StatefulWidget {
  const _LoginPage();
  @override
  State<_LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<_LoginPage> with SingleTickerProviderStateMixin {
  final _emailCtrl = TextEditingController();
  final _passCtrl  = TextEditingController();
  final _formKey   = GlobalKey<FormState>();
  bool _obscure    = true;
  bool _loading    = false;
  late AnimationController _animCtrl;
  late Animation<double>   _fadeIn;
  late Animation<Offset>   _slideIn;

  @override
  void initState() {
    super.initState();
    _animCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 700));
    _fadeIn  = CurvedAnimation(parent: _animCtrl, curve: Curves.easeIn);
    _slideIn = Tween<Offset>(begin: const Offset(0, 0.1), end: Offset.zero)
        .animate(CurvedAnimation(parent: _animCtrl, curve: Curves.easeOutCubic));
    _animCtrl.forward();
  }

  @override
  void dispose() { _animCtrl.dispose(); _emailCtrl.dispose(); _passCtrl.dispose(); super.dispose(); }

  void _login() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _loading = true);
    await Future.delayed(const Duration(milliseconds: 1500));
    if (!mounted) return;
    setState(() => _loading = false);
    _snack(context, 'Welcome back! Login successful 🎉', color: _green);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _navy,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(28),
          child: FadeTransition(opacity: _fadeIn,
            child: SlideTransition(position: _slideIn,
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                const SizedBox(height: 20),
                // Logo
                Center(child: Column(children: [
                  Container(
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(colors: [_orange, Color(0xFFFF8C42)],
                          begin: Alignment.topLeft, end: Alignment.bottomRight),
                      shape: BoxShape.circle,
                      boxShadow: [BoxShadow(color: _orange.withValues(alpha: 0.45),
                          blurRadius: 24, spreadRadius: 4)]),
                    child: const Icon(Icons.laptop_mac, color: Colors.white, size: 36)),
                  const SizedBox(height: 16),
                  const Text('LaptopHarbor', style: TextStyle(
                      color: Colors.white, fontSize: 26, fontWeight: FontWeight.bold,
                      letterSpacing: 1)),
                  const SizedBox(height: 6),
                  Text('Sign in to your account', style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.55), fontSize: 13)),
                ])),
                const SizedBox(height: 40),
                Form(key: _formKey, child: Column(children: [
                  // Email
                  TextFormField(
                    controller: _emailCtrl,
                    keyboardType: TextInputType.emailAddress,
                    style: const TextStyle(color: Colors.white, fontSize: 14),
                    decoration: _inputDeco('Email Address', Icons.email_outlined),
                    validator: (v) {
                      if (v == null || v.isEmpty) return 'Email required';
                      if (!v.contains('@')) return 'Invalid email';
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  // Password
                  TextFormField(
                    controller: _passCtrl,
                    obscureText: _obscure,
                    style: const TextStyle(color: Colors.white, fontSize: 14),
                    decoration: _inputDeco('Password', Icons.lock_outline).copyWith(
                      suffixIcon: IconButton(
                        icon: Icon(_obscure ? Icons.visibility_off_outlined
                            : Icons.visibility_outlined, color: Colors.white54, size: 20),
                        onPressed: () => setState(() => _obscure = !_obscure)),
                    ),
                    validator: (v) {
                      if (v == null || v.isEmpty) return 'Password required';
                      if (v.length < 6) return 'Min 6 characters';
                      return null;
                    },
                  ),
                  const SizedBox(height: 12),
                  // Forgot password
                  Align(alignment: Alignment.centerRight,
                    child: GestureDetector(
                      onTap: () => _snack(context, 'Reset link sent to your email!', color: _orange),
                      child: Text('Forgot Password?', style: TextStyle(
                          color: _orange.withValues(alpha: 0.9), fontSize: 13,
                          fontWeight: FontWeight.w500)))),
                  const SizedBox(height: 28),
                  // Login button
                  _Hover(builder: (h) => GestureDetector(
                    onTap: _loading ? null : _login,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      width: double.infinity,
                      height: 52,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                            colors: [_orange, h ? _orangeD : _orange],
                            begin: Alignment.topLeft, end: Alignment.bottomRight),
                        borderRadius: BorderRadius.circular(14),
                        boxShadow: [BoxShadow(color: _orange.withValues(alpha: h ? 0.5 : 0.3),
                            blurRadius: h ? 18 : 10, offset: const Offset(0, 5))]),
                      child: Center(child: _loading
                          ? const SizedBox(width: 22, height: 22,
                              child: CircularProgressIndicator(strokeWidth: 2.5, color: Colors.white))
                          : const Text('Sign In', style: TextStyle(
                              color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold))),
                    ),
                  )),
                  const SizedBox(height: 20),
                  // OR divider
                  Row(children: [
                    Expanded(child: Container(height: 1, color: Colors.white12)),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Text('OR', style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.35), fontSize: 12))),
                    Expanded(child: Container(height: 1, color: Colors.white12)),
                  ]),
                  const SizedBox(height: 20),
                  // Google sign in
                  _Hover(builder: (h) => GestureDetector(
                    onTap: () => _snack(context, 'Google Sign-In coming soon!'),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      decoration: BoxDecoration(
                        color: h ? Colors.white.withValues(alpha: 0.15) : Colors.white.withValues(alpha: 0.08),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: Colors.white.withValues(alpha: 0.15))),
                      child: const Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                        Icon(Icons.g_mobiledata_rounded, color: Colors.white, size: 24),
                        SizedBox(width: 8),
                        Text('Continue with Google', style: TextStyle(
                            color: Colors.white, fontSize: 14, fontWeight: FontWeight.w500)),
                      ]),
                    ),
                  )),
                  const SizedBox(height: 32),
                  // Sign up link
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                    Text("Don't have an account? ",
                        style: TextStyle(color: Colors.white.withValues(alpha: 0.55), fontSize: 13)),
                    GestureDetector(
                      onTap: () => _snack(context, 'Sign up page coming soon!', color: _orange),
                      child: const Text('Sign Up', style: TextStyle(
                          color: _orange, fontSize: 13, fontWeight: FontWeight.bold))),
                  ]),
                ])),
              ]),
            ),
          ),
        ),
      ),
    );
  }

  InputDecoration _inputDeco(String label, IconData icon) => InputDecoration(
    labelText: label,
    labelStyle: TextStyle(color: Colors.white.withValues(alpha: 0.55), fontSize: 13),
    prefixIcon: Icon(icon, color: Colors.white38, size: 20),
    filled: true,
    fillColor: Colors.white.withValues(alpha: 0.07),
    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.15))),
    enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.15))),
    focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: _orange, width: 1.5)),
    errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: _red)),
    errorStyle: const TextStyle(color: Color(0xFFFF8A80)),
  );
}
