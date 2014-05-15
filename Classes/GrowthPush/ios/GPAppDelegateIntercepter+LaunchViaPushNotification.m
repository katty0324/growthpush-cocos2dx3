//
//  GPAppDelegateIntercepter+LaunchViaPushNotification.m
//  GrowthPushSample
//
//  Created by Kataoka Naoyuki on 2014/05/14.
//  Copyright (c) 2014年 SIROK, Inc. All rights reserved.
//

#include "CCPlatformConfig.h"
#if CC_TARGET_PLATFORM == CC_PLATFORM_IOS

#import "GPAppDelegateIntercepter+LaunchViaPushNotification.h"

#import "GrowthPushCCInternal.h"

@implementation GPAppDelegateIntercepter (LaunchViaPushNotification)

- (BOOL) willPerformApplication:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [self trackLaunchViaPushNotificationEvent:[launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey]];
    
    return YES;
    
}

- (void)didPerformApplication:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    
    if (application.applicationState == UIApplicationStateActive) {
        return;
    }
    
    [self trackLaunchViaPushNotificationEvent:userInfo];
    
}


- (void)willPerformApplicationWillEnterForeground:(UIApplication *)application {
    NSLog(@"----");
}

- (void)trackLaunchViaPushNotificationEvent:(NSDictionary *)payload {
    
    if(payload == nil)
        return;
    
    NSDictionary *growthpushDictionary = [payload objectForKey:@"growthpush"];
    if(growthpushDictionary == nil)
        return;
    
    NSString *notificationId = [growthpushDictionary objectForKey:@"notificationId"];
    if(notificationId == nil)
        return;
    
    [GrowthPushCCInternal trackEvent:[NSString stringWithFormat:@"Launch via push notification %@", notificationId] value:nil];
    
}


@end

#endif