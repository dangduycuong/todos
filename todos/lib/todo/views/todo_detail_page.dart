import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todos/todo/bloc/todo_bloc.dart';
import 'package:todos/todo/models/todo_model.dart';

class TodoDetailPage extends StatelessWidget {
  const TodoDetailPage({Key? key}) : super(key: key);
  static const routeName = 'TodoDetailPage';

  @override
  Widget build(BuildContext context) {
    final TodoModel todo =
        ModalRoute.of(context)?.settings.arguments as TodoModel;
    return BlocProvider(
      create: (context) => TodoBloc(),
      child: TodoDetailView(
        todoDetail: todo,
      ),
    );
  }
}

class TodoDetailView extends StatefulWidget {
  const TodoDetailView({Key? key, required this.todoDetail}) : super(key: key);

  final TodoModel todoDetail;

  @override
  _TodoDetailViewState createState() => _TodoDetailViewState();
}

class _TodoDetailViewState extends State<TodoDetailView> {
  late TodoBloc bloc;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _todoTitleController = TextEditingController();
  final TextEditingController _todoDescriptionController =
      TextEditingController();

  bool _isCompleted = false;

  @override
  void initState() {
    _todoTitleController.text = widget.todoDetail.title ?? '';
    _todoDescriptionController.text = widget.todoDetail.description ?? '';
    _isCompleted = widget.todoDetail.isCompleted ?? false;
    bloc = context.read();
    bloc.add(TodoEventInit());
    super.initState();
  }

  void _updateTodo() {
    TodoModel newTodo = TodoModel(
      id: widget.todoDetail.id,
      title: _todoTitleController.text,
      description: _todoDescriptionController.text,
      isCompleted: _isCompleted,
    );
    bloc.add(TodoEventModify(newTodo));
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
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Title',
                  hintText: 'Enter Todo Title',
                ),
                controller: _todoTitleController,
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Please Fill";
                  }
                  return null;
                },
              ),
              Expanded(
                child: TextFormField(
                  maxLines: null,
                  autocorrect: true,
                  decoration: const InputDecoration(
                    labelText: 'Description',
                    hintText: 'Enter Todo Description',
                  ),
                  controller: _todoDescriptionController,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Please Fill";
                    }
                    return null;
                  },
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
                          _updateTodo();
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
      if (state is ReloadData) {
        Navigator.pop(context);
      }
    });
  }
}
