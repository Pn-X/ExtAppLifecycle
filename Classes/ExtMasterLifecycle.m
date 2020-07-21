//
//  ExtMasterLifecycle.m
//  ExtAppLifecycle
//
//  Created by hang_pan on 2020/4/30.
//

#import "ExtMasterLifecycle.h"
#import "ExtSlaveLifecycle.h"
#import "ExtReducerLifecycle.h"
#import <objc/runtime.h>

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
#pragma clang diagnostic ignored "-Wdeprecated-implementations"

#define METHOD_NAME_LENGTH 1024
#define STUB_PREFIX  "stub_"

static NSURL *ExtMasterLifecycleConfigurationFileUrl;
static NSDictionary *ExtMasterLifecycleConfigurations;

@interface ExtMasterLifecycle()

@property (nonatomic, strong) NSMutableArray *slaveArray;
@property (nonatomic, strong) ExtReducerLifecycle *reducer;

@end

@implementation ExtMasterLifecycle

- (instancetype)init {
    self = [super init];
    if (self) {
        self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
        self.window.backgroundColor = [UIColor yellowColor];
        self.slaveArray = [@[] mutableCopy];
        [self loadLifecycles];
    }
    return self;
}

- (void)loadLifecycles {
    NSDictionary *dict = ExtMasterLifecycleConfigurations;
    if (dict == nil) {
        NSData *data = [NSData dataWithContentsOfURL:ExtMasterLifecycle.filePath];
        dict = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    }
    assert(dict != nil);
    NSDictionary *core = dict[@"core"]?:@{};
    Class coreCls = NSClassFromString(core[@"name"]?:@"");
    if ([coreCls isSubclassOfClass:[ExtSlaveLifecycle class]]) {
        id obj = [[coreCls alloc] initWithParams:core[@"params"] masterLifecycle:self];
        [self.slaveArray addObject:obj];
    }
    NSArray *slaves = dict[@"slaves"];
    for (NSDictionary *dic in slaves) {
        NSString *className = dic[@"name"]?:@"";
        Class cls = NSClassFromString(className);
        if ([cls isSubclassOfClass:[ExtSlaveLifecycle class]]) {
            id obj = [[cls alloc] initWithParams:dic[@"params"] masterLifecycle:self];
            [self.slaveArray addObject:obj];
        }
    }
    [self dynamicAddMethodWithArray:self.slaveArray];
    NSDictionary *reducer = dict[@"reducer"]?:@{};
    Class reducerCls = NSClassFromString(reducer[@"name"]?:@"");
    if ([reducerCls isSubclassOfClass:[ExtReducerLifecycle class]]) {
        self.reducer = [[reducerCls alloc] initWithParams:reducer[@"params"] masterLifecycle:self];
    } else {
        self.reducer = [ExtReducerLifecycle new];
    }
}

+ (NSURL *)filePath {
    return ExtMasterLifecycleConfigurationFileUrl;
}

+ (void)setFilePath:(NSURL *)filePath {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        ExtMasterLifecycleConfigurationFileUrl = filePath;
    });
}

+ (NSDictionary *)configurations {
    return ExtMasterLifecycleConfigurations;
}

+ (void)setConfigurations:(NSDictionary *)configurations {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        ExtMasterLifecycleConfigurations = configurations;
    });
}

- (void)dynamicAddMethodWithArray:(NSArray *)array {
    unsigned int methodCount = 0;
    struct objc_method_description *methodList = protocol_copyMethodDescriptionList(@protocol(UIApplicationDelegate), NO, YES, &methodCount);
    for (int i = 0; i < methodCount; i++) {
        struct objc_method_description methodDescription = methodList[i];
        char stubName[METHOD_NAME_LENGTH] = STUB_PREFIX;
        strlcat(stubName, sel_getName(methodDescription.name), METHOD_NAME_LENGTH);
        SEL stubSelector = sel_registerName(stubName);
        Method aMethod = class_getInstanceMethod([ExtMasterLifecycle class], stubSelector);
        if (aMethod == NULL) {
            continue;
        }
        for (ExtSlaveLifecycle *lifecycle in array) {
            if ([lifecycle respondsToSelector:methodDescription.name]) {
                struct objc_method_description *description = method_getDescription(aMethod);
                class_addMethod([ExtMasterLifecycle class], methodDescription.name, method_getImplementation(aMethod), description->types);
                break;
            }
        }
    }
}

#pragma mark - public method

- (void)application:(UIApplication *)application dispatchEvent:(NSString *)event withParams:(nullable NSDictionary *)params {
    for (ExtSlaveLifecycle *slave in self.slaveArray) {
        [slave application:application handleEvent:event withParams:params];
    }
    [self.reducer application:application handleEvent:event withParams:params];
}

#pragma mark - UIApplicationDelegate

- (void)stub_applicationDidFinishLaunching:(UIApplication *)application {
    for (ExtSlaveLifecycle *slave in self.slaveArray) {
        if (slave.response.applicationDidFinishLaunching) {
            [slave applicationDidFinishLaunching:application];
        }
    }
    [self.reducer applicationDidFinishLaunching:application];
}

