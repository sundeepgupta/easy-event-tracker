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


#pragma mark - Events
+ (Event *)newEvent;

+ (NSArray *)events;
+ (NSArray *)confirmedParticipantsForEvent:(Event *)event;
+ (NSArray *)unconfirmedParticipantsForEvent:(Event *)event;
+ (NSInteger)numberOfConfirmedParticipantsForEvent:(Event *)event;

+ (void)addParticipant:(Participant *)participant toEvent:(Event *)event;
+ (void)deleteParticipant:(Participant *)participant fromEvent:(Event *)event;

#pragma mark - Participants
+ (Participant *)newParticipant;

+ (NSArray *)participants;
+ (NSArray *)confirmedEventsForParticipant:(Participant *)participant;
+ (NSInteger)numberOfConfirmedEventsForParticipant:(Participant *)participant;
+ (NSArray *)participantsWithAttributeValue:(NSString *)value forKey:(NSString *)key;
+ (NSArray *)participantAbRecordIds;








#pragma mark - Core Data
+ (void)deleteObject:(NSManagedObject *)object;

+ (void)saveContext;

+ (void)resetStore;



@end
