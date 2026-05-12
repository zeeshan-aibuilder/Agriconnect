import 'package:flutter/material.dart';
import 'dart:async'; 
import '../../core/theme/app_colors.dart';
import 'add_listing_screen.dart';
import 'listing_detail_screen.dart'; 

// ==========================================
// PREMIUM DESIGN TOKENS (GREEN THEME)
// ==========================================
const Color _ink = Color(0xFF1E293B);
const Color _muted = Color(0xFF64748B);
const Color _primaryGreen = Color(0xFF10B981);
const Color _hairline = Color(0xFFE2E8F0);
const Color _surfaceSoft = Color(0xFFF1F5F9); 

class HomeScreen extends StatefulWidget {
  final String role;
  const HomeScreen({super.key, required this.role});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final PageController _promoController = PageController(viewportFraction: 0.92);
  int _currentPromoIndex = 0;
  Timer? _promoTimer;

  String _selectedGraphCrop = 'Wheat'; 
  final List<String> _graphCrops = ['Wheat', 'Apples', 'Rice', 'Cotton', 'Corn'];

  final Map<String, Map<String, dynamic>> _mandiGraphData = {
    'Wheat': {'price': 'Rs. 4,250', 'unit': '/ 40kg', 'trend': '+2.4%', 'isUp': true, 'data': [0.4, 0.6, 0.5, 0.8, 0.7, 0.9, 1.0]},
    'Apples': {'price': 'Rs. 4,500', 'unit': '/ Carton', 'trend': '+5.1%', 'isUp': true, 'data': [0.3, 0.4, 0.4, 0.6, 0.8, 0.9, 0.85]},
    'Rice': {'price': 'Rs. 8,500', 'unit': '/ 40kg', 'trend': '-1.2%', 'isUp': false, 'data': [1.0, 0.9, 0.8, 0.85, 0.7, 0.6, 0.65]},
    'Cotton': {'price': 'Rs. 9,100', 'unit': '/ 40kg', 'trend': '+0.5%', 'isUp': true, 'data': [0.7, 0.75, 0.7, 0.8, 0.85, 0.8, 0.9]},
    'Corn': {'price': 'Rs. 3,000', 'unit': '/ 40kg', 'trend': '-0.8%', 'isUp': false, 'data': [0.6, 0.8, 0.9, 0.7, 0.6, 0.5, 0.4]},
  };

  final List<Map<String, dynamic>> _promos = [
    {'title': 'Sona Urea - FFC 🌾', 'subtitle': 'Bumper fasal ki zamanat! Order bulk Sona Urea today.', 'color1': const Color(0xFF047857), 'color2': const Color(0xFF10B981), 'icon': Icons.eco_rounded, 'isAd': true},
    {'title': 'Millat Tractors 🚜', 'subtitle': 'Massey Ferguson 385. Book now on easy installment plans.', 'color1': const Color(0xFFB91C1C), 'color2': const Color(0xFFE11D48), 'icon': Icons.agriculture_rounded, 'isAd': true},
    {'title': 'Engro Zarkhez 🌿', 'subtitle': 'Pakistan\'s premium balanced fertilizer for maximum yield.', 'color1': const Color(0xFF1E3A8A), 'color2': const Color(0xFF3B82F6), 'icon': Icons.grass_rounded, 'isAd': true},
  ];

  @override
  void initState() {
    super.initState();
    _promoTimer = Timer.periodic(const Duration(seconds: 4), (Timer timer) {
      if (_promoController.hasClients) {
        int nextPage = _currentPromoIndex + 1;
        if (nextPage >= _promos.length) nextPage = 0;
        _promoController.animateToPage(nextPage, duration: const Duration(milliseconds: 800), curve: Curves.fastOutSlowIn);
      }
    });
  }

  @override
  void dispose() {
    _promoTimer?.cancel();
    _promoController.dispose();
    super.dispose();
  }
  
  String _getGreeting() {
    var hour = DateTime.now().hour;
    if (hour < 12) return 'Good morning';
    if (hour < 17) return 'Good afternoon';
    return 'Good evening';
  }

