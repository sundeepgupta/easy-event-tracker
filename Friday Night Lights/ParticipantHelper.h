//
//  ParticipantHelper.h
//  Friday Night Lights
//
//  Created by Sundeep Gupta on 13-06-25.
//  Copyright (c) 2013 Sundeep Gupta. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AddressBookUI/AddressBookUI.h>


@class Participant, ParticipantsCell;

@interface ParticipantHelper : NSObject

+ (NSArray *)allParticipants;
+ (NSArray *)activeParticipants;
+ (NSString *)nameForParticipant:(Participant *)participant;
+ (void)configureCell:(ParticipantsCell *)cell forParticipant:(Participant *)participant;



+ (NSURL *)phoneUrlForParticipant:(Participant *)participant;
+ (Participant *)participantForAbRecordRef:(ABRecordRef)abRecordRef;


+ (NSString *)sumOfTransactionsStringForParticipant:(Participant *)participant;
+ (NSString *)balanceStringForParticipant:(Participant *)participant;

@end
