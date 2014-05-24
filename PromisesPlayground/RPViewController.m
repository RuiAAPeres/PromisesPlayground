//
//  RPViewController.m
//  PromisesPlayground
//
//  Created by Rui Peres on 23/05/2014.
//  Copyright (c) 2014 Promises. All rights reserved.
//

#import "RPViewController.h"
#import "RPDataProvider.h"
#import "RPMood.h"

@interface RPViewController ()

@end

@implementation RPViewController

#pragma mark - Promises


#pragma mark - View LifeCycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [RPDataProvider moodsWithCompletionBlock:^(NSArray *moods, NSError *error) {
        NSLog(@"ad");
    }];
}

@end
