//
//  Event.h
//  Friday Night Lights
//
//  Created by Sundeep Gupta on 2013-09-29.
//  Copyright (c) 2013 Sundeep Gupta. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Participant;

@interface Event : NSManagedObject

@property (nonatomic, retain) NSNumber * cost;
@property (nonatomic, retain) NSDate * date;
@property (nonatomic, retain) NSString * eventDescription;
@property (nonatomic, retain) NSNumber * maxParticipants;
@property (nonatomic, retain) NSNumber * minParticipants;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * note;
@property (nonatomic, retain) NSString * status;
@property (nonatomic, retain) NSString * type;
@property (nonatomic, retain) NSString * venueName;
@property (nonatomic, retain) NSString * externalId;
@property (nonatomic, retain) NSSet *participants;
@property (nonatomic, retain) NSManagedObject *venue;
@end

@interface Event (CoreDataGeneratedAccessors)

- (void)addParticipantsObject:(Participant *)value;
- (void)removeParticipantsObject:(Participant *)value;
- (void)addParticipants:(NSSet *)values;
- (void)removeParticipants:(NSSet *)values;

@end
