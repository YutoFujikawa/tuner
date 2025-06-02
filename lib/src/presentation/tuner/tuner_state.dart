import 'dart:async';
import 'package:freezed_annotation/freezed_annotation.dart';

part '../../_generated/src/presentation/tuner/tuner_state.freezed.dart';

@freezed
class TunerState with _$TunerState {
  const factory TunerState({
    @Default(false) bool isRecording,
    @Default([]) List<double> audio,
    StreamSubscription<List<double>>? audioSubscription,
    @Default(0.0) double frequency, // 周波数
  }) = _TunerState;
}
