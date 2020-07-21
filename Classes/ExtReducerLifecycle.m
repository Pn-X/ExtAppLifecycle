//
//  ExtReducerLifecycle.m
//  ExtAppLifecycle
//
//  Created by hang_pan on 2020/5/8.
//

#import "ExtReducerLifecycle.h"
#import <Intents/Intents.h>

NSString * const ExtReducerLifecycleObjectKey = @"object";
NSString * const ExtReducerLifecycleDataKey = @"data";

@interface ExtReducerLifecycle()

@property (nonatomic, strong, readwrite) NSDictionary *params;

@property (nonatomic, weak, readwrite) ExtMasterLifecycle *masterLifecycle;

@end

@implementation ExtReducerLifecycle

- (instancetype)initWithParams:(NSDictionary *)params masterLifecycle:(ExtMasterLifecycle *)masterLifecycle {
    self = [super init];
    if (self) {
        self.params = params;
        self.masterLifecycle = masterLifecycle;
    }
    return self;
}

- (void)application:(UIApplication *)application handleEvent:(NSString *)event withParams:(nullable NSDictionary *)params {
    
}

- (void)applicationDidFinishLaunching:(UIApplication *)application {
    
}

- (BOOL)application:(UIApplication *)application willFinishLaunchingWithOptions:(nullable NSDictionary<UIApplicationLaunchOptionsKey, id> *)launchOptions dataArray:(NSArray *)dataArray {
    if (dataArray.count >= 1 && [dataArray[0] isKindOfClass:[NSDictionary class]]) {
        NSNumber *value = dataArray[0][ExtReducerLifecycleDataKey];
        if ([value isKindOfClass:[NSNumber class]]) {
            return [value boolValue];
        }
    }
    return YES;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(nullable NSDictionary<UIApplicationLaunchOptionsKey, id> *)launchOptions dataArray:(NSArray *)dataArray {
    if (dataArray.count >= 1 && [dataArray[0] isKindOfClass:[NSDictionary class]]) {
        NSNumber *value = dataArray[0][ExtReducerLifecycleDataKey];
        if ([value isKindOfClass:[NSNumber class]]) {
            return [value boolValue];
        }
    }
    return YES;
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    
}

- (void)applicationWillResignActive:(UIApplication *)application {
    
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url dataArray:(NSArray *)dataArray {
    if (dataArray.count >= 1 && [dataArray[0] isKindOfClass:[NSDictionary class]]) {
        NSNumber *value = dataArray[0][ExtReducerLifecycleDataKey];
        if ([value isKindOfClass:[NSNumber class]]) {
            return [value boolValue];
        }
    }
    return YES;
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(nullable NSString *)sourceApplication annotation:(id)annotation  dataArray:(NSArray *)dataArray {
    if (dataArray.count >= 1 && [dataArray[0] isKindOfClass:[NSDictionary class]]) {
        NSNumber *value = dataArray[0][ExtReducerLifecycleDataKey];
        if ([value isKindOfClass:[NSNumber class]]) {
            return [value boolValue];
        }
    }
    return YES;
}

- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey, id> *)options dataArray:(NSArray *)dataArray {
    if (dataArray.count >= 1 && [dataArray[0] isKindOfClass:[NSDictionary class]]) {
        NSNumber *value = dataArray[0][ExtReducerLifecycleDataKey];
        if ([value isKindOfClass:[NSNumber class]]) {
            return [value boolValue];
        }
    }
    return YES;
}

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
    
}

- (void)applicationWillTerminate:(UIApplication *)application {
    
}

- (void)applicationSignificantTimeChange:(UIApplication *)application {
    
}

- (void)application:(UIApplication *)application willChangeStatusBarOrientation:(UIInterfaceOrientation)newStatusBarOrientation duration:(NSTimeInterval)duration {
    
}

- (void)application:(UIApplication *)application didChangeStatusBarOrientation:(UIInterfaceOrientation)oldStatusBarOrientation {
    
}

- (void)application:(UIApplication *)application willChangeStatusBarFrame:(CGRect)newStatusBarFrame {
    
}

- (void)application:(UIApplication *)application didChangeStatusBarFrame:(CGRect)oldStatusBarFrame {
    
}

- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings {
    
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    
}

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification {
    
}

- (void)application:(UIApplication *)application handleActionWithIdentifier:(nullable NSString *)identifier forLocalNotification:(UILocalNotification *)notification completionHandler:(void (^)(void))completionHandler {
    if (completionHandler) {
        completionHandler();
    }
}

- (void)application:(UIApplication *)application handleActionWithIdentifier:(nullable NSString *)identifier forRemoteNotification:(NSDictionary *)userInfo completionHandler:(void (^)(void))completionHandler {
    if (completionHandler) {
        completionHandler();
    }
}

- (void)application:(UIApplication *)application handleActionWithIdentifier:(nullable NSString *)identifier forLocalNotification:(UILocalNotification *)notification withResponseInfo:(NSDictionary *)responseInfo completionHandler:(void (^)(void))completionHandler {
    if (completionHandler) {
        completionHandler();
    }
}

- (void)application:(UIApplication *)application handleActionWithIdentifier:(nullable NSString *)identifier forRemoteNotification:(NSDictionary *)userInfo withResponseInfo:(NSDictionary *)responseInfo completionHandler:(void (^)(void))completionHandler {
    if (completionHandler) {
        completionHandler();
    }
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult result))completionHandler dataArray:(NSArray *)dataArray {
    UIBackgroundFetchResult result = UIBackgroundFetchResultNewData;
    if (dataArray.count >= 1 && [dataArray[0] isKindOfClass:[NSDictionary class]]) {
        NSNumber *value = dataArray[0][ExtReducerLifecycleDataKey];
        if ([value isKindOfClass:[NSNumber class]]) {
            result = (UIBackgroundFetchResult)[value integerValue];
        }
    }
    if (completionHandler) {
        completionHandler(result);
    }
}

