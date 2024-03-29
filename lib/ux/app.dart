import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:screen/screen.dart';
import 'package:smr_app/backend/backend.dart';
import 'package:smr_app/ux/containers/main_container.dart';
import 'package:smr_app/ux/theme.dart';

class SmrApp extends StatelessWidget {
  SmrApp({
    Key key,
    @required this.backend,
  }) : super(key: key) {
    Screen.keepOn(true);
  }

  final Backend backend;

  @override
  Widget build(BuildContext context) {
    return Provider<Backend>.value(
      value: backend,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'SMR',
        theme: AppTheme.theme(),
        home: MainContainer(),
      ),
    );
  }
}
