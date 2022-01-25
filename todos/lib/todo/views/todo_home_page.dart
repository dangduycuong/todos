import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_segmented_control/material_segmented_control.dart';
import 'package:todos/todo/bloc/todo_bloc.dart';
import 'package:todos/todo/models/todos_type.dart';
import 'package:todos/todo/views/todos_list_view.dart';

import 'add_or_modify_todo_page.dart';

class TodosHomePage extends StatelessWidget {
  const TodosHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TodoBloc(),
      child: const TodosHomeView(),
    );
  }
}

class TodosHomeView extends StatefulWidget {
  const TodosHomeView({Key? key}) : super(key: key);

  @override
  State<TodosHomeView> createState() => _TodosHomeViewState();
}

class _TodosHomeViewState extends State<TodosHomeView> {
  late TodoBloc bloc;

  @override
  void initState() {
    bloc = context.read();
    bloc.add(TodoEventInit());
    super.initState();
  }

  void _gotoAddTodo(BuildContext context) async {
    // await Navigator.pushNamed(context, AddNewTodoPage.routeName);
    await Navigator.pushNamed(context, AddOrModifyTodoPage.routeName);

    bloc.add(TodoEventLoadData(todosType, true));
    setState(() {});
  }

  final Map<int, Widget> _children = {
    0: const Text('All'),
    1: const Text('Completed'),
    2: const Text('Incomplete'),
  };

  int _currentSelection = 0;

  TodosType todosType = TodosType.all;

  final List<int> _disabledIndices = [];

  void _onSegmentChosen(int index) {
    switch (index) {
      case 0:
        todosType = TodosType.all;
        break;
      case 1:
        todosType = TodosType.completed;
        break;
      default: //2
        todosType = TodosType.incomplete;
        break;
    }
    _currentSelection = index;

    bloc.add(TodoEventLoadData(todosType, true));
    setState(() {});
  }

  Widget _materialSegmentedControl() {
    return Expanded(
      child: MaterialSegmentedControl(
        children: _children,
        selectionIndex: _currentSelection,
        borderColor: Colors.blue,
        selectedColor: Colors.blue,
        unselectedColor: Colors.white,
        borderRadius: 8.0,
        disabledChildren: _disabledIndices,
        onSegmentChosen: (i) {
          int index = i as int;
          _onSegmentChosen(index);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Todos'),
      ),
      body: Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                _materialSegmentedControl(),
              ],
            ),
            Expanded(
              child: TodosListView(
                todosType: todosType,
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _gotoAddTodo(context),
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
