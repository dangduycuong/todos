import 'package:hive/hive.dart';

part 'todo_model.g.dart';

@HiveType(typeId: 0)
class TodoModel {
  @HiveField(0)
  final String? id;

  @HiveField(1)
  String? title;

  @HiveField(2)
  String? description;

  @HiveField(3)
  bool? isCompleted;

  TodoModel({
    this.id,
    this.title,
    this.description,
    this.isCompleted,
  });
}
