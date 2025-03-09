import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:task_list1/data/data.dart';
import 'package:task_list1/data/repo/repository.dart';
import 'package:task_list1/data/wigets.dart';
import 'package:task_list1/main.dart';
import 'package:task_list1/screens/edit/cubit/edit_task_cubit.dart';
import 'package:task_list1/screens/edit/edit.dart';
import 'package:task_list1/screens/home/bloc/tasklist_bloc.dart';

class HomeScreen extends StatelessWidget {
  final TextEditingController controller = TextEditingController();
  final ValueNotifier<String> searchKeywordNotifier = ValueNotifier('');

  HomeScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    return Scaffold(
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: FloatingActionButton.extended(
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => BlocProvider<EdittaskCubit>(
                        create: (context) => EdittaskCubit(TaskEntity(),
                            context.read<Repository<TaskEntity>>()),
                        child: const EditTaskScreen(),
                      )));
            },
            label: Row(
              children: [
                Text('Add New Task'),
                SizedBox(
                  width: 4,
                ),
                Icon(CupertinoIcons.add),
              ],
            )),
        body: BlocProvider<TaskListBloc>(
          create: (context) =>
              TaskListBloc(context.read<Repository<TaskEntity>>()),
          child: SafeArea(
            child: Column(
              children: [
                Container(
                  height: 110,
                  decoration: BoxDecoration(
                      gradient: LinearGradient(colors: [
                    themeData.colorScheme.primary,
                    themeData.colorScheme.primaryFixed,
                  ])),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'To Do List',
                              style: themeData.textTheme.headlineSmall!.apply(
                                  color: themeData.colorScheme.onPrimary),
                            ),
                            Icon(
                              CupertinoIcons.share,
                              color: themeData.colorScheme.onPrimary,
                            )
                          ],
                        ),
                        SizedBox(
                          height: 12,
                        ),
                        Container(
                          height: 38,
                          width: double.infinity,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(19),
                              color: themeData.colorScheme.onPrimary,
                              boxShadow: [
                                BoxShadow(
                                    blurRadius: 20,
                                    // ignore: deprecated_member_use
                                    color: Colors.black.withOpacity(0.1))
                              ]),
                          child: Builder(builder: (context) {
                            return TextField(
                              onChanged: (value) {
                                context
                                    .read<TaskListBloc>()
                                    .add(TaskListSearch(value));
                              },
                              controller: controller,
                              decoration: InputDecoration(
                                  prefixIcon: Icon(CupertinoIcons.search),
                                  label: Text('Search tasks...')),
                            );
                          }),
                        )
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: Consumer<Repository<TaskEntity>>(
                    builder: (context, model, child) {
                      context.read<TaskListBloc>().add(TaskListStarted());
                      return BlocBuilder<TaskListBloc, TaskListState>(
                          builder: (context, state) {
                        if (state is TaskListSuccess) {
                          return TaskList(
                              items: state.items, themeData: themeData);
                        } else if (state is TaskListEmpty) {
                          return const EmptyState();
                        } else if (state is TaskListLoading ||
                            state is TaskListInitial) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        } else if (state is TaskListError) {
                          return Center(
                            child: Text(state.errorMessage),
                          );
                        } else {
                          throw Exception('state is not valid...');
                        }
                      });
                    },
                  ),
                )
              ],
            ),
          ),
        ));
  }
}

class TaskList extends StatelessWidget {
  const TaskList({
    super.key,
    required this.items,
    required this.themeData,
  });

  final List<TaskEntity> items;
  final ThemeData themeData;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        padding: EdgeInsets.fromLTRB(16, 16, 16, 100),
        itemCount: items.length + 1,
        itemBuilder: (context, index) {
          if (index == 0) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Today',
                      style: themeData.textTheme.headlineSmall!
                          .apply(fontSizeFactor: 0.9),
                    ),
                    Container(
                      width: 70,
                      height: 3,
                      margin: EdgeInsets.only(top: 4),
                      decoration: BoxDecoration(
                          color: primaryColor,
                          borderRadius: BorderRadius.circular(1.5)),
                    )
                  ],
                ),
                MaterialButton(
                    color: Color(0xffEAEFF5),
                    textColor: secondryTextColor,
                    elevation: 0,
                    onPressed: () {
                      context.read<TaskListBloc>().add(TaskListDeleteAll());
                    },
                    child: Row(
                      children: [
                        Text('Dellet All'),
                        SizedBox(
                          width: 4,
                        ),
                        Icon(
                          CupertinoIcons.delete_solid,
                          size: 18,
                        )
                      ],
                    ))
              ],
            );
          } else {
            final TaskEntity task = items[index - 1];
            return TaskItem(task: task);
          }
        });
  }
}

class TaskItem extends StatefulWidget {
  static const double height = 74;
  static const double borderRadius = 8;
  const TaskItem({
    super.key,
    required this.task,
  });

  final TaskEntity task;

  @override
  State<TaskItem> createState() => _TaskItemState();
}

class _TaskItemState extends State<TaskItem> {
  @override
  Widget build(BuildContext context) {
    final ThemeData themdata = Theme.of(context);
    final Color priorityColor;
    switch (widget.task.priority) {
      case Priority.high:
        priorityColor = highPriority;
        break;
      case Priority.normal:
        priorityColor = normalPriority;
        break;
      case Priority.low:
        priorityColor = lowPriority;
        break;
    }
    return InkWell(
      onTap: () {
        setState(() {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => BlocProvider<EdittaskCubit>(
                  create: (context) => EdittaskCubit(
                      widget.task, context.read<Repository<TaskEntity>>()),
                  child: const EditTaskScreen())));
        });
      },
      onLongPress: () {
        widget.task.delete();
      },
      child: Container(
          height: TaskItem.height,
          margin: EdgeInsets.only(top: 8),
          padding: EdgeInsets.only(left: 16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(TaskItem.borderRadius),
            color: themdata.colorScheme.surface,
          ),
          child: Row(
            children: [
              MyCheckBox(
                  value: widget.task.isCompleted,
                  onTap: () {
                    setState(() {
                      widget.task.isCompleted = !widget.task.isCompleted;
                    });
                  }),
              SizedBox(
                width: 16,
              ),
              Expanded(
                child: Text(
                  widget.task.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      decoration: widget.task.isCompleted
                          ? TextDecoration.lineThrough
                          : null),
                ),
              ),
              SizedBox(
                width: 8,
              ),
              Container(
                height: TaskItem.height,
                width: 5,
                decoration: BoxDecoration(
                  color: priorityColor,
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(TaskItem.borderRadius),
                      bottomRight: Radius.circular(TaskItem.borderRadius)),
                ),
              )
            ],
          )),
    );
  }
}
