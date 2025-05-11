import 'package:audio_streamer/audio_streamer.dart';
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

    AudioStreamer().sampleRate = 22100;

    final subscription = AudioStreamer().audioStream.listen(
      (List<double> buffer) {
        state = state.copyWith(
          audio: state.audio + buffer,
        );
      },
      onError: (error) {
        state = state.copyWith(isRecording: false);
        throw Exception(error);
      },
    );

    state = state.copyWith(isRecording: true, audioSubscription: subscription);
  }

  void stop() async {
    state.audioSubscription?.cancel();
    state = state.copyWith(isRecording: false, audioSubscription: null);
  }

  Future<bool> checkPermission() async {
    return await Permission.microphone.isGranted;
  }

  Future<void> requestPermission() async =>
      await Permission.microphone.request();
}
