import 'dart:typed_data';

import 'package:audio_streamer/audio_streamer.dart';
import 'package:fftea/stft.dart';
import 'package:fftea/util.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tuner/src/presentation/tuner/tuner_state.dart';
part '../../_generated/src/presentation/tuner/tuner_view_model.g.dart';

@riverpod
final class TunerViewModel extends _$TunerViewModel {
  final _chunkSize = 2048;
  late final STFT _stft = STFT(_chunkSize, Window.hanning(_chunkSize));
  final _bufferQueue = <double>[]; // バッファを一時保持

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
        // バッファを蓄積
        _bufferQueue.addAll(buffer);

        // チャンクサイズ以上たまったら処理
        while (_bufferQueue.length >= _chunkSize) {
          final chunk =
              Float64List.fromList(_bufferQueue.sublist(0, _chunkSize));

          // STFTでFFT実行?
          _stft.run(chunk, (Float64x2List fftResult) {
            final amps = fftResult.discardConjugates().magnitudes();
            final peakIndex = amps.indexOf(
              amps.reduce((a, b) => a > b ? a : b),
            );
            final freq =
                peakIndex * (22100 / _chunkSize); // sampleRate / chunkSize

            // 周波数を必要に応じて state に保存
            state = state.copyWith(frequency: freq);
          });

          // 使用済み部分を削除（オーバーラップあり?: 半分だけ進める）
          _bufferQueue.removeRange(0, _chunkSize ~/ 2);
        }
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
