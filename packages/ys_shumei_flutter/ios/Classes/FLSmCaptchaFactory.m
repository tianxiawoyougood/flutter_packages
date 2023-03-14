//
//  FLSmCaptchaFactory.m
//  Runner
//
//  Created by Binhua Sun on 2022/9/1.
//

#import "FLSmCaptchaFactory.h"
#import "SmCaptchaWebView.h"

@implementation FLSmCaptchaFactory {
    NSObject<FlutterBinaryMessenger>* _messenger;
    
}

- (instancetype)initWithMessenger:(NSObject<FlutterBinaryMessenger>*)messenger {
    self = [super init];
    if (self) {
        _messenger = messenger;
       
    }
    return self;
}

- (NSObject<FlutterPlatformView>*)createWithFrame:(CGRect)frame
                                   viewIdentifier:(int64_t)viewId
                                        arguments:(id _Nullable)args {
    return [[FLSmCaptchaView alloc] initWithFrame:frame
                                viewIdentifier:viewId
                                     arguments:args
                               binaryMessenger:_messenger];
}

@end

@interface FLSmCaptchaView ()<SmCaptchaProtocol>

@end

@implementation FLSmCaptchaView
{
    SmCaptchaWKWebView *_webview;
    FlutterMethodChannel *_methodChannel;
}

- (instancetype)initWithFrame:(CGRect)frame
               viewIdentifier:(int64_t)viewId
                    arguments:(id _Nullable)args
              binaryMessenger:(NSObject<FlutterBinaryMessenger>*)messenger {
    if (self = [super init]) {
        NSString *channelName = [NSString stringWithFormat:@"shumei_method_channel_%lld", viewId];
        _methodChannel = [FlutterMethodChannel methodChannelWithName:channelName binaryMessenger:messenger];

        
        CGFloat width = frame.size.width;
        CGFloat height = frame.size.height;
        // 构造数美验证码WEBVIEW对象，目前宽高比为3:2
        _webview = [[SmCaptchaWKWebView alloc] init];
        CGRect captchaRect = CGRectMake(0, 0, width, height);
        [_webview setFrame:captchaRect];
        
    }
    return self;
}


- (UIView*)view {
    
    if (!_webview) {
        _webview = [[SmCaptchaWKWebView alloc] init];
    }
    
    __weak FLSmCaptchaView *weakSelf = self;
    [_methodChannel setMethodCallHandler:^(FlutterMethodCall * _Nonnull call, FlutterResult  _Nonnull result) {
        __strong FLSmCaptchaView *strongSelf = weakSelf;
        
        NSString *method = call.method;
        if ([method isEqualToString:@"initSmCaptchaWebView"]) {
            NSDictionary *data = call.arguments;
            
            int borderRadius = [[data objectForKey:@"borderRadius"] intValue];
            double width = [[data objectForKey:@"width"] doubleValue];
            NSString *organization = [data objectForKey:@"organization"];
            NSString *appId = [data objectForKey:@"appId"];
            
            // 初始化验证码WebView
            SmCaptchaOption *caOption = [[SmCaptchaOption alloc] init];
            [caOption setOrganization: organization];   // 必填，组织标识
            [caOption setAppId:appId]; // 必填，应用标识
            [caOption setHttps:YES];
            
            [caOption setMode: SM_MODE_SLIDE];
            [caOption setTipMessage:@"向右滑动滑块填充拼图"];      // 选填，自定义提示文字，仅滑动式支持
            [caOption setChannel:@"AppStore"];                   // 选填，渠道标识
            [caOption setDeviceId:@"xxxxx"];  // 选填，数美反欺诈SDK获取到的设备标识
            
            if (!strongSelf->_webview) {
                strongSelf->_webview = [[SmCaptchaWKWebView alloc] init];
            }
//            [strongSelf->_webview setFrame:CGRectMake(0, 0, width, width / 3.0 * 2.0)];
            // 初始化验证码 WebView
            NSInteger code = [strongSelf->_webview createWithOption: caOption delegate: strongSelf];
            result([NSString stringWithFormat:@"%ld", (long)code]);
        } else if ([method isEqualToString:@"destroySmCaptchaWebView"]) {
            if (strongSelf->_webview) {
                [strongSelf->_webview removeFromSuperview];
                strongSelf->_webview = nil;
            }   else {
                NSLog(@"SmCaptchaWKWebView is nil");
            }
        } else if ([method isEqualToString:@"reload"]) {
            if (strongSelf->_webview) {
                [strongSelf->_webview reloadCaptcha];
            } else {
                NSLog(@"SmCaptchaWKWebView is nil");
            }
            
        }
    }];
    
    return _webview;
}

// 验证码图片加载成功回调函数
- (void) onReady {
    NSLog(@"view onReady");
    [_methodChannel invokeMethod:@"onReady" arguments:@"onReady"];
    
}

// 处理过程出现异常回调函数
- (void) onError:(NSInteger)code {
    NSLog(@"view onError:%ld", (long)code);
    [_methodChannel invokeMethod:@"onError" arguments:@"验证失败，请重试"];
}

// 用户操作结束回调函数，操作验证未通过pass为false，操作验证通过pass为true。
- (void) onSuccess:(NSString *)rid pass:(BOOL)pass {
    NSLog(@"view onSuccess:%@", rid);
    if (pass) {
        [_methodChannel invokeMethod:@"pass" arguments:rid];
    } else {
        [_methodChannel invokeMethod:@"no_pass" arguments:@"验证失败，请重试"];
    }
}

@end


