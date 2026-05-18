// ════════════════════════════════════════════════════
// FILE: lib/screens/home_screen.dart
// ════════════════════════════════════════════════════
import 'package:flutter/material.dart';

// ════════════════════════════════════════════════════
// HOME SCREEN
// ════════════════════════════════════════════════════
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  int _currentIndex = 0;
  String _selectedCategory = 'All';

  late AnimationController _animController;
  late Animation<double> _fadeAnim;

  final List<Map<String, dynamic>> _categories = [
    {'name': 'All',      'icon': Icons.apps},
    {'name': 'Gaming',   'icon': Icons.sports_esports},
    {'name': 'Business', 'icon': Icons.business_center},
    {'name': 'Student',  'icon': Icons.school},
    {'name': 'Apple',    'icon': Icons.apple},
    {'name': 'Budget',   'icon': Icons.savings},
  ];

  final List<Map<String, dynamic>> _products = [
    {
      'name': 'Dell XPS 15', 'brand': 'Dell', 'category': 'Business',
      'price': 1299, 'rating': 4.8, 'reviews': 120,
      'icon': Icons.laptop_mac, 'color': Color(0xFF1A237E), 'badge': 'Best Seller',
    },
    {
      'name': 'MacBook Pro M3', 'brand': 'Apple', 'category': 'Apple',
      'price': 1999, 'rating': 4.9, 'reviews': 89,
      'icon': Icons.laptop, 'color': Color(0xFF424242), 'badge': 'New',
    },
    {
      'name': 'ASUS ROG Strix', 'brand': 'ASUS', 'category': 'Gaming',
      'price': 2299, 'rating': 4.9, 'reviews': 74,
      'icon': Icons.laptop_chromebook, 'color': Color(0xFF880E4F), 'badge': 'Gaming',
    },
    {
      'name': 'HP Pavilion 15', 'brand': 'HP', 'category': 'Student',
      'price': 799, 'rating': 4.5, 'reviews': 67,
      'icon': Icons.laptop_mac, 'color': Color(0xFF0D47A1), 'badge': 'Budget',
    },
    {
      'name': 'Lenovo ThinkPad', 'brand': 'Lenovo', 'category': 'Business',
      'price': 1099, 'rating': 4.7, 'reviews': 95,
      'icon': Icons.laptop, 'color': Color(0xFF212121), 'badge': 'Popular',
    },
    {
      'name': 'Acer Nitro 5', 'brand': 'Acer', 'category': 'Gaming',
      'price': 999, 'rating': 4.6, 'reviews': 58,
      'icon': Icons.laptop_chromebook, 'color': Color(0xFF1B5E20), 'badge': 'Gaming',
    },
  ];

  List<Map<String, dynamic>> get _filteredProducts {
    if (_selectedCategory == 'All') return _products;
    return _products.where((p) => p['category'] == _selectedCategory).toList();
  }

  final Set<String> _wishlist = {};

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _fadeAnim = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeIn),
    );
    _animController.forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FF),
      body: FadeTransition(
        opacity: _fadeAnim,
        child: CustomScrollView(
          slivers: [
            // ── APP BAR ──────────────────────────────────
            SliverAppBar(
              expandedHeight: 180,
              floating: false,
              pinned: true,
              backgroundColor: const Color(0xFF1A237E),
              automaticallyImplyLeading: false,
              title: const Row(
                children: [
                  Icon(Icons.laptop_mac, color: Colors.white, size: 22),
                  SizedBox(width: 8),
                  Text(
                    'LaptopHarbor',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
              actions: [
                Stack(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.notifications_outlined, color: Colors.white),
                      onPressed: () {},
                    ),
                    Positioned(
                      top: 8, right: 8,
                      child: Container(
                        width: 8, height: 8,
                        decoration: const BoxDecoration(
                          color: Color(0xFFFF6D00),
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                  ],
                ),
                IconButton(
                  icon: const Icon(Icons.shopping_cart_outlined, color: Colors.white),
                  onPressed: () => Navigator.pushNamed(context, '/cart'),
                ),
              ],
              flexibleSpace: FlexibleSpaceBar(
                background: Container(
                  color: const Color(0xFF1A237E),
                  child: SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Good Morning 👋',
                            style: TextStyle(color: Colors.white60, fontSize: 14),
                          ),
                          const Text(
                            'Ali Hassan',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 14),
                          Container(
                            height: 48,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(14),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.08),
                                  blurRadius: 10,
                                ),
                              ],
                            ),
                            child: TextField(
                              onTap: () => Navigator.pushNamed(context, '/products'),
                              readOnly: true,
                              decoration: InputDecoration(
                                hintText: 'Laptop search karein...',
                                hintStyle: TextStyle(
                                  color: Colors.grey.shade400,
                                  fontSize: 14,
                                ),
                                prefixIcon: const Icon(
                                  Icons.search,
                                  color: Color(0xFF1A237E),
                                ),
                                suffixIcon: Container(
                                  margin: const EdgeInsets.all(6),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFFF6D00),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: const Icon(
                                    Icons.tune,
                                    color: Colors.white,
                                    size: 18,
                                  ),
                                ),
                                border: InputBorder.none,
                                fillColor: Colors.transparent,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),

            // ── BANNER SECTION ───────────────────────────
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 20, 16, 0),
                child: _BannerSection(),
              ),
            ),

            // ── STATS ROW ────────────────────────────────
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                child: Row(
                  children: [
                    _StatCard(
                      icon: Icons.laptop_mac,
                      label: 'Products',
                      value: '500+',
                      color: const Color(0xFF1A237E),
                    ),
                    const SizedBox(width: 10),
                    _StatCard(
                      icon: Icons.local_shipping_outlined,
                      label: 'Fast Delivery',
                      value: '2 Days',
                      color: const Color(0xFFFF6D00),
                    ),
                    const SizedBox(width: 10),
                    _StatCard(
                      icon: Icons.star_outline,
                      label: 'Rating',
                      value: '4.9★',
                      color: const Color(0xFF2E7D32),
                    ),
                  ],
                ),
              ),
            ),

            // ── CATEGORIES SECTION ───────────────────────
            SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.fromLTRB(16, 20, 16, 12),
                    child: Row(
                      children: [
                        Text(
                          'Categories',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF1A1A2E),
                          ),
                        ),
                        Spacer(),
                        Text(
                          'Sab dekhein',
                          style: TextStyle(
                            fontSize: 13,
                            color: Color(0xFFFF6D00),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 44,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: _categories.length,
                      itemBuilder: (_, i) {
                        final cat = _categories[i];
                        final isSelected = _selectedCategory == cat['name'];
                        return GestureDetector(
                          onTap: () => setState(
                            () => _selectedCategory = cat['name'],
                          ),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 250),
                            margin: const EdgeInsets.only(right: 10),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 10,
                            ),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? const Color(0xFF1A237E)
                                  : Colors.white,
                              borderRadius: BorderRadius.circular(22),
                              border: Border.all(
                                color: isSelected
                                    ? const Color(0xFF1A237E)
                                    : const Color(0xFFE0E4FF),
                              ),
                              boxShadow: isSelected
                                  ? [
                                      BoxShadow(
                                        color: const Color(0xFF1A237E)
                                            .withOpacity(0.3),
                                        blurRadius: 8,
                                        offset: const Offset(0, 3),
                                      ),
                                    ]
                                  : [],
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  cat['icon'] as IconData,
                                  size: 16,
                                  color: isSelected
                                      ? Colors.white
                                      : const Color(0xFF1A237E),
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  cat['name'],
                                  style: TextStyle(
                                    color: isSelected
                                        ? Colors.white
                                        : const Color(0xFF1A237E),
                                    fontWeight: FontWeight.w600,
                                    fontSize: 13,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),

            // ── FEATURED LAPTOPS HEADING ─────────────────
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 20, 16, 12),
                child: Row(
                  children: [
                    const Text(
                      'Featured Laptops',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF1A1A2E),
                      ),
                    ),
                    const Spacer(),
                    GestureDetector(
                      onTap: () => Navigator.pushNamed(context, '/products'),
                      child: const Text(
                        'Sab dekhein →',
                        style: TextStyle(
                          fontSize: 13,
                          color: Color(0xFFFF6D00),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // ── PRODUCTS GRID ────────────────────────────
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 100),
              sliver: SliverGrid(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final product = _filteredProducts[index];
                    final isWishlisted = _wishlist.contains(product['name']);
                    return _ProductCard(
                      product: product,
                      isWishlisted: isWishlisted,
                      onWishlistTap: () {
                        setState(() {
                          if (isWishlisted) {
                            _wishlist.remove(product['name']);
                          } else {
                            _wishlist.add(product['name']);
                          }
                        });
                      },
                      onTap: () =>
                          Navigator.pushNamed(context, '/product-detail'),
                    );
                  },
                  childCount: _filteredProducts.length,
                ),
                gridDelegate:
                    const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 14,
                  crossAxisSpacing: 14,
                  childAspectRatio: 0.72,
                ),
              ),
            ),
          ],
        ),
      ),

      // ── BOTTOM NAVIGATION BAR ────────────────────────
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 20,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() => _currentIndex = index);
            if (index == 1) Navigator.pushNamed(context, '/products');
            if (index == 2) Navigator.pushNamed(context, '/wishlist');
            if (index == 3) Navigator.pushNamed(context, '/profile');
          },
          type: BottomNavigationBarType.fixed,
          selectedItemColor: const Color(0xFF1A237E),
          unselectedItemColor: Colors.grey,
          selectedLabelStyle: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 11,
          ),
          backgroundColor: Colors.white,
          elevation: 0,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              activeIcon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.search),
              label: 'Search',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.favorite_outline),
              activeIcon: Icon(Icons.favorite),
              label: 'Wishlist',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_outline),
              activeIcon: Icon(Icons.person),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }
}

