//
//  AppDelegate.m
//  CLDemo
//
//  Created by JmoVxia on 2016/11/17.
//  Copyright © 2016年 JmoVxia. All rights reserved.
//

#import "AppDelegate.h"
#import "CLTabbarController.h"
#import "FPSDisplay.h"
#import "CLDemo-Swift.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    CLTabbarController *tbc = [[CLTabbarController alloc] init];
    self.window.rootViewController = tbc;
    [self.window makeKeyAndVisible];
//    [FPSDisplay shareFPSDisplay];
    return YES;
}



@end
