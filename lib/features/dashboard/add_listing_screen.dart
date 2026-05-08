import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';

class AddListingScreen extends StatefulWidget {
  final String role; // 'farmer' or 'industry'
  const AddListingScreen({super.key, required this.role});

  @override
  State<AddListingScreen> createState() => _AddListingScreenState();
}

class _AddListingScreenState extends State<AddListingScreen> {
  final PageController _pageController = PageController();
  int _currentStep = 0;
  final int _totalSteps = 3;

  // Form Controllers
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _qtyController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();

  // State Variables
  String _selectedCategory = '';
  String _selectedUnit = '40kg (Maund)';
  final List<XFile> _selectedImages = [];
  final ImagePicker _picker = ImagePicker();

  // Premium Airbnb-style accent color (similar to Rausch)
  final Color _premiumAccent = const Color(0xFFFF385C);
  final Color _ink = const Color(0xFF222222);
  final Color _muted = const Color(0xFF6A6A6A);

  final List<Map<String, dynamic>> _categories = [
    {'name': 'Wheat', 'icon': Icons.grass_rounded},
    {'name': 'Rice', 'icon': Icons.eco_rounded},
    {'name': 'Cotton', 'icon': Icons.spa_rounded},
    {'name': 'Fruits', 'icon': Icons.apple_rounded},
    {'name': 'Vegetables', 'icon': Icons.local_florist_rounded},
    {'name': 'Machinery', 'icon': Icons.agriculture_rounded},
  ];

  final List<String> _units = ['kg', '40kg (Maund)', 'Ton', 'Carton', 'Dozen'];

