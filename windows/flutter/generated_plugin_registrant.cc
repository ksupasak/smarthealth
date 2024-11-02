//
//  Generated file. Do not edit.
//

// clang-format off

#include "generated_plugin_registrant.h"

#include <flutter_pos_printer_platform/flutter_pos_printer_platform_plugin.h>
#include <flutter_webrtc/flutter_web_r_t_c_plugin.h>
#include <network_info_plus/network_info_plus_windows_plugin.h>
#include <openvidu_client/openvidu_client_plugin_c_api.h>
#include <quick_usb/quick_usb_plugin.h>

void RegisterPlugins(flutter::PluginRegistry* registry) {
  FlutterPosPrinterPlatformPluginRegisterWithRegistrar(
      registry->GetRegistrarForPlugin("FlutterPosPrinterPlatformPlugin"));
  FlutterWebRTCPluginRegisterWithRegistrar(
      registry->GetRegistrarForPlugin("FlutterWebRTCPlugin"));
  NetworkInfoPlusWindowsPluginRegisterWithRegistrar(
      registry->GetRegistrarForPlugin("NetworkInfoPlusWindowsPlugin"));
  OpenviduClientPluginCApiRegisterWithRegistrar(
      registry->GetRegistrarForPlugin("OpenviduClientPluginCApi"));
  QuickUsbPluginRegisterWithRegistrar(
      registry->GetRegistrarForPlugin("QuickUsbPlugin"));
}
