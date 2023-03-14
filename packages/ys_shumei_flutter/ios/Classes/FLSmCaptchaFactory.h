//
//  FLSmCaptchaFactory.h
//  Runner
//
//  Created by Binhua Sun on 2022/9/1.
//

#import <Flutter/Flutter.h>

NS_ASSUME_NONNULL_BEGIN



@interface FLSmCaptchaFactory : NSObject <FlutterPlatformViewFactory>

- (instancetype)initWithMessenger:(NSObject<FlutterBinaryMessenger>*)messenger;

@end

@interface FLSmCaptchaView : NSObject<FlutterPlatformView>

- (instancetype)initWithFrame:(CGRect)frame
               viewIdentifier:(int64_t)viewId
                    arguments:(id _Nullable)args
              binaryMessenger:(NSObject<FlutterBinaryMessenger>*)messenger;

- (UIView*)view;
@end


NS_ASSUME_NONNULL_END
