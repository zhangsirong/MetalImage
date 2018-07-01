//
//  MIAppDelegate.m
//  MetalImage
//
//  Created by zsr on 2018/6/24.
//  Copyright © 2018年 beauty Inc. All rights reserved.
//

#import "MIAppDelegate.h"

@implementation MIAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    _window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    UIViewController *vc = [[NSClassFromString(@"MIViewController") alloc] init];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
    
    _window.rootViewController = nav;
    [_window makeKeyAndVisible];
    return YES;
}

@end
