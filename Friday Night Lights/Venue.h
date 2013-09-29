//
//  Venue.h
//  Friday Night Lights
//
//  Created by Sundeep Gupta on 2013-09-29.
//  Copyright (c) 2013 Sundeep Gupta. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Event;

@interface Venue : NSManagedObject

@property (nonatomic, retain) NSString * address1;
@property (nonatomic, retain) NSString * address2;
@property (nonatomic, retain) NSString * address3;
@property (nonatomic, retain) NSString * city;
@property (nonatomic, retain) NSString * contact;
@property (nonatomic, retain) NSString * country;
@property (nonatomic, retain) NSNumber * latitude;
@property (nonatomic, retain) NSNumber * longitude;
@property (nonatomic, retain) NSNumber * maxParticipants;
@property (nonatomic, retain) NSNumber * minParticipants;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * note;
@property (nonatomic, retain) NSString * phone;
@property (nonatomic, retain) NSString * state;
@property (nonatomic, retain) NSString * status;
@property (nonatomic, retain) NSString * type;
@property (nonatomic, retain) NSString * website;
@property (nonatomic, retain) NSString * externalId;
@property (nonatomic, retain) NSSet *events;
@end

@interface Venue (CoreDataGeneratedAccessors)

- (void)addEventsObject:(Event *)value;
- (void)removeEventsObject:(Event *)value;
- (void)addEvents:(NSSet *)values;
- (void)removeEvents:(NSSet *)values;

@end
