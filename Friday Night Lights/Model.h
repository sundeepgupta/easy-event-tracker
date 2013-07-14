//
//  Model.h
//  Friday Night Lights
//
//  Created by Sundeep Gupta on 13-06-15.
//  Copyright (c) 2013 Sundeep Gupta. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Participant, Event;

@interface Model : NSObject

#pragma mark - Create
+ (Participant *)newParticipant;
+ (Event *)newEvent;


#pragma mark - Read
+ (NSArray *)participants;
+ (NSArray *)events;
+ (NSArray *)confirmedParticipantsForEvent:(Event *)event;

+ (NSArray *)participantsWithAttributeValue:(NSString *)value forKey:(NSString *)key;
+ (NSArray *)participantAbRecordIds;





#pragma mark - Update
+ (void)addParticipant:(Participant *)participant toEvent:(Event *)event;
+ (void)deleteParticipant:(Participant *)participant fromEvent:(Event *)event;

+ (void)saveContext;


#pragma mark - Delete
+ (void)deleteObject:(NSManagedObject *)object;
+ (void)resetStore;

@end
