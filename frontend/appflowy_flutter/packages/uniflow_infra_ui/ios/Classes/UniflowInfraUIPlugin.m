#import "UniflowInfraUIPlugin.h"
#if __has_include(<uniflow_infra_ui/uniflow_infra_ui-Swift.h>)
#import <uniflow_infra_ui/uniflow_infra_ui-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "uniflow_infra_ui-Swift.h"
#endif

@implementation UniflowInfraUIPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftUniflowInfraUIPlugin registerWithRegistrar:registrar];
}
@end
