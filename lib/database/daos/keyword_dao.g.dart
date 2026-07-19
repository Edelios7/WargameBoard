// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'keyword_dao.dart';

// ignore_for_file: type=lint
mixin _$KeywordDaoMixin on DatabaseAccessor<AppDatabase> {
  $KeywordsTable get keywords => attachedDatabase.keywords;
  KeywordDaoManager get managers => KeywordDaoManager(this);
}

class KeywordDaoManager {
  final _$KeywordDaoMixin _db;
  KeywordDaoManager(this._db);
  $$KeywordsTableTableManager get keywords =>
      $$KeywordsTableTableManager(_db.attachedDatabase, _db.keywords);
}
