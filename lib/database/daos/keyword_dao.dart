import 'package:drift/drift.dart';

import '../app_database.dart';
import '../tables/keywords_table.dart';

part 'keyword_dao.g.dart';

@DriftAccessor(tables: [Keywords])
class KeywordDao extends DatabaseAccessor<AppDatabase>
    with _$KeywordDaoMixin {
  KeywordDao(AppDatabase db) : super(db);

  Future<List<Keyword>> getAll() {
    return select(keywords).get();
  }

  Future<Keyword?> getById(String id) {
    return (select(keywords)
          ..where((tbl) => tbl.id.equals(id)))
        .getSingleOrNull();
  }

  Future<List<Keyword>> search(String text) {
    return (select(keywords)
          ..where((tbl) => tbl.name.contains(text)))
        .get();
  }

  Future<void> insertKeyword(KeywordsCompanion keyword) async {
    await into(keywords).insert(keyword);
  }

  Future<bool> updateKeyword(Keyword keyword) {
    return update(keywords).replace(keyword);
  }

  Future<int> deleteKeyword(String id) {
    return (delete(keywords)
          ..where((tbl) => tbl.id.equals(id)))
        .go();
  }

  Future<void> clear() async {
    await delete(keywords).go();
  }
}