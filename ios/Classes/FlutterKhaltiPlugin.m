#import "FlutterKhaltiPlugin.h"
#import <flutter_khalti/flutter_khalti-Swift.h>

@implementation FlutterKhaltiPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftFlutterKhaltiPlugin registerWithRegistrar:registrar];
}
@end
