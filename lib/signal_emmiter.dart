import 'dart:convert';
import 'dart:math';

import 'package:flutter_remote/lg_signal_codes.dart';
import 'package:flutter_remote/samsung_signal_codes.dart';
import 'package:ir_sensor_plugin/ir_sensor_plugin.dart';
import 'package:isolate_handler/isolate_handler.dart';
import 'package:riverpod/riverpod.dart';

IsolateHandler _isolates = IsolateHandler();

void _entryPoint(Map<String, dynamic> context) {
  final _messenger = HandledIsolate.initialize(context);

  _messenger.listen((pattern) {
    _emmit(pattern);
  });
}

void _emmit(String json) async {
  final _map = jsonDecode(json);

  await IrSensorPlugin.transmitString(pattern: _map['pattern']!);

  _isolates.kill(_map['isolate']!);
}

final signalEmmiter = Provider<SignalEmmiter>((ref) => LgRemoteSignalEmmiter());

abstract class SignalEmmiter {
  void turnOnOff();
  void home();
  void info();
  void navigateUp();
  void navigateDown();
  void navigateLeft();
  void navigateRight();
  void ok();
  void exit();
  void back();
  void volumeUp();
  void volumeDown();
  void mute();
  void nextChannel();
  void previousChannel();
  void backwards();
  void forward();
  void play();
  void pause();
  void red();
  void green();
  void yellow();
  void blue();
}

class LgRemoteSignalEmmiter implements SignalEmmiter {
  @override
  void backwards() {
    emmit(SamsungSignalCodes.fastBackward);
  }

  @override
  void forward() {
    emmit(SamsungSignalCodes.fastForward);
  }

  @override
  void home() {
    emmit(SamsungSignalCodes.home);
  }

  @override
  void info() {
    emmit(SamsungSignalCodes.info);
  }

  @override
  void mute() {
    emmit(SamsungSignalCodes.mute);
  }

  @override
  void navigateDown() {
    emmit(SamsungSignalCodes.navigateDown);
  }

  @override
  void navigateLeft() {
    emmit(SamsungSignalCodes.navigateLeft);
  }

  @override
  void navigateRight() {
    emmit(SamsungSignalCodes.navigateRight);
  }

  @override
  void navigateUp() {
    emmit(SamsungSignalCodes.navigateUp);
  }

  @override
  void nextChannel() {
    emmit(SamsungSignalCodes.channelUp);
  }

  @override
  void ok() {
    emmit(SamsungSignalCodes.ok);
  }

  @override
  void play() {
    emmit(SamsungSignalCodes.play);
  }

  @override
  void previousChannel() {
    emmit(SamsungSignalCodes.channelDown);
  }

  @override
  void pause() {
    emmit(SamsungSignalCodes.pause);
  }

  @override
  void turnOnOff() {
    emmit(SamsungSignalCodes.turnOnOff);
  }

  @override
  void volumeDown() {
    emmit(SamsungSignalCodes.volumeDown);
  }

  @override
  void volumeUp() {
    emmit(SamsungSignalCodes.volumeUp);
  }

  @override
  void back() {
    emmit(SamsungSignalCodes.back);
  }

  @override
  void exit() {
    emmit(SamsungSignalCodes.exit);
  }

  @override
  void blue() {
    emmit(SamsungSignalCodes.blue);
  }

  @override
  void green() {
    emmit(SamsungSignalCodes.green);
  }

  @override
  void red() {
    emmit(SamsungSignalCodes.red);
  }

  @override
  void yellow() {
    emmit(SamsungSignalCodes.yellow);
  }

  void emmit(String pattern) {
    final _isolateName = Random().nextInt(100).toString();

    _isolates = IsolateHandler();

    _isolates.spawn(
      _entryPoint,
      name: _isolateName,
      onInitialized: () => _isolates.send(
        jsonEncode({
          'isolate': _isolateName,
          'pattern': pattern,
        }),
        to: _isolateName,
      ),
    );
  }
}
