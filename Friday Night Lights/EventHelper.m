//
//  EventHelper.m
//  Friday Night Lights
//
//  Created by Sundeep Gupta on 13-06-22.
//  Copyright (c) 2013 Sundeep Gupta. All rights reserved.
//

#import "EventHelper.h"
#import "Event.h"
#import "Helper.h"
#import "EventsCell.h"
#import "NSDate+Helpers.h"

@interface EventHelper ()


@end

@implementation EventHelper

+ (void)configureCell:(EventsCell *)cell forEvent:(Event *)event {
    cell.dateValue.text = [event.date dateAndTimeString];
    cell.confirmedParticipantsValue.text = [Helper stringForNumberOfConfirmedParticipantsForEvent:event];
}


+ (NSString *)costPerParticipantStringForEvent:(Event *)event {
    NSString *string;
    
    NSInteger numberOfParticipants = event.participants.count;
    if (numberOfParticipants > 0) {
        CGFloat amount = [self costPerParticipantFloatForEvent:event];
        string = [Helper formattedStringForAmountFloat:amount];
    } else {
        string = @"";
    }

    return  string;
}

+ (CGFloat)costPerParticipantFloatForEvent:(Event *)event {
    CGFloat cost = event.cost.floatValue;
    NSInteger numberOfParticipants = event.participants.count;
    CGFloat costPerparticipant = cost/numberOfParticipants;
    return costPerparticipant;
}



@end
