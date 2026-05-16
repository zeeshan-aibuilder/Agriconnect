import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../add_listing_provider.dart';

class Step3Pricing extends ConsumerStatefulWidget {
  const Step3Pricing({super.key});

  @override
  ConsumerState<Step3Pricing> createState() => _Step3PricingState();
}

class _Step3PricingState extends ConsumerState<Step3Pricing> {
  late TextEditingController _priceCtrl;
  late TextEditingController _moqCtrl;
  final List<String> _units = ['kg', 'Maund (40kg)', 'Ton', 'Box/Crate'];

  @override
  void initState() {
    super.initState();
    final state = ref.read(addListingProvider);
    _priceCtrl = TextEditingController(text: state.price);
    _moqCtrl =
        TextEditingController(); // Connect this to provider state in your free time

    _priceCtrl.addListener(() {
      ref.read(addListingProvider.notifier).setPrice(_priceCtrl.text);
    });
  }

  @override
  void dispose() {
    _priceCtrl.dispose();
    _moqCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(addListingProvider);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Deal & Pricing",
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.w900,
              color: AppColors.gray900,
              letterSpacing: -1,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            "Set your B2B terms, MOQ, and pricing structure.",
            style: TextStyle(
              fontSize: 15,
              color: AppColors.gray500,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 32),

          // --- 1. CORE PRICING ---
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: AppColors.gray200),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.03),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Price per Unit (PKR)",
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                    color: AppColors.gray900,
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _priceCtrl,
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w900,
                    color: AppColors.primary700,
                  ),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: AppColors.bgSecondary,
                    prefixText: "Rs.  ",
                    prefixStyle: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                      color: AppColors.gray500,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide.none,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: const BorderSide(
                        color: AppColors.primary700,
                        width: 2,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                const Text(
                  "Select Unit Type",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                    color: AppColors.gray900,
                  ),
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: _units.map((unit) {
                    final isSel = state.unit == unit;
                    return GestureDetector(
                      onTap: () =>
                          ref.read(addListingProvider.notifier).setUnit(unit),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        decoration: BoxDecoration(
                          color: isSel ? AppColors.gray900 : Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: isSel
                                ? AppColors.gray900
                                : AppColors.gray200,
                            width: 1.5,
                          ),
                        ),
                        child: Text(
                          unit,
                          style: TextStyle(
                            fontWeight: isSel
                                ? FontWeight.w800
                                : FontWeight.w600,
                            color: isSel ? Colors.white : AppColors.gray600,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // --- 2. B2B TERMS (MOQ & Negotiation) ---
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppColors.gray200),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Open to Negotiation",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                            color: AppColors.gray900,
                          ),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          "Allow buyers to counter offer",
                          style: TextStyle(
                            fontSize: 12,
                            color: AppColors.gray500,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    Switch.adaptive(
                      value: state.isNegotiable,
                      activeTrackColor:
                          AppColors.primary700, // 🔥 FIXED activeColor warning
                      onChanged: (_) => ref
                          .read(addListingProvider.notifier)
                          .toggleNegotiable(),
                    ),
                  ],
                ),
                const Divider(height: 40, color: AppColors.gray200),
                const Text(
                  "Minimum Order Quantity (MOQ)",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                    color: AppColors.gray900,
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: _moqCtrl,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    hintText: "e.g. 50",
                    hintStyle: const TextStyle(color: AppColors.gray400),
                    filled: true,
                    fillColor: AppColors.bgSecondary,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    suffixText: state.unit,
                    suffixStyle: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary700,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 100),
        ],
      ),
    );
  }
}
