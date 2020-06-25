import 'dart:async';

import 'package:flutter/material.dart';

class PlannerBloc {
  StreamController<String> _listController = StreamController<String>();
  Stream<String> get listStream => _listController.stream;

  void dispose() {
    _listController.close();
  }

  handleCell(DateTime date) {
    _listController.add(
        "sicas from bloc d:${date.day} m:${date.month} y: ${date.year}"
    );
  }
}