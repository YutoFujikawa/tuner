import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tuner/src/tuner/tuner_state.dart';

final class TunerProviders {
  static final tunerProvider = StateNotifierProvider<TunerNotifier, TunerState>(
    (ref) => TunerNotifier(),
  );
}

class TunerNotifier extends StateNotifier<TunerState> {
  TunerNotifier() : super(const TunerState());

  void toggleRecording() {
    state = state.copyWith(isRecording: !state.isRecording);
  }
}
