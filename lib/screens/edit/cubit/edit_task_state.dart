part of 'edit_task_cubit.dart';

@immutable
sealed class EdittaskState {
  final TaskEntity task;

  const EdittaskState(this.task);
}

final class EdittaskInitial extends EdittaskState {
  const EdittaskInitial(super.task);
}

class EditTaskPriorityChanged extends EdittaskState{
  const EditTaskPriorityChanged(super.task);
  

}