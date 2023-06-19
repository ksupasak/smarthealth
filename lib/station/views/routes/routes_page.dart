import 'package:get/get.dart';
import 'package:smart_health/station/views/pages/checkqueue.dart';

import 'package:smart_health/station/views/pages/health_record.dart';
import 'package:smart_health/station/views/pages/home.dart';
import 'package:smart_health/station/views/pages/menu.dart';
import 'package:smart_health/station/views/pages/pages_setting/functionble/ble.dart';
import 'package:smart_health/station/views/pages/pages_setting/device.dart';
import 'package:smart_health/station/views/pages/pages_setting/init_setting.dart';
import 'package:smart_health/station/views/pages/printqueue.dart';
import 'package:smart_health/station/views/pages/regter.dart';
import 'package:smart_health/station/views/pages/setting.dart';
import 'package:smart_health/station/views/pages/user_information.dart';
import 'package:smart_health/station/views/pages/user_information2.dart';
import 'package:smart_health/station/views/splash/splash_screen.dart';

import 'test_routes.dart';

class Routes {
  static const String splash = '/splash';
  static const String home = '/home';
  static const String menu = '/menu';
  static const String healthrecord = '/healthrecord';
  static const String setting = '/setting';
  static const String checkqueue = '/checkqueue';
  static const String device = '/device';
  static const String initsetting = '/initsetting';
  static const String user_information = '/user_information';
  static const String printqueue = '/printqueue';
  static const String regter = '/regter';
  static final routes = [
        GetPage(name: splash, page: (() => Splash_Screen())),
        GetPage(name: home, page: (() => Homeapp())),
        GetPage(name: menu, page: (() => Menu())),
        GetPage(name: healthrecord, page: (() => HealthRecord())),
        GetPage(name: setting, page: (() => Setting())),
        GetPage(name: checkqueue, page: (() => CheckQueue())),
        GetPage(name: device, page: (() => Device())),
        GetPage(name: initsetting, page: (() => Initsetting())),
        GetPage(name: user_information, page: (() => UserInformation2())),
        GetPage(name: printqueue, page: (() => PrintQueue())),
        GetPage(name: regter, page: (() => Regter())),
      ] +
      TestRoutes.routes;
}
