//
//  RPMood.h
//  PromisesPlayground
//
//  Created by Rui Peres on 24/05/2014.
//  Copyright (c) 2014 Promises. All rights reserved.
//

#import "Mantle.h"

@interface RPMood : MTLModel <MTLJSONSerializing>

@property (nonatomic,strong,readonly)NSString *moodName;
@property (nonatomic,strong,readonly)NSURL *moodImageURL;

@property (nonatomic,strong)UIImage *image;

@end
