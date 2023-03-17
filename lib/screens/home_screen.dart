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
const _bntTextResumeBreak = "RETOMAR PAUSA RAPIDA";
const _bntTextStartShortBreak = "INICIAR PAUSA RAPIDA";
const _bntTextStartLongBreak = "INICIAR PAUSA LONGA";
const _bntTextStartNewSet = "INICIAR NOVA SERIE";
const _bntTextPause = "PAUSAR POMODORO";
const _bntTextReset = "REINICIAR";

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    int remainingTime = defaultTime;
    String mainBtnText = _bntTextStart;
    PomodoroStatus pomodoroStatus = PomodoroStatus.pausedPomodoro;
    Timer _timer;
    int pomodoroCycle = 0;
    int setNum = 0;

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
              "Ciclos Completos Hoje: $pomodoroCycle",
              style: TextStyle(fontSize: 20, color: Colors.white),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              "Séries: $setNum",
              style: TextStyle(fontSize: 16, color: Colors.white),
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularPercentIndicator(
                    radius: 100.0,
                    lineWidth: 15.0,
                    percent: 0.3,
                    circularStrokeCap: CircularStrokeCap.round,
                    center: Text(
                      _secondsToFormatedString(remainingTime),
                      style: TextStyle(fontSize: 36, color: Colors.white),
                    ),
                    progressColor: Colors.red,
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  Text(
                    "Status Pomodoro",
                    style: TextStyle(color: Colors.white),
                  ),
                ],
              ),
            ),
            CustomButton(
              onTap: () {},
              text: "Iniciar",
            ),
            CustomButton(
              onTap: () {},
              text: "Resetar",
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
}
