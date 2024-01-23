// Flutter web plugin registrant file.
//
// Generated file. Do not edit.
//

// @dart = 2.13
// ignore_for_file: type=lint

import 'package:camera_web/camera_web.dart';
import 'package:image_picker_for_web/image_picker_for_web.dart';
import 'package:tflite_flutter_plus/tflite_flutter_plus_web.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';

void registerPlugins([final Registrar? pluginRegistrar]) {
  final Registrar registrar = pluginRegistrar ?? webPluginRegistrar;
  CameraPlugin.registerWith(registrar);
  ImagePickerPlugin.registerWith(registrar);
  TfliteFlutterPlusWeb.registerWith(registrar);
  registrar.registerMessageHandler();
}
