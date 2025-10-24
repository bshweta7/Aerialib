// abstract interface

import 'package:sqflite/sqflite.dart';

abstract class LocalDataSource<T> {
  String get tableName;
  Future<Database> get database;

  Future<T?> getById(String id);
  Future<List<T>> getAll();
  Future<void> saveAll(List<T> items);
  Future<void> save(T item);
  Future<void> delete(String id);
}
