import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../chat/chat_detail_screen.dart';

const Color _bgDark = Color(0xFF0F172A);
const Color _cardDark = Color(0xFF1E293B);
const Color _primaryNeon = Color(0xFF10B981);
const Color _textWhite = Color(0xFFF8FAFC);
const Color _textMuted = Color(0xFF94A3B8);

class ListingDetailScreen extends StatelessWidget {
  final bool isFarmer;
  const ListingDetailScreen({super.key, required this.isFarmer});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bgDark,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          // --- 1. PRODUCT IMAGE HERO ---
          SliverAppBar(
            expandedHeight: 320,
            pinned: true,
            backgroundColor: _bgDark,
            leading: IconButton(
              icon: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.3),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.arrow_back_ios_new_rounded,
                  color: Colors.white,
                  size: 18,
                ),
              ),
              onPressed: () => Navigator.pop(context),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Image.network(
                    'https://images.unsplash.com/photo-1574323347407-f5e1ad6d020b?q=80&w=600&auto=format&fit=crop',
                    fit: BoxFit.cover,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [_bgDark, Colors.transparent, _bgDark],
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 20,
                    right: 20,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: _primaryNeon,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Text(
                        'VERIFIED STOCK',
                        style: TextStyle(
                          color: _bgDark,
                          fontWeight: FontWeight.w800,
                          fontSize: 10,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // --- 2. HEADER DETAILS ---
                  const Text(
                    'Premium Organic Wheat (Grade A)',
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.w900,
                      color: _textWhite,
                      letterSpacing: -0.5,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'OFFERED RATE',
                            style: TextStyle(
                              fontSize: 10,
                              color: _textMuted,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 1,
                            ),
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            'Rs. 4,200',
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.w900,
                              color: _primaryNeon,
                            ),
                          ),
                          Text(
                            'per 40kg',
                            style: TextStyle(
                              fontSize: 12,
                              color: _textMuted.withValues(alpha: 0.8),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        decoration: BoxDecoration(
                          color: _cardDark,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: Colors.white.withValues(alpha: 0.05),
                          ),
                        ),
                        child: Column(
                          children: const [
                            Text(
                              'MOQ',
                              style: TextStyle(
                                fontSize: 10,
                                color: _textMuted,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              '50 Tons',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w800,
                                color: _textWhite,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),

                  // --- 3. SUPPLIER CARD ---
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: _cardDark,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.05),
                      ),
                    ),
                    child: Row(
                      children: [
                        const CircleAvatar(
                          radius: 24,
                          backgroundImage: NetworkImage(
                            'https://images.unsplash.com/photo-1500382017468-9049fed747ef?q=80&w=100&auto=format&fit=crop',
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              Text(
                                'Chaudhry Farms',
                                style: TextStyle(
                                  color: _textWhite,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                'Lahore, Punjab • 4.9 ★',
                                style: TextStyle(
                                  color: _textMuted,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          icon: const Icon(
                            Icons.chat_bubble_rounded,
                            color: _primaryNeon,
                          ),
                          onPressed: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const ChatDetailScreen(
                                name: 'Chaudhry Farms',
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),

                  // --- 4. LOGISTICS ---
                  const Text(
                    'LOGISTICS INFO',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w800,
                      color: _textMuted,
                      letterSpacing: 1,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: _cardDark,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.05),
                      ),
                    ),
                    child: Column(
                      children: [
                        Row(
                          children: const [
                            Icon(
                              Icons.location_on_rounded,
                              color: _textMuted,
                              size: 20,
                            ),
                            SizedBox(width: 12),
                            Text(
                              'Pickup: Gujranwala Farm',
                              style: TextStyle(
                                color: _textWhite,
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                        const Padding(
                          padding: EdgeInsets.only(left: 10, top: 8, bottom: 8),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: SizedBox(
                              height: 20,
                              child: VerticalDivider(
                                color: _textMuted,
                                thickness: 1,
                              ),
                            ),
                          ),
                        ),
                        Row(
                          children: const [
                            Icon(
                              Icons.local_shipping_rounded,
                              color: _primaryNeon,
                              size: 20,
                            ),
                            SizedBox(width: 12),
                            Text(
                              'Delivery arranged by Buyer',
                              style: TextStyle(
                                color: _primaryNeon,
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 40),

                  // --- 5. ACTION BUTTON ---
                  SizedBox(
                    width: double.infinity,
                    height: 60,
                    child: ElevatedButton(
                      onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              const ChatDetailScreen(name: 'Chaudhry Farms'),
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _primaryNeon,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        elevation: 0,
                      ),
                      child: const Text(
                        'Initiate Deal & Negotiate',
                        style: TextStyle(
                          color: _bgDark,
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
