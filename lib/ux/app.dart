import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smr_app/backend/backend.dart';
import 'package:smr_app/ux/containers/main_container.dart';
import 'package:smr_app/ux/theme.dart';

class SmrApp extends StatelessWidget {
  SmrApp({
    Key key,
    @required this.backend,
  }) : super(key: key);

  final Backend backend;

  @override
  Widget build(BuildContext context) {
    return Provider<Backend>.value(
      value: backend,
      child: MaterialApp(
        title: 'SMR',
        theme: AppTheme.theme(),
        home: MainContainer(),
      ),
    );
  }
}
