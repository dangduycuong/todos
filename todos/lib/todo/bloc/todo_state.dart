part of 'todo_bloc.dart';

abstract class TodoState extends Equatable {
  const TodoState();
}

class TodoInitial extends TodoState {
  @override
  List<Object> get props => [];
}

class TodoStateLoading extends TodoState {
  @override
  List<Object> get props => [];
}

class LoadDataSuccess extends TodoState {
  @override
  List<Object> get props => [];
}

class ReloadData extends TodoState {
  @override
  List<Object> get props => [];
}


