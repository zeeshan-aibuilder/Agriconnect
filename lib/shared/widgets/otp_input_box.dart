import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';

class OtpInputBox extends StatelessWidget {
  final bool first;
  final bool last;

  const OtpInputBox({super.key, required this.first, required this.last});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 64, // Specs ke mutabiq
      width: 56,  // Specs ke mutabiq
      child: TextField(
        autofocus: true,
        onChanged: (value) {
          // Agar number likh diya toh agle box par jao
          if (value.isNotEmpty && !last) {
            FocusScope.of(context).nextFocus();
          }
          // Agar delete kiya toh pichle box par jao
          if (value.isEmpty && !first) {
            FocusScope.of(context).previousFocus();
          }
        },
        showCursor: true,
        readOnly: false,
        textAlign: TextAlign.center,
        style: AppTextStyles.h4.copyWith(fontSize: 20),
        keyboardType: TextInputType.number,
        maxLength: 1, // Ek box mein sirf 1 number
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        decoration: InputDecoration(
          counter: const Offstage(), // Niche wala counter hide karne ke liye
          filled: true,
          fillColor: AppColors.white,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: AppColors.gray200, width: 2),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: AppColors.primary500, width: 2),
          ),
        ),
      ),
    );
  }
}