  // ==========================================
  // LOGIC & ACTIONS
  // ==========================================
  void _nextStep() {
    if (_currentStep == 0 && (_selectedCategory.isEmpty || _titleController.text.isEmpty)) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: const Text('Please select a category and enter a title.'),
        backgroundColor: _ink,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ));
      return;
    }
    
    if (_currentStep < _totalSteps - 1) {
      _pageController.nextPage(duration: const Duration(milliseconds: 500), curve: Curves.easeOutQuart);
      setState(() => _currentStep++);
    } else {
      _publishListing();
    }
  }

  void _prevStep() {
    if (_currentStep > 0) {
      _pageController.previousPage(duration: const Duration(milliseconds: 500), curve: Curves.easeOutQuart);
      setState(() => _currentStep--);
    } else {
      Navigator.pop(context);
    }
  }

  Future<void> _pickImages() async {
    try {
      final List<XFile> images = await _picker.pickMultiImage(imageQuality: 80);
      if (images.isNotEmpty) {
        setState(() => _selectedImages.addAll(images));
      }
    } catch (e) {
      debugPrint("Image pick error");
    }
  }

  void _removeImage(int index) {
    setState(() => _selectedImages.removeAt(index));
  }

  void _publishListing() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Dialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)), // Soft radius
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: _premiumAccent.withOpacity(0.05),
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.check_rounded, color: _premiumAccent, size: 48),
              ),
              const SizedBox(height: 24),
              Text('You\'re all set!', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: _ink, letterSpacing: -0.44)),
              const SizedBox(height: 12),
              Text(
                widget.role == 'farmer' ? 'Your crop is now live on the marketplace.' : 'Your demand has been posted successfully.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: _muted, height: 1.5),
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _ink, // Black button for secondary actions in premium apps
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    elevation: 0,
                  ),
                  onPressed: () {
                    Navigator.pop(context); 
                    Navigator.pop(context); 
                  },
                  child: const Text('Back to Dashboard', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                ),
              )
            ],
          ),
        ),
      )
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    _titleController.dispose();
    _descController.dispose();
    _priceController.dispose();
    _qtyController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Pure white canvas
      
      // ---- PREMIUM CLEAN APPBAR ----
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0, // Prevent scroll shadow
        leading: IconButton(
          icon: Icon(Icons.close_rounded, color: _ink, size: 28),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          TextButton(
            onPressed: () {},
            child: Text('Save & exit', style: TextStyle(color: _ink, fontWeight: FontWeight.w600, fontSize: 16, decoration: TextDecoration.underline)),
          ),
          const SizedBox(width: 8),
        ],
      ),
      
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ---- AIRBNB STYLE STEP INDICATOR ----
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              child: Row(
                children: List.generate(_totalSteps, (index) {
                  return Expanded(
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      margin: const EdgeInsets.only(right: 8),
                      height: 4,
                      decoration: BoxDecoration(
                        color: index <= _currentStep ? _ink : Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(2), // Soft pill shape
                      ),
                    ),
                  );
                }),
              ),
            ),
            
            // ---- WIZARD PAGES ----
            Expanded(
              child: PageView(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  _buildStep1BasicInfo(),
                  _buildStep2Media(),
                  _buildStep3Pricing(widget.role == 'farmer'),
                ],
              ),
            ),
          ],
        ),
      ),
      
      // ---- STICKY BOTTOM BAR (Like Reservation Card) ----
      bottomNavigationBar: Container(
        padding: const EdgeInsets.only(top: 16, bottom: 32, left: 24, right: 24),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(top: BorderSide(color: Colors.grey.shade200, width: 1)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Back Link
            if (_currentStep > 0)
              TextButton(
                onPressed: _prevStep,
                style: TextButton.styleFrom(padding: EdgeInsets.zero, minimumSize: const Size(0, 0), tapTargetSize: MaterialTapTargetSize.shrinkWrap),
                child: Text('Back', style: TextStyle(color: _ink, fontSize: 16, fontWeight: FontWeight.w600, decoration: TextDecoration.underline)),
              )
            else
              const SizedBox.shrink(),
            
            // Next / Publish Button
            ElevatedButton(
              onPressed: _nextStep,
              style: ElevatedButton.styleFrom(
                backgroundColor: _currentStep == _totalSteps - 1 ? _premiumAccent : _ink,
                foregroundColor: Colors.white,
                elevation: 0,
                padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 32),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)), // Soft corners
              ),
              child: Text(
                _currentStep == _totalSteps - 1 ? 'Publish listing' : 'Next',
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ==========================================
  // STEP 1: CATEGORY & TITLE (OVERFLOW FIXED)
  // ==========================================
  Widget _buildStep1BasicInfo() {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Display Typography (Modest weight)
          Text('Which of these best describes your listing?', style: TextStyle(fontSize: 28, fontWeight: FontWeight.w600, color: _ink, height: 1.2, letterSpacing: -0.5)),
          const SizedBox(height: 32),

          // Airbnb Category Style Grid
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, 
              childAspectRatio: 1.3, // Slightly adjusted for smaller screens
              crossAxisSpacing: 16, 
              mainAxisSpacing: 16,
            ),
            itemCount: _categories.length,
            itemBuilder: (context, index) {
              final cat = _categories[index];
              final isSelected = _selectedCategory == cat['name'];
              return GestureDetector(
                onTap: () => setState(() => _selectedCategory = cat['name']),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.all(12), // Reduced padding slightly
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16), 
                    border: Border.all(
                      color: isSelected ? _ink : Colors.grey.shade300, 
                      width: isSelected ? 2 : 1
                    ),
                    boxShadow: isSelected ? [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4))] : [],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center, // Fixed overflow root cause
                    children: [
                      Icon(cat['icon'], size: 28, color: isSelected ? _ink : _muted),
                      const SizedBox(height: 12), // Fixed safe spacing
                      Flexible( // Prevents text from ever breaking out
                        child: Text(
                          cat['name'], 
                          style: TextStyle(
                            color: isSelected ? _ink : _ink.withOpacity(0.8), 
                            fontWeight: FontWeight.w600, 
                            fontSize: 15
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 48),

          Text('Now, let\'s give it a title', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600, color: _ink, letterSpacing: -0.44)),
          const SizedBox(height: 8),
          Text('Short titles work best. Have fun with it.', style: TextStyle(fontSize: 16, color: _muted)),
          const SizedBox(height: 24),
          
          _buildTextInput(controller: _titleController, hint: 'e.g. Fresh Organic Wheat'),
          const SizedBox(height: 32),
          
          Text('Create your description', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600, color: _ink, letterSpacing: -0.44)),
          const SizedBox(height: 8),
          Text('Share what makes your listing special.', style: TextStyle(fontSize: 16, color: _muted)),
          const SizedBox(height: 24),
          _buildTextInput(controller: _descController, hint: 'Tell buyers about the quality...', maxLines: 4),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  // ==========================================
  // STEP 2: MEDIA UPLOAD
  // ==========================================
  Widget _buildStep2Media() {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Add some photos of your produce', style: TextStyle(fontSize: 28, fontWeight: FontWeight.w600, color: _ink, height: 1.2, letterSpacing: -0.5)),
          const SizedBox(height: 8),
          Text('You\'ll need 1 photo to get started. You can add more or make changes later.', style: TextStyle(fontSize: 16, color: _muted, height: 1.5)),
          const SizedBox(height: 32),

          // Clean Upload Area
          GestureDetector(
            onTap: _pickImages,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 60),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: _ink, width: 1, style: BorderStyle.solid), // Clean dashed look via solid line in premium UI
              ),
              child: Column(
                children: [
                  Icon(Icons.photo_library_outlined, color: _ink, size: 48),
                  const SizedBox(height: 16),
                  Text('Drag your photos here', style: TextStyle(fontSize: 18, color: _ink, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 8),
                  Text('Choose at least 1 photo', style: TextStyle(fontSize: 14, color: _muted)),
                  const SizedBox(height: 24),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(border: Border.all(color: _ink), borderRadius: BorderRadius.circular(8)),
                    child: Text('Upload from device', style: TextStyle(color: _ink, fontWeight: FontWeight.w600, fontSize: 14)),
                  )
                ],
              ),
            ),
          ),
          const SizedBox(height: 32),

          if (_selectedImages.isNotEmpty) ...[
            Text('Photos', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600, color: _ink)),
            const SizedBox(height: 16),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, crossAxisSpacing: 16, mainAxisSpacing: 16, childAspectRatio: 1.2),
              itemCount: _selectedImages.length,
              itemBuilder: (context, index) {
                return Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: kIsWeb 
                        ? Image.network(_selectedImages[index].path, width: double.infinity, height: double.infinity, fit: BoxFit.cover, errorBuilder: (_,__,___) => _fallbackImage())
                        : Image.file(File(_selectedImages[index].path), width: double.infinity, height: double.infinity, fit: BoxFit.cover, errorBuilder: (_,__,___) => _fallbackImage()),
                    ),
                    Positioned(
                      top: 8, right: 8,
                      child: GestureDetector(
                        onTap: () => _removeImage(index),
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(color: Colors.white, shape: BoxShape.circle, boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 4)]),
                          child: Icon(Icons.delete_outline_rounded, color: _ink, size: 18),
                        ),
                      ),
                    )
                  ],
                );
              },
            ),
          ]
        ],
      ),
    );
  }

  Widget _fallbackImage() => Container(color: Colors.grey.shade100, child: Center(child: Icon(Icons.image_not_supported_outlined, color: Colors.grey.shade400)));

  // ==========================================
  // STEP 3: PRICING & LOCATION
  // ==========================================
  Widget _buildStep3Pricing(bool isFarmer) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Now, set your price', style: TextStyle(fontSize: 28, fontWeight: FontWeight.w600, color: _ink, height: 1.2, letterSpacing: -0.5)),
          const SizedBox(height: 8),
          Text('You can change it anytime.', style: TextStyle(fontSize: 16, color: _muted)),
          const SizedBox(height: 48),

          // Big Price Input (Like Airbnb Nightly Price)
          Center(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text('Rs', style: TextStyle(fontSize: 32, fontWeight: FontWeight.w600, color: _ink)),
                const SizedBox(width: 8),
                IntrinsicWidth(
                  child: TextField(
                    controller: _priceController,
                    keyboardType: TextInputType.number,
                    style: TextStyle(fontSize: 64, fontWeight: FontWeight.w700, color: _ink, letterSpacing: -2),
                    decoration: InputDecoration(
                      hintText: '0',
                      hintStyle: TextStyle(color: Colors.grey.shade300),
                      border: InputBorder.none,
                      isDense: true,
                      contentPadding: EdgeInsets.zero,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 48),

          Text('Quantity & Unit', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600, color: _ink, letterSpacing: -0.44)),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(child: _buildTextInput(controller: _qtyController, hint: 'Amount (e.g. 50)', keyboardType: TextInputType.number)),
              const SizedBox(width: 16),
              Expanded(
                child: Container(
                  height: 56,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade300), borderRadius: BorderRadius.circular(8)),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: _selectedUnit,
                      isExpanded: true,
                      icon: Icon(Icons.keyboard_arrow_down_rounded, color: _ink),
                      style: TextStyle(color: _ink, fontSize: 16),
                      items: _units.map((u) => DropdownMenuItem(value: u, child: Text(u))).toList(),
                      onChanged: (val) => setState(() => _selectedUnit = val!),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 40),

          Text('Location', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600, color: _ink, letterSpacing: -0.44)),
          const SizedBox(height: 16),
          Container(
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(8), border: Border.all(color: Colors.grey.shade300)),
            child: Row(
              children: [
                const SizedBox(width: 16),
                Icon(Icons.location_on_outlined, color: _ink, size: 24),
                Expanded(
                  child: TextField(
                    controller: _locationController,
                    style: TextStyle(fontSize: 16, color: _ink),
                    decoration: InputDecoration(hintText: 'City, Region...', hintStyle: TextStyle(color: Colors.grey.shade400), border: InputBorder.none, contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16)),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 80), // Extra padding for bottom bar
        ],
      ),
    );
  }

  // ==========================================
  // HELPER WIDGETS
  // ==========================================
  Widget _buildTextInput({required TextEditingController controller, required String hint, int maxLines = 1, TextInputType keyboardType = TextInputType.text}) {
    return Container(
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8), border: Border.all(color: Colors.grey.shade400)), // Subtle border
      child: TextField(
        controller: controller,
        maxLines: maxLines,
        keyboardType: keyboardType,
        style: TextStyle(fontSize: 16, color: _ink),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(color: Colors.grey.shade400, fontWeight: FontWeight.w400),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.all(16),
        ),
      ),
    );
  }
}