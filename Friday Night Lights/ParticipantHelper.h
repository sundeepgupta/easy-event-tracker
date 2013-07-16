//
//  ParticipantHelper.h
//  Friday Night Lights
//
//  Created by Sundeep Gupta on 13-06-25.
//  Copyright (c) 2013 Sundeep Gupta. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Participant;

@interface ParticipantHelper : NSObject

+ (NSArray *)dataSource;

+ (NSString *)nameForParticipant:(Participant *)participant;

+ (NSURL *)phoneUrlForParticipant:(Participant *)participant;
    
@end
