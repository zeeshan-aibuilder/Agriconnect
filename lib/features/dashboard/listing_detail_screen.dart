import 'package:flutter/material.dart';
import 'dart:ui'; 
import 'package:url_launcher/url_launcher.dart'; // Maps open karne ke liye

// ---- APNI SCREENS KE IMPORTS YAHAN DALEN ----
import 'chat_detail_screen.dart'; 
import 'user_profile_screen.dart'; 

// ==========================================
// ULTRA-PREMIUM DESIGN TOKENS
// ==========================================
const Color _ink = Color(0xFF1E293B); 
const Color _muted = Color(0xFF64748B);
const Color _primaryGreen = Color(0xFF10B981); 
const Color _hairline = Color(0xFFE2E8F0);
const Color _surfaceSoft = Color(0xFFF8FAFC); 

class ListingDetailScreen extends StatefulWidget {
  final bool isFarmer;

  const ListingDetailScreen({super.key, required this.isFarmer});

  @override
  State<ListingDetailScreen> createState() => _ListingDetailScreenState();
}

class _ListingDetailScreenState extends State<ListingDetailScreen> {
  // ---- STATE VARIABLES ----
  int _currentImageIndex = 0;
  bool _isDescriptionExpanded = false;

  // Mock Images Array
  final List<String> _images = [
    'https://images.unsplash.com/photo-1574323347407-f5e1ad6d020b?q=80&w=1000&auto=format&fit=crop',
    'https://images.unsplash.com/photo-1586201375761-83865001e31c?q=80&w=1000&auto=format&fit=crop', 
    'https://images.unsplash.com/photo-1627920769841-f67e5ed7a834?q=80&w=1000&auto=format&fit=crop',
  ];

