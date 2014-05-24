//
//  RPCaching.h
//  PromisesPlayground
//
//  Created by Rui Peres on 23/05/2014.
//  Copyright (c) 2014 Promises. All rights reserved.
//

#import "PromiseKit.h"

extern NSUInteger const RPCacheErrorRoot;
extern NSUInteger const RPCacheErrorNoImage;

@interface RPCaching : NSObject

+ (Promise *)promiseForCachedImageName:(NSString *)cachedImageName;
+ (Promise *)promiseForCachingImage:(UIImage *)image withName:(NSString *)name;

@end
