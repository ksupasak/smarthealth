import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';
import 'package:smart_health/provider/Provider.dart';

Future<Database> openDatabaseapp() async {
  Directory app = await getApplicationDocumentsDirectory();
  String dbpart = app.path + '/' + 'local.db';
  final db = await databaseFactoryIo.openDatabase(dbpart);
  return db;
}

Future<int> Showdatabasedatauserapp() async {
  Database db = await openDatabaseapp();
  var store = intMapStoreFactory.store('dataapp');
  var records = await store.find(db);
  if ((records.length == 0)) {
    return 0;
  } else {
    return 1;
  }
}

Future deletedatabase() async {
  Database db = await openDatabaseapp();
  var store = intMapStoreFactory.store('dataapp');
  await store.drop(db);
}

Future Adddatabaseapp(stringitem data) async {
  Database db = await openDatabaseapp();
  var store = intMapStoreFactory.store('dataapp');
  var key = await store.add(db, {
    'Hospitalname_local': data.Hospitalname,
    'LicenseKey_local': data.LicenseKey,
    'PlatfromURL_local': data.PlatfromURL,
  });
  db.close();
}
