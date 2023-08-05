import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';
import 'package:smart_health/myapp/provider/provider.dart';

Future<Database> openDatabase_list_health_record() async {
  Directory app = await getApplicationDocumentsDirectory();
  String dbpart = app.path + '/health_record/' + 'health_record.db';
  final db = await databaseFactoryIo.openDatabase(dbpart);
  return db;
}

Future<void> addData_health_record() async {
  Database db = await openDatabase_list_health_record();
  var store = intMapStoreFactory.store('list_health_record');
  var records = await store.find(db);
//  print(records);
  if ((records.length == 0)) {
    final db_id = await openDatabase_list_health_record();
    final store = intMapStoreFactory.store('list_health_record');
    final key = await store.add(db_id, {});

    await db_id.close();
  }
}

Future<void> add_map_health_record(String id, Map data) async {
  // await addData_health_record();
  final db = await openDatabase_list_health_record();
  final store = intMapStoreFactory.store('list_health_record');
  var snapshot = await store.find(db);
  //List datas = [];

  int x = 0;
  for (var records in snapshot) {
//datas.add(records['list_health_record']);

    print("ข้อมูลที่ $x = $records");

    x++;
  }

  // Map<String, Object?> list_health_record = {};

  //datas.add(records);
  //datas = records as List;

  // datas.add(data);

  // for (RecordSnapshot<int, Map<String, Object?>> record in records) {
  //   var getmapd = record['list_health_record'];

  //   if (getmapd != null) {
  //     list_health_record =
  //         Map.fromEntries((getmapd as Map<String, Object?>).entries);
  //   }
  // }

  // print("health_record =${list_health_record['health_record']}");
  // if (list_health_record['health_record'] != null) {
  //   datas = list_health_record['health_record'] as List;

  //   // datas.add(list_health_record['health_record']);
  // } else {
  //   datas.add([]);
  // }

  // datas.add(data);

  // list_health_record[id] = datas;

  final key = await store.add(db, {
    'health_record': data,
  });
  await db.close();
}
