import 'package:flutter/material.dart';
import 'package:todos/todo/views/add_or_modify_todo_page.dart';
import 'package:todos/todo/views/todo_home_page.dart';

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      routes: {
        AddOrModifyTodoPage.routeName: (context) => const AddOrModifyTodoPage(),
      },
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const TodosHomePage(),
    );
  }
}
