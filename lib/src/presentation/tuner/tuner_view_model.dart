import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tuner/src/presentation/tuner/tuner_state.dart';
part '../../../_generated/src/presentation/tuner/tuner_view_model.g.dart';

@riverpod
final class TunerViewModel extends _$TunerViewModel {
  @override
  TunerState build() => const TunerState();

  void toggleRecording() {
    state = state.copyWith(isRecording: !state.isRecording);
  }
}
