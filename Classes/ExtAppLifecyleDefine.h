//
//  ExtAppLifecyleDefine.h
//  Pods
//
//  Created by hang_pan on 2020/4/30.
//

#ifndef ExtAppLifecyleDefine_h
#define ExtAppLifecyleDefine_h


#import <UIKit/UIKit.h>

typedef struct {
    unsigned int applicationDidFinishLaunching : 1;
    unsigned int application_willFinishLaunchingWithOptions : 1;
    unsigned int application_didFinishLaunchingWithOptions : 1;
    unsigned int applicationDidBecomeActive : 1;
    unsigned int applicationWillResignActive : 1;
    unsigned int application_handleOpenURL : 1;
    unsigned int application_openURL_sourceApplication_annotation : 1;
    unsigned int application_openURL_options : 1;
    unsigned int applicationDidReceiveMemoryWarning : 1;
    unsigned int applicationWillTerminate : 1;
    unsigned int applicationSignificantTimeChange : 1;
    unsigned int application_willChangeStatusBarOrientation_duration : 1;
    unsigned int application_didChangeStatusBarOrientation : 1;
    unsigned int application_willChangeStatusBarFrame : 1;
    unsigned int application_didChangeStatusBarFrame : 1;
    unsigned int application_didRegisterUserNotificationSettings : 1;
    unsigned int application_didRegisterForRemoteNotificationsWithDeviceToken : 1;
    unsigned int application_didFailToRegisterForRemoteNotificationsWithError : 1;
    unsigned int application_didReceiveRemoteNotification : 1;
    unsigned int application_didReceiveLocalNotification : 1;
    unsigned int application_handleActionWithIdentifier_forLocalNotification_completionHandler : 1;
    unsigned int application_handleActionWithIdentifier_forRemoteNotification_withResponseInfo_completionHandler : 1;
    unsigned int application_handleActionWithIdentifier_forRemoteNotification_completionHandler : 1;
    unsigned int application_handleActionWithIdentifier_forLocalNotification_withResponseInfo_completionHandler : 1;
    unsigned int application_didReceiveRemoteNotification_fetchCompletionHandler : 1;
    unsigned int application_performFetchWithCompletionHandler : 1;
    unsigned int application_performActionForShortcutItem_completionHandler : 1;
    unsigned int application_handleEventsForBackgroundURLSession_completionHandler : 1;
    unsigned int application_handleWatchKitExtensionRequest_reply : 1;
    unsigned int applicationShouldRequestHealthAuthorization : 1;
    unsigned int application_handleIntent_completionHandler: 1;
    unsigned int applicationDidEnterBackground: 1;
    unsigned int applicationWillEnterForeground: 1;
    unsigned int applicationProtectedDataWillBecomeUnavailable: 1;
    unsigned int applicationProtectedDataDidBecomeAvailable: 1;
    unsigned int application_supportedInterfaceOrientationsForWindow: 1;
    unsigned int application_shouldAllowExtensionPointIdentifier: 1;
    unsigned int application_viewControllerWithRestorationIdentifierPath_coder: 1;
    unsigned int application_shouldSaveApplicationState: 1;
    unsigned int application_shouldRestoreApplicationState: 1;
    unsigned int application_willEncodeRestorableStateWithCoder: 1;
    unsigned int application_didDecodeRestorableStateWithCoder: 1;
    unsigned int application_willContinueUserActivityWithType: 1;
    unsigned int application_continueUserActivity_restorationHandler: 1;
    unsigned int application_didFailToContinueUserActivityWithType_error: 1;
    unsigned int application_didUpdateUserActivity: 1;
    unsigned int application_userDidAcceptCloudKitShareWithMetadata: 1;
    unsigned int application_configurationForConnectingSceneSession_options: 1;
    unsigned int application_didDiscardSceneSessions: 1;
} ExteAppLifecycleResponse;

#endif /* ExtAppLifecyleDefine_h */
