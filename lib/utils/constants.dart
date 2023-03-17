import "package:flutter/material.dart";
import "package:pomodoro_tool_jera/models/pomodoro_status.dart";

const defaultTime = 25 * 60;
const shortBreak = 5 * 60;
const longBreak = 10 * 60;
const pomodoroPerSet = 4;

const Map<PomodoroStatus, String> statusDescription = {
  PomodoroStatus.runningPomodoro: "Pomodoro foi iniciado, hora de focar!",
  PomodoroStatus.pausedPomodoro: "Pronto para iniciar uma série Pomodoro?",
  PomodoroStatus.runningShortBreak: "Pausa curta iniciada, hora de relaxar!",
  PomodoroStatus.pausedShortBreak: "Vamos iniciar uma pequena pausa?",
  PomodoroStatus.runningLongBreak: "Pausa longa iniciada, hora de relaxar!",
  PomodoroStatus.pausedLongBreak: "Sugerimos uma pausa mais longa!",
  PomodoroStatus.setFinished:
      "Parabéns, você merece uma pausa mais longa, podemos iniciá-la?",
};

const Map<PomodoroStatus, MaterialColor> statusColor = {
  PomodoroStatus.runningPomodoro: Colors.yellow,
  PomodoroStatus.pausedPomodoro: Colors.red,
  PomodoroStatus.runningShortBreak: Colors.green,
  PomodoroStatus.pausedShortBreak: Colors.red,
  PomodoroStatus.runningLongBreak: Colors.green,
  PomodoroStatus.pausedLongBreak: Colors.red,
  PomodoroStatus.setFinished: Colors.red,
};
