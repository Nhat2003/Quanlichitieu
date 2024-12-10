
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'category_model.dart';

@HiveType(typeId: 1)
class Transaction extends HiveObject {
  @HiveField(0)
  CategoryModel category;
  @HiveField(1)
  String notes;
  @HiveField(2)
  String amount;
  @HiveField(3)
  String type;
  @HiveField(4)
  DateTime createAt;

  Transaction(this.type, this.amount, this.createAt, this.notes, this.category);
}

