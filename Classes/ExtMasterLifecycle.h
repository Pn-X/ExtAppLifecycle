//
//  ExtMasterLifecycle.h
//  ExtAppLifecycle
//
//  Created by hang_pan on 2020/4/30.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ExtMasterLifecycle : NSObject<UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

//json file path, specific before call UIApplicationMain() function,
@property (nonatomic, strong, class) NSURL *filePath;
//specific before call UIApplicationMain() function, if you use configurations, filePath is ignored
@property (nonatomic, strong, class) NSDictionary *configurations;

- (void)application:(UIApplication *)application dispatchEvent:(NSString *)event withParams:(nullable NSDictionary *)params;

@end

NS_ASSUME_NONNULL_END
