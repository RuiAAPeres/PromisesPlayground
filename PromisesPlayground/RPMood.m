//
//  RPMood.m
//  PromisesPlayground
//
//  Created by Rui Peres on 24/05/2014.
//  Copyright (c) 2014 Promises. All rights reserved.
//

#import "RPMood.h"

@implementation RPMood

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{
             @"moodName": @"moodName",
             @"moodImageURL": @"moodImageURL"
             };
}

+ (NSValueTransformer *)moodImageURLJSONTransformer
{
    return [NSValueTransformer valueTransformerForName:MTLURLValueTransformerName];
}

@end
