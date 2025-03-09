import 'package:freezed_annotation/freezed_annotation.dart';

part 'tuner_state.freezed.dart';

@freezed
class TunerState with _$TunerState {
  const factory TunerState({
    @Default(false) bool isRecording,
  }) = _TunerState;
}
