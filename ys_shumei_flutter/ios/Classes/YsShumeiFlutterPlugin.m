#import "YsShumeiFlutterPlugin.h"
#import "FLSmCaptchaFactory.h"

@implementation YsShumeiFlutterPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
    FLSmCaptchaFactory* factory = [[FLSmCaptchaFactory alloc] initWithMessenger:registrar.messenger];
    [registrar registerViewFactory:factory withId:@"sample_view"];
    
}
@end
