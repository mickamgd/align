import 'package:flutter_riverpod/flutter_riverpod.dart';

// Selected grid size notifier
class SelectedSizeNotifier extends Notifier<int> {
  @override
  int build() => 3;

  void setSize(int size) => state = size;
}

final selectedSizeProvider = NotifierProvider<SelectedSizeNotifier, int>(
  SelectedSizeNotifier.new,
);
