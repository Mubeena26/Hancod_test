import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeNavigationState {
  final int selectedIndex;

  HomeNavigationState({this.selectedIndex = 0});

  HomeNavigationState copyWith({int? selectedIndex}) {
    return HomeNavigationState(
      selectedIndex: selectedIndex ?? this.selectedIndex,
    );
  }
}

class HomeNavigationNotifier extends StateNotifier<HomeNavigationState> {
  HomeNavigationNotifier() : super(HomeNavigationState());

  void setSelectedIndex(int index) {
    state = state.copyWith(selectedIndex: index);
  }
}

final homeNavigationProvider =
    StateNotifierProvider<HomeNavigationNotifier, HomeNavigationState>((ref) {
  return HomeNavigationNotifier();
});