- (BOOL)stub_application:(UIApplication *)application willFinishLaunchingWithOptions:(nullable NSDictionary<UIApplicationLaunchOptionsKey, id> *)launchOptions {
    NSMutableArray *resultArray = [NSMutableArray array];
    for (ExtSlaveLifecycle *slave in self.slaveArray) {
        if (slave.response.application_willFinishLaunchingWithOptions) {
            BOOL result = [slave application:application willFinishLaunchingWithOptions:launchOptions];
            [resultArray addObject:@{
                ExtReducerLifecycleObjectKey:slave,
                ExtReducerLifecycleDataKey:@(result)
            }];
        }
    }
    return [self.reducer application:application willFinishLaunchingWithOptions:launchOptions dataArray:resultArray];
}

- (BOOL)stub_application:(UIApplication *)application didFinishLaunchingWithOptions:(nullable NSDictionary<UIApplicationLaunchOptionsKey, id> *)launchOptions {
    NSMutableArray *resultArray = [NSMutableArray array];
    for (ExtSlaveLifecycle *slave in self.slaveArray) {
        if (slave.response.application_didFinishLaunchingWithOptions) {
            BOOL result = [slave application:application didFinishLaunchingWithOptions:launchOptions];
            [resultArray addObject:@{
                ExtReducerLifecycleObjectKey:slave,
                ExtReducerLifecycleDataKey:@(result)
            }];
        }
    }
    return [self.reducer application:application didFinishLaunchingWithOptions:launchOptions dataArray:resultArray];
}

- (void)stub_applicationDidBecomeActive:(UIApplication *)application {
    for (ExtSlaveLifecycle *slave in self.slaveArray) {
        if (slave.response.applicationDidBecomeActive) {
            [slave applicationDidBecomeActive:application];
        }
    }
    [self.reducer applicationDidBecomeActive:application];
}

- (void)stub_applicationWillResignActive:(UIApplication *)application {
    for (ExtSlaveLifecycle *slave in self.slaveArray) {
        if (slave.response.applicationWillResignActive) {
            [slave applicationWillResignActive:application];
        }
    }
    [self.reducer applicationWillResignActive:application];
}

- (BOOL)stub_application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    NSMutableArray *resultArray = [NSMutableArray array];
    for (ExtSlaveLifecycle *slave in self.slaveArray) {
        if (slave.response.application_handleOpenURL) {
            BOOL result = [slave application:application handleOpenURL:url];
            [resultArray addObject:@{
                ExtReducerLifecycleObjectKey:slave,
                ExtReducerLifecycleDataKey:@(result)
            }];
        }
    }
    return [self.reducer application:application handleOpenURL:url dataArray:resultArray];
}

- (BOOL)stub_application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(nullable NSString *)sourceApplication annotation:(id)annotation {
    NSMutableArray *resultArray = [NSMutableArray array];
    for (ExtSlaveLifecycle *slave in self.slaveArray) {
        if (slave.response.application_openURL_sourceApplication_annotation) {
            BOOL result = [slave application:application openURL:url sourceApplication:sourceApplication annotation:annotation];
            [resultArray addObject:@{
                ExtReducerLifecycleObjectKey:slave,
                ExtReducerLifecycleDataKey:@(result)
            }];
        }
    }
    return [self.reducer application:application openURL:url sourceApplication:sourceApplication annotation:annotation dataArray:resultArray];
}

- (BOOL)stub_application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey, id> *)options {
    NSMutableArray *resultArray = [NSMutableArray array];
    for (ExtSlaveLifecycle *slave in self.slaveArray) {
        if (slave.response.application_openURL_options) {
            BOOL result = [slave application:app openURL:url options:options];
            [resultArray addObject:@{
                ExtReducerLifecycleObjectKey:slave,
                ExtReducerLifecycleDataKey:@(result)
            }];
        }
    }
    return [self.reducer application:app openURL:url options:options dataArray:resultArray];
}

- (void)stub_applicationDidReceiveMemoryWarning:(UIApplication *)application {
    for (ExtSlaveLifecycle *slave in self.slaveArray) {
        if (slave.response.applicationDidReceiveMemoryWarning) {
            [slave applicationDidReceiveMemoryWarning:application];
        }
    }
    [self.reducer applicationDidReceiveMemoryWarning:application];
}

- (void)stub_applicationWillTerminate:(UIApplication *)application {
    for (ExtSlaveLifecycle *slave in self.slaveArray) {
        if (slave.response.applicationWillTerminate) {
            [slave applicationWillTerminate:application];
        }
    }
    [self.reducer applicationWillTerminate:application];
}

- (void)stub_applicationSignificantTimeChange:(UIApplication *)application {
    for (ExtSlaveLifecycle *slave in self.slaveArray) {
        if (slave.response.applicationSignificantTimeChange) {
            [slave applicationSignificantTimeChange:application];
        }
    }
    [self.reducer applicationSignificantTimeChange:application];
}

