//
//  ExtSlaveLifecycle.m
//  ExtAppLifecycle
//
//  Created by hang_pan on 2020/4/30.
//

#import "ExtSlaveLifecycle.h"

#define ExtSlaveLifecycleReponseTo(x) [self respondsToSelector:@selector(x)]

@interface ExtSlaveLifecycle()

@property (nonatomic, strong, readwrite) NSDictionary *params;

@property (nonatomic, assign, readwrite) ExteAppLifecycleResponse response;

@property (nonatomic, weak, readwrite) ExtMasterLifecycle *masterLifecycle;

@end

@implementation ExtSlaveLifecycle

@synthesize response = _reponse;

- (instancetype)initWithParams:(NSDictionary *)params masterLifecycle:(ExtMasterLifecycle *)masterLifecycle {
    self = [super init];
    if (self) {
        self.params = params?:@{};
        self.masterLifecycle = masterLifecycle;
        ExteAppLifecycleResponse response;
        response.applicationDidFinishLaunching = ExtSlaveLifecycleReponseTo(applicationDidFinishLaunching:);
        response.application_willFinishLaunchingWithOptions = ExtSlaveLifecycleReponseTo(application:willFinishLaunchingWithOptions:);
        response.application_didFinishLaunchingWithOptions = ExtSlaveLifecycleReponseTo(application:didFinishLaunchingWithOptions:);
        response.applicationDidBecomeActive = ExtSlaveLifecycleReponseTo(applicationDidBecomeActive:);
        response.applicationWillResignActive = ExtSlaveLifecycleReponseTo(applicationWillResignActive:);
        response.application_handleOpenURL = ExtSlaveLifecycleReponseTo(application:handleOpenURL:);
        response.application_openURL_sourceApplication_annotation = ExtSlaveLifecycleReponseTo(application:openURL:sourceApplication:annotation:);
        response.application_openURL_options = ExtSlaveLifecycleReponseTo(application:openURL:options:);
        response.applicationDidReceiveMemoryWarning = ExtSlaveLifecycleReponseTo(applicationDidReceiveMemoryWarning:);
        response.applicationWillTerminate = ExtSlaveLifecycleReponseTo(applicationWillTerminate:);
        response.applicationSignificantTimeChange =  ExtSlaveLifecycleReponseTo(applicationSignificantTimeChange:);
        response.application_willChangeStatusBarOrientation_duration = ExtSlaveLifecycleReponseTo(application:willChangeStatusBarOrientation:duration:);
        response.application_didChangeStatusBarOrientation = ExtSlaveLifecycleReponseTo(application:didChangeStatusBarOrientation:);
        response.application_willChangeStatusBarFrame = ExtSlaveLifecycleReponseTo(application:willChangeStatusBarFrame:);
        response.application_didChangeStatusBarFrame = ExtSlaveLifecycleReponseTo(application:didChangeStatusBarFrame:);
        response.application_didRegisterUserNotificationSettings = ExtSlaveLifecycleReponseTo(application:didRegisterUserNotificationSettings:);
        response.application_didRegisterForRemoteNotificationsWithDeviceToken = ExtSlaveLifecycleReponseTo(application:didRegisterForRemoteNotificationsWithDeviceToken:);
        response.application_didFailToRegisterForRemoteNotificationsWithError = ExtSlaveLifecycleReponseTo(application:didFailToRegisterForRemoteNotificationsWithError:);
        response.application_didReceiveLocalNotification = ExtSlaveLifecycleReponseTo(application:didReceiveLocalNotification:);
        response.application_didReceiveRemoteNotification = ExtSlaveLifecycleReponseTo(application:didReceiveRemoteNotification:);
        response.application_handleActionWithIdentifier_forLocalNotification_completionHandler = ExtSlaveLifecycleReponseTo(application:handleActionWithIdentifier:forLocalNotification:completionHandler:);
        response.application_handleActionWithIdentifier_forRemoteNotification_completionHandler = ExtSlaveLifecycleReponseTo(application:handleActionWithIdentifier:forRemoteNotification:completionHandler:);
        response.application_handleActionWithIdentifier_forLocalNotification_withResponseInfo_completionHandler = ExtSlaveLifecycleReponseTo(application:handleActionWithIdentifier:forLocalNotification:withResponseInfo:completionHandler:);
        response.application_handleActionWithIdentifier_forRemoteNotification_withResponseInfo_completionHandler = ExtSlaveLifecycleReponseTo(application:handleActionWithIdentifier:forRemoteNotification:withResponseInfo:completionHandler:);
        response.application_didReceiveRemoteNotification_fetchCompletionHandler = ExtSlaveLifecycleReponseTo(application:didReceiveRemoteNotification:fetchCompletionHandler:);
        response.application_performFetchWithCompletionHandler = ExtSlaveLifecycleReponseTo(application:performFetchWithCompletionHandler:);
        response.application_performActionForShortcutItem_completionHandler = ExtSlaveLifecycleReponseTo(application:performActionForShortcutItem:completionHandler:);
        response.application_handleEventsForBackgroundURLSession_completionHandler = ExtSlaveLifecycleReponseTo(application:handleEventsForBackgroundURLSession:completionHandler:);
        response.application_handleWatchKitExtensionRequest_reply = ExtSlaveLifecycleReponseTo(application:handleWatchKitExtensionRequest:reply:);
        response.applicationShouldRequestHealthAuthorization = ExtSlaveLifecycleReponseTo(applicationShouldRequestHealthAuthorization:);
        response.application_handleIntent_completionHandler = ExtSlaveLifecycleReponseTo(application:handleIntent:completionHandler:);
        response.applicationDidEnterBackground = ExtSlaveLifecycleReponseTo(applicationDidEnterBackground:);
        response.applicationWillEnterForeground = ExtSlaveLifecycleReponseTo(applicationWillEnterForeground:);
        response.applicationProtectedDataWillBecomeUnavailable = ExtSlaveLifecycleReponseTo(applicationProtectedDataWillBecomeUnavailable:);
        response.applicationProtectedDataDidBecomeAvailable = ExtSlaveLifecycleReponseTo(applicationProtectedDataDidBecomeAvailable:);
        response.application_supportedInterfaceOrientationsForWindow = ExtSlaveLifecycleReponseTo(application:supportedInterfaceOrientationsForWindow:);
        response.application_shouldAllowExtensionPointIdentifier = ExtSlaveLifecycleReponseTo(application:shouldAllowExtensionPointIdentifier:);
        response.application_viewControllerWithRestorationIdentifierPath_coder = ExtSlaveLifecycleReponseTo(viewControllerWithRestorationIdentifierPath:coder:);
        response.application_shouldSaveApplicationState = ExtSlaveLifecycleReponseTo(application:shouldSaveApplicationState:);
        response.application_shouldRestoreApplicationState = ExtSlaveLifecycleReponseTo(application:shouldRestoreApplicationState:);
        response.application_willEncodeRestorableStateWithCoder = ExtSlaveLifecycleReponseTo(application:willEncodeRestorableStateWithCoder:);
        response.application_didDecodeRestorableStateWithCoder = ExtSlaveLifecycleReponseTo(application:didDecodeRestorableStateWithCoder:);
        response.application_willContinueUserActivityWithType = ExtSlaveLifecycleReponseTo(application:willContinueUserActivityWithType:);
        response.application_continueUserActivity_restorationHandler = ExtSlaveLifecycleReponseTo(application:continueUserActivity:restorationHandler:);
        response.application_didFailToContinueUserActivityWithType_error = ExtSlaveLifecycleReponseTo(application:didFailToContinueUserActivityWithType:error:);
        response.application_didUpdateUserActivity = ExtSlaveLifecycleReponseTo(application:didUpdateUserActivity:);
        response.application_userDidAcceptCloudKitShareWithMetadata = ExtSlaveLifecycleReponseTo(application:userDidAcceptCloudKitShareWithMetadata:);
        response.application_configurationForConnectingSceneSession_options = ExtSlaveLifecycleReponseTo(application:configurationForConnectingSceneSession:options:);
        response.application_didDiscardSceneSessions = ExtSlaveLifecycleReponseTo(application:didDiscardSceneSessions:);
        self.response = response;
    }
    return self;
}

- (void)application:(UIApplication *)application handleEvent:(NSString *)event withParams:(nullable NSDictionary *)params {
    
}

@end
