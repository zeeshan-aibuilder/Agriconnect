import 'package:flutter/material.dart';
import 'dart:ui';
import '../listings/listing_detail_screen.dart';

// ==========================================
// ULTRA-PREMIUM DESIGN TOKENS (GREEN THEME)
// ==========================================
const Color _ink = Color(0xFF1E293B);
const Color _muted = Color(0xFF64748B);
const Color _primaryGreen = Color(0xFF10B981);
const Color _hairline = Color(0xFFE2E8F0);
const Color _surfaceSoft = Color(0xFFF1F5F9);

class MarketScreen extends StatefulWidget {
  final String role;
  const MarketScreen({super.key, required this.role});

  @override
  State<MarketScreen> createState() => _MarketScreenState();
}

class _MarketScreenState extends State<MarketScreen> {
  // Global States for Filters
  String _selectedCategory = 'All';
  String _searchQuery = '';
  String _selectedSort = 'Recommended';
  double _minPrice = 0;
  double _maxPrice = 50000; // Set a reasonable max limit

  final TextEditingController _searchController = TextEditingController();

  final List<String> _categories = [
    'All',
    'Wheat',
    'Rice',
    'Machinery',
    'Fertilizers',
    'Fruits',
  ];

  // Master Data List
  final List<Map<String, dynamic>> _marketItems = [
    {
      'title': 'Premium Organic Wheat (Grade A)',
      'priceRaw': 4200,
      'price': 'Rs 4,200',
      'unit': '/ 40kg',
      'location': 'Lahore, Punjab',
      'distance': '12 km away',
      'rating': '4.9',
      'category': 'Wheat',
      'isVerified': true,
      'isFavorite': true,
      'image':
          'https://images.unsplash.com/photo-1574323347407-f5e1ad6d020b?q=80&w=600&auto=format&fit=crop',
    },
    {
      'title': 'Millat Tractor 385 (2023 Model)',
      'priceRaw': 15000,
      'price': 'Rs 15,000',
      'unit': '/ day',
      'location': 'Faisalabad, Punjab',
      'distance': '45 km away',
      'rating': '4.8',
      'category': 'Machinery',
      'isVerified': true,
      'isFavorite': false,
      'image':
          'https://images.unsplash.com/photo-1592982537447-6f2da0c0c66b?q=80&w=600&auto=format&fit=crop',
    },
    {
      'title': 'Engro Zarkhez Fertilizer (50kg)',
      'priceRaw': 8500,
      'price': 'Rs 8,500',
      'unit': '/ bag',
      'location': 'Multan, Punjab',
      'distance': 'Same day',
      'rating': '5.0',
      'category': 'Fertilizers',
      'isVerified': false,
      'isFavorite': false,
      'image':
          'https://images.unsplash.com/photo-1628352081506-83c43123ed6d?q=80&w=600&auto=format&fit=crop',
    },
    {
      'title': 'Basmati Rice Super Kernel',
      'priceRaw': 9000,
      'price': 'Rs 9,000',
      'unit': '/ 40kg',
      'location': 'Gujranwala, Punjab',
      'distance': '20 km away',
      'rating': '4.7',
      'category': 'Rice',
      'isVerified': true,
      'isFavorite': false,
      'image':
          'https://images.unsplash.com/photo-1586201375761-83865001e8ac?q=80&w=600&auto=format&fit=crop',
    },
    {
      'title': 'Fresh Red Apples (Export Quality)',
      'priceRaw': 3500,
      'price': 'Rs 3,500',
      'unit': '/ carton',
      'location': 'Quetta',
      'distance': 'Delivery Available',
      'rating': '4.9',
      'category': 'Fruits',
      'isVerified': true,
      'isFavorite': false,
      'image':
          'https://images.unsplash.com/photo-1560806887-1e4cd0b6fac6?q=80&w=600&auto=format&fit=crop',
    },
  ];

  // ==========================================
  // LOGIC: SEARCH, CATEGORY, PRICE & SORT
  // ==========================================
  List<Map<String, dynamic>> get _filteredItems {
    // 1. Apply Search, Category AND Price Filters
    List<Map<String, dynamic>> result = _marketItems.where((item) {
      final matchesCategory =
          _selectedCategory == 'All' || item['category'] == _selectedCategory;
      final matchesSearch = item['title'].toString().toLowerCase().contains(
        _searchQuery.toLowerCase(),
      );

      // Price Check
      final itemPrice = item['priceRaw'] as int;
      final matchesPrice = itemPrice >= _minPrice && itemPrice <= _maxPrice;

      return matchesCategory && matchesSearch && matchesPrice;
    }).toList();

    // 2. Apply Sorting
    if (_selectedSort == 'Price: Low to High') {
      result.sort(
        (a, b) => (a['priceRaw'] as int).compareTo(b['priceRaw'] as int),
      );
    } else if (_selectedSort == 'Price: High to Low') {
      result.sort(
        (a, b) => (b['priceRaw'] as int).compareTo(a['priceRaw'] as int),
      );
    } else if (_selectedSort == 'Top Rated') {
      result.sort(
        (a, b) =>
            double.parse(b['rating']).compareTo(double.parse(a['rating'])),
      );
    }

    return result;
  }

