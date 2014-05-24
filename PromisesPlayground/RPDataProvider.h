//
//  RPDataProvider.h
//  PromisesPlayground
//
//  Created by Rui Peres on 24/05/2014.
//  Copyright (c) 2014 Promises. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RPDataProvider : NSObject

+ (void)moodsWithCompletionBlock:(void(^)(NSArray *moods, NSError *error))completionBlock;

@end
