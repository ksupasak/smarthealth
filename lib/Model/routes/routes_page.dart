import 'package:get/get.dart';
import 'package:smart_health/Model/splash/splash_screen.dart';
import 'package:smart_health/Model/view/checkqueue.dart';
import 'package:smart_health/Model/view/health_record.dart';
import 'package:smart_health/Model/view/home.dart';
import 'package:smart_health/Model/view/menu.dart';
import 'package:smart_health/Model/view/setting.dart';

class Routes {
  static const String splash = '/splash';
  static const String home = '/home';
  static const String menu = '/menu';
  static const String healthrecord = '/healthrecord';
  static const String setting = '/setting';
  static const String checkqueue = '/checkqueue';

  static final routes = [
    GetPage(name: splash, page: (() => Splash_Screen())),
    GetPage(name: home, page: (() => Homeapp())),
    GetPage(name: menu, page: (() => Menu())),
    GetPage(name: healthrecord, page: (() => HealthRecord())),
    GetPage(name: setting, page: (() => Setting())),
    GetPage(name: checkqueue, page: (() => CheckQueue()))
  ];
}
