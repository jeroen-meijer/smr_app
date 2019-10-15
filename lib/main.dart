import 'package:flutter/material.dart';
import 'package:smr_app/backend/api/device_calendar_api.dart';
import 'package:smr_app/backend/backend.dart';
import 'package:smr_app/ux/app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  final backend = await Backend.init(const DeviceCalendarApi(ApiEnv.live));
  runApp(SmrApp(backend: backend));
}