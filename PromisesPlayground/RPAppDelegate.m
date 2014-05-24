//
//  RPAppDelegate.m
//  PromisesPlayground
//
//  Created by Rui Peres on 23/05/2014.
//  Copyright (c) 2014 Promises. All rights reserved.
//

#import "RPAppDelegate.h"
#import "RPViewController.h"

@implementation RPAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    self.window.rootViewController = [[RPViewController alloc] init];
    return YES;
}

@end
