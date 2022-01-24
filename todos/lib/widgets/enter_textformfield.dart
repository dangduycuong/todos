import 'package:flutter/material.dart';
import 'package:provider/src/provider.dart';
import 'package:todos/todo/bloc/todo_bloc.dart';
import 'package:todos/todo/models/todo_model.dart';
import 'package:todos/todo/models/todos_type.dart';

class EnterTextFormField extends StatefulWidget {
  const EnterTextFormField({
    Key? key,
    required this.enterTextType,
    required this.labelText,
    required this.hintText,
    this.maxLines,
  }) : super(key: key);

  final TodoEnterText enterTextType;
  final String labelText;
  final String hintText;
  final int? maxLines;

  @override
  _EnterTextFormFieldState createState() => _EnterTextFormFieldState();
}

class _EnterTextFormFieldState extends State<EnterTextFormField> {
  final _textController = TextEditingController();
  late TodoBloc _todoBloc;

  @override
  void initState() {
    super.initState();
    _todoBloc = context.read<TodoBloc>();
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      validator: (value) {
        if (value?.isEmpty ?? false) {
          return 'Please Fill';
        }
        return null;
      },
      maxLines: widget.maxLines,
      controller: _textController,
      autocorrect: false,
      onChanged: (text) {
        TodoModel todo = TodoModel(

        );
        if (widget.enterTextType == TodoEnterText.title) {
          todo.title = _textController.text;
        } else {
          todo.description = _textController.text;
        }
        _todoBloc.add(
          EventTextChange(todo),
        );
      },
      decoration: InputDecoration(
        suffixIcon: GestureDetector(
          onTap: _onClearTapped,
          child: const Icon(Icons.clear),
        ),
        border: InputBorder.none,
        labelText: widget.labelText,
        hintText: widget.hintText,
      ),
    );
  }

  void _onClearTapped() {
    _textController.text = '';
    // _todoBloc.add(const EventTextChange(''));
  }
}
