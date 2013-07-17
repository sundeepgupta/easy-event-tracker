//
//  EventHelper.m
//  Friday Night Lights
//
//  Created by Sundeep Gupta on 13-06-22.
//  Copyright (c) 2013 Sundeep Gupta. All rights reserved.
//

#import "EventHelper.h"
#import "Event.h"

@interface EventHelper ()


@end

@implementation EventHelper

+ (CGFloat)costPerParticipantForEvent:(Event *)event {
    CGFloat cost = event.cost.floatValue;
    NSInteger numberOfParticipants = event.participants.count;
    CGFloat costPerparticipant = cost/numberOfParticipants;
    return costPerparticipant;
}



@end
