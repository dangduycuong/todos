part of 'todo_bloc.dart';

abstract class TodoEvent extends Equatable {
  const TodoEvent();
}

class TodoEventInit extends TodoEvent {
  @override
  List<Object?> get props => [];
}

class TodoEventAdd extends TodoEvent {
  final TodoModel todo;

  const TodoEventAdd(this.todo);

  @override
  List<Object?> get props => [];
}

class TodoEventModify extends TodoEvent {
  final TodoModel todo;

  const TodoEventModify(this.todo);
  @override
  List<Object?> get props => [todo];
}

class TodoEventDelete extends TodoEvent {
  final String id;

  const TodoEventDelete(this.id);

  @override
  List<Object?> get props => [id];
}

class TodoEventLoadData extends TodoEvent {
  final TodosType todosType;

  const TodoEventLoadData(this.todosType);

  @override
  List<Object?> get props => [todosType];
}

class TodoEventReloadLoadData extends TodoEvent {
  final TodosType todosType;

  const TodoEventReloadLoadData(this.todosType);

  @override
  List<Object?> get props => [todosType];
}

class TodoEventViewDetail extends TodoEvent {
  final String id;
  const TodoEventViewDetail(this.id);
  @override
  List<Object?> get props => [id];
}

class EventTextChange extends TodoEvent {
  final TodoModel todo;
  const EventTextChange(this.todo);
  @override
  List<Object?> get props => [];
}

class EventAddOrModifyTodo extends TodoEvent {
  final bool isAdd;
  const EventAddOrModifyTodo(this.isAdd);
  @override
  List<Object?> get props => [isAdd];
}
