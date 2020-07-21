//
//  ExtReducerLifecycle.h
//  ExtAppLifecycle
//
//  Created by hang_pan on 2020/5/8.
//

#import <Foundation/Foundation.h>
#import "ExtMasterLifecycle.h"

NS_ASSUME_NONNULL_BEGIN

extern NSString * const ExtReducerLifecycleObjectKey;
extern NSString * const ExtReducerLifecycleDataKey;

@interface ExtReducerLifecycle : NSObject

@property (nonatomic, strong, readonly) NSDictionary *params;

- (instancetype)initWithParams:(NSDictionary *)params masterLifecycle:(ExtMasterLifecycle *)masterLifecycle;

- (void)application:(UIApplication *)application handleEvent:(NSString *)event withParams:(nullable NSDictionary *)params;

- (void)applicationDidFinishLaunching:(UIApplication *)application;

- (BOOL)application:(UIApplication *)application willFinishLaunchingWithOptions:(nullable NSDictionary<UIApplicationLaunchOptionsKey, id> *)launchOptions dataArray:(NSArray *)dataArray;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(nullable NSDictionary<UIApplicationLaunchOptionsKey, id> *)launchOptions dataArray:(NSArray *)dataArray;

- (void)applicationDidBecomeActive:(UIApplication *)application;

- (void)applicationWillResignActive:(UIApplication *)application;

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url dataArray:(NSArray *)dataArray;

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(nullable NSString *)sourceApplication annotation:(id)annotation  dataArray:(NSArray *)dataArray;

- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey, id> *)options dataArray:(NSArray *)dataArray;

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application;

- (void)applicationWillTerminate:(UIApplication *)application;

- (void)applicationSignificantTimeChange:(UIApplication *)application;

- (void)application:(UIApplication *)application willChangeStatusBarOrientation:(UIInterfaceOrientation)newStatusBarOrientation duration:(NSTimeInterval)duration;

- (void)application:(UIApplication *)application didChangeStatusBarOrientation:(UIInterfaceOrientation)oldStatusBarOrientation;

- (void)application:(UIApplication *)application willChangeStatusBarFrame:(CGRect)newStatusBarFrame;

- (void)application:(UIApplication *)application didChangeStatusBarFrame:(CGRect)oldStatusBarFrame;

- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings;

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken;

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error;

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo;

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification;

- (void)application:(UIApplication *)application handleActionWithIdentifier:(nullable NSString *)identifier forLocalNotification:(UILocalNotification *)notification completionHandler:(void (^)(void))completionHandler;

- (void)application:(UIApplication *)application handleActionWithIdentifier:(nullable NSString *)identifier forRemoteNotification:(NSDictionary *)userInfo completionHandler:(void (^)(void))completionHandler;

- (void)application:(UIApplication *)application handleActionWithIdentifier:(nullable NSString *)identifier forLocalNotification:(UILocalNotification *)notification withResponseInfo:(NSDictionary *)responseInfo completionHandler:(void (^)(void))completionHandler;

- (void)application:(UIApplication *)application handleActionWithIdentifier:(nullable NSString *)identifier forRemoteNotification:(NSDictionary *)userInfo withResponseInfo:(NSDictionary *)responseInfo completionHandler:(void (^)(void))completionHandler;

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult result))completionHandler dataArray:(NSArray *)dataArray;

- (void)application:(UIApplication *)application performFetchWithCompletionHandler:(void (^)(UIBackgroundFetchResult result))completionHandler dataArray:(NSArray *)dataArray;

- (void)application:(UIApplication *)application performActionForShortcutItem:(UIApplicationShortcutItem *)shortcutItem completionHandler:(void(^)(BOOL succeeded))completionHandler dataArray:(NSArray *)dataArray;

- (void)application:(UIApplication *)application handleEventsForBackgroundURLSession:(NSString *)identifier completionHandler:(void (^)(void))completionHandler;

- (void)application:(UIApplication *)application handleWatchKitExtensionRequest:(nullable NSDictionary *)userInfo reply:(void(^)(NSDictionary * __nullable replyInfo))reply dataArray:(NSArray *)dataArray;

- (void)applicationShouldRequestHealthAuthorization:(UIApplication *)application;

- (void)application:(UIApplication *)application handleIntent:(INIntent *)intent completionHandler:(void(^)(INIntentResponse *intentResponse))completionHandler dataArray:(NSArray *)dataArray;

- (void)applicationDidEnterBackground:(UIApplication *)application;

- (void)applicationWillEnterForeground:(UIApplication *)application;

- (void)applicationProtectedDataWillBecomeUnavailable:(UIApplication *)application;

- (void)applicationProtectedDataDidBecomeAvailable:(UIApplication *)application;

- (UIInterfaceOrientationMask)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(nullable UIWindow *)window dataArray:(NSArray *)dataArray;

- (BOOL)application:(UIApplication *)application shouldAllowExtensionPointIdentifier:(UIApplicationExtensionPointIdentifier)extensionPointIdentifier dataArray:(NSArray *)dataArray;

- (nullable UIViewController *)application:(UIApplication *)application viewControllerWithRestorationIdentifierPath:(NSArray<NSString *> *)identifierComponents coder:(NSCoder *)coder dataArray:(NSArray *)dataArray;

- (BOOL)application:(UIApplication *)application shouldSaveApplicationState:(NSCoder *)coder dataArray:(NSArray *)dataArray;

- (BOOL)application:(UIApplication *)application shouldRestoreApplicationState:(NSCoder *)coder dataArray:(NSArray *)dataArray;

- (void)application:(UIApplication *)application willEncodeRestorableStateWithCoder:(NSCoder *)coder;

- (void)application:(UIApplication *)application didDecodeRestorableStateWithCoder:(NSCoder *)coder;

- (BOOL)application:(UIApplication *)application willContinueUserActivityWithType:(NSString *)userActivityType dataArray:(NSArray *)dataArray;

- (BOOL)application:(UIApplication *)application continueUserActivity:(NSUserActivity *)userActivity restorationHandler:(void(^)(NSArray<id<UIUserActivityRestoring>> * __nullable restorableObjects))restorationHandler dataArray:(NSArray *)dataArray;

- (void)application:(UIApplication *)application didFailToContinueUserActivityWithType:(NSString *)userActivityType error:(NSError *)error;

- (void)application:(UIApplication *)application didUpdateUserActivity:(NSUserActivity *)userActivity;

- (void)application:(UIApplication *)application userDidAcceptCloudKitShareWithMetadata:(CKShareMetadata *)cloudKitShareMetadata;

- (UISceneConfiguration *)application:(UIApplication *)application configurationForConnectingSceneSession:(UISceneSession *)connectingSceneSession options:(UISceneConnectionOptions *)options dataArray:(NSArray *)dataArray API_AVAILABLE(ios(13.0));

- (void)application:(UIApplication *)application didDiscardSceneSessions:(NSSet<UISceneSession *> *)sceneSessions API_AVAILABLE(ios(13.0));

@end

NS_ASSUME_NONNULL_END