- (void)application:(UIApplication *)application performFetchWithCompletionHandler:(void (^)(UIBackgroundFetchResult result))completionHandler dataArray:(NSArray *)dataArray {
    UIBackgroundFetchResult result = UIBackgroundFetchResultNewData;
    if (dataArray.count >= 1 && [dataArray[0] isKindOfClass:[NSDictionary class]]) {
        NSNumber *value = dataArray[0][ExtReducerLifecycleDataKey];
        if ([value isKindOfClass:[NSNumber class]]) {
            result = (UIBackgroundFetchResult)[value integerValue];
        }
    }
    if (completionHandler) {
        completionHandler(result);
    }
}

- (void)application:(UIApplication *)application performActionForShortcutItem:(UIApplicationShortcutItem *)shortcutItem completionHandler:(void(^)(BOOL succeeded))completionHandler dataArray:(NSArray *)dataArray {
    BOOL result = YES;
    if (dataArray.count >= 1 && [dataArray[0] isKindOfClass:[NSDictionary class]]) {
        NSNumber *value = dataArray[0][ExtReducerLifecycleDataKey];
        if ([value isKindOfClass:[NSNumber class]]) {
            result = [value boolValue];
        }
    }
    if (completionHandler) {
        completionHandler(result);
    }
}

- (void)application:(UIApplication *)application handleEventsForBackgroundURLSession:(NSString *)identifier completionHandler:(void (^)(void))completionHandler {
    if (completionHandler) {
        completionHandler();
    }
}

- (void)application:(UIApplication *)application handleWatchKitExtensionRequest:(nullable NSDictionary *)userInfo reply:(void(^)(NSDictionary * __nullable replyInfo))reply dataArray:(NSArray *)dataArray {
    NSDictionary *result = nil;
    if (dataArray.count >= 1 && [dataArray[0] isKindOfClass:[NSDictionary class]]) {
        NSDictionary *value = dataArray[0][ExtReducerLifecycleDataKey];
        if ([value isKindOfClass:[NSDictionary class]]) {
            result = value;
        }
    }
    if (reply) {
        reply(result);
    }
}

- (void)applicationShouldRequestHealthAuthorization:(UIApplication *)application {
    
}

- (void)application:(UIApplication *)application handleIntent:(INIntent *)intent completionHandler:(void(^)(INIntentResponse *intentResponse))completionHandler dataArray:(NSArray *)dataArray  API_AVAILABLE(ios(10.0)) {
    id result = nil;
    if (@available(iOS 10.0, *)) {
        result = [[INIntentResponse alloc] init];
    }
    if (dataArray.count >= 1 && [dataArray[0] isKindOfClass:[NSDictionary class]]) {
        id value = dataArray[0][ExtReducerLifecycleDataKey];
        Class cls = NSClassFromString(@"INIntentResponse");
        if (cls && [value isKindOfClass:cls]) {
            result = value;
        }
    }
    if (completionHandler) {
        completionHandler(result);
    }
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    
}

- (void)applicationProtectedDataWillBecomeUnavailable:(UIApplication *)application {
    
}

- (void)applicationProtectedDataDidBecomeAvailable:(UIApplication *)application {
    
}

- (UIInterfaceOrientationMask)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(nullable UIWindow *)window dataArray:(NSArray *)dataArray {
    if (dataArray.count >= 1 && [dataArray[0] isKindOfClass:[NSDictionary class]]) {
        NSNumber *value = dataArray[0][ExtReducerLifecycleDataKey];
        if ([value isKindOfClass:[NSNumber class]]) {
            return (UIInterfaceOrientationMask)[value integerValue];
        }
    }
    return UIInterfaceOrientationMaskAll;
}

