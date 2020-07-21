//
//  TabBarController.m
//  Example
//
//  Created by hang_pan on 2020/7/21.
//  Copyright © 2020 hang_pan. All rights reserved.
//

#import "TabBarController.h"

@interface TabBarController ()

@end

@implementation TabBarController

- (instancetype)initWithArray:(NSArray <NSString *>*)array {
    self = [super init];
    if (self) {
        NSMutableArray *viewControllers = [NSMutableArray array];
        for (NSDictionary *dic in array) {
            NSString *cls = dic[@"class"];
            BOOL embed = [dic[@"embed"] boolValue];
            Class class = NSClassFromString(cls);
            UIViewController *vc = [class new];
            if (embed) {
                UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:vc];
                [viewControllers addObject:navi];
            } else {
                [viewControllers addObject:vc];
            }
            
        }
        self.viewControllers = viewControllers;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
}


@end
