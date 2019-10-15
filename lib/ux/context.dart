import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:smr_app/backend/backend.dart';

mixin WidgetContext<T extends StatefulWidget> on State<T> {
  MediaQueryData get mediaQuery => MediaQuery.of(context);
  ThemeData get theme => Theme.of(context);
  Backend get backend => Backend.of(context);
  NavigatorState get navigator => Navigator.of(context);
}
