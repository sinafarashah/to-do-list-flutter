import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:task_list1/data/data.dart';

import 'package:task_list1/main.dart';
import 'package:task_list1/screens/edit/cubit/edit_task_cubit.dart';

class EditTaskScreen extends StatefulWidget {
  const EditTaskScreen({
    super.key,
  });

  @override
  State<EditTaskScreen> createState() => _EditTaskScreenState();
}

class _EditTaskScreenState extends State<EditTaskScreen> {
  late final TextEditingController _controller;

  @override
  void initState() {
    _controller = TextEditingController(
        text: context.read<EdittaskCubit>().state.task.name);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    return Scaffold(
      backgroundColor: themeData.colorScheme.surface,
      appBar: AppBar(
        backgroundColor: themeData.colorScheme.surface,
        foregroundColor: themeData.colorScheme.onSurface,
        title: Text('Edit Task'),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            context.read<EdittaskCubit>().onSaveChangesClick();

            Navigator.of(context).pop();
          },
          label: Row(
            children: [
              Text('Save Changes'),
              Icon(CupertinoIcons.checkmark, size: 18),
            ],
          )),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            BlocBuilder<EdittaskCubit, EdittaskState>(
              builder: ((context, state) {
                final priority = state.task.priority;
                return Flex(
                  direction: Axis.horizontal,
                  children: [
                    Flexible(
                        flex: 1,
                        child: PriorityCheckBox(
                          onTap: () {
                            context
                                .read<EdittaskCubit>()
                                .onPriorityChanged(Priority.high);
                          },
                          label: 'High',
                          color: highPriority,
                          isSelected: priority == Priority.high,
                        )),
                    SizedBox(width: 8),
                    Flexible(
                        flex: 1,
                        child: PriorityCheckBox(
                          onTap: () {
                            context
                                .read<EdittaskCubit>()
                                .onPriorityChanged(Priority.normal);
                          },
                          label: 'Normal',
                          color: normalPriority,
                          isSelected: priority == Priority.normal,
                        )),
                    SizedBox(width: 8),
                    Flexible(
                        flex: 1,
                        child: PriorityCheckBox(
                          onTap: () {
                            context
                                .read<EdittaskCubit>()
                                .onPriorityChanged(Priority.low);
                          },
                          label: 'Low',
                          color: lowPriority,
                          isSelected: priority == Priority.low,
                        )),
                  ],
                );
              }),
            ),
            TextField(
              controller: _controller,
              onChanged: (value) {
                context.read<EdittaskCubit>().onTextChanged(value);
              },
            )
          ],
        ),
      ),
    );
  }
}

class PriorityCheckBox extends StatelessWidget {
  final String label;
  final Color color;
  final bool isSelected;
  final GestureTapCallback onTap;

  const PriorityCheckBox(
      {super.key,
      required this.label,
      required this.color,
      required this.isSelected,
      required this.onTap});
  @override
  Widget build(BuildContext context) {
   
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 40,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4),
          border:
              // ignore: deprecated_member_use
              Border.all(width: 2, color: secondryTextColor.withOpacity(0.2)),
        ),
        child: Stack(
          children: [
            Center(
              child: Text(label),
            ),
            Positioned(
                right: 8,
                bottom: 0,
                top: 0,
                child: Center(
                  child: _CheckBoxShape(
                    value: isSelected,
                    color: color,
                  ),
                )),
          ],
        ),
      ),
    );
  }
}

class _CheckBoxShape extends StatelessWidget {
  final bool value;
  final Color color;

  const _CheckBoxShape({required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    return Container(
      width: 16,
      height: 16,
      decoration:
          BoxDecoration(borderRadius: BorderRadius.circular(12), color: color),
      child: value
          ? Icon(
              CupertinoIcons.checkmark,
              color: themeData.colorScheme.onPrimary,
              size: 12,
            )
          : null,
    );
  }
}
