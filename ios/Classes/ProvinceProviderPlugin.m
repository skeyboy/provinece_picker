#import "ProvinceProviderPlugin.h"
#import <province_provider/province_provider-Swift.h>

@implementation ProvinceProviderPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftProvinceProviderPlugin registerWithRegistrar:registrar];
}
@end
