import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todos/todo/bloc/todo_bloc.dart';
import 'package:todos/todo/models/todo_model.dart';
import 'package:todos/todo/models/todos_type.dart';
import 'package:todos/widgets/loading_list_page.dart';

import 'add_or_modify_todo_page.dart';

class TodosListView extends StatefulWidget {
  const TodosListView({Key? key, required this.todosType}) : super(key: key);

  final TodosType todosType;

  @override
  _TodosListViewState createState() => _TodosListViewState();
}

class _TodosListViewState extends State<TodosListView> {
  late TodoBloc bloc;

  @override
  void initState() {
    bloc = context.read();
    bloc.add(TodoEventLoadData(widget.todosType, false));
    super.initState();
  }

  void _viewTodoDetail(BuildContext context, TodoModel todo) async {
    await Navigator.pushNamed(context, AddOrModifyTodoPage.routeName,
        arguments: todo);
    bloc.add(TodoEventLoadData(widget.todosType, true));
    setState(() {});
  }

  Widget _displayTodoList() {
    return Column(
      children: [
        Expanded(
            child: ListView.builder(
          itemBuilder: (context, index) {
            return InkWell(
              onTap: () {
                _viewTodoDetail(context, bloc.todos[index]);
              },
              child: Row(
                children: [
                  Checkbox(
                    value: bloc.todos[index].isCompleted,
                    onChanged: (value) {
                      TodoModel todo = bloc.todos[index];
                      TodoModel newTodo = TodoModel(
                        id: todo.id,
                        title: todo.title,
                        description: todo.description,
                        isCompleted: value!,
                      );
                      bloc.add(EventAddOrModifyTodo(false, newTodo));
                    },
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          bloc.todos[index].title ?? '',
                          maxLines: 1,
                          style: TextStyle(
                              color: bloc.todos[index].isCompleted ?? false
                                  ? Colors.blue
                                  : Colors.redAccent,
                              fontWeight: FontWeight.bold),
                        ),
                        Text(
                          bloc.todos[index].description ?? '',
                          maxLines: 1,
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                      onPressed: () {
                        final String id = bloc.todos[index].id ?? '';
                        bloc.add(TodoEventDelete(id));
                      },
                      icon: const Icon(Icons.remove)),
                ],
              ),
            );
          },
          itemCount: bloc.todos.length,
        )),
        Text('${bloc.todos.length}'),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TodoBloc, TodoState>(builder: (context, state) {
      if (state is TodoStateLoading) {
        return const LoadingListPage();
      }
      if (bloc.todos.isEmpty) {
        return const EmptyTodoData();
      }

      return _displayTodoList();
    }, listener: (context, state) {
      if (state is LoadDataSuccess) {
        setState(() {});
      }
      if (state is ReloadData) {
        bloc.add(TodoEventLoadData(widget.todosType, false));
      }
    });
  }
}

class EmptyTodoData extends StatelessWidget {
  const EmptyTodoData({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        'Empty',
        style: TextStyle(
          fontWeight: FontWeight.w900,
          fontSize: 24,
        ),
      ),
    );
  }
}
