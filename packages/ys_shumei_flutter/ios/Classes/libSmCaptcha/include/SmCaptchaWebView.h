//
//  SmCaptcha.h
//  SmCaptcha
//
//  Created by weipingshun on 17/6/29.
//  Copyright © 2017年 shumei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <WebKit/WebKit.h>

// 错误码
typedef NS_ENUM(NSUInteger, SmCaptchaCode) {
    SmCaptchaSuccess = 0,
    SMCaptchaSDKOptionEmpty = 1001,  // 调用SDK没有option为空
    SMCaptchaSDKOptionNoOrg,         // 调用SDK没有传入organization
    SMCaptchaSDKOptionNoAppId,       // 调用SDK没有传入appId
    SMCaptchaSDKNoDelegate,
    SMCaptchaWVNetworkError,         // webview加载h5页面失败
    SMCaptchaWVResultError,          // webview接收JS返回的数据格式错误
    
    SmCaptchaJSResourceError = 2001,
    SMCaptchaJSServerError,
    SMCaptchaJSOptionError,
    SmCaptchaJSInitError,
    SMCaptchaJSNetworkError
};

typedef NS_ENUM(NSUInteger, SmCaptchaMode) {
    SM_MODE_SLIDE = 0,
    SM_MODE_SELECT = 1,
    SM_MODE_SEQ_SELECT = 3,
    SM_MODE_ICON_SELECT = 4,
    SM_MODE_SPATIAL_SELECT = 5,
};

// 数美滑动验证码配置类
@interface SmCaptchaOption : NSObject {
}

@property(readwrite) NSString* organization;
@property(readwrite) NSString* appId;
@property(readwrite) NSString* deviceId;
@property(readwrite) NSString* channel;
@property(readwrite) NSString* tipMessage;
@property(readwrite) NSDictionary* data;
@property(readwrite) NSDictionary* extOption;
@property(readwrite) BOOL https;
@property(readwrite) SmCaptchaMode mode;
@property(readwrite) NSString* host;     //conf接口的host
@property(readwrite) NSString* cdnHost;  //index.html资源的host
@property(readwrite) NSString* captchaHtml; //index.html的url
@end


// 数美滑动验证码回调类
@protocol  SmCaptchaProtocol <NSObject>
/**
 * 加载成功回调函数
 */
@required - (void)onReady;

/**
 * 处理成功回调函数
 */
@required - (void)onSuccess:(NSString*) rid pass:(BOOL) pass;

/**
 * 中途出现异常回调函数
 */
@required - (void)onError:(NSInteger) code;

@end


// 数美滑动验证码View类
@interface SmCaptchaWKWebView : WKWebView

// 初始化接口，如果初始化失败，返回error非空
-(NSInteger) createWithOption: (SmCaptchaOption*)option delegate:(id<SmCaptchaProtocol>) delegate;
+(void) initCaptcha;
-(void) reloadCaptcha;

-(void) enableCaptcha;
-(void) disableCaptcha;

@end
