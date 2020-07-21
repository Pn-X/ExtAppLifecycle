//
//  ExtSlaveLifecycle.h
//  ExtAppLifecycle
//
//  Created by hang_pan on 2020/4/30.
//

#import <Foundation/Foundation.h>
#import "ExtAppLifecyleDefine.h"
#import "ExtMasterLifecycle.h"

NS_ASSUME_NONNULL_BEGIN

//override
@interface ExtSlaveLifecycle : NSObject<UIApplicationDelegate>

@property (nonatomic, weak, readonly) ExtMasterLifecycle *masterLifecycle;

@property (nonatomic, strong, readonly) NSDictionary *params;

@property (nonatomic, assign, readonly) ExteAppLifecycleResponse response;

- (instancetype)initWithParams:(NSDictionary *)params masterLifecycle:(ExtMasterLifecycle *)masterLifecycle;

- (void)application:(UIApplication *)application handleEvent:(NSString *)event withParams:(nullable NSDictionary *)params;

@end

NS_ASSUME_NONNULL_END
