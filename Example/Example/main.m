//
//  main.m
//  Example
//
//  Created by hang_pan on 2020/7/21.
//  Copyright © 2020 hang_pan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ExtAppLifecycle/ExtMasterLifecycle.h>

int main(int argc, char * argv[]) {
    @autoreleasepool {
        NSString *string = [[NSBundle mainBundle] pathForResource:@"lifecycle" ofType:@"json"];
        ExtMasterLifecycle.filePath = [NSURL fileURLWithPath:string];
    }
    return UIApplicationMain(argc, argv, nil, @"ExtMasterLifecycle");
}
