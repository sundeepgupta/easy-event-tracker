//
//  Global.m
//  Friday Night Lights
//
//  Created by Sundeep Gupta on 13-06-15.
//  Copyright (c) 2013 Sundeep Gupta. All rights reserved.
//


#import "Model.h"

@implementation Global

+ (id)sharedGlobal {
    static Global *sharedGlobal = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedGlobal = [[self alloc] init];
    });
    return sharedGlobal;
}

- (id)init {
    if (self = [super init]) {
        self.model = [[Model alloc] init];


    }
    return self;
}

- (void)dealloc {
    // Should never be called, but just here for clarity really.
}

@end