  // ---- WORKFLOW 3: OPEN GOOGLE MAPS ----
  Future<void> _openMap() async {
    final Uri url = Uri.parse('https://www.google.com/maps/search/?api=1&query=Faisalabad,+Punjab');
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Could not open maps.')));
    }
  }

  // ---- WORKFLOW 1: OPEN CHAT SCREEN ----
  void _openChat() {
    Navigator.push(
      context, 
      MaterialPageRoute(builder: (context) => const ChatDetailScreen(userName: 'Chaudhry Farms'))
    );
  }

  // ---- WORKFLOW 2: OPEN PROFILE SCREEN ----
  void _openProfile() {
    Navigator.push(
      context, 
      MaterialPageRoute(builder: (context) => const UserProfileScreen(userName: 'Chaudhry Farms'))
    );
  }

  @override
  Widget build(BuildContext context) {
    // ---- WORKFLOW 4: DYNAMIC ROLE LOGIC ----
    // Agar farmer dekh raha hai, to usay industry (buyer) ki "Demand" nazar aani chahiye
    final String tagText = widget.isFarmer ? 'Verified Demand' : 'Verified Listing';
    final String highlight1Title = widget.isFarmer ? 'Required' : 'Available';
    final String highlight1Value = '50 Tons';
    final String buttonText = widget.isFarmer ? 'Contact Buyer' : 'Contact Farmer';

    return Scaffold(
      backgroundColor: _surfaceSoft,
      
      // ---- UX: GLASSMORPHIC STICKY BOTTOM BAR ----
      bottomNavigationBar: ClipRRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 24, sigmaY: 24),
          child: Container(
            padding: EdgeInsets.only(
              left: 24, right: 24, top: 16, 
              bottom: MediaQuery.of(context).padding.bottom > 0 ? MediaQuery.of(context).padding.bottom : 24
            ),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.85),
              border: Border(top: BorderSide(color: _hairline.withOpacity(0.5))),
            ),
            child: Row(
              children: [
                // Chat Button -> Navigates to Chat
                Container(
                  width: 56, height: 56,
                  decoration: BoxDecoration(
                    color: _primaryGreen.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: _primaryGreen.withOpacity(0.2)),
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.chat_bubble_rounded, color: _primaryGreen, size: 24),
                    onPressed: _openChat, // Connected to logic
                  ),
                ),
                const SizedBox(width: 16),
                
                // Primary Action Button -> Navigates to Chat
                Expanded(
                  child: Container(
                    height: 56,
                    decoration: BoxDecoration(
                      boxShadow: [BoxShadow(color: _primaryGreen.withOpacity(0.3), blurRadius: 16, offset: const Offset(0, 6))],
                    ),
                    child: ElevatedButton(
                      onPressed: _openChat, // Connected to logic
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _primaryGreen,
                        elevation: 0,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      ),
                      child: Text(
                        buttonText, // Dynamic Text Based on Role
                        style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w800, letterSpacing: 0.5),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      
      // ---- PARALLAX SCROLLING BODY ----
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          // ---- 1. INTERACTIVE IMAGE CAROUSEL HERO ----
          SliverAppBar(
            expandedHeight: 280.0, 
            pinned: true,
            stretch: true,
            backgroundColor: Colors.white,
            elevation: 0,
            leading: IconButton(
              icon: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(color: Colors.black.withOpacity(0.25), shape: BoxShape.circle),
                child: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 18),
              ),
              onPressed: () => Navigator.pop(context),
            ),
            actions: [
              IconButton(
                icon: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(color: Colors.black.withOpacity(0.25), shape: BoxShape.circle),
                  child: const Icon(Icons.favorite_border_rounded, color: Colors.white, size: 18),
                ),
                onPressed: () {},
              ),
              const SizedBox(width: 8),
            ],
            flexibleSpace: FlexibleSpaceBar(
              stretchModes: const [StretchMode.zoomBackground],
              background: Stack(
                fit: StackFit.expand,
                children: [
                  PageView.builder(
                    itemCount: _images.length,
                    onPageChanged: (index) {
                      setState(() {
                        _currentImageIndex = index;
                      });
                    },
                    itemBuilder: (context, index) {
                      return Image.network(
                        _images[index],
                        fit: BoxFit.cover,
                      );
                    },
                  ),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter, end: Alignment.bottomCenter,
                        colors: [Colors.black.withOpacity(0.3), Colors.transparent, Colors.black.withOpacity(0.4)],
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 48, 
                    left: 0, right: 0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        _images.length,
                        (index) => AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          height: 8,
                          width: _currentImageIndex == index ? 24 : 8,
                          decoration: BoxDecoration(
                            color: _currentImageIndex == index ? _primaryGreen : Colors.white.withOpacity(0.6),
                            borderRadius: BorderRadius.circular(4),
                            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 4)],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // ---- 2. OVERLAPPING DETAILS CARD ----
          SliverToBoxAdapter(
            child: Transform.translate(
              offset: const Offset(0, -32), 
              child: Container(
                decoration: const BoxDecoration(
                  color: _surfaceSoft,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    
                    // --- Title, Price & Header Info ---
                    Container(
                      padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: const BorderRadius.vertical(top: Radius.circular(32), bottom: Radius.circular(32)),
                        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10, offset: const Offset(0, 4))],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Center(
                            child: Container(
                              margin: const EdgeInsets.only(bottom: 24),
                              width: 48, height: 5,
                              decoration: BoxDecoration(color: _hairline, borderRadius: BorderRadius.circular(10)),
                            ),
                          ),

                          // Dynamic Verified Tag
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                            decoration: BoxDecoration(color: const Color(0xFF10B981).withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(Icons.verified_rounded, color: Color(0xFF10B981), size: 14),
                                const SizedBox(width: 4),
                                Text(tagText, style: const TextStyle(color: Color(0xFF10B981), fontSize: 11, fontWeight: FontWeight.w800)),
                              ],
                            ),
                          ),
                          const SizedBox(height: 16),
                          
                          const Text(
                            'Premium Quality Wheat (2026 Harvest)', 
                            style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800, color: _ink, letterSpacing: -0.5, height: 1.2)
                          ),
                          const SizedBox(height: 16),
                          
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              const Text('Rs 4,500', style: TextStyle(fontSize: 32, fontWeight: FontWeight.w800, color: _primaryGreen, letterSpacing: -1)),
                              const SizedBox(width: 6),
                              Padding(
                                padding: const EdgeInsets.only(bottom: 6),
                                child: Text('/ 40 kg', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: _muted.withOpacity(0.8))),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          
                          Row(
                            children: [
                              Container(padding: const EdgeInsets.all(6), decoration: const BoxDecoration(color: _surfaceSoft, shape: BoxShape.circle), child: const Icon(Icons.access_time_filled_rounded, color: _muted, size: 16)),
                              const SizedBox(width: 8),
                              const Text('Posted 2 hours ago', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: _ink)),
                            ],
                          )
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),

                    // --- Interactive Seller Info Card -> Opens Profile ---
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Material( 
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(24),
                        child: InkWell( 
                          onTap: _openProfile, // Connected to logic
                          borderRadius: BorderRadius.circular(24),
                          child: Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(24),
                              border: Border.all(color: _hairline),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  width: 56, height: 56,
                                  decoration: BoxDecoration(color: _primaryGreen.withOpacity(0.1), shape: BoxShape.circle, border: Border.all(color: _primaryGreen.withOpacity(0.2))),
                                  child: const Center(child: Text('C', style: TextStyle(color: _primaryGreen, fontSize: 24, fontWeight: FontWeight.w800))),
                                ),
                                const SizedBox(width: 16),
                                const Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text('Chaudhry Farms', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: _ink, letterSpacing: -0.3)),
                                      SizedBox(height: 4),
                                      Row(
                                        children: [
                                          Icon(Icons.star_rounded, color: Color(0xFFF59E0B), size: 16),
                                          SizedBox(width: 4),
                                          Text('4.8 (120 Reviews)', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: _muted)),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                Container(padding: const EdgeInsets.all(8), decoration: const BoxDecoration(color: _surfaceSoft, shape: BoxShape.circle), child: const Icon(Icons.arrow_forward_ios_rounded, color: _ink, size: 14)),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // --- Smart Expandable Description ---
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 24),
                      child: Text('Description', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: _ink, letterSpacing: -0.5)),
                    ),
                    const SizedBox(height: 12),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AnimatedCrossFade(
                            duration: const Duration(milliseconds: 300),
                            crossFadeState: _isDescriptionExpanded ? CrossFadeState.showSecond : CrossFadeState.showFirst,
                            firstChild: const Text(
                              'A-grade premium wheat available directly from our farm. Harvested this season with extreme care. Total available quantity is 50 tons...',
                              style: TextStyle(fontSize: 15, color: _muted, height: 1.6, fontWeight: FontWeight.w500),
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                            ),
                            secondChild: const Text(
                              'A-grade premium wheat available directly from our farm. Harvested this season with extreme care. Total available quantity is 50 tons. Transportation can be arranged upon request. Price is slightly negotiable for bulk buyers. We only use organic fertilizers and our yield has been tested by regional labs.',
                              style: TextStyle(fontSize: 15, color: _muted, height: 1.6, fontWeight: FontWeight.w500),
                            ),
                          ),
                          const SizedBox(height: 8),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                _isDescriptionExpanded = !_isDescriptionExpanded;
                              });
                            },
                            child: Text(
                              _isDescriptionExpanded ? 'Read less' : 'Read more',
                              style: const TextStyle(fontSize: 14, color: _primaryGreen, fontWeight: FontWeight.w800),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 32),
                    
                    // --- Dynamic Highlights Row ---
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Row(
                        children: [
                          _buildHighlightCard(Icons.inventory_2_rounded, highlight1Title, highlight1Value),
                          const SizedBox(width: 16),
                          _buildHighlightCard(Icons.local_shipping_rounded, 'Delivery', 'Available'),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    // --- Premium Visual Location Map Card -> Opens Map ---
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 24),
                      child: Text('Location', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: _ink, letterSpacing: -0.5)),
                    ),
                    const SizedBox(height: 12),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: _openMap, // Connected to Map logic
                          borderRadius: BorderRadius.circular(20),
                          child: Container(
                            height: 120,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: const Color(0xFFE2E8F0), 
                              borderRadius: BorderRadius.circular(20),
                              image: const DecorationImage(
                                image: NetworkImage('https://images.unsplash.com/photo-1524661135-423995f22d0b?q=80&w=1000&auto=format&fit=crop'), 
                                fit: BoxFit.cover,
                                opacity: 0.5,
                              ),
                              border: Border.all(color: _hairline),
                            ),
                            child: Center(
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(30),
                                  boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10, offset: const Offset(0, 4))],
                                ),
                                child: const Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(Icons.location_on_rounded, color: _primaryGreen, size: 20),
                                    SizedBox(width: 8),
                                    Text('Faisalabad, Punjab', style: TextStyle(fontWeight: FontWeight.w800, color: _ink)),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    
                    const SizedBox(height: 120), 
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildHighlightCard(IconData icon, String title, String value) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: _hairline),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10, offset: const Offset(0, 4))],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(color: _surfaceSoft, borderRadius: BorderRadius.circular(12)),
              child: Icon(icon, color: _primaryGreen, size: 20),
            ),
            const SizedBox(height: 16),
            Text(title, style: const TextStyle(fontSize: 12, color: _muted, fontWeight: FontWeight.w600)),
            const SizedBox(height: 4),
            Text(value, style: const TextStyle(fontSize: 15, color: _ink, fontWeight: FontWeight.w800)),
          ],
        ),
      ),
    );
  }
}