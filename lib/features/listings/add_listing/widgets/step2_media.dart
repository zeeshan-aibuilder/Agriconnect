import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart'; // 🔥 IMPORT ADDED
import '../../../../core/theme/app_colors.dart';
import '../add_listing_provider.dart';

class Step2MediaUpload extends ConsumerWidget {
  const Step2MediaUpload({super.key});

  // 🚀 SENIOR LOGIC: Auto Permission Handler
  Future<bool> _requestPermissions(BuildContext context) async {
    if (kIsWeb) return true; // Web doesn't need this

    // Request Photos/Storage permission
    PermissionStatus status;
    if (Platform.isAndroid) {
      // Android 13+ uses photos, older uses storage
      status = await Permission.photos.request();
      if (status.isDenied) {
        status = await Permission.storage.request();
      }
    } else {
      status = await Permission.photos.request();
    }

    if (status.isGranted || status.isLimited) {
      return true;
    } else if (status.isPermanentlyDenied) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text(
              'Storage permission is permanently denied. Please enable in settings.',
            ),
            action: SnackBarAction(
              label: 'Settings',
              onPressed: () => openAppSettings(),
              textColor: Colors.white,
            ),
            backgroundColor: AppColors.error500,
          ),
        );
      }
      return false;
    }
    return false;
  }

  Future<void> _pickImages(BuildContext context, WidgetRef ref) async {
    final state = ref.read(addListingProvider);
    if (state.images.length >= 5) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Maximum 5 images allowed')));
      return;
    }

    // 🔥 Check Permissions Before Opening Picker!
    bool hasPermission = await _requestPermissions(context);
    if (!hasPermission) return;

    final ImagePicker picker = ImagePicker();
    try {
      final List<XFile> selected = await picker.pickMultiImage(
        imageQuality: 70,
      );
      if (selected.isNotEmpty) {
        ref.read(addListingProvider.notifier).addImages(selected);
      }
    } catch (e) {
      debugPrint("Image picker error: $e");
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(addListingProvider);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Add Photos",
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.w900,
              color: AppColors.gray900,
              letterSpacing: -1,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "${state.images.length}/5 Images Uploaded",
            style: const TextStyle(
              fontSize: 15,
              color: AppColors.gray500,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 32),

          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 1,
            ),
            itemCount: state.images.length < 5 ? state.images.length + 1 : 5,
            itemBuilder: (context, index) {
              if (index == state.images.length) {
                return _buildAddButton(context, ref);
              }
              return _buildImagePreview(state.images[index], index, ref);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildAddButton(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      onTap: () => _pickImages(context, ref), // Passed context for snackbars
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.primary700.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: AppColors.primary700.withValues(alpha: 0.3),
            width: 2,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.primary700.withValues(alpha: 0.15),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.add_photo_alternate_rounded,
                color: AppColors.primary700,
                size: 32,
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              "Upload",
              style: TextStyle(
                fontWeight: FontWeight.w800,
                color: AppColors.primary700,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImagePreview(XFile file, int index, WidgetRef ref) {
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 16,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(24),
            child: kIsWeb
                ? Image.network(
                    file.path,
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: double.infinity,
                  )
                : Image.file(
                    File(file.path),
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: double.infinity,
                  ),
          ),
        ),
        Positioned(
          top: 10,
          right: 10,
          child: GestureDetector(
            onTap: () =>
                ref.read(addListingProvider.notifier).removeImage(index),
            child: Container(
              padding: const EdgeInsets.all(6),
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.delete_outline_rounded,
                color: AppColors.error500,
                size: 20,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
