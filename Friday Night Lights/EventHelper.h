//
//  EventHelper.h
//  Friday Night Lights
//
//  Created by Sundeep Gupta on 13-06-22.
//  Copyright (c) 2013 Sundeep Gupta. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Event, EventsCell;

@interface EventHelper : NSObject

+ (void)configureCell:(EventsCell *)cell forEvent:(Event *)event;

+ (NSString *)costPerParticipantStringForEvent:(Event *)event;
+ (CGFloat)costPerParticipantFloatForEvent:(Event *)event;

@end
