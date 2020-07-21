//
//  HomeLifecycle.m
//  Example
//
//  Created by hang_pan on 2020/7/21.
//  Copyright © 2020 hang_pan. All rights reserved.
//

#import "HomeLifecycle.h"

@implementation HomeLifecycle

- (BOOL)application:(UIApplication *)application willFinishLaunchingWithOptions:(nullable NSDictionary<UIApplicationLaunchOptionsKey,id> *)launchOptions {
    //you can do something here like regist,initialize,etc..
    return YES;
}

- (void)application:(UIApplication *)application handleEvent:(NSString *)event withParams:(nullable NSDictionary *)params {
    NSLog(@"\nevent:%@\nparams:%@", event, params);
}

@end
