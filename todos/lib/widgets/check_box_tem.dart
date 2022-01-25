import 'package:flutter/material.dart';

typedef CompletedChangValue = Function(bool value);

class CheckBoxItem extends StatefulWidget {
  const CheckBoxItem(
      {Key? key, required this.onchange, required this.defaultValue})
      : super(key: key);

  final CompletedChangValue onchange;
  final bool defaultValue;

  @override
  _CheckBoxItemState createState() => _CheckBoxItemState();
}

class _CheckBoxItemState extends State<CheckBoxItem> {
  bool _currentValue = false;

  @override
  void initState() {
    _currentValue = widget.defaultValue;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        _currentValue = !_currentValue;
        widget.onchange(_currentValue);
        setState(() {});
      },
      child: Row(
        children: [
          Checkbox(
            value: _currentValue,
            onChanged: (value) {
              _currentValue = value ?? false;
              widget.onchange(_currentValue);

              setState(() {});
            },
          ),
          const Text('Completed'),
        ],
      ),
    );
  }
}