// ════════════════════════════════════════════════════
// BANNER SECTION WIDGET
// ════════════════════════════════════════════════════
class _BannerSection extends StatefulWidget {
  @override
  State<_BannerSection> createState() => __BannerSectionState();
}

class __BannerSectionState extends State<_BannerSection> {
  int _currentBanner = 0;
  final PageController _pageController = PageController();

  final List<Map<String, dynamic>> _banners = [
    {
      'title':    '🔥 Mega Sale!',
      'subtitle': 'Top brands par 40% tak off',
      'btn':      'Shop Now',
      'color1':   Color(0xFFFF6D00),
      'color2':   Color(0xFFFF9800),
    },
    {
      'title':    '💻 Gaming Laptops',
      'subtitle': 'RTX 4080 ke saath gaming karein',
      'btn':      'Explore',
      'color1':   Color(0xFF1A237E),
      'color2':   Color(0xFF283593),
    },
    {
      'title':    '🎓 Student Deal',
      'subtitle': 'Students ke liye special discount',
      'btn':      'Check Now',
      'color1':   Color(0xFF2E7D32),
      'color2':   Color(0xFF388E3C),
    },
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 150,
          child: PageView.builder(
            controller: _pageController,
            onPageChanged: (i) => setState(() => _currentBanner = i),
            itemCount: _banners.length,
            itemBuilder: (_, i) {
              final b = _banners[i];
              return Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [b['color1'] as Color, b['color2'] as Color],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              b['title'] as String,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              b['subtitle'] as String,
                              style: const TextStyle(
                                color: Colors.white70,
                                fontSize: 13,
                              ),
                            ),
                            const SizedBox(height: 14),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 7,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                b['btn'] as String,
                                style: TextStyle(
                                  color: b['color1'] as Color,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 13,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Icon(
                        Icons.laptop_mac,
                        size: 70,
                        color: Colors.white24,
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(_banners.length, (i) {
            return AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              margin: const EdgeInsets.symmetric(horizontal: 3),
              width: _currentBanner == i ? 20 : 7,
              height: 7,
              decoration: BoxDecoration(
                color: _currentBanner == i
                    ? const Color(0xFFFF6D00)
                    : Colors.grey.shade300,
                borderRadius: BorderRadius.circular(10),
              ),
            );
          }),
        ),
      ],
    );
  }
}

