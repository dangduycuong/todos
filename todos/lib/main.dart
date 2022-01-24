import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:todos/app.dart';
import 'package:todos/todo/models/todo_model.dart';

void main() async {
  //khoi tao hive
  await Hive.initFlutter();
  //dang ky
  Hive.registerAdapter(TodoModelAdapter());
  //tao va mo box
  await Hive.openBox('todoBox');
  runApp(const App());
}
