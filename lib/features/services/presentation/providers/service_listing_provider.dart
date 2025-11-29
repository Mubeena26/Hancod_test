import 'package:flutter_riverpod/flutter_riverpod.dart';

class ServiceListingState {
  final int selectedCategoryIndex;

  ServiceListingState({this.selectedCategoryIndex = 1});

  ServiceListingState copyWith({int? selectedCategoryIndex}) {
    return ServiceListingState(
      selectedCategoryIndex: selectedCategoryIndex ?? this.selectedCategoryIndex,
    );
  }
}

class ServiceListingNotifier extends StateNotifier<ServiceListingState> {
  ServiceListingNotifier() : super(ServiceListingState());

  void selectCategory(int index) {
    state = state.copyWith(selectedCategoryIndex: index);
  }
}

final serviceListingProvider =
    StateNotifierProvider<ServiceListingNotifier, ServiceListingState>((ref) {
  return ServiceListingNotifier();
});


