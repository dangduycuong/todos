import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';
import 'package:todos/todo/models/todo_model.dart';
import 'package:todos/todo/models/todos_type.dart';
import 'package:uuid/uuid.dart';

part 'todo_event.dart';

part 'todo_state.dart';

class TodoBloc extends Bloc<TodoEvent, TodoState> {
  List<TodoModel> todos = [];
  TodoModel todoItem = TodoModel();
  late final Box box;

  TodoBloc() : super(TodoInitial()) {
    on<TodoEvent>((event, emit) {});
    on<TodoEventInit>(_hiveInit);
    on<EventAddOrModifyTodo>(_addOrModifyTodo);
    on<TodoEventDelete>(_deleteTodo);
    on<TodoEventLoadData>(_fetchTodosData);
  }

  void _addOrModifyTodo(EventAddOrModifyTodo event, Emitter<TodoState> emit) {
    if (event.isAdd) {
      var uuid = const Uuid();
      String id = uuid.v1();
      todoItem = event.todo;
      todoItem.id = id;
      box.add(todoItem);
    } else {
      final String id = event.todo.id ?? '';
      int index = getIndexOfItem(id);
      box.putAt(index, event.todo);
    }
    emit(ReloadData());
  }

  void _hiveInit(TodoEventInit event, Emitter<TodoState> emit) {
    box = Hive.box('todoBox');
  }

  void _deleteTodo(TodoEventDelete event, Emitter<TodoState> emit) {
    int index = getIndexOfItem(event.id);
    box.deleteAt(index);
    emit(ReloadData());
  }

  void _fetchTodosData(TodoEventLoadData event, Emitter<TodoState> emit) {
    if (event.showLoading) {
      emit(TodoStateLoading());
    }

    _filterTodos(event.todosType);
    emit(LoadDataSuccess());
  }

  void _filterTodos(TodosType todosType) {
    todos = [];
    for (int index = 0; index < box.length; index++) {
      final TodoModel todo = box.getAt(index) as TodoModel;
      final bool isCompleted = todo.isCompleted ?? false;
      switch (todosType) {
        case (TodosType.all):
          todos.add(todo);
          break;
        case TodosType.completed:
          if (isCompleted) {
            todos.add(todo);
          }
          break;
        case TodosType.incomplete:
          if (todo.isCompleted == false) {
            todos.add(todo);
          }
          break;
      }
    }
  }

  int getIndexOfItem(String id) {
    int result = 0;
    for (int index = 0; index < box.length; index++) {
      final TodoModel todo = box.getAt(index) as TodoModel;
      if (todo.id == id) {
        result = index;
        break;
      }
    }
    return result;
  }
}
