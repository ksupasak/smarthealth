import 'package:get/get.dart';

import 'package:smart_health/station/test/test_page.dart';

class TestRoutes {
  static const String test = '/test_page';

  static final routes = [GetPage(name: test, page: (() => TestPage()))];
}
