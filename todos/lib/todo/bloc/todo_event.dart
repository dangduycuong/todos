part of 'todo_bloc.dart';

abstract class TodoEvent extends Equatable {
  const TodoEvent();
}

class TodoEventInit extends TodoEvent {
  @override
  List<Object?> get props => [];
}

class TodoEventDelete extends TodoEvent {
  final String id;

  const TodoEventDelete(this.id);

  @override
  List<Object?> get props => [id];
}

class TodoEventLoadData extends TodoEvent {
  final bool showLoading;
  final TodosType todosType;

  const TodoEventLoadData(this.todosType, this.showLoading);

  @override
  List<Object?> get props => [todosType];
}

class EventAddOrModifyTodo extends TodoEvent {
  final bool isAdd;
  final TodoModel todo;

  const EventAddOrModifyTodo(this.isAdd, this.todo);

  @override
  List<Object?> get props => [isAdd, todo];
}