- (BOOL)application:(UIApplication *)application shouldAllowExtensionPointIdentifier:(UIApplicationExtensionPointIdentifier)extensionPointIdentifier dataArray:(NSArray *)dataArray {
    if (dataArray.count >= 1 && [dataArray[0] isKindOfClass:[NSDictionary class]]) {
        NSNumber *value = dataArray[0][ExtReducerLifecycleDataKey];
        if ([value isKindOfClass:[NSNumber class]]) {
            return [value boolValue];
        }
    }
    return YES;
}

- (nullable UIViewController *)application:(UIApplication *)application viewControllerWithRestorationIdentifierPath:(NSArray<NSString *> *)identifierComponents coder:(NSCoder *)coder dataArray:(NSArray *)dataArray {
    if (dataArray.count >= 1 && [dataArray[0] isKindOfClass:[NSDictionary class]]) {
        UIViewController *value = dataArray[0][ExtReducerLifecycleDataKey];
        if ([value isKindOfClass:[UIViewController class]]) {
            return value;
        }
    }
    return nil;
}

- (BOOL)application:(UIApplication *)application shouldSaveApplicationState:(NSCoder *)coder dataArray:(NSArray *)dataArray {
    if (dataArray.count >= 1 && [dataArray[0] isKindOfClass:[NSDictionary class]]) {
        NSNumber *value = dataArray[0][ExtReducerLifecycleDataKey];
        if ([value isKindOfClass:[NSNumber class]]) {
            return [value boolValue];
        }
    }
    return YES;
}

- (BOOL)application:(UIApplication *)application shouldRestoreApplicationState:(NSCoder *)coder dataArray:(NSArray *)dataArray {
    if (dataArray.count >= 1 && [dataArray[0] isKindOfClass:[NSDictionary class]]) {
        NSNumber *value = dataArray[0][ExtReducerLifecycleDataKey];
        if ([value isKindOfClass:[NSNumber class]]) {
            return [value boolValue];
        }
    }
    return YES;
}

- (void)application:(UIApplication *)application willEncodeRestorableStateWithCoder:(NSCoder *)coder {
    
}

- (void)application:(UIApplication *)application didDecodeRestorableStateWithCoder:(NSCoder *)coder {
    
}

- (BOOL)application:(UIApplication *)application willContinueUserActivityWithType:(NSString *)userActivityType dataArray:(NSArray *)dataArray {
    if (dataArray.count >= 1 && [dataArray[0] isKindOfClass:[NSDictionary class]]) {
        NSNumber *value = dataArray[0][ExtReducerLifecycleDataKey];
        if ([value isKindOfClass:[NSNumber class]]) {
            return [value boolValue];
        }
    }
    return YES;
}


- (BOOL)application:(UIApplication *)application continueUserActivity:(NSUserActivity *)userActivity restorationHandler:(void(^)(NSArray<id<UIUserActivityRestoring>> * __nullable restorableObjects))restorationHandler dataArray:(NSArray *)dataArray {
    if (dataArray.count >= 1 && [dataArray[0] isKindOfClass:[NSDictionary class]]) {
        NSNumber *value = dataArray[0][ExtReducerLifecycleDataKey];
        if ([value isKindOfClass:[NSNumber class]]) {
            return [value boolValue];
        }
    }
    return YES;
}

- (void)application:(UIApplication *)application didFailToContinueUserActivityWithType:(NSString *)userActivityType error:(NSError *)error {
    
}

- (void)application:(UIApplication *)application didUpdateUserActivity:(NSUserActivity *)userActivity {
    
}

- (void)application:(UIApplication *)application userDidAcceptCloudKitShareWithMetadata:(CKShareMetadata *)cloudKitShareMetadata {
    
}

- (UISceneConfiguration *)application:(UIApplication *)application configurationForConnectingSceneSession:(UISceneSession *)connectingSceneSession options:(UISceneConnectionOptions *)options dataArray:(NSArray *)dataArray API_AVAILABLE(ios(13.0)) {
    if (dataArray.count >= 1 && [dataArray[0] isKindOfClass:[NSDictionary class]]) {
        UISceneConfiguration *configuration = dataArray[0][ExtReducerLifecycleDataKey];
        if (configuration) {
            return configuration;
        }
    }
    return [[UISceneConfiguration alloc] initWithName:@"Default Configuration" sessionRole:connectingSceneSession.role];
}

- (void)application:(UIApplication *)application didDiscardSceneSessions:(NSSet<UISceneSession *> *)sceneSessions API_AVAILABLE(ios(13.0)) {
    
}
@end
