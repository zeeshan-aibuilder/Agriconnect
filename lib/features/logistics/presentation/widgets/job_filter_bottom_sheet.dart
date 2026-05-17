import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';

class JobFilterBottomSheet extends StatefulWidget {
  final VoidCallback onApply;
  const JobFilterBottomSheet({super.key, required this.onApply});

  @override
  State<JobFilterBottomSheet> createState() => _JobFilterBottomSheetState();
}

class _JobFilterBottomSheetState extends State<JobFilterBottomSheet> {
  double _distance = 50;
  RangeValues _priceRange = const RangeValues(10000, 100000);
  String _selectedUrgency = 'All';

  @override
  Widget build(BuildContext context) {
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
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Filters', style: AppTextStyles.h3),
                  IconButton(
                    icon: const Icon(Icons.close_rounded),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                children: [
                  Text(
                    'Distance (Radius)',
                    style: AppTextStyles.bodyMedium.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  Slider(
                    value: _distance,
                    min: 10,
                    max: 200,
                    divisions: 19,
                    activeColor: AppColors.primary700,
                    label: '${_distance.toInt()} km',
                    onChanged: (val) => setState(() => _distance = val),
                  ),
                  const SizedBox(height: 24),

                  Text(
                    'Price Range',
                    style: AppTextStyles.bodyMedium.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  RangeSlider(
                    values: _priceRange,
                    min: 5000,
                    max: 200000,
                    divisions: 39,
                    activeColor: AppColors.primary700,
                    labels: RangeLabels(
                      'Rs. ${_priceRange.start.toInt()}',
                      'Rs. ${_priceRange.end.toInt()}',
                    ),
                    onChanged: (val) => setState(() => _priceRange = val),
                  ),
                  const SizedBox(height: 24),

                  Text(
                    'Urgency',
                    style: AppTextStyles.bodyMedium.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 12,
                    children: ['All', 'High', 'Normal']
                        .map(
                          (e) => ChoiceChip(
                            label: Text(
                              e,
                              style: TextStyle(
                                color: _selectedUrgency == e
                                    ? Colors.white
                                    : AppColors.gray900,
                              ),
                            ),
                            selected: _selectedUrgency == e,
                            selectedColor: AppColors.primary700,
                            onSelected: (val) =>
                                setState(() => _selectedUrgency = e),
                          ),
                        )
                        .toList(),
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border(top: BorderSide(color: AppColors.gray200)),
              ),
              child: SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: () {
                    widget.onApply();
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary700,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    'Apply Filters',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
