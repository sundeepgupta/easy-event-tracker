//
//  Participant.h
//  Friday Night Lights
//
//  Created by Sundeep Gupta on 13-06-16.
//  Copyright (c) 2013 Sundeep Gupta. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Event;

@interface Participant : NSManagedObject

@property (nonatomic, retain) NSNumber * abRecordId;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSSet *events;
@end

@interface Participant (CoreDataGeneratedAccessors)

- (void)addEventsObject:(Event *)value;
- (void)removeEventsObject:(Event *)value;
- (void)addEvents:(NSSet *)values;
- (void)removeEvents:(NSSet *)values;

@end
