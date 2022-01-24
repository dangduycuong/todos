import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todos/todo/bloc/todo_bloc.dart';
import 'package:todos/todo/models/todo_model.dart';
import 'package:todos/todo/models/todos_type.dart';
import 'package:todos/widgets/enter_textformfield.dart';
import 'package:uuid/uuid.dart';

class AddNewTodoPage extends StatefulWidget {
  const AddNewTodoPage({Key? key}) : super(key: key);

  static const routeName = 'AddNewTodoPage';

  @override
  _AddNewTodoPageState createState() => _AddNewTodoPageState();
}

class _AddNewTodoPageState extends State<AddNewTodoPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TodoBloc(),
      child: BlocConsumer<TodoBloc, TodoState>(
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Add New'),
            ),
            body: Container(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    const EnterTextFormField(
                      enterTextType: TodoEnterText.title,
                      labelText: 'Title',
                      hintText: 'Enter Todo Title',
                    ),
                    Expanded(
                      child: EnterTextFormField(
                        enterTextType: TodoEnterText.description,
                        labelText: 'Description',
                        hintText: 'Enter Todo Description',
                        maxLines: null,
                      ),
                    ),
                    Row(
                      children: [
                        Checkbox(value: true, onChanged: (value) {}),
                        const Text('Completed'),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text('Cancel'),
                          ),
                        ),
                        const SizedBox(
                          width: 16,
                        ),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () async {
                              // bloc.add(const EventTextChange());
                              if (_formKey.currentState!.validate()) {
                                context
                                    .read<TodoBloc>()
                                    .add(const EventAddOrModifyTodo(true));
                              } else {
                                ScaffoldMessenger.of(context)
                                  ..removeCurrentSnackBar()
                                  ..showSnackBar(const SnackBar(
                                      content: Text(
                                          'Vui lòng nhập đầy đủ các thông tin')));
                              }
                              _formKey.currentState!.save();
                            },
                            child: const Text('Submit'),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
        listener: (context, state) {},
      ),
    );
  }
}

class AddTodoPage extends StatelessWidget {
  const AddTodoPage({Key? key}) : super(key: key);
  static const routeName = 'AddTodoGage';

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TodoBloc(),
      child: const AddTodoView(),
    );
  }
}

class AddTodoView extends StatefulWidget {
  const AddTodoView({Key? key}) : super(key: key);

  @override
  _AddTodoViewState createState() => _AddTodoViewState();
}

class _AddTodoViewState extends State<AddTodoView> {
  late TodoBloc bloc;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _todoTitleController = TextEditingController();
  final TextEditingController _todoDescriptionController =
      TextEditingController();

  bool _isCompleted = false;

  @override
  void initState() {
    bloc = context.read();
    bloc.add(TodoEventInit());
    super.initState();
  }

  void _addTodo() {
    var uuid = const Uuid();

    String id = uuid.v1(); // -> '6c84fb90-12c4-11e1-840d-7b25c5ee775a'

    TodoModel todo = TodoModel(
      id: id,
      title: _todoTitleController.text,
      description: _todoDescriptionController.text,
      isCompleted: _isCompleted,
    );
    bloc.add(TodoEventAdd(todo));
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TodoBloc, TodoState>(builder: (context, state) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Add New Todo'),
        ),
        body: Container(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(children: [
              const EnterTextFormField(
                enterTextType: TodoEnterText.title,
                labelText: 'Title',
                hintText: 'Enter Todo Title',
              ),
              const Expanded(
                child: EnterTextFormField(
                  enterTextType: TodoEnterText.description,
                  labelText: 'Description',
                  hintText: 'Enter Todo Description',
                  maxLines: null,
                ),
              ),
              InkWell(
                onTap: () {
                  _isCompleted = !_isCompleted;
                  setState(() {});
                },
                child: Row(
                  children: [
                    Checkbox(
                        value: _isCompleted,
                        onChanged: (value) {
                          _isCompleted = value!;
                          setState(() {});
                        }),
                    const Text('Completed'),
                  ],
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Cancel'),
                    ),
                  ),
                  const SizedBox(
                    width: 16,
                  ),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () async {
                        // bloc.add(const EventTextChange());
                        if (_formKey.currentState!.validate()) {
                          _addTodo();
                        } else {
                          ScaffoldMessenger.of(context)
                            ..removeCurrentSnackBar()
                            ..showSnackBar(const SnackBar(
                                content: Text(
                                    'Vui lòng nhập đầy đủ các thông tin')));
                        }
                        _formKey.currentState!.save();
                      },
                      child: const Text('Submit'),
                    ),
                  ),
                ],
              ),
            ]),
          ),
        ),
      );
    }, listener: (context, state) {
      if (state is LoadDataSuccess) {
        Navigator.pop(context);
      }
    });
  }
}
