import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

// --- State Class ---
class AddListingState {
  final String category;
  final String title;
  final List<XFile> images;
  final String price;
  final String unit;
  final bool isNegotiable;
  final bool isLoading;

  const AddListingState({
    this.category = '',
    this.title = '',
    this.images = const [],
    this.price = '',
    this.unit = 'kg',
    this.isNegotiable = true,
    this.isLoading = false,
  });

  AddListingState copyWith({
    String? category,
    String? title,
    List<XFile>? images,
    String? price,
    String? unit,
    bool? isNegotiable,
    bool? isLoading,
  }) {
    return AddListingState(
      category: category ?? this.category,
      title: title ?? this.title,
      images: images ?? this.images,
      price: price ?? this.price,
      unit: unit ?? this.unit,
      isNegotiable: isNegotiable ?? this.isNegotiable,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

// --- Modern Notifier (Controller) ---
class AddListingNotifier extends Notifier<AddListingState> {
  @override
  AddListingState build() {
    return const AddListingState();
  }

  void setCategory(String cat) {
    state = state.copyWith(category: cat);
  }

  void setTitle(String title) {
    state = state.copyWith(title: title);
  }

  void setPrice(String price) {
    state = state.copyWith(price: price);
  }

  void setUnit(String unit) {
    state = state.copyWith(unit: unit);
  }

  void toggleNegotiable() {
    state = state.copyWith(isNegotiable: !state.isNegotiable);
  }

  void addImages(List<XFile> newImages) {
    final combined = [...state.images, ...newImages];
    if (combined.length <= 5) {
      state = state.copyWith(images: combined);
    } else {
      state = state.copyWith(images: combined.take(5).toList());
    }
  }

  void removeImage(int index) {
    final updated = List<XFile>.from(state.images)..removeAt(index);
    state = state.copyWith(images: updated);
  }

  // MOCK CLOUDINARY UPLOAD & PUBLISH
  Future<bool> publishListing() async {
    state = state.copyWith(isLoading: true);
    try {
      await Future.delayed(const Duration(seconds: 3));
      state = state.copyWith(isLoading: false);
      return true; // Success
    } catch (e) {
      state = state.copyWith(isLoading: false);
      return false; // Failed
    }
  }
}

// Global Provider using NotifierProvider (Modern Syntax)
final addListingProvider =
    NotifierProvider<AddListingNotifier, AddListingState>(() {
      return AddListingNotifier();
    });
