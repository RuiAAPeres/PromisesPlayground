//
//  RPCaching.m
//  PromisesPlayground
//
//  Created by Rui Peres on 23/05/2014.
//  Copyright (c) 2014 Promises. All rights reserved.
//

#import "RPCaching.h"

static NSString *const RPCacheDomain = @"RPCacheDomain";
NSUInteger const RPCacheErrorRoot = 100;
NSUInteger const RPCacheErrorNoImage = 101;

static NSString *const RPPngExtension = @"png";

@implementation RPCaching

#pragma mark - Private API

+ (NSString *)rootFileSystemPath
{
    NSString *documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    
    return [documentsPath stringByAppendingPathComponent:@"MoodsImagesFolder"];
}

+ (BOOL)didCreateRootFolderWithSuccess
{
    BOOL didCreateRootFolderWithSuccess = NO;
    NSString *moodsPath = [RPCaching rootFileSystemPath];
    NSError *error;
    BOOL isDirectory;
    
    if ([[NSFileManager defaultManager] createDirectoryAtPath:moodsPath withIntermediateDirectories:NO attributes:nil error:&error] || [[NSFileManager defaultManager] fileExistsAtPath:moodsPath isDirectory:&isDirectory])
    {
        didCreateRootFolderWithSuccess = YES;
    }
    
    return didCreateRootFolderWithSuccess;
}

+ (UIImage *)imageWithCachedImageName:(NSString *)cachedImageName
{
    NSString *rootPath = [RPCaching rootFileSystemPath];
    NSString *cachedImagePath = [rootPath stringByAppendingPathComponent:[cachedImageName stringByAppendingPathExtension:RPPngExtension]];
    NSData *data = [NSKeyedUnarchiver unarchiveObjectWithFile:cachedImagePath];
    return [UIImage imageWithData:data];
}

#pragma mark - Public API

+ (Promise *)promiseForCachedImageName:(NSString *)cachedImageName
{
    return [Promise new:^(PromiseResolver fulfiller, PromiseResolver rejecter) {
        
        if ([RPCaching didCreateRootFolderWithSuccess])
        {
            UIImage *image = [RPCaching imageWithCachedImageName:cachedImageName];
            if (image)
            {
                fulfiller(image);
            }
            else
            {
                NSError *error = [NSError errorWithDomain:RPCacheDomain code:RPCacheErrorNoImage userInfo:nil];
                rejecter(error);
            }
        }
        else
        {
            NSError *error = [NSError errorWithDomain:RPCacheDomain code:RPCacheErrorRoot userInfo:nil];
            rejecter(error);
        }
    }];
}

+ (Promise *)promiseForCachingImage:(UIImage *)image withName:(NSString *)name
{
    return dispatch_promise(^{
        
        NSString *rootPath = [RPCaching rootFileSystemPath];
        NSString *imagePath = [rootPath stringByAppendingPathComponent:[[name lowercaseString] stringByAppendingPathExtension:RPPngExtension]];
        
        [NSKeyedArchiver archiveRootObject:UIImagePNGRepresentation(image) toFile:imagePath];
    });
}

@end
