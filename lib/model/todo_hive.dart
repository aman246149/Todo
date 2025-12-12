import 'package:hive/hive.dart';

part 'todo_hive.g.dart';

@HiveType(typeId: 0)
class TodoDb extends HiveObject {
  @HiveField(0)
  String title;

  @HiveField(1)
  String description;

  @HiveField(2)
  String image;

  TodoDb({required this.title, required this.description, required this.image});
}