- (void)stub_application:(UIApplication *)application willChangeStatusBarOrientation:(UIInterfaceOrientation)newStatusBarOrientation duration:(NSTimeInterval)duration {
    for (ExtSlaveLifecycle *slave in self.slaveArray) {
        if (slave.response.application_willChangeStatusBarOrientation_duration) {
            [slave application:application willChangeStatusBarOrientation:newStatusBarOrientation duration:duration];
        }
    }
    [self.reducer application:application willChangeStatusBarOrientation:newStatusBarOrientation duration:duration];
}

- (void)stub_application:(UIApplication *)application didChangeStatusBarOrientation:(UIInterfaceOrientation)oldStatusBarOrientation {
    for (ExtSlaveLifecycle *slave in self.slaveArray) {
        if (slave.response.application_didChangeStatusBarOrientation) {
            [slave application:application didChangeStatusBarOrientation:oldStatusBarOrientation];
        }
    }
    [self.reducer application:application didChangeStatusBarOrientation:oldStatusBarOrientation];
}

- (void)stub_application:(UIApplication *)application willChangeStatusBarFrame:(CGRect)newStatusBarFrame {
    for (ExtSlaveLifecycle *slave in self.slaveArray) {
        if (slave.response.application_willChangeStatusBarFrame) {
            [slave application:application willChangeStatusBarFrame:newStatusBarFrame];
        }
    }
    [self.reducer application:application willChangeStatusBarFrame:newStatusBarFrame];
}

- (void)stub_application:(UIApplication *)application didChangeStatusBarFrame:(CGRect)oldStatusBarFrame {
    for (ExtSlaveLifecycle *slave in self.slaveArray) {
        if (slave.response.application_didChangeStatusBarFrame) {
            [slave application:application didChangeStatusBarFrame:oldStatusBarFrame];
        }
    }
    [self.reducer application:application didChangeStatusBarFrame:oldStatusBarFrame];
}

- (void)stub_application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings {
    for (ExtSlaveLifecycle *slave in self.slaveArray) {
        if (slave.response.application_didRegisterUserNotificationSettings) {
            [slave application:application didRegisterUserNotificationSettings:notificationSettings];
        }
    }
    [self.reducer application:application didRegisterUserNotificationSettings:notificationSettings];
}

- (void)stub_application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    for (ExtSlaveLifecycle *slave in self.slaveArray) {
        if (slave.response.application_didRegisterForRemoteNotificationsWithDeviceToken) {
            [slave application:application didRegisterForRemoteNotificationsWithDeviceToken:deviceToken];
        }
    }
    [self.reducer application:application didRegisterForRemoteNotificationsWithDeviceToken:deviceToken];
}

- (void)stub_application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    for (ExtSlaveLifecycle *slave in self.slaveArray) {
        if (slave.response.application_didFailToRegisterForRemoteNotificationsWithError) {
            [slave application:application didFailToRegisterForRemoteNotificationsWithError:error];
        }
    }
    [self.reducer application:application didFailToRegisterForRemoteNotificationsWithError:error];
}

- (void)stub_application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    for (ExtSlaveLifecycle *slave in self.slaveArray) {
        if (slave.response.application_didReceiveRemoteNotification) {
            [slave application:application didReceiveRemoteNotification:userInfo];
        }
    }
    [self.reducer application:application didReceiveRemoteNotification:userInfo];
}

- (void)stub_application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification {
    for (ExtSlaveLifecycle *slave in self.slaveArray) {
        if (slave.response.application_didReceiveLocalNotification) {
            [slave application:application didReceiveLocalNotification:notification];
        }
    }
    [self.reducer application:application didReceiveLocalNotification:notification];
}

- (void)stub_application:(UIApplication *)application handleActionWithIdentifier:(nullable NSString *)identifier forLocalNotification:(UILocalNotification *)notification completionHandler:(void (^)(void))completionHandler {
    
    __block NSInteger totalResponserCount = 0;
    __block NSInteger currentCount = 0;
    for (ExtSlaveLifecycle *slave in self.slaveArray) {
        if (slave.response.application_handleActionWithIdentifier_forLocalNotification_completionHandler) {
            totalResponserCount++;
        }
    }
    if (totalResponserCount == 0) {
        [self.reducer application:application handleActionWithIdentifier:identifier forLocalNotification:notification completionHandler:completionHandler];
        return;
    }
    __weak typeof(self) weakSelf = self;
    dispatch_block_t handler = ^{
        currentCount++;
        if (currentCount == totalResponserCount) {
            [weakSelf.reducer application:application handleActionWithIdentifier:identifier forLocalNotification:notification completionHandler:completionHandler];
        }
    };
    for (ExtSlaveLifecycle *slave in self.slaveArray) {
        if (slave.response.application_handleActionWithIdentifier_forLocalNotification_completionHandler) {
            [slave application:application handleActionWithIdentifier:identifier forLocalNotification:notification completionHandler:handler];
        }
    }
}

