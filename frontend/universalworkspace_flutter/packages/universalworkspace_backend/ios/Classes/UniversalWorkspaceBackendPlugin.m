#import "UniversalWorkspaceBackendPlugin.h"
#if __has_include(<universalworkspace_backend/universalworkspace_backend-Swift.h>)
#import <universalworkspace_backend/universalworkspace_backend-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "universalworkspace_backend-Swift.h"
#endif

@implementation UniversalWorkspaceBackendPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftUniversalWorkspaceBackendPlugin registerWithRegistrar:registrar];
}
@end
