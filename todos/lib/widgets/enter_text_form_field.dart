import 'package:flutter/material.dart';
import 'package:todos/todo/models/todo_model.dart';
import 'package:todos/todo/models/todos_type.dart';

/*
* // typedef TextChangValue = Function(String value);
//final TextChangValue onChange;
//final Function(String value) onChange*/

class EnterTextFormField extends StatefulWidget {
  const EnterTextFormField({
    Key? key,
    required this.enterTextType,
    required this.labelText,
    required this.hintText,
    this.maxLines,
    this.initialValue,
    required this.onChange,
  }) : super(key: key);

  final TodoEnterText enterTextType;
  final String labelText;
  final String hintText;
  final int? maxLines;
  final String? initialValue;
  final ValueChanged onChange;

  @override
  _EnterTextFormFieldState createState() => _EnterTextFormFieldState();
}

class _EnterTextFormFieldState extends State<EnterTextFormField> {
  final _textController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.initialValue != null) {
      _textController.text = widget.initialValue!;
    }
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
        TodoModel todo = TodoModel();
        if (widget.enterTextType == TodoEnterText.title) {
          todo.title = _textController.text;
        } else {
          todo.description = _textController.text;
        }
        widget.onChange(text);
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