- (void)stub_application:(UIApplication *)application handleActionWithIdentifier:(nullable NSString *)identifier forRemoteNotification:(NSDictionary *)userInfo completionHandler:(void (^)(void))completionHandler {
    __block NSInteger totalResponserCount = 0;
    __block NSInteger currentCount = 0;
    for (ExtSlaveLifecycle *slave in self.slaveArray) {
        if (slave.response.application_handleActionWithIdentifier_forRemoteNotification_completionHandler) {
            totalResponserCount++;
        }
    }
    if (totalResponserCount == 0) {
        [self.reducer application:application handleActionWithIdentifier:identifier forRemoteNotification:userInfo completionHandler:completionHandler];
        return;
    }
    __weak typeof(self) weakSelf = self;
    dispatch_block_t handler = ^{
        currentCount++;
        if (currentCount == totalResponserCount) {
            [weakSelf.reducer application:application handleActionWithIdentifier:identifier forRemoteNotification:userInfo completionHandler:completionHandler];
        }
    };
    for (ExtSlaveLifecycle *slave in self.slaveArray) {
        if (slave.response.application_handleActionWithIdentifier_forRemoteNotification_completionHandler) {
            [slave application:application handleActionWithIdentifier:identifier forRemoteNotification:userInfo  completionHandler:handler];
        }
    }
}

- (void)stub_application:(UIApplication *)application handleActionWithIdentifier:(nullable NSString *)identifier forLocalNotification:(UILocalNotification *)notification withResponseInfo:(NSDictionary *)responseInfo completionHandler:(void (^)(void))completionHandler {
    __block NSInteger totalResponserCount = 0;
    __block NSInteger currentCount = 0;
    for (ExtSlaveLifecycle *slave in self.slaveArray) {
        if (slave.response.application_handleActionWithIdentifier_forLocalNotification_withResponseInfo_completionHandler) {
            totalResponserCount++;
        }
    }
    if (totalResponserCount == 0) {
        [self.reducer application:application handleActionWithIdentifier:identifier forLocalNotification:notification withResponseInfo:responseInfo completionHandler:completionHandler];
        return;
    }
    __weak typeof(self) weakSelf = self;
    dispatch_block_t handler = ^{
        currentCount++;
        if (currentCount == totalResponserCount) {
            [weakSelf.reducer application:application handleActionWithIdentifier:identifier forLocalNotification:notification withResponseInfo:responseInfo completionHandler:completionHandler];
        }
    };
    for (ExtSlaveLifecycle *slave in self.slaveArray) {
        if (slave.response.application_handleActionWithIdentifier_forLocalNotification_withResponseInfo_completionHandler) {
            [slave application:application handleActionWithIdentifier:identifier forLocalNotification:notification withResponseInfo:responseInfo completionHandler:handler];
        }
    }
}

- (void)stub_application:(UIApplication *)application handleActionWithIdentifier:(nullable NSString *)identifier forRemoteNotification:(NSDictionary *)userInfo withResponseInfo:(NSDictionary *)responseInfo completionHandler:(void (^)(void))completionHandler {
    __block NSInteger totalResponserCount = 0;
    __block NSInteger currentCount = 0;
    for (ExtSlaveLifecycle *slave in self.slaveArray) {
        if (slave.response.application_handleActionWithIdentifier_forRemoteNotification_withResponseInfo_completionHandler) {
            totalResponserCount++;
        }
    }
    if (totalResponserCount == 0) {
        [self.reducer application:application handleActionWithIdentifier:identifier forRemoteNotification:userInfo withResponseInfo:responseInfo completionHandler:completionHandler];
        return;
    }
    __weak typeof(self) weakSelf = self;
    dispatch_block_t handler = ^{
        currentCount++;
        if (currentCount == totalResponserCount) {
            [weakSelf.reducer application:application handleActionWithIdentifier:identifier forRemoteNotification:userInfo withResponseInfo:responseInfo completionHandler:completionHandler];
        }
    };
    for (ExtSlaveLifecycle *slave in self.slaveArray) {
        if (slave.response.application_handleActionWithIdentifier_forRemoteNotification_withResponseInfo_completionHandler) {
            [slave application:application handleActionWithIdentifier:identifier forRemoteNotification:userInfo withResponseInfo:responseInfo completionHandler:handler];
        }
    }
}

