import 'package:btox/btox_app.dart';
import 'package:btox/btox_reducer.dart';
import 'package:btox/btox_state.dart';
import 'package:btox/db/database.dart';
import 'package:btox/db/shared.dart';
import 'package:flutter/material.dart';
import 'package:redux/redux.dart';

void main() {
  final Database database = constructDb();
  final store = createStore();
  runApp(BtoxApp(
    database: database,
    store: store,
  ));
}

Store<BtoxState> createStore() {
  return Store<BtoxState>(
    btoxReducer,
    initialState: BtoxState.initial(),
  );
}
