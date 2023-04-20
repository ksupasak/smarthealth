import 'package:get/get.dart';
import 'package:smart_health/views/pages/check_queue.dart';
import 'package:smart_health/views/pages/health_record.dart';
import 'package:smart_health/views/pages/home.dart';
import 'package:smart_health/views/pages/menu.dart';
import 'package:smart_health/views/pages/pages_setting/functionble/ble.dart';
import 'package:smart_health/views/pages/pages_setting/device.dart';
import 'package:smart_health/views/pages/pages_setting/init_setting.dart';
import 'package:smart_health/views/pages/setting.dart';
import 'package:smart_health/views/splash/splash_screen.dart';

class Routes {
  static const String splash = '/splash';
  static const String home = '/home';
  static const String menu = '/menu';
  static const String healthrecord = '/healthrecord';
  static const String setting = '/setting';
  static const String checkqueue = '/checkqueue';
  static const String device = '/device';
  static const String initsetting = '/initsetting';

  static final routes = [
    GetPage(name: splash, page: (() => Splash_Screen())),
    GetPage(name: home, page: (() => Homeapp())),
    GetPage(name: menu, page: (() => Menu())),
    GetPage(name: healthrecord, page: (() => HealthRecord())),
    GetPage(name: setting, page: (() => Setting())),
    GetPage(name: checkqueue, page: (() => CheckQueue())),
    GetPage(name: device, page: (() => Device())),
    GetPage(name: initsetting, page: (() => Initsetting()))
  ];
}