- (void)stub_application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult result))completionHandler {
    __block NSInteger totalResponserCount = 0;
    __block NSInteger currentCount = 0;
    NSMutableArray *resultArray = [NSMutableArray array];
    for (ExtSlaveLifecycle *slave in self.slaveArray) {
        if (slave.response.application_didReceiveRemoteNotification_fetchCompletionHandler) {
            totalResponserCount++;
        }
    }
    if (totalResponserCount == 0) {
        [self.reducer application:application didReceiveRemoteNotification:userInfo fetchCompletionHandler:completionHandler dataArray:resultArray];
        return;
    }
    for (ExtSlaveLifecycle *slave in self.slaveArray) {
        if (slave.response.application_didReceiveRemoteNotification_fetchCompletionHandler) {
            [resultArray addObject:[@{ExtReducerLifecycleObjectKey:slave} mutableCopy]];
            __weak typeof(slave) weakSlave = slave;
            __weak typeof(self) weakSelf = self;
            void(^handler)(UIBackgroundFetchResult result) = ^(UIBackgroundFetchResult result){
                for (NSMutableDictionary *dic in resultArray) {
                    if ([dic objectForKey:ExtReducerLifecycleObjectKey] == weakSlave) {
                        [dic setObject:@(result) forKey:ExtReducerLifecycleDataKey];
                    }
                }
                currentCount++;
                if (currentCount == totalResponserCount) {
                    [weakSelf.reducer application:application didReceiveRemoteNotification:userInfo fetchCompletionHandler:completionHandler dataArray:resultArray];
                }
            };
            [slave application:application didReceiveRemoteNotification:userInfo fetchCompletionHandler:handler];
        }
    }
}

- (void)stub_application:(UIApplication *)application performFetchWithCompletionHandler:(void (^)(UIBackgroundFetchResult result))completionHandler {
    __block NSInteger totalResponserCount = 0;
    __block NSInteger currentCount = 0;
    NSMutableArray *resultArray = [NSMutableArray array];
    for (ExtSlaveLifecycle *slave in self.slaveArray) {
        if (slave.response.application_performFetchWithCompletionHandler) {
            totalResponserCount++;
        }
    }
    if (totalResponserCount == 0) {
        [self.reducer application:application performFetchWithCompletionHandler:completionHandler dataArray:resultArray];
        return;
    }
    for (ExtSlaveLifecycle *slave in self.slaveArray) {
        if (slave.response.application_performFetchWithCompletionHandler) {
            [resultArray addObject:[@{ExtReducerLifecycleObjectKey:slave} mutableCopy]];
            __weak typeof(slave) weakSlave = slave;
            __weak typeof(self) weakSelf = self;
            void(^handler)(UIBackgroundFetchResult result) = ^(UIBackgroundFetchResult result){
                for (NSMutableDictionary *dic in resultArray) {
                    if ([dic objectForKey:ExtReducerLifecycleObjectKey] == weakSlave) {
                        [dic setObject:@(result) forKey:ExtReducerLifecycleDataKey];
                    }
                }
                currentCount++;
                if (currentCount == totalResponserCount) {
                    [weakSelf.reducer application:application performFetchWithCompletionHandler:completionHandler dataArray:resultArray];
                }
            };
            [slave application:application performFetchWithCompletionHandler:handler];
        }
    }
}

- (void)stub_application:(UIApplication *)application performActionForShortcutItem:(UIApplicationShortcutItem *)shortcutItem completionHandler:(void(^)(BOOL succeeded))completionHandler {
    __block NSInteger totalResponserCount = 0;
    __block NSInteger currentCount = 0;
    NSMutableArray *resultArray = [NSMutableArray array];
    for (ExtSlaveLifecycle *slave in self.slaveArray) {
        if (slave.response.application_performActionForShortcutItem_completionHandler) {
            totalResponserCount++;
        }
    }
    if (totalResponserCount == 0) {
        [self.reducer application:application performActionForShortcutItem:shortcutItem completionHandler:completionHandler dataArray:resultArray];
        return;
    }
    for (ExtSlaveLifecycle *slave in self.slaveArray) {
        if (slave.response.application_performActionForShortcutItem_completionHandler) {
            [resultArray addObject:[@{ExtReducerLifecycleObjectKey:slave} mutableCopy]];
            __weak typeof(slave) weakSlave = slave;
            __weak typeof(self) weakSelf = self;
            void(^handler)(BOOL succeeded) = ^(BOOL succeeded){
                for (NSMutableDictionary *dic in resultArray) {
                    if ([dic objectForKey:ExtReducerLifecycleObjectKey] == weakSlave) {
                        [dic setObject:@(succeeded) forKey:ExtReducerLifecycleDataKey];
                    }
                }
                currentCount++;
                if (currentCount == totalResponserCount) {
                    [weakSelf.reducer application:application performActionForShortcutItem:shortcutItem completionHandler:completionHandler dataArray:resultArray];
                }
            };
            [slave application:application performActionForShortcutItem:shortcutItem completionHandler:handler];
        }
    }
}

