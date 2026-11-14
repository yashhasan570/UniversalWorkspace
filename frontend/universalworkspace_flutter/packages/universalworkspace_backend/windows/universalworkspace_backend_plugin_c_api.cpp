#include "include/universalworkspace_backend/universalworkspace_backend_plugin_c_api.h"

#include <flutter/plugin_registrar_windows.h>

#include "universalworkspace_flutter_backend_plugin.h"

void UniversalWorkspaceBackendPluginCApiRegisterWithRegistrar(
    FlutterDesktopPluginRegistrarRef registrar)
{
    universalworkspace_backend::UniversalWorkspaceBackendPlugin::RegisterWithRegistrar(
        flutter::PluginRegistrarManager::GetInstance()
            ->GetRegistrar<flutter::PluginRegistrarWindows>(registrar));
}
