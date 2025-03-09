part of 'tasklist_bloc.dart';

@immutable
sealed class TaskListEvent {}


class TaskListStarted extends TaskListEvent {}

class TaskListSearch extends TaskListEvent {
  final String searchKeyword;

  TaskListSearch(this.searchKeyword);

}

class TaskListDeleteAll extends TaskListEvent {}