- (void)stub_application:(UIApplication *)application handleEventsForBackgroundURLSession:(NSString *)identifier completionHandler:(void (^)(void))completionHandler {
    __block NSInteger totalResponserCount = 0;
    __block NSInteger currentCount = 0;
    for (ExtSlaveLifecycle *slave in self.slaveArray) {
        if (slave.response.application_handleEventsForBackgroundURLSession_completionHandler) {
            totalResponserCount++;
        }
    }
    if (totalResponserCount == 0) {
        [self.reducer application:application handleEventsForBackgroundURLSession:identifier completionHandler:completionHandler];
        return;
    }
    __weak typeof(self) weakSelf = self;
    dispatch_block_t handler = ^{
        currentCount++;
        if (currentCount == totalResponserCount) {
            [weakSelf.reducer application:application handleEventsForBackgroundURLSession:identifier completionHandler:completionHandler];
        }
    };
    for (ExtSlaveLifecycle *slave in self.slaveArray) {
        if (slave.response.application_handleEventsForBackgroundURLSession_completionHandler) {
            [slave application:application handleEventsForBackgroundURLSession:identifier completionHandler:handler];
        }
    }
}

- (void)stub_application:(UIApplication *)application handleWatchKitExtensionRequest:(nullable NSDictionary *)userInfo reply:(void(^)(NSDictionary * __nullable replyInfo))reply {
    __block NSInteger totalResponserCount = 0;
    __block NSInteger currentCount = 0;
    NSMutableArray *resultArray = [NSMutableArray array];
    for (ExtSlaveLifecycle *slave in self.slaveArray) {
        if (slave.response.application_handleWatchKitExtensionRequest_reply) {
            totalResponserCount++;
        }
    }
    if (totalResponserCount == 0) {
        [self.reducer application:application handleWatchKitExtensionRequest:userInfo reply:reply dataArray:resultArray];
        return;
    }
    for (ExtSlaveLifecycle *slave in self.slaveArray) {
        if (slave.response.application_handleWatchKitExtensionRequest_reply) {
            [resultArray addObject:[@{ExtReducerLifecycleObjectKey:slave} mutableCopy]];
            __weak typeof(slave) weakSlave = slave;
            __weak typeof(self) weakSelf = self;
            void(^handler)(NSDictionary *replyInfo) = ^(NSDictionary *replyInfo){
                for (NSMutableDictionary *dic in resultArray) {
                    if ([dic objectForKey:ExtReducerLifecycleObjectKey] == weakSlave && replyInfo) {
                        [dic setObject:replyInfo forKey:ExtReducerLifecycleDataKey];
                    }
                }
                currentCount++;
                if (currentCount == totalResponserCount) {
                    [weakSelf.reducer application:application handleWatchKitExtensionRequest:userInfo reply:reply dataArray:resultArray];
                }
            };
            [slave application:application handleWatchKitExtensionRequest:userInfo reply:handler];
        }
    }
}

- (void)stub_applicationShouldRequestHealthAuthorization:(UIApplication *)application {
    for (ExtSlaveLifecycle *slave in self.slaveArray) {
        if (slave.response.applicationShouldRequestHealthAuthorization) {
            [slave applicationShouldRequestHealthAuthorization:application];
        }
    }
    [self.reducer applicationShouldRequestHealthAuthorization:application];
}

- (void)stub_application:(UIApplication *)application handleIntent:(INIntent *)intent completionHandler:(void(^)(INIntentResponse *intentResponse))completionHandler {
    __block NSInteger totalResponserCount = 0;
    __block NSInteger currentCount = 0;
    NSMutableArray *resultArray = [NSMutableArray array];
    for (ExtSlaveLifecycle *slave in self.slaveArray) {
        if (slave.response.application_handleIntent_completionHandler) {
            totalResponserCount++;
        }
    }
    if (totalResponserCount == 0) {
        [self.reducer application:application handleIntent:intent completionHandler:completionHandler dataArray:resultArray];
        return;
    }
    for (ExtSlaveLifecycle *slave in self.slaveArray) {
        if (slave.response.application_handleIntent_completionHandler) {
            [resultArray addObject:[@{ExtReducerLifecycleObjectKey:slave} mutableCopy]];
            __weak typeof(slave) weakSlave = slave;
            __weak typeof(self) weakSelf = self;
            void(^handler)(INIntentResponse *intentResponse) = ^(INIntentResponse *intentResponse){
                for (NSMutableDictionary *dic in resultArray) {
                    if ([dic objectForKey:ExtReducerLifecycleObjectKey] == weakSlave && intentResponse) {
                        [dic setObject:intentResponse forKey:ExtReducerLifecycleDataKey];
                    }
                }
                currentCount++;
                if (currentCount == totalResponserCount) {
                    [weakSelf.reducer application:application handleIntent:intent completionHandler:completionHandler dataArray:resultArray];
                }
            };
            if (@available(iOS 11.0, *)) {
                [slave application:application handleIntent:intent completionHandler:handler];
            }
        }
    }
}

- (void)stub_applicationDidEnterBackground:(UIApplication *)application {
    for (ExtSlaveLifecycle *slave in self.slaveArray) {
        if (slave.response.applicationDidEnterBackground) {
            [slave applicationDidEnterBackground:application];
        }
    }
    [self.reducer applicationDidEnterBackground:application];
}

- (void)stub_applicationWillEnterForeground:(UIApplication *)application {
    for (ExtSlaveLifecycle *slave in self.slaveArray) {
        if (slave.response.applicationWillEnterForeground) {
            [slave applicationWillEnterForeground:application];
        }
    }
    [self.reducer applicationWillEnterForeground:application];
}

