//
//  Generated file. Do not edit.
//

// clang-format off

#include "generated_plugin_registrant.h"

#include <sodium_libs/sodium_libs_plugin_c_api.h>
#include <sqlcipher_flutter_libs/sqlite3_flutter_libs_plugin.h>

void RegisterPlugins(flutter::PluginRegistry* registry) {
  SodiumLibsPluginCApiRegisterWithRegistrar(
      registry->GetRegistrarForPlugin("SodiumLibsPluginCApi"));
  Sqlite3FlutterLibsPluginRegisterWithRegistrar(
      registry->GetRegistrarForPlugin("Sqlite3FlutterLibsPlugin"));
}
