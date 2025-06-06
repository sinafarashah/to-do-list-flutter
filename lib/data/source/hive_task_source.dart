import 'package:hive_flutter/hive_flutter.dart';
import 'package:task_list1/data/data.dart';
import 'package:task_list1/data/source/source.dart';

class HiveTaskDtatSource implements DataSource<TaskEntity> {
  final Box<TaskEntity> box;

  HiveTaskDtatSource(this.box);

  @override
  Future<TaskEntity> createOrUpdate(TaskEntity data) async {
    if (data.isInBox) {
      data.save();
    } else {
      data.id = await box.add(data);
    }
    return data;
  }

  @override
  Future<void> delete(TaskEntity data) async {
    return data.delete();
  }

  @override
  Future<void> deleteAll() {
    return box.clear();
  }

  @override
  Future<void> deleteById(id) {
    return box.delete(id);
  }

  @override
  Future<TaskEntity> findById(id) async {
    return box.values.firstWhere((element) => element.id == id);
  }

  @override
  Future<List<TaskEntity>> getAll({String searchKeyword = ''}) async {
    if (searchKeyword.isNotEmpty) {
      return box.values
          .where((task) => task.name.contains(searchKeyword))
          .toList();
    } else {
      return box.values.toList();
    }
  }
}