- (void)stub_applicationProtectedDataWillBecomeUnavailable:(UIApplication *)application {
    for (ExtSlaveLifecycle *slave in self.slaveArray) {
        if (slave.response.applicationProtectedDataWillBecomeUnavailable) {
            [slave applicationProtectedDataWillBecomeUnavailable:application];
        }
    }
    [self.reducer applicationProtectedDataWillBecomeUnavailable:application];
}

- (void)stub_applicationProtectedDataDidBecomeAvailable:(UIApplication *)application {
    for (ExtSlaveLifecycle *slave in self.slaveArray) {
        if (slave.response.applicationProtectedDataDidBecomeAvailable) {
            [slave applicationProtectedDataDidBecomeAvailable:application];
        }
    }
    [self.reducer applicationProtectedDataDidBecomeAvailable:application];
}

- (UIInterfaceOrientationMask)stub_application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(nullable UIWindow *)window {
    NSMutableArray *resultArray = [NSMutableArray array];
    for (ExtSlaveLifecycle *slave in self.slaveArray) {
        if (slave.response.application_supportedInterfaceOrientationsForWindow) {
            UIInterfaceOrientationMask result = [slave application:application supportedInterfaceOrientationsForWindow:window];
            [resultArray addObject:@{
                ExtReducerLifecycleObjectKey:slave,
                ExtReducerLifecycleDataKey:@(result)
            }];
        }
    }
    return [self.reducer application:application supportedInterfaceOrientationsForWindow:window dataArray:resultArray];
}

- (BOOL)stub_application:(UIApplication *)application shouldAllowExtensionPointIdentifier:(UIApplicationExtensionPointIdentifier)extensionPointIdentifier {
    NSMutableArray *resultArray = [NSMutableArray array];
    for (ExtSlaveLifecycle *slave in self.slaveArray) {
        if (slave.response.application_shouldAllowExtensionPointIdentifier) {
            BOOL result = [slave application:application shouldAllowExtensionPointIdentifier:extensionPointIdentifier];
            [resultArray addObject:@{
                ExtReducerLifecycleObjectKey:slave,
                ExtReducerLifecycleDataKey:@(result)
            }];
        }
    }
    return [self.reducer application:application shouldAllowExtensionPointIdentifier:extensionPointIdentifier dataArray:resultArray];
}

- (nullable UIViewController *)stub_application:(UIApplication *)application viewControllerWithRestorationIdentifierPath:(NSArray<NSString *> *)identifierComponents coder:(NSCoder *)coder {
    NSMutableArray *resultArray = [NSMutableArray array];
    for (ExtSlaveLifecycle *slave in self.slaveArray) {
        if (slave.response.application_viewControllerWithRestorationIdentifierPath_coder) {
            UIViewController *result = [slave application:application viewControllerWithRestorationIdentifierPath:identifierComponents coder:coder];
            NSMutableDictionary *dic = [NSMutableDictionary dictionary];
            [dic setObject:slave forKey:ExtReducerLifecycleObjectKey];
            if (result) {
                [dic setObject:result forKey:ExtReducerLifecycleObjectKey];
            }
            [resultArray addObject:dic];
        }
    }
    return [self.reducer application:application viewControllerWithRestorationIdentifierPath:identifierComponents coder:coder dataArray:resultArray];
}

- (BOOL)stub_application:(UIApplication *)application shouldSaveApplicationState:(NSCoder *)coder {
    NSMutableArray *resultArray = [NSMutableArray array];
    for (ExtSlaveLifecycle *slave in self.slaveArray) {
        if (slave.response.application_shouldSaveApplicationState) {
            BOOL result = [slave application:application shouldSaveApplicationState:coder];
            [resultArray addObject:@{
                ExtReducerLifecycleObjectKey:slave,
                ExtReducerLifecycleDataKey:@(result)
            }];
        }
    }
    return [self.reducer application:application shouldSaveApplicationState:coder dataArray:resultArray];
}

- (BOOL)stub_application:(UIApplication *)application shouldRestoreApplicationState:(NSCoder *)coder {
    NSMutableArray *resultArray = [NSMutableArray array];
    for (ExtSlaveLifecycle *slave in self.slaveArray) {
        if (slave.response.application_shouldRestoreApplicationState) {
            BOOL result = [slave application:application shouldRestoreApplicationState:coder];
            [resultArray addObject:@{
                ExtReducerLifecycleObjectKey:slave,
                ExtReducerLifecycleDataKey:@(result)
            }];
        }
    }
    return [self.reducer application:application shouldRestoreApplicationState:coder dataArray:resultArray];
}

- (void)stub_application:(UIApplication *)application willEncodeRestorableStateWithCoder:(NSCoder *)coder {
    for (ExtSlaveLifecycle *slave in self.slaveArray) {
        if (slave.response.application_willEncodeRestorableStateWithCoder) {
            [slave application:application willEncodeRestorableStateWithCoder:coder];
        }
    }
    [self.reducer application:application willEncodeRestorableStateWithCoder:coder];
}

