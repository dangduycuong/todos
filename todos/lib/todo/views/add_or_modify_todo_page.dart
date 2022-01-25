import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todos/todo/bloc/todo_bloc.dart';
import 'package:todos/todo/models/todo_model.dart';
import 'package:todos/todo/models/todos_type.dart';
import 'package:todos/widgets/check_box_tem.dart';
import 'package:todos/widgets/enter_text_form_field.dart';

class AddOrModifyTodoPage extends StatelessWidget {
  const AddOrModifyTodoPage({Key? key}) : super(key: key);

  static const routeName = 'AddOrModifyTodoPage';

  @override
  Widget build(BuildContext context) {
    final TodoModel? todo =
        ModalRoute.of(context)?.settings.arguments as TodoModel?;
    return BlocProvider(
      create: (_) => TodoBloc()..add(TodoEventInit()),
      child: AddOrModifyTodoView(
        todo: todo,
      ),
    );
  }
}

class AddOrModifyTodoView extends StatefulWidget {
  const AddOrModifyTodoView({Key? key, this.todo}) : super(key: key);

  final TodoModel? todo;

  @override
  _AddOrModifyTodoViewState createState() => _AddOrModifyTodoViewState();
}

class _AddOrModifyTodoViewState extends State<AddOrModifyTodoView> {
  late TodoBloc bloc;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TodoModel newTodo = TodoModel();
  bool _isAddTodo = true;

  @override
  void initState() {
    bloc = context.read();
    if (widget.todo != null) {
      _isAddTodo = false;
      newTodo = widget.todo!;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TodoBloc, TodoState>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: (_isAddTodo)
                ? const Text('Add New Todo')
                : const Text('Todo Detail'),
          ),
          body: Container(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  EnterTextFormField(
                    enterTextType: TodoEnterText.title,
                    labelText: 'Title',
                    hintText: 'Enter Todo Title',
                    initialValue: newTodo.title,
                    onChange: (value) => newTodo.title = value,
                  ),
                  Expanded(
                    child: EnterTextFormField(
                      enterTextType: TodoEnterText.title,
                      labelText: 'Description',
                      hintText: 'Enter Todo Description',
                      initialValue: newTodo.description,
                      onChange: (value) {
                        newTodo.description = value;
                      },
                    ),
                  ),
                  CheckBoxItem(
                      onchange: (value) => newTodo.isCompleted = value,
                      defaultValue: newTodo.isCompleted ?? false),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text('Cancel'),
                        ),
                      ),
                      const SizedBox(
                        width: 8,
                      ),
                      Expanded(
                          child: ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            newTodo.isCompleted ??= false;
                            bloc.add(EventAddOrModifyTodo(_isAddTodo, newTodo));
                          } else {
                            ScaffoldMessenger.of(context)
                              ..removeCurrentSnackBar()
                              ..showSnackBar(const SnackBar(
                                  content:
                                      Text('Please complete all information')));
                          }
                          _formKey.currentState!.save();
                        },
                        child: const Text('Save'),
                      ))
                    ],
                  )
                ],
              ),
            ),
          ),
        );
      },
      listener: (context, state) {
        if (state is ReloadData) {
          Navigator.pop(context);
        }
      },
    );
  }
}
