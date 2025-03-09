import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:task_list1/data/data.dart';
import 'package:task_list1/data/repo/repository.dart';

part 'tasklist_event.dart';
part 'tasklist_state.dart';

class TaskListBloc extends Bloc<TaskListEvent, TaskListState> {
  final Repository<TaskEntity> repository;
  TaskListBloc(this.repository) : super(TaskListInitial()) {
    on<TaskListEvent>((event, emit) async {
      if (event is TaskListStarted || event is TaskListSearch) {
        final String searchTerm;
        emit(TaskListLoading());

        if (event is TaskListSearch) {
          searchTerm = event.searchKeyword;
        } else {
          searchTerm = '';
        }

        try {
          final items = await repository.getAll(searchKeyword: searchTerm);

          if (items.isNotEmpty) {
            emit(TaskListSuccess(items));
          } else {
            emit(TaskListEmpty());
          }
        } catch (e) {
          emit(TaskListError('خطای نامشخص'));
        }
      } else if (event is TaskListDeleteAll) {
        await repository.deleteAll();
        emit(TaskListEmpty());
      }
    });
  }
}