- (void)stub_application:(UIApplication *)application didDecodeRestorableStateWithCoder:(NSCoder *)coder {
    for (ExtSlaveLifecycle *slave in self.slaveArray) {
        if (slave.response.application_didDecodeRestorableStateWithCoder) {
            [slave application:application didDecodeRestorableStateWithCoder:coder];
        }
    }
    [self.reducer application:application didDecodeRestorableStateWithCoder:coder];
}

- (BOOL)stub_application:(UIApplication *)application willContinueUserActivityWithType:(NSString *)userActivityType {
    NSMutableArray *resultArray = [NSMutableArray array];
    for (ExtSlaveLifecycle *slave in self.slaveArray) {
        if (slave.response.application_willContinueUserActivityWithType) {
            BOOL result = [slave application:application willContinueUserActivityWithType:userActivityType];
            [resultArray addObject:@{
                ExtReducerLifecycleObjectKey:slave,
                ExtReducerLifecycleDataKey:@(result)
            }];
        }
    }
    return [self.reducer application:application willContinueUserActivityWithType:userActivityType dataArray:resultArray];
}

- (BOOL)stub_application:(UIApplication *)application continueUserActivity:(NSUserActivity *)userActivity restorationHandler:(void(^)(NSArray<id<UIUserActivityRestoring>> * __nullable restorableObjects))restorationHandler {
    NSMutableArray *resultArray = [NSMutableArray array];
    for (ExtSlaveLifecycle *slave in self.slaveArray) {
        if (slave.response.application_continueUserActivity_restorationHandler) {
            BOOL result = [slave application:application continueUserActivity:userActivity restorationHandler:restorationHandler];
            [resultArray addObject:@{
                ExtReducerLifecycleObjectKey:slave,
                ExtReducerLifecycleDataKey:@(result)
            }];
        }
    }
    return [self.reducer application:application continueUserActivity:userActivity restorationHandler:restorationHandler dataArray:resultArray];
}

- (void)stub_application:(UIApplication *)application didFailToContinueUserActivityWithType:(NSString *)userActivityType error:(NSError *)error {
    for (ExtSlaveLifecycle *slave in self.slaveArray) {
        if (slave.response.application_didFailToContinueUserActivityWithType_error) {
            [slave application:application didFailToContinueUserActivityWithType:userActivityType error:error];
        }
    }
    [self.reducer application:application didFailToContinueUserActivityWithType:userActivityType error:error];
}

- (void)stub_application:(UIApplication *)application didUpdateUserActivity:(NSUserActivity *)userActivity {
    for (ExtSlaveLifecycle *slave in self.slaveArray) {
        if (slave.response.application_didUpdateUserActivity) {
            [slave application:application didUpdateUserActivity:userActivity];
        }
    }
    [self.reducer application:application didUpdateUserActivity:userActivity];
}

- (void)stub_application:(UIApplication *)application userDidAcceptCloudKitShareWithMetadata:(CKShareMetadata *)cloudKitShareMetadata {
    for (ExtSlaveLifecycle *slave in self.slaveArray) {
        if (slave.response.application_userDidAcceptCloudKitShareWithMetadata) {
            if (@available(iOS 10.0, *)) {
                [slave application:application userDidAcceptCloudKitShareWithMetadata:cloudKitShareMetadata];
            }
        }
    }
    [self.reducer application:application userDidAcceptCloudKitShareWithMetadata:cloudKitShareMetadata];
}

- (UISceneConfiguration *)stub_application:(UIApplication *)application configurationForConnectingSceneSession:(UISceneSession *)connectingSceneSession options:(UISceneConnectionOptions *)options  API_AVAILABLE(ios(13.0)) {
    NSMutableArray *resultArray = [NSMutableArray array];
    for (ExtSlaveLifecycle *slave in self.slaveArray) {
       if (slave.response.application_configurationForConnectingSceneSession_options) {
           UISceneConfiguration *result = [slave application:application configurationForConnectingSceneSession:connectingSceneSession options:options];
           [resultArray addObject:@{
               ExtReducerLifecycleObjectKey:slave,
               ExtReducerLifecycleDataKey:result
           }];
       }
    }
    return [self.reducer application:application configurationForConnectingSceneSession:connectingSceneSession options:options dataArray:resultArray];
}

- (void)stub_application:(UIApplication *)application didDiscardSceneSessions:(NSSet<UISceneSession *> *)sceneSessions  API_AVAILABLE(ios(13.0)) {
    for (ExtSlaveLifecycle *slave in self.slaveArray) {
        if (slave.response.application_didDiscardSceneSessions) {
            [slave application:application didDiscardSceneSessions:sceneSessions];
        }
    }
    [self.reducer application:application didDiscardSceneSessions:sceneSessions];
}
@end

#pragma clang diagnostic pop
