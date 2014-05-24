//
//  RPDataProvider.m
//  PromisesPlayground
//
//  Created by Rui Peres on 24/05/2014.
//  Copyright (c) 2014 Promises. All rights reserved.
//

#import "RPDataProvider.h"
#import "RPCaching.h"
#import "RPMood.h"

#import "PromiseKit.h"
#import "Mantle.h"

static NSString *const RPServerEndpoint = @"https://yp3X9OzlYI5As5LULbTo7LyWM8xpjH2zZo8RTHF0:javascript-key=xRnOZ70v9vhFKhNSIYgm5Q0stxGjG4YJU891JYhP@api.parse.com/1/classes/MoodCategory";

@implementation RPDataProvider

#pragma mark - Promises
//  "me you'll wait for me 'cause I'll be saving all my love for you and I will be home soon"
//  https://www.youtube.com/watch?v=-LMC-2Y-Emw

+ (Promise *)promiseMoodsAccess
{
    Promise *results = [NSURLConnection GET:RPServerEndpoint].then(^(NSDictionary *results){
        return results[@"results"];
    }).then(^(NSArray *moodCategories){
        return [MTLJSONAdapter modelsOfClass:RPMood.class fromJSONArray:moodCategories error:nil];
    }).catch(^(NSError *error){
        // Show an error perhaps
        // Return the error to break the chain
        return error;
    });
    
    return results;
}

+ (Promise *)promiseDownloadImageForMood:(RPMood *)mood
{
   return [NSURLConnection GET:mood.moodImageURL].then(^(UIImage *image){
        // Let's catch it now
        [RPCaching promiseForCachingImage:image withName:mood.moodName];
        
        // Return the updated moods
        mood.image = image;
        return mood;
   });
}

+ (Promise *)promiseCachedImageForMood:(RPMood *)mood
{
    return [RPCaching promiseForCachedImageName:[mood.moodName lowercaseString]].then(^(UIImage *moodImage){
        mood.image = moodImage;
        
        return mood;
    }).catch(^(NSError *error){
        // When we return an I/O failure, it will break the chain.
        // If there is any other kind of error, let's download the image
        return (error.code == RPCacheErrorRoot)? error : [RPDataProvider promiseDownloadImageForMood:mood];
    });
}

+ (void)moodsImageDownloadWithDependency:(Promise *)depedency completionBlock:(void(^)(NSArray *moods))completionBlock
{
    NSMutableArray *promises = [NSMutableArray array];
    
    depedency.then(^(NSArray *moodCategories){
        [moodCategories enumerateObjectsUsingBlock:^(RPMood *mood, NSUInteger idx, BOOL *stop)
         {
             Promise *imageUpdatePromise = [RPDataProvider promiseCachedImageForMood:mood];
             [promises addObject:imageUpdatePromise];
         }];
        
        completionBlock(promises);
    });
}

#pragma mark - Moods

+ (void)moodsWithCompletionBlock:(void (^)(NSArray *moods, NSError *error))completionBlock
{
    [RPDataProvider moodsImageDownloadWithDependency:[RPDataProvider promiseMoodsAccess] completionBlock:^(NSArray *moodsPromises) {
        
        [Promise when:moodsPromises].then(^(NSArray *moods){
            completionBlock(moods,nil);
        }).catch(^(NSError *error){
            completionBlock(nil,error);
        });
        
    }];
}

@end