  @override
  Widget build(BuildContext context) {
    final isFarmer = widget.role == 'supplier' || widget.role == 'producer';

    return Scaffold(
      backgroundColor: _surfaceSoft,
      // Sirf Floating Action Button rakha hai
      floatingActionButton: Container(
        height: 56, width: 56,
        margin: const EdgeInsets.only(bottom: 16, right: 8),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          boxShadow: [BoxShadow(color: _primaryGreen.withOpacity(0.4), blurRadius: 12, offset: const Offset(0, 6))],
        ),
        child: FloatingActionButton(
          heroTag: 'home_fab', 
          onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => AddListingScreen(role: widget.role))),
          backgroundColor: _primaryGreen,
          elevation: 0, 
          shape: const CircleBorder(),
          child: const Icon(Icons.add_rounded, size: 30, color: Colors.white),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () async { await Future.delayed(const Duration(seconds: 1)); setState((){}); },
        color: _primaryGreen,
        backgroundColor: Colors.white,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SafeArea(
                bottom: false,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(24, 32, 24, 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(_getGreeting(), style: const TextStyle(color: _muted, fontSize: 14, fontWeight: FontWeight.w500)),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                Flexible(child: Text(isFarmer ? 'Kisan Bhai' : 'Industry Partner', style: const TextStyle(color: _ink, fontSize: 26, fontWeight: FontWeight.w700, letterSpacing: -0.5), maxLines: 1, overflow: TextOverflow.ellipsis)),
                                const SizedBox(width: 8),
                                Text(isFarmer ? '🌾' : '🏭', style: const TextStyle(fontSize: 22)),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 16),
                      Container(
                        height: 48, width: 48,
                        decoration: BoxDecoration(
                          color: Colors.white, 
                          shape: BoxShape.circle, 
                          border: Border.all(color: _hairline),
                          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8, offset: const Offset(0, 4))],
                        ),
                        child: IconButton(
                          icon: const Icon(Icons.notifications_none_rounded, color: _ink),
                          onPressed: () {}, 
                        ),
                      )
                    ],
                  ),
                ),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                child: Row(
                  children: [
                    Expanded(child: _StatCard(title: isFarmer ? 'Active Listings' : 'Demands', value: '12', icon: Icons.auto_graph_rounded, color: _primaryGreen)),
                    const SizedBox(width: 16),
                    Expanded(child: _StatCard(title: 'Pending Deals', value: '3', icon: Icons.timer_outlined, color: const Color(0xFFF59E0B))),
                  ],
                ),
              ),
              const SizedBox(height: 32),

              SizedBox(
                height: 170, 
                child: PageView.builder(
                  controller: _promoController,
                  physics: const BouncingScrollPhysics(),
                  onPageChanged: (int index) => setState(() => _currentPromoIndex = index),
                  itemCount: _promos.length,
                  itemBuilder: (context, index) {
                    final promo = _promos[index];
                    return _buildPromoBanner(title: promo['title'], subtitle: promo['subtitle'], color1: promo['color1'], color2: promo['color2'], icon: promo['icon'], isAd: promo['isAd']);
                  },
                ),
              ),
              const SizedBox(height: 16),
              
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  _promos.length,
                  (index) => AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    width: _currentPromoIndex == index ? 24 : 6,
                    height: 6,
                    decoration: BoxDecoration(color: _currentPromoIndex == index ? _ink : _hairline, borderRadius: BorderRadius.circular(4)),
                  ),
                ),
              ),
              const SizedBox(height: 48),

              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 24),
                child: Text('Market trends', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600, color: _ink, letterSpacing: -0.44)),
              ),
              const SizedBox(height: 16),
              
              SizedBox(
                height: 36,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  itemCount: _graphCrops.length,
                  itemBuilder: (context, index) {
                    final crop = _graphCrops[index];
                    final isSelected = _selectedGraphCrop == crop;
                    
                    return GestureDetector(
                      onTap: () => setState(() => _selectedGraphCrop = crop),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        margin: const EdgeInsets.only(right: 8),
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        decoration: BoxDecoration(
                          color: isSelected ? _ink : Colors.white,
                          borderRadius: BorderRadius.circular(999), 
                          border: Border.all(color: isSelected ? _ink : _hairline, width: 1),
                          boxShadow: isSelected ? [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 4, offset: const Offset(0, 2))] : [],
                        ),
                        child: Center(
                          child: Text(
                            crop,
                            style: TextStyle(color: isSelected ? Colors.white : _ink, fontSize: 13, fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 24),
              _buildDynamicMandiGraph(), 
              const SizedBox(height: 48),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Recent activity', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600, color: _ink, letterSpacing: -0.44)),
                        Text('Show all', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: _primaryGreen)),
                      ],
                    ),
                    const SizedBox(height: 16),
                    
                    _buildRichActivityCard(
                      title: isFarmer ? 'Premium Basmati Rice' : 'Require: Basmati 100T', 
                      time: '2 hours ago', 
                      status: 'Pending Approval',
                      statusColor: const Color(0xFFF59E0B),
                      icon: isFarmer ? Icons.eco_rounded : Icons.factory_rounded, 
                      isFarmer: isFarmer, 
                      context: context
                    ),
                    _buildRichActivityCard(
                      title: isFarmer ? 'Organic Wheat' : 'Require: Grade A Wheat', 
                      time: 'Yesterday', 
                      status: 'Deal Closed',
                      statusColor: _primaryGreen,
                      icon: Icons.grass_rounded, 
                      isFarmer: isFarmer, 
                      context: context, 
                      isClosed: true
                    ),
                    const SizedBox(height: 110), 
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // --- Graph & Cards helper methods (Same as you provided) ---
  Widget _buildDynamicMandiGraph() {
    final cropData = _mandiGraphData[_selectedGraphCrop]!;
    final bool isUp = cropData['isUp'];
    final List<double> chartValues = cropData['data'] as List<double>;
    final List<String> days = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20), 
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 16, offset: const Offset(0, 8))], 
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Average price', style: TextStyle(fontSize: 14, color: _muted)),
                    const SizedBox(height: 4),
                    Wrap(
                      crossAxisAlignment: WrapCrossAlignment.end,
                      children: [
                        Text(cropData['price'], style: const TextStyle(fontSize: 26, fontWeight: FontWeight.w700, color: _ink, letterSpacing: -0.5)),
                        const SizedBox(width: 4),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 4),
                          child: Text(cropData['unit'], style: const TextStyle(fontSize: 14, color: _muted)),
                        ),
                      ],
                    )
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(color: isUp ? _primaryGreen.withOpacity(0.1) : const Color(0xFFEF4444).withOpacity(0.1), borderRadius: BorderRadius.circular(999)),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(isUp ? Icons.arrow_upward_rounded : Icons.arrow_downward_rounded, color: isUp ? _primaryGreen : const Color(0xFFEF4444), size: 14),
                    const SizedBox(width: 4),
                    Text(cropData['trend'], style: TextStyle(color: isUp ? _primaryGreen : const Color(0xFFEF4444), fontWeight: FontWeight.w700, fontSize: 12)),
                  ],
                ),
              )
            ],
          ),
          const SizedBox(height: 32),
          SizedBox(
            height: 120,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: List.generate(chartValues.length, (index) {
                final double graphValue = chartValues[index]; 
                return Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 600), 
                      curve: Curves.easeOutQuart,
                      width: 20,
                      height: 90 * graphValue, 
                      decoration: BoxDecoration(
                        color: _ink, 
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(days[index], style: const TextStyle(fontSize: 12, color: _muted, fontWeight: FontWeight.w600)),
                  ],
                );
              }),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildPromoBanner({required String title, required String subtitle, required Color color1, required Color color2, required IconData icon, required bool isAd}) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [color1, color2], begin: Alignment.topLeft, end: Alignment.bottomRight),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: color2.withOpacity(0.3), blurRadius: 12, offset: const Offset(0, 6))],
      ),
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(24),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(title, style: const TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.w700, letterSpacing: -0.5), maxLines: 1, overflow: TextOverflow.ellipsis),
                      const SizedBox(height: 8),
                      Text(subtitle, style: TextStyle(fontSize: 13, color: Colors.white.withOpacity(0.9), height: 1.4), maxLines: 3, overflow: TextOverflow.ellipsis),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                Icon(icon, color: Colors.white.withOpacity(0.9), size: 56)
              ],
            ),
          ),
          if (isAd)
            Positioned(
              top: 16, right: 16,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(color: Colors.black.withOpacity(0.2), borderRadius: BorderRadius.circular(6)),
                child: const Text('SPONSORED', style: TextStyle(fontSize: 9, fontWeight: FontWeight.w700, color: Colors.white, letterSpacing: 0.8)),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildRichActivityCard({required String title, required String time, required String status, required Color statusColor, required IconData icon, required bool isFarmer, required BuildContext context, bool isClosed = false}) {
    return GestureDetector(
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => ListingDetailScreen(isFarmer: isFarmer))),
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white, 
          borderRadius: BorderRadius.circular(20), 
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 12, offset: const Offset(0, 6))], 
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12), 
              decoration: BoxDecoration(color: isClosed ? _surfaceSoft : statusColor.withOpacity(0.1), borderRadius: BorderRadius.circular(16)), 
              child: Icon(icon, color: isClosed ? _muted : statusColor, size: 24)
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start, 
                children: [
                  Text(title, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: isClosed ? _muted : _ink), maxLines: 1, overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8, 
                    runSpacing: 4, 
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: isClosed ? _surfaceSoft : statusColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(status, style: TextStyle(color: isClosed ? _muted : statusColor, fontSize: 11, fontWeight: FontWeight.w700)),
                      ),
                      Text('•  $time', style: const TextStyle(fontSize: 12, color: _muted)),
                    ],
                  ),
                ]
              ),
            ),
            const SizedBox(width: 8),
            const Icon(Icons.chevron_right_rounded, color: _muted, size: 20)
          ],
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String title, value;
  final IconData icon;
  final Color color;
  const _StatCard({required this.title, required this.value, required this.icon, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white, 
        borderRadius: BorderRadius.circular(20), 
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 12, offset: const Offset(0, 6))], 
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(color: _surfaceSoft, borderRadius: BorderRadius.circular(12)),
                child: Icon(icon, color: _ink, size: 20),
              ),
              Icon(Icons.north_east_rounded, color: color, size: 16),
            ],
          ),
          const SizedBox(height: 20),
          Text(value, style: const TextStyle(fontSize: 32, fontWeight: FontWeight.w700, color: _ink, letterSpacing: -1)),
          const SizedBox(height: 4),
          Text(title, style: const TextStyle(fontSize: 13, color: _muted, fontWeight: FontWeight.w500), maxLines: 1, overflow: TextOverflow.ellipsis),
        ],
      ),
    );
  }
}