#import "PitPermissionPlugin.h"
#import <pit_permission/pit_permission-Swift.h>

@implementation PitPermissionPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftPitPermissionPlugin registerWithRegistrar:registrar];
}
@end
