import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../add_listing_provider.dart';

class Step1Category extends ConsumerStatefulWidget {
  const Step1Category({super.key});

  @override
  ConsumerState<Step1Category> createState() => _Step1CategoryState();
}

class _Step1CategoryState extends ConsumerState<Step1Category> {
  late TextEditingController _titleCtrl;

  final List<Map<String, dynamic>> _categories = [
    {'name': 'Wheat', 'icon': Icons.grass_rounded},
    {'name': 'Rice', 'icon': Icons.eco_rounded},
    {'name': 'Cotton', 'icon': Icons.spa_rounded},
    {'name': 'Fruits', 'icon': Icons.apple_rounded},
    {'name': 'Machinery', 'icon': Icons.agriculture_rounded},
    {'name': 'Fertilizer', 'icon': Icons.science_rounded},
  ];

  @override
  void initState() {
    super.initState();
    _titleCtrl = TextEditingController(
      text: ref.read(addListingProvider).title,
    );
    _titleCtrl.addListener(() {
      ref.read(addListingProvider.notifier).setTitle(_titleCtrl.text);
    });
  }

  @override
  void dispose() {
    _titleCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final selectedCategory = ref.watch(addListingProvider).category;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "What are you listing?",
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.w900,
              color: AppColors.gray900,
              letterSpacing: -1,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            "Select a category that best describes your product.",
            style: TextStyle(
              fontSize: 15,
              color: AppColors.gray500,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 32),

          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 1.3,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
            ),
            itemCount: _categories.length,
            itemBuilder: (context, index) {
              final cat = _categories[index];
              final isSel = selectedCategory == cat['name'];
              return GestureDetector(
                onTap: () => ref
                    .read(addListingProvider.notifier)
                    .setCategory(cat['name']),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: isSel ? AppColors.gray900 : Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: isSel ? AppColors.gray900 : AppColors.gray200,
                      width: 1.5,
                    ),
                    boxShadow: isSel
                        ? [
                            BoxShadow(
                              color: AppColors.gray900.withValues(alpha: 0.15),
                              blurRadius: 20,
                              offset: const Offset(0, 8),
                            ),
                          ]
                        : [],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        cat['icon'],
                        size: 32,
                        color: isSel ? Colors.white : AppColors.gray500,
                      ),
                      const Spacer(),
                      Text(
                        cat['name'],
                        style: TextStyle(
                          fontWeight: FontWeight.w800,
                          fontSize: 16,
                          color: isSel ? Colors.white : AppColors.gray900,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 48),

          const Text(
            "Give it a title",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: AppColors.gray900,
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _titleCtrl,
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
            decoration: InputDecoration(
              filled: true,
              fillColor: AppColors.bgSecondary,
              hintText: "e.g. Premium Swat Apples 🍎",
              hintStyle: const TextStyle(
                color: AppColors.gray400,
                fontWeight: FontWeight.w500,
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
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
