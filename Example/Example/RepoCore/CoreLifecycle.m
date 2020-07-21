//
//  CoreLifecycle.m
//  Example
//
//  Created by hang_pan on 2020/7/21.
//  Copyright © 2020 hang_pan. All rights reserved.
//

#import "CoreLifecycle.h"
#import "TabBarController.h"

@implementation CoreLifecycle

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(nullable NSDictionary<UIApplicationLaunchOptionsKey, id> *)launchOptions {
    
    NSArray *array = self.params[@"tabBarVCs"];
    TabBarController *tabbar = [[TabBarController alloc] initWithArray:array];
    
    self.masterLifecycle.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [self.masterLifecycle.window setRootViewController:tabbar];
    [self.masterLifecycle.window makeKeyAndVisible];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.masterLifecycle application:application dispatchEvent:@"EventTest" withParams:@{@"key":@"value"}];
    });
    return YES;
}

@end