  // ==========================================
  // LOGIC: TOP FILTER BOTTOM SHEET
  // ==========================================
  void _showFilterSheet() {
    // Local state variables so UI updates instantly inside the sheet
    String tempSort = _selectedSort;
    double tempMinPrice = _minPrice;
    double tempMaxPrice = _maxPrice;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setSheetState) {
            return Container(
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height * 0.85,
              ),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
              ),
              child: SafeArea(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Handle and Title
                    Padding(
                      padding: const EdgeInsets.only(top: 16, bottom: 8),
                      child: Center(
                        child: Container(
                          width: 48,
                          height: 6,
                          decoration: BoxDecoration(
                            color: _hairline,
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 16,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Filters',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w800,
                              color: _ink,
                              letterSpacing: -0.5,
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              setSheetState(() {
                                tempSort = 'Recommended';
                                tempMinPrice = 0;
                                tempMaxPrice = 50000;
                              });
                            },
                            child: const Text(
                              'Reset',
                              style: TextStyle(
                                color: _muted,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Scrollable Content
                    Flexible(
                      child: SingleChildScrollView(
                        physics: const BouncingScrollPhysics(),
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 8),
                            const Text(
                              'Sort by',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: _ink,
                              ),
                            ),
                            const SizedBox(height: 16),
                            Wrap(
                              spacing: 12,
                              runSpacing: 12,
                              children: [
                                _buildFilterChip(
                                  'Recommended',
                                  tempSort == 'Recommended',
                                  () => setSheetState(
                                    () => tempSort = 'Recommended',
                                  ),
                                ),
                                _buildFilterChip(
                                  'Price: Low to High',
                                  tempSort == 'Price: Low to High',
                                  () => setSheetState(
                                    () => tempSort = 'Price: Low to High',
                                  ),
                                ),
                                _buildFilterChip(
                                  'Price: High to Low',
                                  tempSort == 'Price: High to Low',
                                  () => setSheetState(
                                    () => tempSort = 'Price: High to Low',
                                  ),
                                ),
                                _buildFilterChip(
                                  'Top Rated',
                                  tempSort == 'Top Rated',
                                  () => setSheetState(
                                    () => tempSort = 'Top Rated',
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 32),

                            const Text(
                              'Price Range',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: _ink,
                              ),
                            ),
                            const SizedBox(height: 16),

                            // PREMIUM RANGE SLIDER UI
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Rs ${tempMinPrice.toInt()}',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w700,
                                    color: _primaryGreen,
                                    fontSize: 16,
                                  ),
                                ),
                                Text(
                                  tempMaxPrice == 50000
                                      ? 'Rs 50,000+'
                                      : 'Rs ${tempMaxPrice.toInt()}',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w700,
                                    color: _primaryGreen,
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            RangeSlider(
                              values: RangeValues(tempMinPrice, tempMaxPrice),
                              min: 0,
                              max: 50000,
                              divisions: 50, // Allows increments of 1000
                              activeColor: _primaryGreen,
                              inactiveColor: _hairline,
                              labels: RangeLabels(
                                'Rs ${tempMinPrice.toInt()}',
                                'Rs ${tempMaxPrice.toInt()}',
                              ),
                              onChanged: (RangeValues values) {
                                setSheetState(() {
                                  tempMinPrice = values.start;
                                  tempMaxPrice = values.end;
                                });
                              },
                            ),
                            const SizedBox(height: 32),
                          ],
                        ),
                      ),
                    ),

                    // Bottom Action Button (Show Results)
                    Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border(
                          top: BorderSide(color: _hairline, width: 1),
                        ),
                      ),
                      child: SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: ElevatedButton(
                          onPressed: () {
                            // Apply all filters to the main state!
                            setState(() {
                              _selectedSort = tempSort;
                              _minPrice = tempMinPrice;
                              _maxPrice = tempMaxPrice;
                            });
                            Navigator.pop(context);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _primaryGreen,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            elevation: 0,
                          ),
                          child: const Text(
                            'Show Results',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildFilterChip(String label, bool isSelected, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? _ink : Colors.white,
          border: Border.all(color: isSelected ? _ink : _hairline),
          borderRadius: BorderRadius.circular(999),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ]
              : [],
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : _ink,
            fontSize: 14,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final filteredData = _filteredItems;

    // Check if any filter is active (to show a dot on the filter icon)
    final bool isFilterActive =
        _selectedSort != 'Recommended' || _minPrice > 0 || _maxPrice < 50000;

    return Scaffold(
      backgroundColor: _surfaceSoft,
      body: SafeArea(
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            // ---- 1. APP BAR ----
            SliverAppBar(
              backgroundColor: _surfaceSoft,
              elevation: 0,
              floating: true,
              centerTitle: false,
              title: Text(
                widget.role == 'farmer' ? 'Marketplace' : 'Procurement',
                style: const TextStyle(
                  color: _ink,
                  fontSize: 28,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.5,
                ),
              ),
              actions: [
                Container(
                  margin: const EdgeInsets.only(right: 24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.04),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: IconButton(
                    icon: Stack(
                      children: [
                        const Icon(Icons.tune_rounded, color: _ink, size: 22),
                        if (isFilterActive)
                          Positioned(
                            right: 0,
                            top: 0,
                            child: Container(
                              width: 8,
                              height: 8,
                              decoration: const BoxDecoration(
                                color: _primaryGreen,
                                shape: BoxShape.circle,
                              ),
                            ),
                          ),
                      ],
                    ),
                    onPressed: _showFilterSheet,
                  ),
                ),
              ],
            ),

            // ---- 2. BLURRY STICKY SEARCH & CATEGORY STRIP ----
            SliverPersistentHeader(
              pinned: true,
              delegate: _StickyHeaderDelegate(
                child: ClipRRect(
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
                    child: Container(
                      color: _surfaceSoft.withValues(alpha: 0.85),
                      child: Column(
                        children: [
                          // Search Bar
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 8,
                            ),
                            child: Container(
                              height: 56,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(999),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.04),
                                    blurRadius: 12,
                                    offset: const Offset(0, 6),
                                  ),
                                ],
                              ),
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.search_rounded,
                                    color: _ink,
                                    size: 24,
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: TextField(
                                      controller: _searchController,
                                      onChanged: (value) =>
                                          setState(() => _searchQuery = value),
                                      style: const TextStyle(
                                        fontSize: 15,
                                        color: _ink,
                                        fontWeight: FontWeight.w500,
                                      ),
                                      decoration: InputDecoration(
                                        hintText: 'Search crops, machinery...',
                                        hintStyle: TextStyle(
                                          color: _muted.withValues(alpha: 0.8),
                                          fontSize: 15,
                                          fontWeight: FontWeight.w400,
                                        ),
                                        border: InputBorder.none,
                                        isDense: true,
                                      ),
                                    ),
                                  ),
                                  if (_searchQuery.isNotEmpty)
                                    GestureDetector(
                                      onTap: () {
                                        _searchController.clear();
                                        setState(() => _searchQuery = '');
                                        FocusScope.of(context).unfocus();
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.all(4),
                                        decoration: const BoxDecoration(
                                          color: _hairline,
                                          shape: BoxShape.circle,
                                        ),
                                        child: const Icon(
                                          Icons.close_rounded,
                                          color: _ink,
                                          size: 16,
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          ),

                          // Categories Strip
                          SizedBox(
                            height: 48,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              physics: const BouncingScrollPhysics(),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                              ),
                              itemCount: _categories.length,
                              itemBuilder: (context, index) {
                                final cat = _categories[index];
                                final isSelected = _selectedCategory == cat;
                                return GestureDetector(
                                  onTap: () =>
                                      setState(() => _selectedCategory = cat),
                                  child: AnimatedContainer(
                                    duration: const Duration(milliseconds: 200),
                                    margin: const EdgeInsets.symmetric(
                                      horizontal: 4,
                                      vertical: 6,
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 20,
                                    ),
                                    decoration: BoxDecoration(
                                      color: isSelected
                                          ? _primaryGreen
                                          : Colors.white,
                                      borderRadius: BorderRadius.circular(999),
                                      boxShadow: isSelected
                                          ? [
                                              BoxShadow(
                                                color: _primaryGreen
                                                    .withOpacity(0.3),
                                                blurRadius: 8,
                                                offset: const Offset(0, 4),
                                              ),
                                            ]
                                          : [],
                                    ),
                                    child: Center(
                                      child: Text(
                                        cat,
                                        style: TextStyle(
                                          color: isSelected
                                              ? Colors.white
                                              : _ink,
                                          fontSize: 13,
                                          fontWeight: isSelected
                                              ? FontWeight.w700
                                              : FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 16)),

            // ---- 3. EMPTY STATE OR RESPONSIVE GRID ----
            if (filteredData.isEmpty)
              SliverFillRemaining(
                hasScrollBody: false,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: _primaryGreen.withValues(alpha: 0.3),
                              blurRadius: 20,
                              offset: const Offset(0, 10),
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.search_off_rounded,
                          size: 48,
                          color: _muted,
                        ),
                      ),
                      const SizedBox(height: 24),
                      const Text(
                        'No results found',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                          color: _ink,
                          letterSpacing: -0.5,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Try adjusting your search or filters.',
                        style: TextStyle(
                          fontSize: 14,
                          color: _muted,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 24),
                      TextButton.icon(
                        onPressed: () {
                          setState(() {
                            _selectedCategory = 'All';
                            _searchQuery = '';
                            _selectedSort = 'Recommended';
                            _minPrice = 0;
                            _maxPrice = 50000;
                            _searchController.clear();
                          });
                        },
                        icon: const Icon(
                          Icons.refresh_rounded,
                          color: _primaryGreen,
                        ),
                        label: const Text(
                          'Clear Filters',
                          style: TextStyle(
                            color: _primaryGreen,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            else
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                sliver: SliverGrid(
                  gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 220,
                    mainAxisSpacing: 24,
                    crossAxisSpacing: 16,
                    childAspectRatio: 0.58,
                  ),
                  delegate: SliverChildBuilderDelegate((context, index) {
                    return _buildCleanMarketCard(filteredData[index]);
                  }, childCount: filteredData.length),
                ),
              ),

            const SliverToBoxAdapter(child: SizedBox(height: 140)),
          ],
        ),
      ),
    );
  }

  // ---- WIDGET: CLEAN INSET CARD ----
  Widget _buildCleanMarketCard(Map<String, dynamic> item) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                ListingDetailScreen(isFarmer: widget.role == 'farmer'),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 24,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Stack(
                fit: StackFit.expand,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(18),
                    child: Image.network(
                      item['image'],
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        color: _surfaceSoft,
                        child: Icon(
                          Icons.image_not_supported_rounded,
                          color: Colors.grey.shade400,
                        ),
                      ),
                    ),
                  ),

                  if (item['isVerified'])
                    Positioned(
                      top: 8,
                      left: 8,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.9),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(
                                  Icons.verified_rounded,
                                  color: _primaryGreen,
                                  size: 12,
                                ),
                                const SizedBox(width: 4),
                                const Text(
                                  'Verified',
                                  style: TextStyle(
                                    color: _ink,
                                    fontSize: 10,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),

                  Positioned(
                    top: 8,
                    right: 8,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.9),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            item['isFavorite']
                                ? Icons.favorite_rounded
                                : Icons.favorite_border_rounded,
                            color: item['isFavorite']
                                ? const Color(0xFFEF4444)
                                : _ink.withValues(alpha: 0.7),
                            size: 16,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.fromLTRB(6, 12, 6, 6),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item['title'],
                    style: const TextStyle(
                      color: _ink,
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      height: 1.2,
                      letterSpacing: -0.2,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Icon(
                        Icons.location_on_rounded,
                        size: 12,
                        color: _muted.withValues(alpha: 0.7),
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          item['distance'],
                          style: const TextStyle(
                            color: _muted,
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const Icon(
                        Icons.star_rounded,
                        size: 12,
                        color: Color(0xFFF59E0B),
                      ),
                      const SizedBox(width: 2),
                      Text(
                        item['rating'],
                        style: const TextStyle(
                          color: _ink,
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    crossAxisAlignment: WrapCrossAlignment.end,
                    children: [
                      Text(
                        item['price'],
                        style: const TextStyle(
                          color: _primaryGreen,
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                          letterSpacing: -0.5,
                        ),
                      ),
                      const SizedBox(width: 2),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 1),
                        child: Text(
                          item['unit'],
                          style: const TextStyle(
                            color: _muted,
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                          ),
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

class _StickyHeaderDelegate extends SliverPersistentHeaderDelegate {
  final Widget child;

  _StickyHeaderDelegate({required this.child});

  @override
  double get minExtent => 120.0;

  @override
  double get maxExtent => 120.0;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return SizedBox.expand(child: child);
  }

  @override
  bool shouldRebuild(_StickyHeaderDelegate oldDelegate) {
    return oldDelegate.child != child;
  }
}
