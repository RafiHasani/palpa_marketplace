import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/legacy.dart';

final timerProvider = StateNotifierProvider<TimerNotifier, TimerState>((ref) {
  return TimerNotifier(initialSeconds: 180);
});

class TimerNotifier extends StateNotifier<TimerState> {
  TimerNotifier({required int initialSeconds})
    : _initialSeconds = initialSeconds,
      super(TimerState.initial(initialSeconds)) {
    start();
  }

  final int _initialSeconds;
  Timer? _timer;

  void start() {
    _timer?.cancel();

    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (state.secondsLeft <= 1) {
        _timer?.cancel();
        state = state.copyWith(secondsLeft: 0, canSendAgain: true);
      } else {
        state = state.copyWith(secondsLeft: state.secondsLeft - 1);
      }
    });
  }

  void reset() {
    state = TimerState.initial(_initialSeconds);
    start();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}

class TimerState extends Equatable {
  final int secondsLeft;
  final bool canSendAgain;

  const TimerState({required this.secondsLeft, required this.canSendAgain});

  factory TimerState.initial(int seconds) {
    return TimerState(secondsLeft: seconds, canSendAgain: false);
  }

  TimerState copyWith({int? secondsLeft, bool? canSendAgain}) {
    return TimerState(
      secondsLeft: secondsLeft ?? this.secondsLeft,
      canSendAgain: canSendAgain ?? this.canSendAgain,
    );
  }

  @override
  List<Object> get props => [secondsLeft, canSendAgain];
}
