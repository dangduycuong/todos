import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';
import 'package:todos/todo/models/todo_model.dart';
import 'package:todos/todo/models/todos_type.dart';

part 'todo_event.dart';

part 'todo_state.dart';

class TodoBloc extends Bloc<TodoEvent, TodoState> {
  List<TodoModel> todos = [];
  TodoModel todoItem = TodoModel();
  late final Box box;

  TodoBloc() : super(TodoInitial()) {
    on<TodoEvent>((event, emit) {});
    on<TodoEventInit>(_hiveInit);
    on<TodoEventAdd>(_addTodo);
    on<TodoEventModify>(_modifyTodo);
    on<TodoEventDelete>(_deleteTodo);
    on<TodoEventLoadData>(_fetchTodosData);
    on<TodoEventReloadLoadData>(_reloadData);
    on<TodoEventViewDetail>(_viewDetail);
    on<EventTextChange>(_onChangeText);
    on<EventAddOrModifyTodo>(_addOrModifyTodo);
  }

  void _addOrModifyTodo(EventAddOrModifyTodo event, Emitter<TodoState> emit) {
    if (event.isAdd) {}
  }

  void _onChangeText(EventTextChange event, Emitter<TodoState> emit) {
    todoItem.title = event.todo.title;
    todoItem.title = event.todo.title;
  }

  void _hiveInit(TodoEventInit event, Emitter<TodoState> emit) {
    box = Hive.box('todoBox');
  }

  void _addTodo(TodoEventAdd event, Emitter<TodoState> emit) {
    box.add(event.todo);
    emit(LoadDataSuccess());
  }

  void _modifyTodo(TodoEventModify event, Emitter<TodoState> emit) {
    final String id = event.todo.id ?? '';
    int index = getIndexOfItem(id);
    box.putAt(index, event.todo);
    emit(ReloadData());
  }

  void _deleteTodo(TodoEventDelete event, Emitter<TodoState> emit) {
    int index = getIndexOfItem(event.id);
    box.deleteAt(index);
    emit(ReloadData());
  }

  void _fetchTodosData(TodoEventLoadData event, Emitter<TodoState> emit) {
    emit(TodoStateLoading());
    _filterTodos(event.todosType);
    emit(LoadDataSuccess());
  }

  void _reloadData(TodoEventReloadLoadData event, Emitter<TodoState> emit) {
    _filterTodos(event.todosType);
    emit(LoadDataSuccess());
  }

  void _viewDetail(TodoEventViewDetail event, Emitter<TodoState> emit) {
    int index = getIndexOfItem(event.id);
    final TodoModel todo = box.getAt(index) as TodoModel;
    emit(GotoTodoDetail(todo));
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
