//
//  GPAppDelegateIntercepter+GrowthPushCocos2dx.h
//  GrowthPushSample
//
//  Created by Kataoka Naoyuki on 2014/05/14.
//  Copyright (c) 2014年 SIROK, Inc. All rights reserved.
//

#include "CCPlatformConfig.h"
#if CC_TARGET_PLATFORM == CC_PLATFORM_IOS

#import "GPAppDelegateIntercepter.h"

@interface GPAppDelegateIntercepter (LaunchViaPushNotification)

@end

#endif