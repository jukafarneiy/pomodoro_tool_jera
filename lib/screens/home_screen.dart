import 'dart:async';

import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:pomodoro_tool_jera/models/pomodoro_status.dart';
import 'package:pomodoro_tool_jera/utils/constants.dart';
import '../widgets/custom_button.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

const _bntTextStart = "INICIAR POMODORO";
const _bntTextResumePomodoro = "RETOMAR POMODORO";
const _bntTextResumeBreak = "PARAR PAUSA RÁPIDA";
const _bntTextStartShortBreak = "INICIAR PAUSA RÁPIDA";
const _bntTextStartLongBreak = "INICIAR PAUSA LONGA";
const _bntTextStartNewCycle = "INICIAR NOVO CICLO";
const _bntTextPause = "PAUSAR POMODORO";
const _bntTextReset = "REINICIAR";

class _HomeState extends State<Home> {
  int remainingTime = defaultTime;
  String mainBtnText = _bntTextStart;
  PomodoroStatus pomodoroStatus = PomodoroStatus.pausedPomodoro;
  Timer? _timer;
  int pomodoroSet = 0;
  int cycleNum = 0;

  @override
  void dispose() {
    _cancelTimer();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("PomoTool App"),
        backgroundColor: Colors.blue,
      ),
      backgroundColor: Colors.blue[900],
      body: SafeArea(
        child: Center(
          child: Column(children: [
            SizedBox(
              height: 16,
            ),
            Text(
              "Série: $pomodoroSet",
              style: TextStyle(fontSize: 20, color: Colors.white),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              "Ciclos Completos Hoje: $cycleNum",
              style: TextStyle(fontSize: 16, color: Colors.white),
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularPercentIndicator(
                    radius: 100.0,
                    lineWidth: 15.0,
                    percent: _getPomodoroPercentage(),
                    circularStrokeCap: CircularStrokeCap.round,
                    center: Text(
                      _secondsToFormatedString(remainingTime),
                      style: TextStyle(fontSize: 36, color: Colors.white),
                    ),
                    progressColor: statusColor[pomodoroStatus],
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  Text(
                    statusDescription[pomodoroStatus]!,
                    style: TextStyle(color: Colors.white),
                  ),
                ],
              ),
            ),
            CustomButton(
              onTap: _mainButtonPressed,
              text: mainBtnText,
            ),
            CustomButton(
              onTap: _resetButtonPressed,
              text: _bntTextReset,
            ),
          ]),
        ),
      ),
    );
  }

  _secondsToFormatedString(int seconds) {
    int roundedMinutes = seconds ~/ 60;
    int remainingSeconds = seconds - (roundedMinutes * 60);
    String remainingSecondsFormated;

    if (remainingSeconds < 10) {
      remainingSecondsFormated = "0$remainingSeconds";
    } else {
      remainingSecondsFormated = remainingSeconds.toString();
    }

    return "$roundedMinutes:$remainingSecondsFormated";
  }

  _getPomodoroPercentage() {
    int totalTime;
    switch (pomodoroStatus) {
      case PomodoroStatus.runningPomodoro:
        totalTime = defaultTime;
        break;
      case PomodoroStatus.pausedPomodoro:
        totalTime = defaultTime;
        break;
      case PomodoroStatus.runningShortBreak:
        totalTime = shortBreak;
        break;
      case PomodoroStatus.pausedShortBreak:
        totalTime = shortBreak;
        break;
      case PomodoroStatus.runningLongBreak:
        totalTime = longBreak;
        break;
      case PomodoroStatus.pausedLongBreak:
        totalTime = longBreak;
        break;
      case PomodoroStatus.setFinished:
        totalTime = longBreak;
        break;
    }
    double percentage = (totalTime - remainingTime) / totalTime;
    return percentage;
  }

  _mainButtonPressed() {
    switch (pomodoroStatus) {
      case PomodoroStatus.pausedPomodoro:
        _startPomodoroCountdown();
        break;
      case PomodoroStatus.runningPomodoro:
        _pausePomodoroCountdown();
        break;
      case PomodoroStatus.runningShortBreak:
        _pauseShortBreakCountdown();
        break;
      case PomodoroStatus.pausedShortBreak:
        _startShortBreak();
        break;
      case PomodoroStatus.runningLongBreak:
        _pauseLongBreakCountdown();
        break;
      case PomodoroStatus.pausedLongBreak:
        _startLongBreak();
        break;
      case PomodoroStatus.setFinished:
        cycleNum++;
        _startPomodoroCountdown();
        break;
    }
  }

  _startPomodoroCountdown() {
    pomodoroStatus = PomodoroStatus.runningPomodoro;
    _cancelTimer();

    _timer = Timer.periodic(
        Duration(seconds: 1),
        (timer) => {
              if (remainingTime > 0)
                {
                  setState(() {
                    remainingTime--;
                    mainBtnText = _bntTextPause;
                  })
                }
              else
                {
                  //todo playsound()
                  pomodoroSet++,
                  _cancelTimer(),
                  if (pomodoroSet % pomodoroPerSet == 0)
                    {
                      pomodoroStatus = PomodoroStatus.pausedLongBreak,
                      setState(() {
                        remainingTime = longBreak;
                        mainBtnText = _bntTextStartLongBreak;
                      }),
                    }
                  else
                    {
                      pomodoroStatus = PomodoroStatus.pausedShortBreak,
                      setState(() {
                        remainingTime = shortBreak;
                        mainBtnText = _bntTextStartShortBreak;
                      })
                    }
                }
            });
  }

  _startShortBreak() {
    pomodoroStatus = PomodoroStatus.runningShortBreak;
    setState(() {
      mainBtnText = _bntTextResumeBreak;
    });
    _cancelTimer();
    _timer = Timer.periodic(
        Duration(seconds: 1),
        (timer) => {
              if (remainingTime > 0)
                {
                  setState(() {
                    remainingTime--;
                  }),
                }
              else
                {
                  //todo play sound
                  _playSound(),
                  remainingTime = defaultTime,
                  _cancelTimer(),
                  pomodoroStatus = PomodoroStatus.pausedPomodoro,
                  setState(() {
                    mainBtnText = _bntTextStart;
                  }),
                }
            });
  }

  _startLongBreak() {
    pomodoroStatus = PomodoroStatus.runningLongBreak;
    setState(() {
      mainBtnText = _bntTextPause;
    });
    _cancelTimer();
    _timer = Timer.periodic(
        Duration(seconds: 1),
        (timer) => {
              if (remainingTime > 0)
                {
                  setState(() {
                    remainingTime--;
                  }),
                }
              else
                {
                  //todo play sound
                  _playSound(),
                  remainingTime = defaultTime,
                  _cancelTimer(),
                  pomodoroStatus = PomodoroStatus.setFinished,
                  setState(() {
                    mainBtnText = _bntTextStartNewCycle;
                  }),
                }
            });
  }

  _pausePomodoroCountdown() {
    pomodoroStatus = PomodoroStatus.pausedPomodoro;
    _cancelTimer();
    setState(() {
      mainBtnText = _bntTextResumePomodoro;
    });
  }

  _resetButtonPressed() {
    pomodoroSet = 0;
    cycleNum = 0;
    _cancelTimer();
    _stopCountdown();
  }

  _pauseShortBreakCountdown() {
    pomodoroStatus = PomodoroStatus.pausedShortBreak;
    _pauseBreakCountdown();
  }

  _pauseLongBreakCountdown() {
    pomodoroStatus = PomodoroStatus.pausedLongBreak;
    _pauseBreakCountdown();
  }

  _pauseBreakCountdown() {
    _cancelTimer();
    setState(() {
      mainBtnText = _bntTextResumePomodoro;
    });
  }

  _cancelTimer() {
    if (_timer != null) {
      _timer?.cancel();
    }
  }

  _stopCountdown() {
    pomodoroStatus = PomodoroStatus.pausedPomodoro;
    setState(() {
      mainBtnText = _bntTextStart;
      remainingTime = defaultTime;
    });
  }

  _playSound() {
    print("play sound");
  }
}
