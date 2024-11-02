//
//  Generated file. Do not edit.
//

// clang-format off

#include "generated_plugin_registrant.h"

#include <flutter_webrtc/flutter_web_r_t_c_plugin.h>
#include <openvidu_client/openvidu_client_plugin.h>
#include <quick_usb/quick_usb_plugin.h>

void fl_register_plugins(FlPluginRegistry* registry) {
  g_autoptr(FlPluginRegistrar) flutter_webrtc_registrar =
      fl_plugin_registry_get_registrar_for_plugin(registry, "FlutterWebRTCPlugin");
  flutter_web_r_t_c_plugin_register_with_registrar(flutter_webrtc_registrar);
  g_autoptr(FlPluginRegistrar) openvidu_client_registrar =
      fl_plugin_registry_get_registrar_for_plugin(registry, "OpenviduClientPlugin");
  openvidu_client_plugin_register_with_registrar(openvidu_client_registrar);
  g_autoptr(FlPluginRegistrar) quick_usb_registrar =
      fl_plugin_registry_get_registrar_for_plugin(registry, "QuickUsbPlugin");
  quick_usb_plugin_register_with_registrar(quick_usb_registrar);
}
