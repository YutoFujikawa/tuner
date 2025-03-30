import 'package:permission_handler/permission_handler.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tuner/src/presentation/tuner/tuner_state.dart';
part '../../_generated/src/presentation/tuner/tuner_view_model.g.dart';

@riverpod
final class TunerViewModel extends _$TunerViewModel {
  @override
  TunerState build() => const TunerState();

  void toggleRecording() {
    state = state.copyWith(isRecording: !state.isRecording);
  }

  Future<void> start() async {
    final hasPermission = await checkPermission();
    if (!hasPermission) {
      await requestPermission();
    }

    state = state.copyWith(isRecording: true);
  }

  void stop() async {
    state = state.copyWith(isRecording: false);
  }

  Future<bool> checkPermission() async {
    return await Permission.microphone.isGranted;
  }

  Future<void> requestPermission() async =>
      await Permission.microphone.request();
}
