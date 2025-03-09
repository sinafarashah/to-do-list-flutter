import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:task_list1/data/data.dart';
import 'package:task_list1/data/repo/repository.dart';

part 'edit_task_state.dart';

class EdittaskCubit extends Cubit<EdittaskState> {
  final TaskEntity _task;
  final Repository<TaskEntity> repository;
  EdittaskCubit(this._task, this.repository) : super(EdittaskInitial(_task));

  void onSaveChangesClick() {
    repository.createOrUpdate(_task);
  }

  void onTextChanged(String text) {
    _task.name = text;
  }

  void onPriorityChanged(Priority priority) {
    _task.priority = priority;
    emit(EditTaskPriorityChanged(_task));
  }
}
