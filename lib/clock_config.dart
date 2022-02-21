class ClockConfig {
  ClockConfig({this.mode = modeSeconds, this.quarterTurns = 0});

  static const modeSeconds = 0;
  static const modeMinutes = 1;

  int mode;
  int quarterTurns;

  void rotate() {
    quarterTurns = (quarterTurns + 1) % 4;
  }

  void secondsMode() {
    mode = modeSeconds;
  }

  void minutesMode() {
    mode = modeMinutes;
  }

  get isSecondsMode => mode == modeSeconds;
}
