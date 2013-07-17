//
//  Event.h
//  Friday Night Lights
//
//  Created by Sundeep Gupta on 2013-07-16.
//  Copyright (c) 2013 Sundeep Gupta. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Participant;

@interface Event : NSManagedObject

@property (nonatomic, retain) NSNumber * cost;
@property (nonatomic, retain) NSDate * date;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * venue;
@property (nonatomic, retain) NSSet *participants;
@end

@interface Event (CoreDataGeneratedAccessors)

- (void)addParticipantsObject:(Participant *)value;
- (void)removeParticipantsObject:(Participant *)value;
- (void)addParticipants:(NSSet *)values;
- (void)removeParticipants:(NSSet *)values;

@end