// ════════════════════════════════════════════════════
// STAT CARD WIDGET
// ════════════════════════════════════════════════════
class _StatCard extends StatelessWidget {
  final IconData icon;
  final String   label;
  final String   value;
  final Color    color;

  const _StatCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: const Color(0xFFE0E4FF)),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 22),
            const SizedBox(height: 6),
            Text(
              value,
              style: TextStyle(
                color: color,
                fontSize: 14,
                fontWeight: FontWeight.w700,
              ),
            ),
            Text(
              label,
              style: const TextStyle(color: Colors.grey, fontSize: 11),
            ),
          ],
        ),
      ),
    );
  }
}

// ════════════════════════════════════════════════════
// PRODUCT CARD WIDGET
// ════════════════════════════════════════════════════
class _ProductCard extends StatelessWidget {
  final Map<String, dynamic> product;
  final bool         isWishlisted;
  final VoidCallback onWishlistTap;
  final VoidCallback onTap;

  const _ProductCard({
    required this.product,
    required this.isWishlisted,
    required this.onWishlistTap,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFE0E4FF)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Image area ──────────────────────────────
            Stack(
              children: [
                Container(
                  height: 120,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: (product['color'] as Color).withOpacity(0.08),
                    borderRadius: const BorderRadius.only(
                      topLeft:  Radius.circular(16),
                      topRight: Radius.circular(16),
                    ),
                  ),
                  child: Center(
                    child: Icon(
                      product['icon'] as IconData,
                      size: 60,
                      color: product['color'] as Color,
                    ),
                  ),
                ),
                Positioned(
                  top: 8, left: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8, vertical: 3,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFF6D00),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      product['badge'] as String,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 9,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 6, right: 6,
                  child: GestureDetector(
                    onTap: onWishlistTap,
                    child: Container(
                      width: 30, height: 30,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 4,
                          ),
                        ],
                      ),
                      child: Icon(
                        isWishlisted
                            ? Icons.favorite
                            : Icons.favorite_outline,
                        size: 16,
                        color: isWishlisted ? Colors.red : Colors.grey,
                      ),
                    ),
                  ),
                ),
              ],
            ),

            // ── Product info ─────────────────────────────
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product['brand'] as String,
                    style: const TextStyle(color: Colors.grey, fontSize: 11),
                  ),
                  Text(
                    product['name'] as String,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF1A1A2E),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.star, color: Color(0xFFFFC107), size: 13),
                      const SizedBox(width: 3),
                      Text(
                        '${product['rating']}',
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF1A1A2E),
                        ),
                      ),
                      const SizedBox(width: 3),
                      Text(
                        '(${product['reviews']})',
                        style: const TextStyle(fontSize: 10, color: Colors.grey),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '\$${product['price']}',
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFFFF6D00),
                        ),
                      ),
                      Container(
                        width: 30, height: 30,
                        decoration: BoxDecoration(
                          color: const Color(0xFF1A237E),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(
                          Icons.add_shopping_cart,
                          color: Colors.white,
                          size: 16,
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
